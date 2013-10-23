//
//  AGPaymentListController.m
//  AllMine
//
//  Created by Allgoritm LLC on 12.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "AGPaymentListController.h"
#import "AGTools.h"
#import "AGAccountEditController.h"
#import "Account+EntityWorker.h"
#import "AGPaymentEditController.h"
#import "User+EntityWorker.h"
#import "AGAppDelegate.h"
#import "AGRootController.h"
#import "Payment+EntityWorker.h"
#import "Category+EntityWorker.h"
#import "UILabel+AGExtensions.h"
#import "NSDate+AGExtensions.h"
#import "UIColor+AGExtensions.h"
#import <QuartzCore/QuartzCore.h>
#import "NSArray+Additions.h"


#define kRecordsFrame 20

@interface AGPaymentListController ()

@property(nonatomic, strong) NSArray* paymentsFinished;
@property(nonatomic, strong) NSArray* paymentsNotFinished;
@property(nonatomic, strong) IBOutlet UITableView* tvPayments;

@property(nonatomic, assign) int recordsFrame;
@property(nonatomic, assign) BOOL recordsLoading;
@property(nonatomic, assign) BOOL recordsHasMore;
@property(nonatomic, assign) int cellType;

@end

@implementation AGPaymentListController

@synthesize account = _account;
@synthesize tvPayments = _tvPayments;
@synthesize paymentsFinished = _paymentsFinished;
@synthesize paymentsNotFinished = _paymentsNotFinished;

int counter = 0;
int cellIndex = -1;

int tappedArrayCount = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _account = nil;
        _arrayForCell  = [[NSMutableArray alloc] init];
        _arrayForCategories = [[NSMutableArray alloc]init];
        _arrayForSum = [[NSMutableArray alloc] init];
        _arrayForDate = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isTapped = NO;
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [AGTools navigationBarButtonItemWithImageNamed:@"button-back" target:self action:@selector(back)];
    if(_account){
        self.navigationItem.title = _account.title;
        self.navigationItem.rightBarButtonItem = [AGTools navigationBarButtonItemWithImageNamed:@"button-accountEdit" target:self action:@selector(editAccount)];
    }else{
        self.navigationItem.title = NSLocalizedString(@"PaymentListPayments", @"");
        self.navigationItem.rightBarButtonItem = [AGTools navigationBarButtonItemWithImageNamed:@"button-add" target:self action:@selector(addPayment)];
    }
    
    _tvPayments.delegate = self;
    _tvPayments.dataSource = self;
    _tvPayments.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //    Account* acc = [Account insertAccountWithUser:kUser
    //                                            title:@"asd"
    //                                         currency:(kUser).currencyMain
    //                                             date:[NSDate date]
    //                                            group:AccGroupAllMine
    //                                             type:AccTypeBank
    //                                          comment:@"asd"
    //                                             save:YES];
    //    Category* cat = [Category insertCategoryWithUser:kUser
    //                                               title:@"qwe"
    //                                                type:CatTypeExpense
    //                                            supercat:nil
    //                                                save:YES];
    //    for (NSInteger i = 0; i < 100; i++) {
    //        Payment* p = [Payment insertPaymentWithUser:kUser
    //                                            account:acc
    //                                           category:cat
    //                                  accountAsCategory:nil
    //                                           currency:(kUser).currencyMain
    //                                                sum:100
    //                                            sumMain:100
    //                                          rateValue:0
    //                                               date:[NSDate date]
    //                                            comment:@"qqq"
    //                                          ptemplate:nil
    //                                           finished:YES
    //                                             hidden:NO
    //                                               save:YES];
    //    }
}

- (void) viewWillAppear:(BOOL)animated{
    if(_account){
        self.navigationItem.title = _account.title;
    }
    
    
    _recordsFrame = kRecordsFrame;
    _recordsLoading = NO;
    _recordsHasMore = YES;
    _paymentsFinished = nil;
    [self appendPayments];
    [_tvPayments scrollRectToVisible:CGRectMake(0, 0, 320, 10) animated:YES];
    if ([self paymentsFinishedCount] < kRecordsFrame) {
        _recordsHasMore = NO;
    }
    _paymentsNotFinished = [kUser paymentsNotFinishedWithAccount:_account];
    
    
    if([_paymentsFinished count]>0 || _account || [_paymentsNotFinished count]>0){
        self.addImg.hidden = YES;
    }else{
        self.addImg.hidden = NO;
    }
    
    [_tvPayments reloadData];
}

