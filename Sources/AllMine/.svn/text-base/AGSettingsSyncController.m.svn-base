//
//  AGSettingsSyncController.m
//  AllMine
//
//  Created by Allgoritm LLC on 08.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "AGSettingsSyncController.h"
#import "AGTools.h"
#import "UIColor+AGExtensions.h"
#import "User+EntityWorker.h"
#import "AGAppDelegate.h"
#import "AGRootController.h"
#import "AGDBWorker.h"
#import "DCRoundSwitch.h"

@interface AGSettingsSyncController ()
@property(nonatomic, strong) IBOutlet UITableView* tvItems;

@property(nonatomic, strong) DCRoundSwitch* swViaWiFiOnly;

@end

@implementation AGSettingsSyncController

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
    self.navigationItem.title = NSLocalizedString(@"SettingsSync", @"");
    self.navigationItem.leftBarButtonItem = [AGTools navigationBarButtonItemWithImageNamed:@"button-back" target:self action:@selector(back)];
    
    _tvItems.scrollEnabled = NO;
    _tvItems.delegate = self;
    _tvItems.dataSource = self;
    
    _swViaWiFiOnly = [[DCRoundSwitch alloc] initWithFrame:CGRectMake(210, 16, 70, 25)];
    _swViaWiFiOnly.on = [(kUser).syncViaWiFiOnly boolValue];
    self.swViaWiFiOnly.onText = NSLocalizedString(@"YES", @"");
    self.swViaWiFiOnly.offText = NSLocalizedString(@"NO", @"");
    self.swViaWiFiOnly.onTintColor = [UIColor colorWithHex:kColorHexSwitchOn];
}

-(void)viewWillAppear:(BOOL)animated{
    [_tvItems reloadData];
}

#pragma mark - buttons
- (void) back{
    (kUser).syncViaWiFiOnly = [NSNumber numberWithBool:_swViaWiFiOnly.on];
    [[AGDBWorker sharedWorker] saveManagedContext];
    [(kRoot) syncTimerStart];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 2;
            break;
        default:
            return 1;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* CellIdentifier = @"settingsSyncCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;        
    }else{
        for (UISwitch* sw in cell.contentView.subviews) {
            [sw removeFromSuperview];
        }
    }
    cell.textLabel.font = [UIFont fontWithName:kFont1 size:18.0f];
    cell.textLabel.backgroundColor=[UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithHex:kColorHexBlack];
    cell.accessoryType = UITableViewCellAccessoryNone;
    User* usr = (kUser);
    switch (indexPath.section) {
        case 0:{
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"SettingsSyncAuto", @"");
                    if ([usr.syncAuto boolValue]) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    break;
                default:
                    cell.textLabel.text = NSLocalizedString(@"SettingsSyncManual", @"");
                    if (![usr.syncAuto boolValue]) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    break;
            }
            break;
        }
        case 1:{
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = NSLocalizedString(@"SettingsSyncWiFiOnly", @"");
            [cell.contentView addSubview:_swViaWiFiOnly];
            break;
        }
        default:
            break;
    }
    
    [AGTools tableViewGrouped:tableView
                configureCell:cell
                withIndexPath:indexPath];
    return cell;
}

//header
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return [AGTools tableViewGroupedHeaderViewWithTitle:[NSLocalizedString(@"SettingsSyncHeader", @"") uppercaseString]
                                                         height:[self tableView:tableView heightForHeaderInSection:section]];
            
        default:
            return nil;
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return kTableHeaderStandardHeight;
            
        default:
            return 0;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [AGTools cellStandardHeight];
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    (kUser).syncAuto = [NSNumber numberWithBool:indexPath.row == 0];
    [_tvItems reloadData];
}

@end
