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
#import "RequestManager.h"
#import "NSString+AGExtensions.h"

#define kCountNumbersInPin 5

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

@property (weak, nonatomic) IBOutlet UIView *vPin;

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

    self.passwordRememberLabel.text = NSLocalizedString(@"RememberMe", nil);
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
    frame.origin.y -=2;
    frame.size.width -= 20;
    _tfLogin.frame = frame;
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"autoAuth"]){
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"autoAuth"];
    }
    
    if (_state != LoginStateRegistration){
        if ([[NSUserDefaults standardUserDefaults] objectForKey:kUDLastLogin]) {
            _tfLogin.text = [[NSUserDefaults standardUserDefaults] objectForKey:kUDLastLogin];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"password"]&&[[NSUserDefaults standardUserDefaults] boolForKey:@"autoAuth"])
            {
                _state  = LoginStateLogged;
                _tfPassword.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
            }
            else
                    _state= LoginStateLogin;
        }
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"protPin"] && [[NSUserDefaults standardUserDefaults] objectForKey:@"pin"])
        {
            _state = LoginStatePinProtection;
        }
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
            _passwordRememberLabel.hidden = NO;
            _rememberMeButton.hidden = NO;
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
            _passwordRememberLabel.hidden = YES;
            _rememberMeButton.hidden = YES;
            _bnLoginHelp.hidden = YES;
            self.shouldLogin = YES;
            _bnPasswordHelp.hidden = NO;
            _bnPasswordHelp.frame = CGRectMake(_bnPasswordHelp.frame.origin.x+8, _bnPasswordHelp.frame.origin.y+12 , 32.0f, 32.0f);
            [_bnPasswordHelp setImage:nil forState:UIControlStateNormal];
            [_bnPasswordHelp setImage:nil forState:UIControlStateHighlighted];
            
            [_bnPasswordHelp setBackgroundImage:[UIImage imageNamed:@"button-arrow"] forState:UIControlStateNormal];
            
            [_bnPasswordHelp setBackgroundImage:[UIImage imageNamed:@"button-arrow-pressed"] forState:UIControlStateHighlighted];
            
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
            _passwordRememberLabel.hidden = YES;
            _rememberMeButton.hidden = YES;
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
        case LoginStatePinProtection:
        {
            _bnLogout.hidden = NO;
            _bnLogout.frame = CGRectMake(230, 20, _bnLogout.frame.size.width, _bnLogout.frame.size.height);
            _passwordRememberLabel.hidden = YES;
            _rememberMeButton.hidden = YES;
            _bnLoginHelp.hidden = YES;
            self.shouldLogin = YES;
            _bnPasswordHelp.hidden = YES;
            _bnRegistration.hidden = YES;
            _vLogin.hidden = YES;
            _vPassword.hidden = YES;
            _vPin.hidden = NO;
            break;
        }
        default:
            break;
    }
    if (_state == LoginStateBadToken) {
        _bnRegistration.hidden = YES;
    }
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activityIndicator.center = self.view.center;
    [_activityIndicator startAnimating];
    
    //----
    CGPoint point_load;
    point_load.x=self.view.bounds.size.width/2;
    point_load.y=self.view.bounds.size.height/2-25;
    //   _activityIndicator.center=point_load;
    
    UILabel *lb_load=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    if (_state == LoginStateRegistration){
        CGRect frame = lb_load.frame;
        frame.size.height=200;
        frame.size.width=250;
        lb_load.frame = frame;
        lb_load.numberOfLines = 0;
        lb_load.textAlignment = NSTextAlignmentCenter;
        lb_load.font = [UIFont fontWithName:kFont1 size:12.0f];
        lb_load.text=NSLocalizedString(@"RegistrationSuccessful", @"");
    }else{
        lb_load.text=NSLocalizedString(@"Loading", @"");
        lb_load.font = [UIFont fontWithName:kFont1 size:17.0f];
    }
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
    UIImageView *img_load=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Mod-window.png"]];
    img_load.alpha=1.0f;
    img_load.center=point_load;
    
    [_vScreenBlock addSubview:img_load];
    if(_state != LoginStateRegistration){
        point_load.x+=20;
        point_load.y-=22;
        lb_load.center=point_load;
    }else{
        point_load.y-=20;
        lb_load.center=point_load;
    }
    [_vScreenBlock addSubview:lb_load];
    if(_state != LoginStateRegistration){
        point_load.x-=67;
        point_load.y-=3;
        _activityIndicator.center=point_load;
        [_vScreenBlock addSubview:_activityIndicator];
    }
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"incomeMonth"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"incomeMonth"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

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
            
        case LoginStatePinProtection:
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            break;
            
        default:
            break;
    }
}

