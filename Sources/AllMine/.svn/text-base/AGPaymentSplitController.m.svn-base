//
//  AGPaymentSplitController.m
//  AllMine
//
//  Created by Allgoritm LLC on 14.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "AGPaymentSplitController.h"
#import "AGTools.h"
#import "UILabel+AGExtensions.h"
#import "Category+EntityWorker.h"
#import "Payment+EntityWorker.h"
#import "AGAppDelegate.h"
#import "AGRootController.h"
#import "UIColor+AGExtensions.h"
#import "UIView+AGExtensions.h"
#import "NSString+AGExtensions.h"
#import "AGPaymentSplitCell.h"

@interface AGPaymentSplitController ()

@property(nonatomic, strong) IBOutlet UITableView* tvSplit;
@property(nonatomic, strong) IBOutlet UIButton* bnSave;
@property(nonatomic, strong) IBOutlet UILabel* lbSum;
@property(nonatomic, strong) IBOutlet UILabel* lbCategory;
@property(nonatomic, strong) IBOutlet UILabel* lbError;

@property(nonatomic, strong) NSIndexPath* indexCurrentCell;

@end

@implementation AGPaymentSplitController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _subpayments = [NSMutableArray array];
        _sum = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = NSLocalizedString(@"PaymentEditSplit", @"");
    self.navigationItem.leftBarButtonItem = [AGTools navigationBarButtonItemWithImageNamed:@"button-back" target:self action:@selector(back)];
    
    _tvSplit.dataSource = self;
    _tvSplit.delegate = self;
    _tvSplit.scrollEnabled = YES;
    
    _lbSum.font = [UIFont fontWithName:kFont2 size:40.0f];
    [_lbSum setTextFromNumber:_sum asInteger:NO withColor:[UIColor colorWithHex:kColorHexPaymentResult]];
    
    _lbCategory.font = [UIFont fontWithName:kFont1 size:14.0f];
    _lbCategory.textColor = [UIColor colorWithHex:kColorHexWhite];
    if(_category){
        _lbCategory.text = _category.title;
    }else{
        _lbCategory.text = @"";
    }
    
    _lbError.numberOfLines = 2;
    _lbError.font = [UIFont fontWithName:kFont1 size:20.0f];
    _lbError.textColor = [UIColor colorWithHex:kColorHexOrange];
    _lbError.text = [NSLocalizedString(@"PaymentSplitError", @"") uppercaseString];
    _lbError.hidden = YES;
    
    _bnSave.titleLabel.font = [UIFont fontWithName:kFont1 size:16.0f];
    [_bnSave setTitleColor:[UIColor colorWithHex:kColorHexWhite] forState:UIControlStateNormal];
    [_bnSave setTitle:NSLocalizedString(@"Save", @"") forState:UIControlStateNormal];
    
    _subpayments = [NSMutableArray arrayWithArray:_subpayments];

    self.tvSplit.sectionFooterHeight = 0.0f;
    self.tvSplit.sectionHeaderHeight = 0.0f;
}

- (void) viewWillAppear:(BOOL)animated{
    [_tvSplit reloadData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:kEventAGKeyboardWillHide
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:kEventAGKeyboardWillShow
                                               object:nil];
}

-(void)keyboardWillShow{
    _tvSplit.tag = 1;
    CGSize size = _tvSplit.frame.size;
    size.height = 100;
    if (isIphoneRetina4) {
        size.height = 188;
    }
    [_tvSplit sizeChangeAnimated:size];
    [self performSelector:@selector(scrollIn)
               withObject:self
               afterDelay:kSlideAnimationTime];
}
-(void)scrollIn{
    [_tvSplit scrollToRowAtIndexPath:self.indexCurrentCell
                    atScrollPosition:UITableViewScrollPositionMiddle
                            animated:YES];
}
-(void)keyboardWillHide{
    [_tvSplit sizeReturnAnimated];
    [_tvSplit reloadData];
}

#pragma mark - buttons
- (void) back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)save:(id)sender{
    if([_delegate respondsToSelector:@selector(splitFinishedWithArray:)]){
        [_delegate splitFinishedWithArray:_subpayments];
    }
    [self back];
}

