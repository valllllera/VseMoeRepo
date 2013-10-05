//
//  AGLoginPasswordRecoverController.m
//  AllMine
//
//  Created by Allgoritm LLC on 06.12.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "AGLoginPasswordRecoveryController.h"
#import "AGTools.h"
#import "UIColor+AGExtensions.h"
#import "User+EntityWorker.h"
#import "AGServerAccess.h"

@interface AGLoginPasswordRecoveryController ()

@property(nonatomic, strong) IBOutlet UILabel* lb1;
@property(nonatomic, strong) IBOutlet UILabel* lb2;
@property(nonatomic, strong) IBOutlet UITextField* tfLogin;
@property(nonatomic, strong) IBOutlet UIButton* bnRequest;

-(IBAction)requestPasswordChange:(id)sender;
@end

@implementation AGLoginPasswordRecoveryController

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

    if (_login == nil) _login = @"";

    _tfLogin.font = [UIFont fontWithName:kFont1 size:18.0];
    _tfLogin.textColor = [UIColor colorWithHex:kColorHexBlack];
    _tfLogin.clearButtonMode = UITextFieldViewModeWhileEditing;
    _tfLogin.placeholder = NSLocalizedString(@"Email", @"");
    _tfLogin.text = _login;
    _tfLogin.delegate = self;
    _tfLogin.returnKeyType = UIReturnKeyGo;
    
    CGRect frame = _tfLogin.frame;
    frame.origin.x += 10;
    frame.size.width -= 20;
    _tfLogin.frame = frame;    
    
    _lb1.font = [UIFont fontWithName:kFont1 size:16.0];
    _lb1.textColor = [UIColor colorWithHex:kColorHexBrown];
    _lb1.numberOfLines = 3;
    _lb1.text = NSLocalizedString(@"LoginPasswordRecover1", @"");

    _lb2.font = [UIFont fontWithName:kFont1 size:14.0];
    _lb2.textColor = [UIColor colorWithHex:kColorHexBrown];
    _lb2.numberOfLines = 2;
    _lb2.text = NSLocalizedString(@"LoginPasswordRecover2", @"");
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [AGTools navigationBarButtonItemWithImageNamed:@"button-back" target:self action:@selector(back)];
    
    [_tfLogin becomeFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    _bnRequest.hidden = YES;
}

- (BOOL) textFieldShouldClear:(UITextField*) textField {
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
//    _bnRequest.hidden = NO;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self.bnRequest sendActionsForControlEvents:UIControlEventTouchUpInside];
    return YES;
}

#pragma mark - request
-(IBAction)requestPasswordChange:(id)sender{
    if ([AGTools isReachableWithAlert]) {
        User* usr = [User userWithLogin:_tfLogin.text];
        if (usr != nil) {
            @try {
                [[AGServerAccess sharedAccess] userRequestPasswordRecoveryForUser:usr];
                [AGTools showAlertOkWithTitle:@""
                                      message:NSLocalizedString(@"UserPasswordRecoverySent", @"")];
                [self.navigationController popViewControllerAnimated:YES];
            }
            @catch (NSException *exception) {
                [AGTools showAlertOkWithTitle:NSLocalizedString(@"Error", @"")
                                      message:NSLocalizedString(@"UserPasswordRecoveryError", @"")];                
            }
            @finally {
            }
        }else{
            [AGTools showAlertOkWithTitle:NSLocalizedString(@"Error", @"")
                                  message:NSLocalizedString(@"UserNotFoundLocally", @"")];
        }
    }
}

@end
