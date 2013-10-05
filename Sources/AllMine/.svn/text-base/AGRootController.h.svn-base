//
//  AGRootController.h
//  AllMine
//
//  Created by Allgoritm LLC on 06.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGKeyboardController.h"
#import "Flurry.h"
#import "FlurryAds.h"
#import "FlurryAdDelegate.h"


@class User;

@interface AGRootController : UIViewController<UITabBarControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property(nonatomic, strong) User* currentUser;

- (void) showLogin;

- (void) showDatePickerWithDate:(NSDate*)date target:(id)targer action:(SEL)action;

- (void) showKeyboardWithState:(AGKBState)state
                      delegate:(id<AGKeyboardDelegate>)delegate
                      animated:(BOOL)animated;

- (void) showPickerWithDelegate:(id<UIPickerViewDelegate>)delegate
                    selectedRow:(int)row;

-(void)syncTimerStart;
-(void)syncTimerStop;
-(void)synchronize;
-(void)syncAuto:(NSTimer*)timer;

- (void) blockWindowWithActivityIndicator:(BOOL)block;

- (void) restartControllersOnUserChange;

@end
