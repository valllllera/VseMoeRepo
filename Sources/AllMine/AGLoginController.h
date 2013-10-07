//
//  AGLoginController.h
//  AllMine
//
//  Created by Allgoritm LLC on 01.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

typedef enum {
    LoginStateLogin = 0,
    LoginStateLogged = 1,
    LoginStateRegistration = 2,
    LoginStateBadToken = 3,
    LoginStatePinProtection = 4
}LoginState;

#import <UIKit/UIKit.h>
#import "AGLoginListController.h"

@interface AGLoginController : UIViewController<UITextFieldDelegate, AGLoginListDelegate>

@property(nonatomic, assign) LoginState state;
@property (weak, nonatomic) IBOutlet UILabel *passwordRememberLabel;
@property (weak, nonatomic) IBOutlet UIButton *rememberMeButton;
@property (assign , nonatomic) BOOL shouldLogin;
- (IBAction)rememberMeButtonClick:(id)sender;

@end


