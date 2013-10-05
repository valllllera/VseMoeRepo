//
//  AGAccountGroupController.m
//  AllMine
//
//  Created by Allgoritm LLC on 12.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "AGAccountListController.h"
#import "AGTools.h"
#import "User+EntityWorker.h"
#import "AGAppDelegate.h"
#import "AGRootController.h"
#import "Account+EntityWorker.h"
#import "AGAccountEditController.h"
#import "AGPaymentListController.h"
#import "Payment+EntityWorker.h"
#import "NSDate+AGExtensions.h"
#import "UILabel+AGExtensions.h"
#import "UIColor+AGExtensions.h"
#import "AGAccountSelectController.h"

@interface AGAccountListController ()

@property(nonatomic, strong) IBOutlet UITableView* tvAccounts;
@property(nonatomic, strong) NSArray* accountsCash;
@property(nonatomic, strong) NSArray* accountsBank;
@property(nonatomic, strong) NSArray* accountsElectron;
@property(nonatomic, strong) NSArray* accountsOther;

- (void) back;
- (void) addAccount;

@end

@implementation AGAccountListController

@synthesize tvAccounts = _tvAccounts;
@synthesize accountsCash = _accountsCash;
@synthesize accountsBank = _accountsBank;
@synthesize accountsElectron = _accountsElectron;
@synthesize accountsOther = _accountsOther;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = NSLocalizedString(@"AccountListAccounts", @"");
    self.navigationItem.leftBarButtonItem = [AGTools navigationBarButtonItemWithImageNamed:@"button-back" target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [AGTools navigationBarButtonItemWithImageNamed:@"button-add" target:self action:@selector(addAccount)];
    
    _tvAccounts.delegate = self;
    _tvAccounts.dataSource = self;
    _tvAccounts.separatorStyle = UITableViewCellSeparatorStyleNone;    
}

- (void) viewWillAppear:(BOOL)animated{
    User* usr = kUser;
    _accountsCash = [usr accountsByType:AccTypeCash];
    _accountsBank = [usr accountsByType:AccTypeBank];
    _accountsElectron = [usr accountsByType:AccTypeCardCredit];
    _accountsOther = [usr accountsByType:AccTypeLoan];
    [_tvAccounts reloadData];
}

#pragma mark - buttons
- (void) back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) addAccount{
    AGAccountSelectController* ctl = [[AGAccountSelectController alloc] initWithNibName:@"AGAccountSelect" bundle:nil];
    ctl.parentBack = self;
//    ctl.hidesBottomBarWhenPushed = YES;    
    [self.navigationController pushViewController:ctl animated:YES];
}

#pragma mark - UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return [_accountsCash count];
            break;
        case 1:
            return [_accountsBank count];
            break;
        case 2:
            return [_accountsElectron count];
            break;
        default:
            return [_accountsOther count];
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* CellIdentifier = @"accountsListCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        if (self.ctlState == AccountListStateNone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }else{
        for (UILabel* lb in cell.contentView.subviews) {
            [lb removeFromSuperview];
        }
    }

    Account* acc = nil;
    switch (indexPath.section) {
        case 0:
            acc = [_accountsCash objectAtIndex:indexPath.row];
            break;
        case 1:
            acc = [_accountsBank objectAtIndex:indexPath.row];
            break;
        case 2:
            acc = [_accountsElectron objectAtIndex:indexPath.row];
            break;
        default:
            acc = [_accountsOther objectAtIndex:indexPath.row];
            break;
    }

    double originX = 30.0;
    
    UILabel* lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(originX, 16, 150-originX, 20)];
    lbTitle.font = [UIFont fontWithName:kFont1 size:16.0f];
    lbTitle.textColor = [UIColor colorWithHex:kColorHexBlack];
    lbTitle.text = acc.title;
    lbTitle.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:lbTitle];

    Payment* p = [acc lastPayment];
    if(p != nil){
        UILabel* lbInfo = [[UILabel alloc] initWithFrame:CGRectMake(originX, 30, 140-originX, 20)];
        lbInfo.backgroundColor = [UIColor clearColor];
        lbInfo.font = [UIFont fontWithName:kFont1 size:11.0f];
        lbInfo.textColor = [UIColor colorWithHex:kColorHexBrown];
        lbInfo.text = [NSString stringWithFormat:@"%@, %+.2f", [p.date dateTitleDayMonthShort], [p.sumMain doubleValue]];
        if((lbInfo.text.length > 3) && ([[lbInfo.text substringFromIndex:lbInfo.text.length-3] isEqualToString:@".00"])){
            lbInfo.text = [lbInfo.text substringToIndex:lbInfo.text.length-3];
        }
        lbInfo.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:lbInfo];
    }
    
    double sum = [acc balance];
    UILabel* lbSum = [[UILabel alloc] initWithFrame:CGRectMake(150, 22, 140, 20)];
    lbSum.font = [UIFont fontWithName:kFont1 size:18.0f];
    [lbSum setTextFromNumber:sum asInteger:sum > 1000 withColor:nil];
    lbSum.adjustsFontSizeToFitWidth = YES;
    lbSum.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:lbSum];
    
    
    [AGTools tableViewPlain:tableView
              configureCell:cell
              withIndexPath:indexPath];
    
 /*   [AGTools tableView:tableView
changeAccessoryArrowForCell:cell];
   */
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 28.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    NSString* title = @"";
    switch (section) {
        case 0:
            title = @"AccountListCash";
            break;
        case 1:
            title = @"AccountListBank";
            break;
        case 2:
            title = @"AccountListElectron";
            break;            
        default:
            title = @"AccountListOther";
            break;
    }
    title = [NSLocalizedString(title, @"") uppercaseString];
    
    return [AGTools tableViewHeaderViewWithTitle:title height:[self tableView:tableView heightForHeaderInSection:section]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [AGTools cellStandardHeight];
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Account* acc = nil;
    switch (indexPath.section) {
        case 0:
            acc = [_accountsCash objectAtIndex:indexPath.row];
            break;
        case 1:
            acc = [_accountsBank objectAtIndex:indexPath.row];
            break;
        case 2:
            acc = [_accountsElectron objectAtIndex:indexPath.row];
            break;
        default:
            acc = [_accountsOther objectAtIndex:indexPath.row];
            break;
    }

    switch (self.ctlState) {
        case AccountListStateNone:{
            AGPaymentListController* ctl = [[AGPaymentListController alloc] initWithNibName:@"AGPaymentListView" bundle:nil];
            ctl.account = acc;
            [self.navigationController pushViewController:ctl animated:YES];
            break;
        }
            
        default:{
            if ((self.delegateSelect) && ([self.delegateSelect respondsToSelector:@selector(accountListController:didSelectAccount:)])){
                [self.delegateSelect accountListController:self
                                          didSelectAccount:acc];
            }
        }
            break;
    }
}

@end
