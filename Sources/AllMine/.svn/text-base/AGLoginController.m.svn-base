//
//  AGLoginController.m
//  AllMine
//
//  Created by Allgoritm LLC on 01.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "AGLoginController.h"
#import "User+EntityWorker.h"
#import "AGAppDelegate.h"
#import "AGRootController.h"
#import "UIColor+AGExtensions.h"
#import "AGTools.h"
#import "UIView+AGExtensions.h"
#import "AGDBWorker.h"
#import "AGServerAccess.h"
#import "AGLoginPasswordRecoveryController.h"
#import <QuartzCore/QuartzCore.h>
#import "AGExceptionServerResponseBadStatus.h"

@interface AGLoginController ()
@property(nonatomic, retain) IBOutlet UIView* vLogin;
@property(nonatomic, retain) IBOutlet UITextField* tfLogin;
@property(nonatomic, retain) IBOutlet UIButton* bnLoginHelp;

@property(nonatomic, retain) IBOutlet UIView* vPassword;
@property(nonatomic, retain) IBOutlet UITextField* tfPassword;
@property(nonatomic, retain) IBOutlet UIButton* bnPasswordHelp;

//@property(nonatomic, retain) IBOutlet UITextField* tfConfirm;
@property(nonatomic, retain) IBOutlet UIButton* bnSubmit;
@property(nonatomic, retain) IBOutlet UIButton* bnRegistration;
@property(nonatomic, retain) IBOutlet UIButton* bnLogout;

@property(nonatomic, retain) IBOutlet UIImageView* imgBackground;

@property(nonatomic, strong) UIActivityIndicatorView* activityIndicator;
@property(nonatomic, strong) UIView* vScreenBlock;

- (IBAction) submit:(id) sender;
- (IBAction) toRegistration:(id)sender;
- (IBAction) loginHelp:(id)sender;
- (IBAction) passwordHelp:(id)sender;
- (IBAction) logout:(id)sender;
@end

@implementation AGLoginController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _bnRegistration.titleLabel.font = [UIFont fontWithName:kFont1 size:14.0f];
    [_bnRegistration setTitleColor:[UIColor colorWithHex:kColorHexWhite] forState:UIControlStateNormal];
    [_bnRegistration setTitle:NSLocalizedString(@"LoginRegistration", @"") forState:UIControlStateNormal];
    
    _bnSubmit.titleLabel.font = [UIFont fontWithName:kFont1 size:16.0f];
    [_bnSubmit setTitleColor:[UIColor colorWithHex:kColorHexWhite] forState:UIControlStateNormal];
    [_bnSubmit setTitle:NSLocalizedString(@"LoginSubmit", @"") forState:UIControlStateNormal];
    
    _bnLogout.titleLabel.font = [UIFont fontWithName:kFont1 size:14.0f];
    [_bnLogout setTitleColor:[UIColor colorWithHex:kColorHexWhite] forState:UIControlStateNormal];
    [_bnLogout setTitle:NSLocalizedString(@"LoginLogout", @"") forState:UIControlStateNormal];
    
    _tfLogin.font = [UIFont fontWithName:kFont1 size:18.0f];
    _tfLogin.textColor = [UIColor colorWithHex:kColorHexBlack];
    _tfLogin.placeholder = NSLocalizedString(@"Email", @"");
     _tfLogin.backgroundColor=[UIColor clearColor];
    _tfLogin.delegate = self;
    _tfLogin.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    _tfLogin.keyboardType = UIKeyboardTypeEmailAddress;
    _tfLogin.returnKeyType = UIReturnKeyNext;
   

    CGRect frame = _tfLogin.frame;
    frame.origin.x += 10;
    frame.size.width -= 20;
    _tfLogin.frame = frame;

    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUDLastLogin]) {
        _tfLogin.text = [[NSUserDefaults standardUserDefaults] objectForKey:kUDLastLogin];
    }
    
    _vLogin.layer.cornerRadius = 4.0f;
    
    _tfPassword.font = [UIFont fontWithName:kFont1 size:18.0f];
    _tfPassword.textColor = [UIColor colorWithHex:kColorHexBlack];
    _tfPassword.placeholder = NSLocalizedString(@"Password", @"");
    _tfPassword.delegate = self;
    _tfPassword.secureTextEntry = YES;
    _tfPassword.backgroundColor=[UIColor clearColor];
    _tfPassword.borderStyle = UITextBorderStyleNone;
    _tfPassword.keyboardType = UIKeyboardTypeDefault;
    _tfPassword.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    _tfPassword.returnKeyType = UIReturnKeyGo;
    
    frame = _tfPassword.frame;
    frame.origin.x += 10;
    frame.size.width -= 20;
    _tfPassword.frame = frame;
    
    _vPassword.layer.cornerRadius = 4.0f;
    
