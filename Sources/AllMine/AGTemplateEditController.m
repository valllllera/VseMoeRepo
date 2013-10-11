//
//  AGPaymentAddFavouriteNewController.m
//  AllMine
//
//  Created by Allgoritm LLC on 16.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "AGTemplateEditController.h"
#import "AGTools.h"
#import "Account+EntityWorker.h"
#import "Category+EntityWorker.h"
#import "UILabel+AGExtensions.h"
#import "Currency+EntityWorker.h"
#import "AGAppDelegate.h"
#import "AGRootController.h"
#import "Template+EntityWorker.h"
#import "Payment+EntityWorker.h"
#import "NSDate+AGExtensions.h"
#import "User+EntityWorker.h"
#import "UIColor+AGExtensions.h"
#import "AGDBWorker.h"
#import "UIView+AGExtensions.h"

@interface AGTemplateEditController ()

@property(nonatomic, strong) IBOutlet UILabel* lbSum;
@property(nonatomic, strong) IBOutlet UILabel* lbCurrency;
@property(nonatomic, strong) IBOutlet UIButton* bnRemove;
@property(nonatomic, strong) IBOutlet UITableView* tvInfo;
@property(nonatomic, strong) IBOutlet UIView* vInfo;
@property(nonatomic, strong) IBOutlet UIView* vSum;

@property(nonatomic, strong) UITextField* tfTitle;
@property(nonatomic, strong) UITextView* tfComment;
@property(nonatomic, strong) UITableViewCell* cell_comment;

@property(nonatomic, strong) Account* account;
@property(nonatomic, strong) Category* category;
@property(nonatomic, strong) Account* accountAsCategory;
@property(nonatomic, strong) NSString* templTitle;
@property(nonatomic, strong) NSString* comment;

@property(nonatomic, strong) NSArray* accounts;
@property(nonatomic, assign) int numberOfLines;

-(IBAction)remove:(id)sender;
-(void)back;
-(void)save;
@end

@implementation AGTemplateEditController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _currency = nil;
        _category = nil;
        _account = nil;
        _accountAsCategory = nil;
        _comment = @"";
        _templTitle = @"";
        _subpayments = [NSMutableArray array];
        _sum = 0.0;
        _ptemplate = nil;
        _addPayment = NO;
        _numberOfLines =0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer: tapRec];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title=NSLocalizedString(@"PaymentAddFavourite", @"");
    
 //   self.navigationItem.title = NSLocalizedString(@"PaymentAddFavourite", @"");
    self.navigationItem.leftBarButtonItem = [AGTools navigationBarButtonItemWithImageNamed:@"button-back" target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [AGTools navigationBarButtonItemWithTitle:NSLocalizedString(@"Save", @"") imageNamed:@"button-save" target:self action:@selector(save)];

    if (_ptemplate) {
        _account = _ptemplate.account;
        _category = _ptemplate.category;
        _accountAsCategory = _ptemplate.accountAsCategory;
        _comment = _ptemplate.comment;
        _templTitle = _ptemplate.title;
    }
    
    _accounts = [(kUser).accounts allObjects];
    
    _lbCurrency.font = [UIFont fontWithName:kFont1 size:16.0f];
    _lbCurrency.textColor = [UIColor colorWithHex:kColorHexWhite];
    if(_currency){
        _lbCurrency.text = _currency.title;
    }
    
    _lbSum.font = [UIFont fontWithName:kFont2 size:40.0f];
    [_lbSum setTextFromNumber:_sum asInteger:NO withColor:[UIColor colorWithHex:kColorHexPaymentResult]];
    if((_addPayment == NO)||(_sum == 0.0)){
        CGRect frame = _vInfo.frame;
        frame.size.height += 96;
        frame.origin.y = 0;
        _vInfo.frame = frame;
        _vSum.hidden = YES;
    }else{
        CGRect frame = _vInfo.frame;
        frame.size.height += 40;
        _vInfo.frame = frame;
    }
    
    _tvInfo.scrollEnabled = YES;
    _tvInfo.delegate = self;
    _tvInfo.dataSource = self;
    
    _bnRemove.titleLabel.font = [UIFont fontWithName:kFont1 size:16.0f];
    [_bnRemove setTitleColor:[UIColor colorWithHex:kColorHexWhite] forState:UIControlStateNormal];
    [_bnRemove setTitle:NSLocalizedString(@"PaymentTemplateRemove", @"") forState:UIControlStateNormal];
    if (_ptemplate == nil) {
        [_bnRemove setHidden:YES];
    }
    
    _tfTitle = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 300, [AGTools cellStandardHeight])];
    _tfTitle.textColor = [UIColor colorWithHex:kColorHexBlack];
    _tfTitle.font = [UIFont fontWithName:kFont1 size:18.0f];
    _tfTitle.placeholder = NSLocalizedString(@"PaymentAddFavouriteNewTitle", @"");
    _tfTitle.delegate = self;
    _tfTitle.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    _tfComment = [[UITextView alloc] initWithFrame:CGRectMake(5, 10, 288, [AGTools cellStandardHeight]+_tfComment.contentSize.height)];
    _tfComment.textColor = [UIColor colorWithHex:kColorHexGray];
    _tfComment.font = [UIFont fontWithName:kFont1 size:18.0f];
    _tfComment.text = NSLocalizedString(@"AccountEditComment", @"");
    //_tfComment.pagingEnabled = NSLocalizedString(@"PaymentEditComment", @"");
    _tfComment.backgroundColor = [UIColor clearColor];
    _tfComment.delegate = self;
