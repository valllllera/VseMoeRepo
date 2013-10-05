//
//  AGSettingsCurrencyController.m
//  AllMine
//
//  Created by Allgoritm LLC on 07.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "AGSettingsCurrencyController.h"
#import "AGTools.h"
#import "User+EntityWorker.h"
#import "Currency+EntityWorker.h"
#import "AGRootController.h"
#import "AGAppDelegate.h"
#import "AGCurrencyListController.h"
#import "AGDBWorker.h"
#import "Rate+EntityWorker.h"
#import "UIColor+AGExtensions.h"

@interface AGSettingsCurrencyController ()
- (void) back;

@property(nonatomic, strong) Currency* mainCurrency;
@property(nonatomic, strong) Rate* mainCurrencyRate;
@property(nonatomic, strong) NSMutableArray* additionalCurrencies;

@property(nonatomic, retain) IBOutlet UITableView* tvItems;

@end

@implementation AGSettingsCurrencyController

@synthesize tvItems = _tvItems;
@synthesize additionalCurrencies = _additionalCurrencies;
@synthesize mainCurrency = _mainCurrency;
@synthesize mainCurrencyRate = _mainCurrencyRate;

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
    self.navigationItem.title = NSLocalizedString(@"SettingsCurrencyTitle", @"");
    self.navigationItem.leftBarButtonItem = [AGTools navigationBarButtonItemWithImageNamed:@"button-back" target:self action:@selector(back)];
        
    _tvItems.delegate = self;
    _tvItems.dataSource = self;
}

- (void) viewWillAppear:(BOOL)animated{
    User* usr = (kUser);
    _mainCurrency = usr.currencyMain;
    _additionalCurrencies = [NSMutableArray arrayWithArray: [usr.currenciesAdditional allObjects]];
    [_tvItems reloadData];
}

#pragma mark - buttons
- (void) back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDatasource/UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        default:
            return 1 + [_additionalCurrencies count];
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* CellIdentifier = @"settingsCurrencyCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;        
    }
    cell.textLabel.font = [UIFont fontWithName:kFont1 size:18.0f];
    cell.textLabel.textColor = [UIColor colorWithHex:kColorHexBlack];
    cell.textLabel.backgroundColor=[UIColor clearColor];
    cell.detailTextLabel.font = [UIFont fontWithName:kFont1 size:16.0];
    cell.detailTextLabel.backgroundColor=[UIColor clearColor];
    cell.detailTextLabel.textColor = [UIColor colorWithHex:kColorHexSettingsCurrencyMarine];
    cell.accessoryType = UITableViewCellAccessoryNone;
    switch (indexPath.section) {
        case 0:{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = _mainCurrency.title;
            cell.detailTextLabel.text = NSLocalizedString(@"SettingsCurrencyMain", @"");
            break;
        }
        case 1:{
            switch (indexPath.row) {
                case 0:
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.textLabel.textColor = [UIColor colorWithHex:kColorHexBrown];
                    cell.textLabel.text = NSLocalizedString(@"SettingsCurrencyAddCurrency", @"");
                    break;
                default:{
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    Currency* cur = [_additionalCurrencies objectAtIndex:indexPath.row - 1];
                    cell.textLabel.text = cur.title;
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f %@", [cur rateValueWithDate:[NSDate date] mainCurrency:_mainCurrency], _mainCurrency.title];
                    break;
                }
            }
            break;
        }
        default:
            break;
    }
    
    
    
    return cell;
}

//header
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 1:
            return [AGTools tableViewGroupedHeaderViewWithTitle:[NSLocalizedString(@"SettingsCurrencyAdditional", @"") uppercaseString]
                                                         height:[self tableView:tableView heightForHeaderInSection:section]];
            
        default:
            return nil;
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 1:
            return kTableHeaderStandardHeight;
            
        default:
            return 0;
            break;
    }
}

//footer
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    switch (section) {
        case 1:
            return [AGTools tableViewGroupedFooterViewWithTitle:NSLocalizedString(@"SettingsCurrencyFooter", @"")
                                                         height:[self tableView:tableView heightForFooterInSection:section]
                                                     numOfLines:3];
            
        default:
            return nil;
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    switch (section) {
        case 1:
            return 30.0f;
            
        default:
            return 0;
            break;
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return NO;
    }else{
        return YES;
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.row > 0) {
            User* usr = (kUser);
            [usr removeCurrenciesAdditionalObject:[_additionalCurrencies objectAtIndex:indexPath.row-1]];
            [[AGDBWorker sharedWorker] saveManagedContext];
            [_additionalCurrencies removeObjectAtIndex:indexPath.row-1];
            [tableView reloadData];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if(indexPath.row == 0){
        AGCurrencyListController* ctl = [[AGCurrencyListController alloc] initWithNibName:@"AGCurrencyListView" bundle:nil];
        ctl.delegate = self;
        ctl.tag = indexPath.section;
        ctl.currencies = [Currency currenciesWithUser:kUser];
        User* usr = (kUser);
        ctl.currenciesDisabled = [usr currenciesMainAdditionalSorted];
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

- (void) tableView:(UITableView *)tableView
   willDisplayCell:(UITableViewCell *)cell
 forRowAtIndexPath:(NSIndexPath *)indexPath{

    [AGTools tableViewGrouped:tableView
                configureCell:cell
                withIndexPath:indexPath];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [AGTools cellStandardHeight];
}

#pragma mark - AGCurrencyListDelegate
-(void)currencyListController:(AGCurrencyListController *)controller didFinishedSelectingCurrency:(Currency *)currency{
    User* usr = (kUser);
    if(controller.tag == 1){
        [usr addCurrenciesAdditionalObject:currency];
        [[AGDBWorker sharedWorker] saveManagedContext];
    }else{
        usr.currencyMain = currency;
        [usr recalculatePayments];
        [[AGDBWorker sharedWorker] saveManagedContext];
    }
}

@end
