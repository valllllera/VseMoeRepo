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

#define kRecordsFrame 20

@interface AGPaymentListController ()

@property(nonatomic, strong) NSArray* paymentsFinished;
@property(nonatomic, strong) NSArray* paymentsNotFinished;
@property(nonatomic, strong) IBOutlet UITableView* tvPayments;

@property(nonatomic, assign) int recordsFrame;
@property(nonatomic, assign) BOOL recordsLoading;
@property(nonatomic, assign) BOOL recordsHasMore;

@end

@implementation AGPaymentListController

@synthesize account = _account;
@synthesize tvPayments = _tvPayments;
@synthesize paymentsFinished = _paymentsFinished;
@synthesize paymentsNotFinished = _paymentsNotFinished;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _account = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

- (void) addPayment{
    AGPaymentEditController* ctl = [[AGPaymentEditController alloc] initWithNibName:@"AGPaymentEditView" bundle:nil];
    ctl.hidesBottomBarWhenPushed = YES;    
    [self.navigationController pushViewController:ctl animated:YES];
}

#pragma mark - UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_paymentsFinished count]+1+(_recordsHasMore?1:0);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [_paymentsNotFinished count];
    }
    if((section == [self numberOfSectionsInTableView:tableView]-1) && (_recordsHasMore)){
        return 1;
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
            payment = (Payment*)[[_paymentsFinished objectAtIndex:indexPath.section-1]objectAtIndex:indexPath.row];
        }
        
    //    if (payment.template != nil) {
    //        cell.imageView.image = [UIImage imageNamed:@"star"];
    //    }
        double originX = 30.0;
        
        UILabel* lbCat = [[UILabel alloc] initWithFrame:CGRectMake(originX, 16, 150-originX, 20)];
        lbCat.font = [UIFont fontWithName:kFont1 size:16.0f];
        lbCat.textColor = [UIColor colorWithHex:kColorHexBlack];
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
        lbAcc.textColor = [UIColor colorWithHex:kColorHexBrown];
    //    lbAcc.text = [NSString stringWithFormat:@"%@, %@", payment.account.title, [payment.date dateTitleHourMinute]];
        lbAcc.text = [NSString stringWithFormat:@"%@", payment.account.title];
        lbAcc.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:lbAcc];
        
        UILabel* lbSum = [[UILabel alloc] initWithFrame:CGRectMake(150, 22, 140, 20)];
        lbSum.font = [UIFont fontWithName:kFont1 size:18.0f];
        [lbSum setTextFromNumber:[payment.sumMain doubleValue] asInteger:[payment.sumMain doubleValue] > 100000 withColor:nil];
        lbSum.adjustsFontSizeToFitWidth = YES;
        lbSum.backgroundColor = [UIColor clearColor];    
        [cell.contentView addSubview:lbSum];
        
        if (indexPath.section == 0) {
            lbCat.text = [payment.date dateTitleWeekDay];
            if(payment.account == nil){
                lbAcc.text = NSLocalizedString(@"PaymentListUndefined", @"");
            }
            [lbSum setTextFromNumber:[payment.sumMain doubleValue] asInteger:[payment.sumMain doubleValue] > 100000 withColor:[UIColor colorWithHex:kColorHexBlue]];
        }
    }
    
    [AGTools tableViewPlain:tableView
              configureCell:cell
              withIndexPath:indexPath];
    
 //   [AGTools tableView:tableView
//changeAccessoryArrowForCell:cell];
    return cell;
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
    return [AGTools cellStandardHeight];
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AGPaymentEditController* ctl = [[AGPaymentEditController alloc] initWithNibName:@"AGPaymentEditView" bundle:nil];
    if(indexPath.section == 0){
        ctl.payment = [_paymentsNotFinished objectAtIndex:indexPath.row];
    }else{
        ctl.payment = [[_paymentsFinished objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row];
        
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
