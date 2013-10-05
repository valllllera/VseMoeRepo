//
//  AGSettingsMainController.m
//  AllMine
//
//  Created by Allgoritm LLC on 07.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "AGSettingsMainController.h"
#import "AGTools.h"
#import "UIColor+AGExtensions.h"
#import "User+EntityWorker.h"
#import "AGAppDelegate.h"
#import "AGRootController.h"
#import "AGDBWorker.h"
#import "DCRoundSwitch.h"
#import "MainMenuCellController.h"

@interface AGSettingsMainController ()
@property(nonatomic, retain) IBOutlet UITableView* tvItems;
@property (nonatomic, strong) DCRoundSwitch* swResetAll;
@end

@implementation AGSettingsMainController

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
    self.navigationItem.title = NSLocalizedString(@"SettingsMain", @"");
    self.navigationItem.leftBarButtonItem = [AGTools navigationBarButtonItemWithImageNamed:@"button-back" target:self action:@selector(back)];
    
    _tvItems.scrollEnabled = NO;
    _tvItems.delegate = self;
    _tvItems.dataSource = self;
    
    self.swResetAll = [[DCRoundSwitch alloc] initWithFrame:CGRectMake(210, 16, 70, 25)];
    [self.swResetAll setOn:NO];
    [self.swResetAll addTarget:self
                        action:@selector(swResetAllChangedState:)
              forControlEvents:UIControlEventValueChanged];
    self.swResetAll.onText = NSLocalizedString(@"YES", @"");
    self.swResetAll.offText = NSLocalizedString(@"NO", @"");
    self.swResetAll.onTintColor = [UIColor colorWithHex:kColorHexSwitchOn];
}

-(void)viewWillAppear:(BOOL)animated{
    [_tvItems reloadData];
}

#pragma mark - buttons
- (void) back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch(section){
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        default:
            return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* CellIdentifier = @"MainMenuCellView";
        MainMenuCellController* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];

    }else{
        for (UIView* v in cell.contentView.subviews) {
            if ([v isKindOfClass:[UISwitch class]]) {
                [v removeFromSuperview];
            }
        }
    }
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
   // cell.accessoryType = UITableViewCellAccessoryNone;
    switch (indexPath.section) {
        case 0:{
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont fontWithName:kFont1 size:18.0f];
            cell.textLabel.textColor = [UIColor colorWithHex:kColorHexBlack];
            cell.textLabel.backgroundColor=[UIColor clearColor];
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.textLabel.text = NSLocalizedString(@"SettingsMainRestart", @"");
            [cell.contentView addSubview:self.swResetAll];
            cell.dawImage.hidden = YES;
            break;
        }
        case 1:{
            cell.userInteractionEnabled = YES;
            cell.cellLabel.font = [UIFont fontWithName:kFont1 size:17.0f];
            cell.cellLabel.textColor = [UIColor colorWithHex:kColorHexBrown];
            cell.cellLabel.textAlignment = NSTextAlignmentLeft;
            cell.backgroundColor = [UIColor clearColor];
            cell.cellLabel.backgroundColor = [UIColor clearColor];
            cell.cellLabel.numberOfLines = 4;
            NSString* cellName = [NSString stringWithFormat:@"SettingsMainItem%d", indexPath.row];
            cell.cellLabel.text = NSLocalizedString(cellName,nil);
            cell.cellLabel.highlightedTextColor = cell.cellLabel.textColor;
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"incomeMonth"]==NO){
                if(indexPath.row == 0){
                    cell.dawImage.hidden = NO;
                    cell.cellLabel.textColor = [UIColor colorWithHex:kColorHexBlack];
                }else{
                    cell.dawImage.hidden = YES;
                    cell.cellLabel.textColor = [UIColor colorWithHex:kColorHexBrown];
                }
            }else{
                if(indexPath.row == 0){
                    cell.dawImage.hidden = YES;
                    cell.cellLabel.textColor = [UIColor colorWithHex:kColorHexBrown];
                }else{
                    cell.dawImage.hidden = NO;
                    cell.cellLabel.textColor = [UIColor colorWithHex:kColorHexBlack];
                }
            }
        }
        default:
            break;
    }
    [AGTools tableViewGrouped:tableView
              configureCell:cell
              withIndexPath:indexPath];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0)
        return [AGTools cellStandardHeight];
    else
        return [AGTools cellStandardHeight]+40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kTableHeaderStandardHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section==0){
        UIView* v = [[UIView alloc] init];
        v.frame = CGRectMake(0, 0, 320, 50.0f);
        
        //  title
        UILabel* lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(25, 9, 270, v.frame.size.height)];
        lbTitle.font = [UIFont fontWithName:kFont1 size:12.0];
        lbTitle.textColor = [UIColor colorWithHex:kColorHexMudBlue];
        lbTitle.textAlignment = NSTextAlignmentLeft;
        lbTitle.backgroundColor = [UIColor clearColor];
        lbTitle.text = NSLocalizedString(@"SettingsMainFooter", nil);
        lbTitle.numberOfLines = 2;
        lbTitle.textAlignment = NSTextAlignmentCenter;
        
        [v addSubview:lbTitle];
        
        return v;
    }else
        return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section==1){
        UIView* v = [[UIView alloc] init];
        v.frame = CGRectMake(0, 0, 320, [self tableView:tableView heightForHeaderInSection:section]);
        
        //  title
        UILabel* lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(25, 6, 270.0, v.frame.size.height)];
        lbTitle.font = [UIFont fontWithName:kFont1 size:14.0];
        lbTitle.textColor = [UIColor colorWithHex:kColorHexBrown];
        lbTitle.textAlignment = NSTextAlignmentLeft;
        lbTitle.backgroundColor = [UIColor clearColor];
        lbTitle.text = NSLocalizedString(@"SettingsMainReview", nil);
        
        [v addSubview:lbTitle];
        
        return v;
    }else
        return nil;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"incomeMonth"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        }
        case 1:{
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"incomeMonth"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        }
        default:
            break;
    }
    [tableView reloadData];
}

#pragma mark - Switch
- (void) swResetAllChangedState:(id)sender{
    if (((DCRoundSwitch*)sender).isOn) {
        UIAlertView* avRestart = [[UIAlertView alloc]
                                  initWithTitle:nil
                                  message:nil
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                  otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
        avRestart.alertViewStyle = UIAlertViewStyleSecureTextInput;
        
        UITextField* tfPass = [avRestart textFieldAtIndex:0];
        tfPass.font = [UIFont fontWithName:kFont1 size:18.0f];
        tfPass.textColor = [UIColor colorWithHex:kColorHexBlack];
        tfPass.placeholder = NSLocalizedString(@"Password", @"");
        
        [avRestart show];
    }
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [_tvItems reloadData];
    [(kRoot) blockWindowWithActivityIndicator:YES];
    BOOL finished = YES;
    if(buttonIndex == 0){
    }else if ([[alertView textFieldAtIndex:0].text isEqualToString:(kUser).password] == NO) {
        [AGTools showAlertOkWithTitle:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"UserPasswordWrong", @"")];
    }else{
        finished = NO;
        [self performSelector:@selector(markRemoved)
                   withObject:self
                   afterDelay:0.5f];
    }
    if (finished) {
        [self.swResetAll setOn:NO animated:YES];
        [(kRoot) blockWindowWithActivityIndicator:NO];
    }
}

- (void) markRemoved{
    [(kUser) resetData];
    [self.swResetAll setOn:NO animated:YES];
    [(kRoot) blockWindowWithActivityIndicator:NO];
}

@end
