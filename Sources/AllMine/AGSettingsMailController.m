//
//  AGSettingsMailController.m
//  AllMine
//
//  Created by Allgoritm LLC on 08.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "AGSettingsMailController.h"
#import "AGTools.h"
#import "UIColor+AGExtensions.h"
#import "User+EntityWorker.h"
#import "AGAppDelegate.h"
#import "AGRootController.h"
#import "AGDBWorker.h"
#import "UIView+AGExtensions.h"
#import "AGServerAccess.h"
#import "DCRoundSwitch.h"

@interface AGSettingsMailController ()
@property(nonatomic, retain) IBOutlet UITableView* tvItems;
@property(nonatomic, strong) UITextField* tfPassword;
@property(nonatomic, strong) UITextField* tfPasswordConfirm;

@property(nonatomic, strong) NSString* password;
@property(nonatomic, strong) NSString* passwordConfirm;

@property (nonatomic, strong) DCRoundSwitch* swAutoAuth;

@end

@implementation AGSettingsMailController

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
    self.navigationItem.title = NSLocalizedString(@"SettingsMail", @"");
    self.navigationItem.leftBarButtonItem = [AGTools navigationBarButtonItemWithImageNamed:@"button-back" target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [AGTools navigationBarButtonItemWithTitle:NSLocalizedString(@"Save", @"") imageNamed:@"button-save" target:self action:@selector(save)];
    
    _tvItems.scrollEnabled = NO;
    _tvItems.delegate = self;
    _tvItems.dataSource = self;
    
    _tfPassword = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, 280, [AGTools cellStandardHeight])];
    _tfPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _tfPassword.font = [UIFont fontWithName:kFont1 size:18.0f];
    _tfPassword.textColor = [UIColor colorWithHex:kColorHexBlack];
    _tfPassword.placeholder = NSLocalizedString(@"PasswordNew*", @"");
    _tfPassword.text = @"";
    _tfPassword.delegate = self;
    _tfPassword.secureTextEntry = YES;

    _tfPasswordConfirm = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, 280, [AGTools cellStandardHeight])];
    _tfPasswordConfirm.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _tfPasswordConfirm.font = [UIFont fontWithName:kFont1 size:18.0f];
    _tfPasswordConfirm.textColor = [UIColor colorWithHex:kColorHexBrown];
    _tfPasswordConfirm.placeholder = NSLocalizedString(@"PasswordConfirm", @"");
    _tfPasswordConfirm.text = @"";
    _tfPasswordConfirm.delegate = self;
    _tfPasswordConfirm.secureTextEntry = YES;
    
    _password = @"";
    _passwordConfirm = @"";
    
    [_tfPassword setValue:[UIColor colorWithHex:kColorHexBlack]
                    forKeyPath:@"_placeholderLabel.textColor"];
    
    self.swAutoAuth = [[DCRoundSwitch alloc] initWithFrame:CGRectMake(217, 16, 70, 25)];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"autoAuth"])
    {
        [self.swAutoAuth setOn:NO];
    }else{
        [self.swAutoAuth setOn:YES];
    }
    [self.swAutoAuth addTarget:self
                        action:@selector(swAutoAuthChangedState:)
              forControlEvents:UIControlEventValueChanged];
    self.swAutoAuth.onText = NSLocalizedString(@"YES", @"");
    self.swAutoAuth.offText = NSLocalizedString(@"NO", @"");
    self.swAutoAuth.onTintColor = [UIColor colorWithHex:kColorHexSwitchOn];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [_tvItems reloadData];
}

#pragma mark - buttons
- (void) back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) save{
    if ([_tfPassword.text isEqualToString:@""]) {
        [_tfPassword shake];
        return;
    }
//    if (![_tfPassword.text isEqualToString:_tfPasswordConfirm.text]) {
//        [_tfPasswordConfirm shake];
//        return;
//    }
    if ([AGTools isReachableWithAlert] == NO) {
        return;
    }
    User* usr = (kUser);
    @try {
        [[AGServerAccess sharedAccess] userSetNewPassword:_tfPassword.text
                                                  forUser:usr];
        usr.password = _tfPassword.text;
        [[AGDBWorker sharedWorker] saveManagedContext];
        [self back];
    }
    @catch (NSException *exception) {
        [AGTools showAlertOkWithTitle:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"UserPasswordChangeError", @"")];
    }
    @finally {
    }
}

#pragma mark - UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else
        return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* CellIdentifier = @"settingsMailCell";
                
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        for (UITextField* tf in cell.contentView.subviews) {
            [tf removeFromSuperview];
        }
    }
    /*cell.textLabel.font = [UIFont fontWithName:kFont1 size:18.0f];
    cell.textLabel.backgroundColor=[UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithHex:kColorHexBlack];*/
    UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 280, [AGTools cellStandardHeight])];
    cellLabel.font = [UIFont fontWithName:kFont1 size:18.0f];
    cellLabel.backgroundColor=[UIColor clearColor];
    cellLabel.textColor = [UIColor colorWithHex:kColorHexBlack];
    switch (indexPath.row) {
        case 0:
            if(indexPath.section ==0)
                cellLabel.text = (kUser).login;
            else{
                cellLabel.text = NSLocalizedString(@"SettingsRemoveAutoauth", nil);
                [cell.contentView addSubview:self.swAutoAuth];
            }
            break;

        case 1:
            _tfPassword.text = _password;
            [cell.contentView addSubview:_tfPassword];
            break;
    }
    [cell.contentView addSubview:cellLabel];
    [AGTools tableViewGrouped:tableView
              configureCell:cell
              withIndexPath:indexPath];
    
    return cell;
}

//header
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section==0)
        return [AGTools tableViewGroupedHeaderViewWithTitle:[NSLocalizedString(@"SettingsMailHeader", @"") uppercaseString]
                                           height:[self tableView:tableView heightForHeaderInSection:section]];
    else
        return [AGTools tableViewGroupedHeaderViewWithTitle:[NSLocalizedString(@"SettingsAuthorization", @"") uppercaseString]
                                                     height:[self tableView:tableView heightForHeaderInSection:section]];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return /*kTableHeaderStandardHeight*/ 50.0f;
}

//footer
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section==0)
        return [AGTools tableViewGroupedFooterViewWithTitle:NSLocalizedString(@"SettingsMailFooter", @"")
                                                 height:[self tableView:tableView heightForFooterInSection:section]
                                             numOfLines:3];
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 70.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [AGTools cellStandardHeight];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _tfPassword) {
        _password = textField.text;
    }else{
        _passwordConfirm = textField.text;
    }
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    _tvItems.tag = 1;
    CGSize size = _tvItems.frame.size;
    size.height = 200;
    [_tvItems sizeChangeAnimated:size];
    int row = 0;
    if (textField == _tfPasswordConfirm) {
        row = 1;
    }
    [self performSelector:@selector(scrollIn:) withObject:[NSNumber numberWithInt:row] afterDelay:kSlideAnimationTime-0.1];
}
-(void)scrollIn:(NSNumber*)row{
    [_tvItems scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row.intValue inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [_tvItems sizeReturnAnimated];
}


#pragma mark - Switch
- (void) swAutoAuthChangedState:(id)sender{
    if (((DCRoundSwitch*)sender).isOn) {
        [((DCRoundSwitch*)sender) setOn:YES];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"autoAuth"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if (!((DCRoundSwitch*)sender).isOn) {
        [((DCRoundSwitch*)sender) setOn:NO];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"autoAuth"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}



@end
