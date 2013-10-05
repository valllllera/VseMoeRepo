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
    LoginStateBadToken = 3
}LoginState;

#import <UIKit/UIKit.h>
#import "AGLoginListController.h"

@interface AGLoginController : UIViewController<UITextFieldDelegate, AGLoginListDelegate>

@property(nonatomic, assign) LoginState state;


@end