#pragma mark - buttons
- (void) back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) editAccount{
    AGAccountEditController* ctl = [[AGAccountEditController alloc] initWithNibName:@"AGAccountEditView" bundle:nil];
    ctl.account = _account;
    //    ctl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void) addPayment
{
    if(_indexPathForCell)
    {
        _indexPathForCell = nil;
    }
    AGPaymentEditController* ctl = [[AGPaymentEditController alloc] initWithNibName:@"AGPaymentEditView" bundle:nil];
    ctl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctl animated:YES];
}

-(int) numberOfSplitPayments{
    int splitPayments=0;
    for(int i =0; i<([_paymentsFinished count]); i++){
        for(Payment *p in _paymentsFinished[i]){
            if([p.subpayments count]>0)
                splitPayments++;
        }
    }
    return splitPayments;
}

-(NSArray*) indexesOfSplitPayments{
    NSMutableArray* indexes = [[NSMutableArray alloc]init];
    
    for(int i =0; i<([_paymentsFinished count]); i++){
        for(Payment *p in _paymentsFinished[i]){
            if([p.subpayments count]>0)
                [indexes arrayByAddingObject:p];
        }
    }
    return [NSArray arrayWithArray:indexes];
}

#pragma mark - UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // return [_paymentsFinished count]+1+(_recordsHasMore?1:0)+[self numberOfSplitPayments];
    return [_paymentsFinished count]+1+(_recordsHasMore?1:0);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [_paymentsNotFinished count];
    }
    if((section == [self numberOfSectionsInTableView:tableView]-1) && (_recordsHasMore)){
        return 1;
    }
    
    if(_indexPathForCell)
    {
        if(_indexPathForCell.section == section)
        {
            //NSLog(@"%i",[[_paymentsFinished objectAtIndex:section-1] count] + [_arrayForCategories count]);
            return [[_paymentsFinished objectAtIndex:section-1] count] + [_arrayForCategories count];
        }
    }
    return [[_paymentsFinished objectAtIndex:section-1] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* CellIdentifier = @"paymentsListCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }else{
        for (UIView* v in cell.contentView.subviews) {
            if([v isKindOfClass:[UILabel class]]){
                [v removeFromSuperview];
            }
            if([v isKindOfClass:[UIActivityIndicatorView class]]){
                [v removeFromSuperview];
            }
        }
    }
    cell.imageView.image = nil;
    
    
    if((indexPath.section == [self numberOfSectionsInTableView:tableView]-1) && (_recordsHasMore)){
        cell.accessoryType = UITableViewCellAccessoryNone;
        UIActivityIndicatorView* activity = [[UIActivityIndicatorView alloc]
                                             initWithFrame:CGRectMake(140,
                                                                      ([self tableView:tableView
                                                               heightForRowAtIndexPath:indexPath] - 40)/2,
                                                                      40,
                                                                      40)];
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [cell.contentView addSubview:activity];
        [activity startAnimating];
    }else{
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        Payment* payment = nil;
        
        
        if (indexPath.section == 0) {
            
            payment = (Payment*)[_paymentsNotFinished objectAtIndex:indexPath.row];
        }else{
            if (_indexPathForCell && _indexPathForCell.section == indexPath.section && indexPath.row > _indexPathForCell.row + [_arrayForCategories count])
            {
                payment = (Payment*)[[_paymentsFinished objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row - [_arrayForCategories count]];
            }
            else
            {
                if([[_paymentsFinished objectAtIndex:indexPath.section - 1] count] > indexPath.row)
                {
                    payment = (Payment*)[[_paymentsFinished objectAtIndex:indexPath.section-1]objectAtIndex:indexPath.row];
                }
            }
            
        }
        //    if (payment.template != nil) {
        //        cell.imageView.image = [UIImage imageNamed:@"star"];
        //    }
        
        
        double originX = 30.0;
        
        if (_indexPathForCell && _indexPathForCell.section == indexPath.section && indexPath.row > _indexPathForCell.row && indexPath.row <= _indexPathForCell.row + [_arrayForCategories count])
        {
            _cellType = 1;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.accessoryView = nil;
            UILabel* lbSubCat1 = [[UILabel alloc] initWithFrame:CGRectMake(originX, 20, 150-originX, 20)];
            lbSubCat1.font = [UIFont fontWithName:kFont1 size:16.0f];
            lbSubCat1.backgroundColor = [UIColor clearColor];
            lbSubCat1.textColor = [UIColor colorWithRed:(26/255.0) green:(26/255.0) blue:(26/255.0) alpha:1];
            Category *cat = [_arrayForCategories objectAtIndex:indexPath.row - _indexPathForCell.row - 1];
            lbSubCat1.text = [NSString stringWithFormat:@"%@ ",cat.title];
                       
            UILabel* lbSum = [[UILabel alloc] initWithFrame:CGRectMake(150, 22, 140, 20)];
            lbSum.font = [UIFont fontWithName:kFont1 size:18.0f];
            [lbSum setTextFromNumber:[[_arrayForSum objectAtIndex:indexPath.row - _indexPathForCell.row - 1] doubleValue] asInteger:[[_arrayForSum objectAtIndex:indexPath.row - _indexPathForCell.row - 1] doubleValue] > 100000 withColor:nil];
            lbSum.adjustsFontSizeToFitWidth = YES;
            lbSum.backgroundColor = [UIColor clearColor];
            
            UILabel* lbAcc = [[UILabel alloc] initWithFrame:CGRectMake(originX, 33, 140-originX, 20)];
            lbAcc.backgroundColor = [UIColor clearColor];
            lbAcc.font = [UIFont fontWithName:kFont1 size:11.0f];
            lbAcc.textColor = [UIColor colorWithHex:kColorHexPaymentListDate];
            UILabel* lbColorForTime = [[UILabel alloc] initWithFrame:CGRectMake(originX, 33, 140-originX, 20)];
            lbColorForTime.backgroundColor = [UIColor clearColor];
            lbColorForTime.font = [UIFont fontWithName:kFont1 size:11.0f];
            lbColorForTime.textColor = [UIColor colorWithHex:kColorHexBrown];
            if(![[_arrayForDate objectAtIndex:indexPath.row - _indexPathForCell.row - 1] isEqualToString:@"00:00"])
            {
                 lbAcc.text =[NSString stringWithFormat:@"%@ %@",_paymentTitle ,[_arrayForDate objectAtIndex:indexPath.row - _indexPathForCell.row - 1]];
                lbColorForTime.text =[NSString stringWithFormat:@"%@",_paymentTitle];
                
            }else{
                lbColorForTime.text = [NSString stringWithFormat:@"%@",_paymentTitle];
            }
            
            if([_arrayForCategories count]-1 == (indexPath.row - _indexPathForCell.row - 1)){
                _cellType = 3;
            }
            lbColorForTime.backgroundColor = [UIColor clearColor];
            lbAcc.backgroundColor = [UIColor clearColor];
            
            lbColorForTime.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:lbAcc];
            [cell.contentView addSubview:lbColorForTime];
            [cell.contentView addSubview:lbSum];
            [cell.contentView addSubview:lbSubCat1];
            
            
        }
        else if (payment)
        {
            _cellType = 0;
            UILabel* lbCat = [[UILabel alloc] initWithFrame:CGRectMake(originX, 16, 150-originX, 20)];
            lbCat.font = [UIFont fontWithName:kFont1 size:16.0f];
            lbCat.textColor = [UIColor colorWithRed:(26/255.0) green:(26/255.0) blue:(26/255.0) alpha:1];
            if (payment.category != nil) {
                lbCat.text = payment.category.title;
            }else{
                lbCat.text = payment.accountAsCategory.title;
            }
            lbCat.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:lbCat];
            
            
            UILabel* lbAcc = [[UILabel alloc] initWithFrame:CGRectMake(originX, 30, 140-originX, 20)];
            lbAcc.backgroundColor = [UIColor clearColor];
            lbAcc.font = [UIFont fontWithName:kFont1 size:11.0f];
            lbAcc.textColor = [UIColor colorWithHex:kColorHexGray2];
            UILabel* lbColorForTime = [[UILabel alloc] initWithFrame:CGRectMake(originX, 30, 140-originX, 20)];
            lbColorForTime.backgroundColor = [UIColor clearColor];
            lbColorForTime.font = [UIFont fontWithName:kFont1 size:11.0f];
            lbColorForTime.textColor = [UIColor colorWithHex:kColorHexBrown];
            if(![[payment.date dateTitleHourMinute] isEqualToString:@"00:00"])
            {
                lbAcc.text = [NSString stringWithFormat:@"%@ %@", payment.account.title, [payment.date dateTitleHourMinute]];
                lbColorForTime.text =[NSString stringWithFormat:@"%@", payment.account.title];
                
            }else{
                lbAcc.text = [NSString stringWithFormat:@"%@", payment.account.title];
                lbColorForTime.text = [NSString stringWithFormat:@"%@", payment.account.title];
            }
            lbColorForTime.backgroundColor = [UIColor clearColor];
            lbAcc.backgroundColor = [UIColor clearColor];
            
            
            
            if([payment.subpayments count] > 0)
            {
                /*for(NSDictionary *dict in payment.subpayments){
                 NSLog(@"Subpayment: %@",[dict objectForKey:kSum]);
                 }*/
                
                if(_indexPathForCell && _indexPathForCell.section == indexPath.section && indexPath.row == _indexPathForCell.row && indexPath.row <= _indexPathForCell.row + [_arrayForCategories count]){
                    _cellType =2;
                }
                
                [cell.imageView setImage:[UIImage imageNamed:@"icon-split.png"]];
                cell.imageView.frame = CGRectMake(11,11, 20, 20);
                
                [cell.imageView setUserInteractionEnabled:YES];
                
                BOOL isHas = NO;
                for(NSIndexPath *ip in _arrayForCell)
                {
                    if(ip.row == indexPath.row && ip.section == indexPath.section)
                    {
                        isHas = YES;
                        lbAcc.tag = [_arrayForCell indexOfObject:ip];
                        lbColorForTime.tag = [_arrayForCell indexOfObject:ip];
                        break;
                    }
                }
                
                if(!isHas)
                {
                    [_arrayForCell addObject:indexPath];
                    lbAcc.tag = [_arrayForCell indexOfObject:indexPath];
                    lbColorForTime.tag = [_arrayForCell indexOfObject:indexPath];
                }
                
                UIView *viewToSplit = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 140, [AGTools cellStandardHeight])];
                viewToSplit.userInteractionEnabled = YES;
                viewToSplit.backgroundColor = [UIColor clearColor];
                
                [cell.contentView addSubview:viewToSplit];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infoImageTapped:)];
                
                [tap setNumberOfTapsRequired:1];
                [viewToSplit addGestureRecognizer:tap];
            }
            
            [cell.contentView addSubview:lbAcc];
            [cell.contentView addSubview:lbColorForTime];
            //NSLog(@"section %i",indexPath.section);
            
            
            UILabel* lbSum = [[UILabel alloc] initWithFrame:CGRectMake(150, 22, 140, 20)];
            lbSum.font = [UIFont fontWithName:kFont1 size:18.0f];
            [lbSum setTextFromNumber:[payment.sumMain doubleValue] asInteger:[payment.sumMain doubleValue] > 100000 withColor:nil];
            if(payment.accountAsCategory != nil && payment.category == nil){
                cell.imageView.image = [UIImage imageNamed:@"icon-transfer.png"];
                [lbSum setTextColor:kColorHexBlack];
            }
            lbSum.adjustsFontSizeToFitWidth = YES;
            lbSum.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:lbSum];
            
            if (indexPath.section == 0) {
                lbCat.text = [payment.date dateTitleWeekDay];
                if(payment.account == nil){
                    lbAcc.text = NSLocalizedString(@"PaymentListUndefined", @"");
                    lbColorForTime.text = NSLocalizedString(@"PaymentListUndefined", @"");
                }
                [lbSum setTextFromNumber:[payment.sumMain doubleValue] asInteger:[payment.sumMain doubleValue] > 100000 withColor:[UIColor colorWithHex:kColorHexBlue]];
                
            }
        }
        else
        {
            UILabel* lbCat = [[UILabel alloc] initWithFrame:CGRectMake(originX, 16, 150-originX, 20)];
            lbCat.font = [UIFont fontWithName:kFont1 size:16.0f];
            lbCat.textColor = [UIColor colorWithRed:(26/255.0) green:(26/255.0) blue:(26/255.0) alpha:1];
            lbCat.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:lbCat];
        }
        
    }
    
   
    [self tableViewPlain:tableView
                  configureCell:cell
                  withIndexPath:indexPath];
    
    //   [AGTools tableView:tableView
    //changeAccessoryArrowForCell:cell];
    return cell;
}