#pragma mark - buttons
-(void) back{
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];

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
    if (textField == _tfLogin)
    {
        if(![textField.text isEqual:@""]){
        // email corrector
        
        NSRange range = [textField.text rangeOfString:@"@"];
        if(range.length != 0){
            NSString *eMailDomain = [[textField.text substringFromIndex:NSMaxRange(range)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *eMailAdres = [textField.text substringWithRange:NSMakeRange(0, [textField.text rangeOfString:@"@"].location)];
            if ([eMailDomain isEqual: @"mail.ri"] || [eMailDomain isEqual: @"mail.ry"] || [eMailDomain isEqual: @"meil.ri"]) {
                textField.text = [eMailAdres stringByAppendingFormat:@"@mail.ru"];
            }
            if ([eMailDomain isEqual: @"yandex.ri"] || [eMailDomain isEqual: @"yndex.ri"] || [eMailDomain isEqual: @"yandex.ry"]) {
                textField.text = [eMailAdres stringByAppendingFormat:@"@yandex.ru"];
            }
            if ([eMailDomain isEqual: @"inbox.ri"] || [eMailDomain isEqual: @"nbox.r"] || [eMailDomain isEqual: @"inbox.r"] || [eMailDomain isEqual: @"inbox.ry"]) {
                textField.text = [eMailAdres stringByAppendingFormat:@"@inbox.ru"];
            }
            if ([eMailDomain isEqual: @"gmail.ri"] || [eMailDomain isEqual: @"gmail.ry"] || [eMailDomain isEqual: @"gmeil.ri"]) {
                textField.text = [eMailAdres stringByAppendingFormat:@"@gmail.com"];
                }
            
            }
        }
    }
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
        //if ((textField == _tfPassword) || (textField == _tfConfirm)){
        if (textField == _tfPassword) {
            [self.view slideOut];
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField.superview == _vPin)
    {
        if(textField.tag < kCountNumbersInPin - 1)
        {
            textField = (UITextField *)[_vPin viewWithTag:textField.tag + 1];
            [textField becomeFirstResponder];
        }
        else
        {
            [self submit:nil];
            [textField resignFirstResponder];
        }
        return YES;
    }
    if (textField == _tfLogin) {
        [_tfPassword becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
        [self submit:nil];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.superview == _vPin)
    {
        if(![string isNumeric])
        {
            return NO;
        }
        
        if(range.length == 0)
        {
            if(range.location > 0)
            {
                if(textField.tag < kCountNumbersInPin)
                {
                    textField = (UITextField *)[_vPin viewWithTag:textField.tag + 1];
                    textField.text = [string substringToIndex:1];
                    [textField becomeFirstResponder];
                }
                return NO;
            }
        }
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
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];

    
    [self.navigationController pushViewController:ctl animated:YES];
}


- (IBAction) submit:(id)sender{
  
    if(_state == LoginStatePinProtection)
    {
        if([[self currentPin] isEqualToNumber:[[NSUserDefaults standardUserDefaults] objectForKey:@"pin"]])
        {
            User* user = [User userWithLogin:[[NSUserDefaults standardUserDefaults] objectForKey:kUDLastLogin]];
            
            if(user)
            {
                [self userLogin:user];
                [self dismissModalViewControllerAnimated:YES];
            }
        }
        else
        {
            for(UITextField *textField in _vPin.subviews)
            {
                if([textField isKindOfClass:[UITextField class]])
                {
                    [textField shake];
                }
            }
        }
        return;
    }

    
    if(_state != LoginStateRegistration){

       User* user = [User userWithLogin:_tfLogin.text];

        if (user)
        {
            if ([AGTools isReachable])
            {
        
                user.login = _tfLogin.text;
                user.password = _tfPassword.text;
                
                [[RequestManager sharedRequest] checkLoginWithUser:user withParams:nil withSuccess:^(BOOL isLoged) {
                    if (isLoged == YES)
                    {
                        
                        if (_rememberMeButton.selected == YES)
                        {
                            [[NSUserDefaults standardUserDefaults] setObject:_tfPassword.text forKey:@"password"];
                            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"autoAuth"];
                            
                            
                            [[NSUserDefaults standardUserDefaults] synchronize];
                        }
                        [self userLogin:user];
                        [self dismissModalViewControllerAnimated:YES];
                    }
                    else
                        [_vPassword shake];

                } withFailure:^(NSError *error) {
                    [_vPassword shake];
                }];
                
            }
            else if([user.password isEqualToString:_tfPassword.text]) {
                [self userLogin:user];
                [self dismissModalViewControllerAnimated:YES];
            }
            else
                [_vPassword shake];
        }
        else if([AGTools isReachable]){
            @try {
                [[RequestManager sharedRequest] checkLoginWithUser:nil withParams:@{@"user":_tfLogin.text,@"password":_tfPassword.text} withSuccess:^(BOOL isLoged) {
                    if (isLoged)
                    {
                        [self userCreateWithStandardData:NO];
                        [self dismissModalViewControllerAnimated:YES];
                    }
                    else
                    {
                        [self blockWindowWithActivityIndicator:NO];
                        [_vLogin shake];
                    }
                } withFailure:^(NSError *error) {
                    [_vLogin shake];
                }];
            }
            @catch (NSException *exception) {
                [_vLogin shake];
            }
            @finally {
            }

        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"NoConnection", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            [self blockWindowWithActivityIndicator:NO];
        }
    }
    else if (_state == LoginStateRegistration)
    {
        
        if ([AGTools isReachable])
        {
            @try {
                [[AGServerAccess sharedAccess] userRegisterLogin:_tfLogin.text
                                                        password:_tfPassword.text];
                [self blockWindowWithActivityIndicator:YES];
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
                [self blockWindowWithActivityIndicator:NO];
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"NoConnection", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            [self blockWindowWithActivityIndicator:NO];
            
        }
    }
    
    
    
        // check login
    
    /*if(_state != LoginStateRegistration)
     {
       User* usr = [User userWithLogin:_tfLogin.text];
        if(usr != nil)
        {
            // check pass
            if([AGTools isReachable])
            {
                @try {
                    [[AGServerAccess sharedAccess] userExistWithLogin:_tfLogin.text
                                                             password:_tfPassword.text];
                    usr.password = _tfPassword.text;
                    
                    if (_rememberMeButton.selected == YES)
                    {
                        [[NSUserDefaults standardUserDefaults] setObject:_tfPassword.text forKey:@"password"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                    
                    [self userLogin:usr];
                    [self dismissModalViewControllerAnimated:YES];
                }
                @catch (AGExceptionServerResponseBadStatus* exception)
                {
                    [_vPassword shake];
                }
                @catch (NSException *exception)
                {
                    if([usr.password isEqualToString:_tfPassword.text])
                    {
                        [self userLogin:usr];
                        [self dismissModalViewControllerAnimated:YES];
                    }
                    else
                    {
                        [_vPassword shake];
                    }
                }
                @finally {
                }
            }
            else if([usr.password isEqualToString:_tfPassword.text])
            {
                [self userLogin:usr];
                [self dismissModalViewControllerAnimated:YES];
            }
            else
            {
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
    }*/
    
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
    /*if ([AGTools isReachableForSync]) {
        [(kRoot) synchronize];
    }*/
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
    if (_shouldLogin == NO)
    {
        AGLoginPasswordRecoveryController* ctl = [[AGLoginPasswordRecoveryController alloc] initWithNibName:@"AGLoginPasswordRecoveryView" bundle:nil];
        ctl.login = _tfLogin.text;
        [self.navigationController pushViewController:ctl animated:YES];
    }
    else
    {
        [self submit:nil];
        
    }
}

- (IBAction)logout:(id)sender{
    [_bnLogout hideAnimated];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"pin"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"protPin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _tfLogin.text = @"";
    _tfPassword.text = @"";
    [_vLogin showAnimated];
    _passwordRememberLabel.hidden = NO;
    _shouldLogin = NO;
    _rememberMeButton.hidden = noErr;
    _vLogin.hidden = NO;
    _vPassword.hidden = NO;
    
    [_bnPasswordHelp setImage:[UIImage imageNamed:@"button-help"] forState:UIControlStateNormal];
    
    [_bnPasswordHelp setImage:[UIImage imageNamed:@"button-help-pressed"] forState:UIControlStateHighlighted];
    
    CGPoint point = _vPassword.frame.origin;
    point.y = 159;
    [_vPassword slideToPoint:point];
    
    point = _bnSubmit.frame.origin;
    point.y = 222;
    [_bnSubmit slideToPoint:point];
    
}

- (NSNumber *)currentPin
{
    NSUInteger pin = 0;
    for(int i = 0; i < kCountNumbersInPin; i++)
    {
        for(UITextField *textField in _vPin.subviews)
        {
            if([textField isKindOfClass:[UITextField class]])
            {
                if(textField.tag == i)
                {
                    NSString *text = textField.text;
                    if(text.length == 1)
                    {
                        pin += pow(10, kCountNumbersInPin - i - 1) * [text integerValue];
                        break;
                    }
                    else
                    {
                        return nil;
                    }
                }
            }
        }
    }
    
    if(pin > 0)
    {
        return @(pin);
    }
    return nil;
}


#pragma mark - AGLoginListControllerProtocol
-(void)loginListController:(AGLoginListController *)controller didFinishedSelectingLogin:(NSString *)login{
    [self textFieldDidBeginEditing:_tfLogin];
    _tfLogin.text = login;
    [self textFieldDidEndEditing:_tfLogin];
}

#pragma mark - Remember 

- (IBAction)rememberMeButtonClick:(id)sender
{
    self.rememberMeButton.selected = !self.rememberMeButton.selected;
}
@end