//    _tfConfirm.font = [UIFont fontWithName:kFont1 size:18.0f];
//    _tfConfirm.textColor = [UIColor colorWithHex:kColorHexBlack];
//    _tfConfirm.placeholder = NSLocalizedString(@"PasswordConfirm", @"");
//    _tfConfirm.delegate = self;
//    [_tfConfirm setSecureTextEntry:YES];
    switch (_state) {
        case LoginStateBadToken:
        case LoginStateLogin:{
            _vLogin.hidden = NO;
//            _tfConfirm.hidden = YES;
            _bnRegistration.hidden = NO;
            _bnLogout.hidden = YES;
            _bnLoginHelp.hidden = YES;
            _bnPasswordHelp.hidden = NO;
            _imgBackground.image = [UIImage imageNamed:@"background-login"];
            
//            CGRect frame = _bnSubmit.frame;
//            frame.origin.y = 222;
//            _bnSubmit.frame = frame;
            break;
        }
        case LoginStateLogged:{
            _vLogin.alpha = 0.0f;
//            _tfConfirm.hidden = YES;
            _bnRegistration.hidden = NO;
            _bnLogout.hidden = NO;
            _bnLoginHelp.hidden = YES;
            _bnPasswordHelp.hidden = NO;
            _imgBackground.image = [UIImage imageNamed:@"background-login"];
            
//            CGRect frame = _bnSubmit.frame;
//            frame.origin.y = 184;
//            _bnSubmit.frame = frame;
            CGRect frame = _vPassword.frame;
            frame.origin.y = _vLogin.frame.origin.y;
            _vPassword.frame = frame;
            break;
        }
        case LoginStateRegistration:{
            _vLogin.hidden = NO;
//            _tfConfirm.hidden = NO;
            _bnRegistration.hidden = YES;
            _bnLogout.hidden = YES;
            _bnLoginHelp.hidden = YES;
            _bnPasswordHelp.hidden = YES;
//            _imgBackground.image = [UIImage imageNamed:@"background-reg"];
            _imgBackground.image = [UIImage imageNamed:@"background-login"];
            
            CGRect frame = _bnSubmit.frame;
//            frame.origin.y = 260;
            frame.origin.y = 222;
            _bnSubmit.frame = frame;
            
            self.navigationItem.hidesBackButton = YES;
            self.navigationItem.title = NSLocalizedString(@"LoginRegistration", @"");
            self.navigationItem.leftBarButtonItem = [AGTools navigationBarButtonItemWithImageNamed:@"button-back" target:self action:@selector(back)];
            
            frame = _vLogin.frame;
            frame.origin.y -= 20;
            _vLogin.frame = frame;
            
            frame = _vPassword.frame;
            frame.origin.y -= 20;
            _vPassword.frame = frame;
            
            break;
        }
        default:
            break;
    }
    if (_state == LoginStateBadToken) {
        _bnRegistration.hidden = YES;
    }
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator.center = self.view.center;
    [_activityIndicator startAnimating];
    
    //----
    CGPoint point_load;
    point_load.x=self.view.bounds.size.width/2;
    point_load.y=self.view.bounds.size.height/2-35;
    //   _activityIndicator.center=point_load;
    
    UILabel *lb_load=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    lb_load.text=NSLocalizedString(@"Loading", @"");
    [lb_load setTextColor:[UIColor whiteColor]];
    //   [lb_load setFont:[UIFont fontWithName:kFont1 size:18]];
    lb_load.center=point_load;
    lb_load.backgroundColor=[UIColor clearColor];
    
    _vScreenBlock = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _vScreenBlock.backgroundColor = [UIColor clearColor];
    UIImageView *img_background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    img_background.frame = _vScreenBlock.frame;
    img_background.alpha=0.7f;
    [_vScreenBlock addSubview:img_background];
    UIImageView *img_load=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_load_2"]];
    img_load.alpha=1.0f;
    img_load.center=point_load;
    
    [_vScreenBlock addSubview:img_load];
    point_load.x+=20;
    point_load.y-=2;
    lb_load.center=point_load;
    [_vScreenBlock addSubview:lb_load];
    point_load.x-=67;
    point_load.y+=1;
    _activityIndicator.center=point_load;
    [_vScreenBlock addSubview:_activityIndicator];
    
    [self.view addSubview:_vScreenBlock];
    [self blockWindowWithActivityIndicator:NO];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if ([_tfLogin isFirstResponder] && [touch view] != _tfLogin) {
        [_tfLogin resignFirstResponder];
    }
    if ([_tfPassword isFirstResponder] && [touch view] != _tfPassword) {
        [_tfPassword resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

-(void)viewWillAppear:(BOOL)animated{
    switch (_state) {
        case LoginStateBadToken:
        case LoginStateLogin:
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            break;
            
        case LoginStateLogged:
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            break;
            
        case LoginStateRegistration:
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            break;
            
        default:
            break;
    }
}

#pragma mark - buttons
-(void) back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if(_state != LoginStateRegistration){
        CGRect frame = textField.frame;
        frame.size.width += 35;
        textField.frame = frame;
        if (textField == _tfLogin) {
            _bnLoginHelp.hidden = YES;
        }
        if (textField == _tfPassword) {
            _bnPasswordHelp.hidden = YES;
        }
    }else{
        CGRect frame = textField.frame;
        frame.size.width += 35;
        textField.frame = frame;
        if ((textField == _tfPassword) && !isIphoneRetina4) {
            [self.view slideToPoint:CGPointMake(0, -10)];
        }
    }
}

- (BOOL) textFieldShouldClear:(UITextField*) textField {
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(_state != LoginStateRegistration){
        CGRect frame = textField.frame;
        frame.size.width -= 35;
        textField.frame = frame;
        if (textField == _tfLogin) {
            _bnLoginHelp.hidden = YES;
        }
        if (textField == _tfPassword) {
            _bnPasswordHelp.hidden = NO;
        }
    }else{
        CGRect frame = textField.frame;
        frame.size.width -= 35;
        textField.frame = frame;
//        if ((textField == _tfPassword) || (textField == _tfConfirm)){
        if (textField == _tfPassword) {
            [self.view slideOut];
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _tfLogin) {
        [_tfPassword becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
        [self submit:nil];
    }
    return YES;
}

#pragma mark - block
- (void) blockWindowWithActivityIndicator:(BOOL)block{
    if (block) {
        self.view.userInteractionEnabled = NO;

        _activityIndicator.alpha = 1.0f;
        CGRect frame = _vScreenBlock.frame;
        _vScreenBlock.frame = [UIScreen mainScreen].bounds;
                frame = _vScreenBlock.frame;
        _vScreenBlock.alpha = 1.0f;
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
    }else{
        self.view.userInteractionEnabled = YES;
        _activityIndicator.alpha = 0.0f;
        _vScreenBlock.alpha = 0.0f;
    }
}

#pragma mark - Actions
- (IBAction) toRegistration:(id)sender{
    AGLoginController* ctl = [[AGLoginController alloc] initWithNibName:@"AGLoginView"
                                                                 bundle:nil];
    ctl.state = LoginStateRegistration;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (IBAction) submit:(id)sender{
    [self blockWindowWithActivityIndicator:YES];
    if(_state != LoginStateRegistration){
        // check login
        User* usr = [User userWithLogin:_tfLogin.text];
        if(usr != nil){
            // check pass
            if([AGTools isReachable]){
                @try {
                    [[AGServerAccess sharedAccess] userExistWithLogin:_tfLogin.text
                                                             password:_tfPassword.text];
                    usr.password = _tfPassword.text;
                    [self userLogin:usr];
                    [self dismissModalViewControllerAnimated:YES];
                }
                @catch (AGExceptionServerResponseBadStatus* exception) {
                    [_vPassword shake];
                }
                @catch (NSException *exception) {
                    if([usr.password isEqualToString:_tfPassword.text]) {
                        [self userLogin:usr];
                        [self dismissModalViewControllerAnimated:YES];
                    }else{
                        [_vPassword shake];
                    }
                }
                @finally {
                }
            }else if([usr.password isEqualToString:_tfPassword.text]) {
                [self userLogin:usr];
                [self dismissModalViewControllerAnimated:YES];
            }else{
                [_vPassword shake];
            }
        }else if([AGTools isReachable]){
            @try {
                [[AGServerAccess sharedAccess] userExistWithLogin:_tfLogin.text
                                                         password:_tfPassword.text];
                [self userCreateWithStandardData:NO];
                [self dismissModalViewControllerAnimated:YES];
            }
            @catch (NSException *exception) {
                [_vLogin shake];
            }
            @finally {
            }
        }else{
            [_vLogin shake];
        }
    }else if ([AGTools isReachableWithAlert]) {
        // register
        if([_tfLogin.text isEqualToString:@""]){
            [_vLogin shake];
            return;
        }
        if([_tfPassword.text isEqualToString:@""]){
            [_vPassword shake];
            return;
        }
//        if(! [_tfPassword.text isEqualToString:_tfConfirm.text]){
//            [_tfConfirm shake];
//            return;
//        }
        @try {
            [[AGServerAccess sharedAccess] userRegisterLogin:_tfLogin.text
                                                    password:_tfPassword.text];
            [self userCreateWithStandardData:YES];
            [self dismissModalViewControllerAnimated:YES];
        }
        @catch (AGExceptionServerResponseBadStatus* exception) {
            [AGTools showAlertOkWithTitle:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"UserExist", @"")];
        }
        @catch (NSException *exception) {
            [AGTools showAlertOkWithTitle:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"UserRegisterFailed", @"")];
        }
        @finally {
        }
    }
    [self blockWindowWithActivityIndicator:NO];
}

- (User*) userCreateWithStandardData:(BOOL)addStandard{
    User* usr = [User insertUserWithLogin:_tfLogin.text
                                 password:_tfPassword.text];
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:usr.login forKey:kUDLastLogin];
    [ud setObject:usr.dateIn forKey:kUDLastLoginDate];
    [ud synchronize];
    
    (kRoot).currentUser = usr;
    if (addStandard) {
        [usr addStandardData];
    }
    if ([AGTools isReachableForSync]) {
        [(kRoot) synchronize];
    }
    [(kRoot) restartControllersOnUserChange];

    return usr;
}
-(void)userLogin:(User*)usr{
    usr.dateIn = [NSDate date];
    usr.hidden = [NSNumber numberWithBool:NO];
    [[AGDBWorker sharedWorker] saveManagedContext];

    (kRoot).currentUser = usr;
    
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    if (([ud objectForKey:kUDLastLogin]) &&
        ([[ud objectForKey:kUDLastLogin] isEqualToString:usr.login])) {
        [(kRoot) restartControllersOnUserChange];
    }
    [ud setObject:usr.login forKey:kUDLastLogin];
    [ud setObject:usr.dateIn forKey:kUDLastLoginDate];
    [ud synchronize];
}

- (IBAction) loginHelp:(id)sender{
    [self passwordHelp:sender];
//    AGLoginListController* ctl = [[AGLoginListController alloc] initWithNibName:@"AGLoginListView" bundle:nil];
//    ctl.delegate = self;
//    [self.navigationController pushViewController:ctl animated:YES];
}

- (IBAction) passwordHelp:(id)sender{
    AGLoginPasswordRecoveryController* ctl = [[AGLoginPasswordRecoveryController alloc] initWithNibName:@"AGLoginPasswordRecoveryView" bundle:nil];
    ctl.login = _tfLogin.text;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (IBAction)logout:(id)sender{
    [_bnLogout hideAnimated];
    
    _tfLogin.text = @"";
    _tfPassword.text = @"";
    [_vLogin showAnimated];
    
    CGPoint point = _vPassword.frame.origin;
    point.y = 184;
    [_vPassword slideToPoint:point];
    
    point = _bnSubmit.frame.origin;
    point.y = 222;
    [_bnSubmit slideToPoint:point];
}

#pragma mark - AGLoginListControllerProtocol
-(void)loginListController:(AGLoginListController *)controller didFinishedSelectingLogin:(NSString *)login{
    [self textFieldDidBeginEditing:_tfLogin];
    _tfLogin.text = login;
    [self textFieldDidEndEditing:_tfLogin];
}


@end