#pragma mark - UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _subpayments.count==0 ? 3 : 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int num = 1;
    if (section == 0) {
        num = [_subpayments count];
    }
    return num;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* CellIdentifier = @"paymentEditSplitsCell";
    
    AGPaymentSplitCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[AGPaymentSplitCell alloc] initWithStyle:UITableViewCellStyleValue1
                                         reuseIdentifier:CellIdentifier
                                                delegate:self
                                              cellHeight:[self tableView:tableView heightForRowAtIndexPath:indexPath]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    [cell setTitleCategory:NSLocalizedString(@"PaymentSplitCategory", @"")];
    [cell setTitleBalance:@"0"];
    
    if (indexPath.section == 0) {
        NSMutableDictionary* dict = [_subpayments objectAtIndex:indexPath.row];
        if([dict objectForKey:kCategory] != nil){
            [cell setTitleCategory:((Category*)[dict objectForKey:kCategory]).title];
            [cell setColorCategory:[UIColor colorWithHex:kColorHexBlack]];
        }
        if([dict objectForKey:kSum] != nil){
            [cell setTitleBalance:[NSString formattedStringFromNumber:[dict objectForKey:kSum]]];
            [cell setColorBalance:[UIColor colorWithHex:kColorHexBlack]];
        }
    }
    if([indexPath isEqual:self.indexCurrentCell]){
        [self checkBalance];
    }
    
    [AGTools tableViewGrouped:tableView
                configureCell:cell
                withIndexPath:indexPath];
    return cell;
}

//footer
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView* v = nil;
    if (section == [self numberOfSectionsInTableView:tableView]-1){
         v = [AGTools tableViewGroupedFooterViewWithTitle:NSLocalizedString(@"PaymentSplitFooter", @"")
                                                   height:[self tableView:tableView heightForFooterInSection:section]
                                               numOfLines:3];
    }
    return v;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    float height = 0;
    if (section == [self numberOfSectionsInTableView:tableView]-1){
        height = 50.0f;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [AGTools cellStandardHeight];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 0;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_subpayments removeObjectAtIndex:indexPath.row];
        [_tvSplit reloadData];
    }
}

#pragma mark - AGPaymentSplitCellDelegate
- (void) paymentSplitCellBalancePressed:(AGPaymentSplitCell *)cell{
    _lbError.hidden = YES;
    _lbCategory.hidden = NO;
    _lbSum.hidden = NO;
    self.indexCurrentCell = [self.tvSplit indexPathForCell:cell];
    if (self.indexCurrentCell.section != 0) {
        [self addEmptySubpayment];
    }
    [(kRoot) showKeyboardWithState:AGKBStateFull
                          delegate:self
                          animated:YES];
}

- (void) paymentSplitCellCategoryPressed:(AGPaymentSplitCell *)cell{
    AGSettingsCategoriesController* ctl = [[AGSettingsCategoriesController alloc] initWithNibName:@"AGSettingsCategoriesView" bundle:nil];
    ctl.delegate = self;
    self.indexCurrentCell = [self.tvSplit indexPathForCell:cell];
    if (self.indexCurrentCell.section != 0) {
        [self addEmptySubpayment];
    }
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void) addEmptySubpayment{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSNumber numberWithDouble:0.0]
            forKey:kSum];
    [_subpayments addObject:dict];
}

#pragma mark - AGSettingsCategoriesDelegate
-(void)selectedCategory:(Category *)category{
    NSMutableDictionary* dict = [self subpaymentForIndexCurrentCell];
    [dict setValue:category forKey:kCategory];
    
    [self.navigationController popToViewController:self animated:YES];
    
    [_tvSplit reloadData];
}

-(void)checkBalance{
    double sum = 0;
    for (NSDictionary* dict in _subpayments) {
        sum += [[dict objectForKey:kSum] doubleValue];
    }
    int a = sum < 0 ? -1 : 1;
    int b = _sum < 0 ? -1 : 1;
    if(((a == b) && (fabs(sum) > fabs(_sum))) ||
        (a != b)){
        [[self currentCell] setColorBalance:[UIColor colorWithHex:kColorHexOrange]];
        _lbError.hidden = NO;
        _lbCategory.hidden = YES;
        _lbSum.hidden = YES;
    }
}

#pragma mark - AGKeyboardDelegate
-(void)keyboardNumberPressed:(NSString *)number
             operationString:(NSString *)operationString
                      result:(double)result{
    [[self currentCell] setTitleBalance:operationString];
    NSMutableDictionary* dict = [self subpaymentForIndexCurrentCell];
    [dict setValue:[NSNumber numberWithDouble:result]
            forKey:kSum];
}

-(void)keyboardOperationPressed:(NSString *)operation
                operationString:(NSString *)operationString
                         result:(double)result{
    [self keyboardNumberPressed:operation
                operationString:operationString
                         result:result];
}

-(void)keyboardResultPressed:(double)result
             operationString:(NSString *)operationString{
    NSMutableDictionary* dict = [self subpaymentForIndexCurrentCell];
    [dict setValue:[NSNumber numberWithDouble:result]
            forKey:kSum];
    [_tvSplit reloadData];
}

#pragma mark - helpers
- (NSMutableDictionary*) subpaymentForIndexCurrentCell{
    NSInteger index = self.indexCurrentCell.section == 0 ?
                    self.indexCurrentCell.row :
                    self.subpayments.count-1;
    return [_subpayments objectAtIndex:index];
}

- (AGPaymentSplitCell*) currentCell{
    return (AGPaymentSplitCell*)[self.tvSplit cellForRowAtIndexPath:self.indexCurrentCell];
}

@end