- (void) tableViewPlain:(UITableView*)tableView
          configureCell:(UITableViewCell*)cell
          withIndexPath:(NSIndexPath*)indexPath{
    UIImageView *background;
    UIImageView* backgroundHighlighted;
    switch (_cellType) {
        case 0:{
            [AGTools tableViewPlain:tableView
        configureCell:cell
        withIndexPath:indexPath];
            break;
        }
        case 1:{
            background=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell-split-pressed-middle.png"]];
            backgroundHighlighted=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell-split-pressed-middle.png"]];
            [cell setBackgroundView:background];
            [cell setSelectedBackgroundView:backgroundHighlighted];

            break;
        }
        case 2:{
            background=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell-split-top.png"]];
            backgroundHighlighted=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_1-highlighted"]];
            [cell setBackgroundView:background];
            [cell setSelectedBackgroundView:backgroundHighlighted];
            break;
        }
        case 3:{
            background=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell-split-pressed-end.png"]];
            backgroundHighlighted=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell-split-pressed-end.png"]];
            [cell setBackgroundView:background];
            [cell setSelectedBackgroundView:backgroundHighlighted];
            break;
        }
        default:
            break;
    }
}



- (void) infoImageTapped:(id) sender {
    
    [_arrayForCategories removeAllObjects];
    [_arrayForSum removeAllObjects];
    [_arrayForDate removeAllObjects];
    
    NSIndexPath *indexPath = [_arrayForCell objectAtIndex:((UIGestureRecognizer *)sender).view.tag];
    
    //NSLog(@"section: %d, row: %d", indexPath.section, indexPath.row);
    
    
    if(_indexPathForCell)
    {
        _indexPathForCell = nil;
    }
    else
    {
        
        _indexPathForCell = indexPath;
        
        Payment *payment;
        
        if (_indexPathForCell.section == 0) {
            payment = (Payment*)[_paymentsNotFinished objectAtIndex:_indexPathForCell.row];
        }else{
            payment = (Payment*)[[_paymentsFinished objectAtIndex:_indexPathForCell.section-1]objectAtIndex:_indexPathForCell.row];
        }
        
        
        for(Payment* p in payment.subpayments)
        {
            if (p.category)
                [_arrayForCategories addObject:p.category];
            if (p.sum){
                if(p.category.type == [NSNumber numberWithInt:CatTypeExpense])
                    [_arrayForSum addObject:[NSNumber numberWithDouble:[p.sum doubleValue]*(-1)]];
                else
                    [_arrayForSum addObject:p.sum];
            }
            if(p.date)
                [_arrayForDate addObject:[p.date dateTitleHourMinute]];
        }
        _paymentTitle = payment.account.title;
    }
    
    [self.tvPayments reloadData];
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.0f;
    }
    if((section == [self numberOfSectionsInTableView:tableView]-1) && (_recordsHasMore)){
        return 0.0f;
    }
    return 28.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }
    if((section == [self numberOfSectionsInTableView:tableView]-1) && (_recordsHasMore)){
        return nil;
    }
    NSString* title = [((Payment*)[((NSArray*)[_paymentsFinished objectAtIndex:section-1]) objectAtIndex:0]).date dateTitleWeekDay];
    return [AGTools tableViewHeaderViewWithTitle:title height:[self tableView:tableView heightForHeaderInSection:section]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isTapped && indexPath.row == _cellTag)
        return 180;
    return [AGTools cellStandardHeight];
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_indexPathForCell && indexPath.row > _indexPathForCell.row && indexPath.row <= _indexPathForCell.row + [_arrayForCategories count])
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    AGPaymentEditController* ctl = [[AGPaymentEditController alloc] initWithNibName:@"AGPaymentEditView" bundle:nil];
    if(indexPath.section == 0){
        ctl.payment = [_paymentsNotFinished objectAtIndex:indexPath.row];
    }else{
        if(_indexPathForCell)
        {
            if (_indexPathForCell && _indexPathForCell.section == indexPath.section && indexPath.row > _indexPathForCell.row + [_arrayForCategories count])
            {
                if(indexPath.row - [_arrayForCategories count] < [[_paymentsFinished objectAtIndex:indexPath.section - 1] count])
                {
                    ctl.payment = (Payment*)[[_paymentsFinished objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row - [_arrayForCategories count]];
                }
            }
            else
            {
                ctl.payment = [[_paymentsFinished objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row];
            }
        }
        else
        {
            ctl.payment = [[_paymentsFinished objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row];
        }
        
    }
    ctl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctl animated:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(_tvPayments.contentOffset.y >= (_tvPayments.contentSize.height - _tvPayments.bounds.size.height)) {
        [self appendPayments];
    }
}

- (void) appendPayments{
    if ((_recordsLoading == NO) && (_recordsHasMore == YES)) {
        _recordsLoading = YES;
        //        AGLog(@"%@", _paymentsFinished);
        int a = [self paymentsFinishedCount];
        _paymentsFinished = [kUser paymentsFinishedSortedByDateWithAccount:_account first:_recordsFrame];
        //        AGLog(@"%@", _paymentsFinished);
        int b = [self paymentsFinishedCount];
        if(b != a){
            _recordsFrame += kRecordsFrame;
        }else{
            _recordsHasMore = NO;
        }
        [_tvPayments reloadData];
        _recordsLoading = NO;
    }
}

- (int) paymentsFinishedCount{
    int a = _paymentsFinished.count;
    for (int i = 0; i < _paymentsFinished.count; i++) {
        a += [[_paymentsFinished objectAtIndex:i] count];
    }
    return a;
}

@end