//    _tfComment.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}

-(void)viewWillAppear:(BOOL)animated{
    //[AGTools navigationBarSetOffsetZero:self.navigationController.navigationBar];
    [_tvInfo reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    //[AGTools navigationBarSetOffsetStandart:self.navigationController.navigationBar];
}

#pragma mark - buttons
- (void) back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tap:(UITapGestureRecognizer *)tapRec{
    [[self view] endEditing: YES];
}

-(IBAction)remove:(id)sender{
    if (_ptemplate) {
        [_ptemplate markRemovedSave:YES];
        [self back];
    }
}

- (void) save{
    NSLog(@"acc: %@, accAsCat: %@", _account.title, _accountAsCategory.title);
    if (([_templTitle isEqualToString:@""])
        || (_account == nil)
        || ((_category == nil)&&(_accountAsCategory == nil))) return;
    User* usr = (kUser);
    if(_category.type == [NSNumber numberWithInt:CatTypeExpense])
        _sum*=-1;
    if (_addPayment) {
        double sumMain = _sum * [_currency rateValueWithDate:[NSDate today] mainCurrency:usr.currencyMain];
        Template* tmpl = [Template insertTemplateWithUser:usr
                                                    title:_templTitle
                                                  account:_account
                                                 category:_category
                                        accountAsCategory:_accountAsCategory
                                                  comment:_comment
                                                     save:YES];
        Payment* payment = [Payment insertPaymentWithUser:usr
                                                  account:_account
                                                 category:_category
                                        accountAsCategory:_ptemplate.accountAsCategory
                                                 currency:_currency
                                                      sum:_sum
                                                  sumMain:sumMain
                                                rateValue:_rateValue
                                                     date:[NSDate date]
                                                  comment:_comment
                                                ptemplate:tmpl
                                                 finished:YES
                                                   hidden:NO
                                                     save:YES];
        
        for (NSDictionary* d in _subpayments) {
            [Payment insertSubPaymentWithCategory:[d objectForKey:kCategory]
                                              sum:[[d objectForKey:kSum] doubleValue]
                                     superpayment:payment
                                             save:YES];
        }
        [[AGDBWorker sharedWorker] saveManagedContext];
        
        if ((self.delegate) && ([self.delegate respondsToSelector:@selector(templateEditController:didAddedPayment:)])){
            [self.delegate templateEditController:self
                                  didAddedPayment:payment];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }else if(_ptemplate == nil){
        // THIS SECTION is only for template creation and it is not used
        [Template insertTemplateWithUser:usr
                                   title:_templTitle
                                 account:_account
                                category:_category
                       accountAsCategory:_accountAsCategory
                                 comment:_comment
                                    save:YES];
        [self back];
    }else{
        _ptemplate.title = _templTitle;
        _ptemplate.account = _account;
        _ptemplate.category = _category;
        _ptemplate.accountAsCategory = _accountAsCategory;
        _ptemplate.comment = _comment;
        _ptemplate.modifiedDate = [NSDate date];
        [[AGDBWorker sharedWorker] saveManagedContext];
        [self back];        
    }
}

#pragma mark - UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section != 1) {
        return 1;
    }
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* CellIdentifier = @"templateEditInfoCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;        
    }else{
        for (UIView* v in cell.contentView.subviews) {
            if([v isKindOfClass:[UITextField class]] || [v isKindOfClass:[UITextView class]] || [v isKindOfClass:[UILabel class]]){
                [v removeFromSuperview];
            }
        }
    }

    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.font = [UIFont fontWithName:kFont1 size:18.0f];
    cell.textLabel.backgroundColor=[UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithHex:kColorHexBlack];
    switch (indexPath.section) {
        case 0:{
            _tfTitle.text = _templTitle;
            [cell.contentView addSubview:_tfTitle];         
            break;
        }
        case 1:{
            switch (indexPath.row) {
                case 0:
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    if(_account == nil){
                        cell.textLabel.textColor = [UIColor colorWithHex:kColorHexGray];
                        cell.textLabel.backgroundColor=[UIColor clearColor];
                        cell.textLabel.text = NSLocalizedString(@"PaymentEditFrom", @"");
                    }else{
                        cell.textLabel.text = _account.title;
                        cell.textLabel.backgroundColor=[UIColor clearColor];
                    }
                    break;
                default:
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    if((_category == nil)&&(_accountAsCategory == nil)){
                        cell.textLabel.textColor = [UIColor colorWithHex:kColorHexGray];
                        cell.textLabel.backgroundColor=[UIColor clearColor];
                        cell.textLabel.text = NSLocalizedString(@"PaymentEditTo", @"");
                    }else{
                        if (_category != nil) {
                            cell.textLabel.text = _category.title;
                            cell.textLabel.backgroundColor=[UIColor clearColor];
                        }else{
                            cell.textLabel.text = _accountAsCategory.title;
                            cell.textLabel.backgroundColor=[UIColor clearColor];
                        }
                    }
                    break;
            }
            break;
        }
        default:{
            if(![_tfComment.text isEqual:NSLocalizedString(@"AccountEditComment", @"")])
                _tfComment.text = _comment;
            cell.textLabel.text = @"";
            _cell_comment = cell;
            [cell.contentView addSubview:_tfComment];
            break;
        }
    }
    
    [AGTools tableViewGrouped:tableView
                configureCell:cell
                withIndexPath:indexPath];
    if (indexPath.section==2)
    {
        UIImageView *background;
        background=[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"cell-comment"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)]];
        [cell setBackgroundView:background];
    }
    
    return cell;
}

