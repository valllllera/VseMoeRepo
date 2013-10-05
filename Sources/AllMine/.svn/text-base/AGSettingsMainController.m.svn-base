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
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* CellIdentifier = @"settingsMainCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
    }else{
        for (UIView* v in cell.contentView.subviews) {
            if ([v isKindOfClass:[UISwitch class]]) {
                [v removeFromSuperview];
            }
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.font = [UIFont fontWithName:kFont1 size:18.0f];
    cell.textLabel.textColor = [UIColor colorWithHex:kColorHexBlack];
    cell.textLabel.backgroundColor=[UIColor clearColor];
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.textLabel.text = NSLocalizedString(@"SettingsMainRestart", @"");
    [cell.contentView addSubview:self.swResetAll];
    
    [AGTools tableViewGrouped:tableView
              configureCell:cell
              withIndexPath:indexPath];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [AGTools cellStandardHeight];
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