//footer

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView* footer = nil;
    if((_vSum.hidden) && (section == 0)){
        footer = [AGTools tableViewGroupedFooterViewWithTitle:NSLocalizedString(@"PaymentAddFavouriteNewFooter", @"")
                                                     height:[self tableView:tableView heightForFooterInSection:section]
                                                 numOfLines:3
                  ];
    }
    return footer;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    NSInteger height = 0;
    switch (section) {
        case 0:
            if (_vSum.hidden) {
                height = 35.0f;
            }
            break;
            
        default:
            height = 0;
            break;
    }
    return height;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section!=2)
        return [AGTools cellStandardHeight];

    else{
        return [AGTools cellStandardHeight] +_tfComment.contentSize.height-30;
    }
    
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section != 1) return;
    if(indexPath.row == 0){
        AGAccountListController* ctl = [[AGAccountListController alloc] initWithNibName:@"AGAccountListView" bundle:nil];
        ctl.ctlState = AccountListStateSelect;
        ctl.delegateSelect = self;
        [self.navigationController pushViewController:ctl animated:YES];
    }else{
        AGSettingsCategoriesController* ctl = [[AGSettingsCategoriesController alloc] initWithNibName:@"AGSettingsCategoriesView" bundle:nil];
        ctl.delegate = self;
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

#pragma mark - UITextFieldDelegate
-(void)textViewDidBeginEditing:(UITextView *)textField{
    if (textField == _tfComment) {
        if (_cell_comment) {
            UIImageView *background;
            background=[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"cell-comment-highlighted"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)]];
            [_cell_comment setBackgroundView:background];
        }
        _tvInfo.tag = 1;
        CGSize size = _tvInfo.frame.size;
        if (_vSum.isHidden == YES) {
            size.height = 200;
        }else{
            size.height = 100;
        }
        
        if ([textField.text isEqual:NSLocalizedString(@"AccountEditComment", @"")]){
            _tfComment.text = @"";
            _tfComment.textColor = [UIColor colorWithHex:kColorHexBlack];
        }
        
        [_tvInfo sizeChangeAnimated:size];
        [self performSelector:@selector(scrollIn) withObject:self afterDelay:kSlideAnimationTime-0.1];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqual:@"\n"]){
        CGRect frame = _tfComment.frame;
        frame.size.height+=_tfComment.contentSize.height;
        _tfComment.frame = frame;
    }
    if (_numberOfLines < (textView.contentSize.height / textView.font.leading)){
        CGRect frame = _tfComment.frame;
        frame.size.height+=(textView.contentSize.height / textView.font.leading)*10;
        _tfComment.frame = frame;
        _numberOfLines = textView.contentSize.height / textView.font.leading;
    }

    
    [_tvInfo beginUpdates];
    [_tvInfo endUpdates];
    return YES;
}


-(void)scrollIn{
    [_tvInfo scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

-(void)textViewDidEndEditing:(UITextView *)textField{
        _comment = textField.text;
        [_tvInfo sizeReturnAnimated];
        [_tvInfo reloadData];

}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    _templTitle = textField.text;
}


-(BOOL)textViewShouldReturn:(UITextView *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - AGSettingsCategoriesDelegate
-(void)selectedCategory:(Category *)category{
    _category = category;
    _accountAsCategory = nil;
    [self.navigationController popToViewController:self animated:YES];
}
-(void)selectedAccount:(Account *)account{
    _category = nil;
    _accountAsCategory = account;
    [self.navigationController popToViewController:self animated:YES];
}

#pragma mark - AGAccountListControllerSelectDelegate
-(void)accountListController:(AGAccountListController *)accountListCtl
            didSelectAccount:(Account *)account{
    _account = account;
    [_tvInfo reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
