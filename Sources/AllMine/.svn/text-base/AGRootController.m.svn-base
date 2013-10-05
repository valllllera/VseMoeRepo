//
//  AGRootController.m
//  AllMine
//
//  Created by Allgoritm LLC on 06.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "AGRootController.h"
#import "AGMenuController.h"
#import "AGAppDelegate.h"
#import "AGLoginController.h"
#import "User+EntityWorker.h"
#import "UIColor+AGExtensions.h"
#import "UIView+AGExtensions.h"
#import "AGPlotController.h"
#import "AGServerAccess.h"
#import "AGTools.h"
#import "AGDBWorker.h"

#define kSyncTimerDelay 20*60
#define kLoginTimePasswordOnly 5*60
#define kLoginTime  15*60

#define kResetupTime kSlideAnimationTime/2.0f

@interface AGRootController ()

@property(nonatomic, strong) UITabBarController* tabController;
@property(nonatomic, strong) UITapGestureRecognizer* tapRecognizer;
@property(nonatomic, assign) BOOL respondToTap;
@property(nonatomic, strong) UIDatePicker* dpDate;
@property(nonatomic, strong) AGKeyboardController* keyboard;
@property(nonatomic, strong) UIPickerView* picker;

@property(nonatomic, strong) UIActivityIndicatorView* activityIndicator;
@property(nonatomic, strong) UIView* vScreenBlock;

@property(nonatomic, assign) BOOL tabBarHidden;

@property(nonatomic, strong) NSTimer* syncTimer;

@property(nonatomic, assign) BOOL hideOnNavigate;

@property(nonatomic, assign) BOOL isSyncActive;
@property(nonatomic, assign) int lastSyncFailed;

@end

@implementation AGRootController

@synthesize tabController = _tabController;
@synthesize currentUser = _currentUser;
@synthesize tapRecognizer = _tapRecognizer;
@synthesize respondToTap = _respondToTap;
@synthesize dpDate = _dpDate;
@synthesize keyboard = _keyboard;
@synthesize picker = _picker;

-(void)loadView{
    
//    _currentUser = [User userWithLogin:@"user"];
    [[UINavigationBar appearance] setTitleTextAttributes:
        [NSDictionary dictionaryWithObjectsAndKeys:
         [UIFont fontWithName:kFont1 size:20.0],UITextAttributeFont,
         [UIColor colorWithHex:kColorHexBlue],UITextAttributeTextColor,
         [UIColor whiteColor], UITextAttributeTextShadowColor,
         [NSValue valueWithUIOffset:UIOffsetMake(0, 1.0f)],UITextAttributeTextShadowOffset,
         nil]];
    
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithHex:kColorHexNavigationBar]];
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:kNavigationBarVerticalOffsetStandart
                                                       forBarMetrics:UIBarMetricsDefault];
    
    _tabController = [[UITabBarController alloc] init];
    _tabController.delegate = self;
    [self createTabViewControllers];
    
    self.view = [[UIView alloc] initWithFrame:((AGAppDelegate*)[[UIApplication sharedApplication] delegate]).window.bounds];
    [self.view addSubview:_tabController.view];
    
    _dpDate = nil;
    _keyboard = nil;
    _picker = nil;
    _tabBarHidden = NO;
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator.center = self.view.center;
    [_activityIndicator startAnimating];
    
 //---
    
    CGPoint point_load;
    point_load.x=self.view.bounds.size.width/2;
    point_load.y=self.view.bounds.size.height/2-35;
    UILabel *lb_load=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    lb_load.text=NSLocalizedString(@"Loading", @"");
    [lb_load setTextColor:[UIColor whiteColor]];
    lb_load.center=point_load;
    lb_load.backgroundColor=[UIColor clearColor];
    _vScreenBlock=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _vScreenBlock.backgroundColor=[UIColor clearColor];
    UIImageView *img_background=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
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
    self.isSyncActive = NO;
    
    [Flurry startSession:@"XRMCVH3CZR99WVRFFMS8"];
    [Flurry initialize];
    [Flurry logEvent:@"test flurry event"];
  //  [FlurryAds setAdDelegate:self];
  //  [FlurryAds initialize:self];
}

- (void) createTabViewControllers{
    UIViewController *menuCtl = [[AGMenuController alloc] initWithNibName:@"AGMenuView" bundle:nil];
    UINavigationController* navMenuCtl = [[UINavigationController alloc] initWithRootViewController:menuCtl];
    navMenuCtl.navigationBar.barStyle = UIBarStyleBlackOpaque;
    navMenuCtl.toolbar.barStyle = UIBarStyleBlackOpaque;
    navMenuCtl.toolbarHidden = YES;
    navMenuCtl.delegate = self;
    
    AGPlotController* plotCtl = [[AGPlotController alloc] initWithNibName:@"AGPlotView" bundle:nil];
    
    _tabController.viewControllers = @[navMenuCtl, plotCtl];
    [self tabBarController:_tabController didSelectViewController:navMenuCtl];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(systemKeyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(systemKeyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(BOOL)shouldAutorotate{
    return NO;
}

#pragma mark - sync timer
-(void)syncTimerStop{
    [_syncTimer invalidate];
    _syncTimer = nil;
}
-(void)syncTimerStart{
    if ((kUser).syncAuto.boolValue == NO) {
        [self syncTimerStop];
        return;
    }
    if ((_syncTimer != nil) && (_syncTimer.isValid == YES)){
        return;
    }
    _syncTimer = [NSTimer scheduledTimerWithTimeInterval:kSyncTimerDelay
                                                  target:self
                                                selector:@selector(syncAuto:)
                                                userInfo:nil
                                                 repeats:YES];
}
-(void)syncAuto:(NSTimer*)timer{
    if ((kUser).syncAuto.boolValue == NO) return;
    if ([AGTools isReachableForSync] == YES) {
        [self performSelectorInBackground:@selector(synchronize)
                               withObject:nil];
    }
    if (_syncTimer == nil){
        [self syncTimerStart];
    }
}
- (void) synchronize{
    BOOL sync = NO;
    @synchronized(self){
        if (self.isSyncActive == NO) {
            self.isSyncActive = YES;
            sync = YES;
        }
    }
    if (sync) {
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        AGServerAccess* sa = [AGServerAccess sharedAccess];
        @try {
            //check user login password
            [sa userToken:kUser];
            @try {
                [sa synchronizeDataForUser:(kUser)];
                //            [dbw saveContext:context];
                NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
                [ud setObject:[NSDate date]
                       forKey:kUDSyncLastDate];
                [ud synchronize];
            }
            @catch (NSException *exception) {
                [AGTools showAlertOkWithTitle:NSLocalizedString(@"Error", @"") message:NSLocalizedString(@"SyncFailed", @"")];
                //            [dbw rollback];
            }
            @finally {
                [(kUser) recalculatePayments];
                [[NSNotificationCenter defaultCenter] postNotificationName:kEventSyncFinished
                                                                    object:nil];
            }
            self.lastSyncFailed = NO;
        }
        @catch (NSException *exception) {
            if (self.lastSyncFailed) {
                // this workaround is to prevent endless sync try if server has problems
                self.lastSyncFailed = NO;
            }else{
                AGLoginController* ctl = [[AGLoginController alloc] initWithNibName:@"AGLoginView" bundle:nil];
                ctl.state = LoginStateBadToken;
                [self presentModalViewController:ctl animated:YES];
                [self syncTimerStop];
                self.lastSyncFailed = YES;
            }
        }
        @finally {
            self.isSyncActive = NO;
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        }
    }
}

#pragma mark - block
- (void) blockWindowWithActivityIndicator:(BOOL)block{
    if (block) {
        self.view.userInteractionEnabled = NO;
        _activityIndicator.alpha = 1.0f;
        _vScreenBlock.frame = [UIScreen mainScreen].bounds;       
        _vScreenBlock.alpha = 1.0f;
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
    }else{
        self.view.userInteractionEnabled = YES;
        _activityIndicator.alpha = 0.0f;
        _vScreenBlock.alpha = 0.0f;
    }
}

#pragma mark - Login
- (void) showLogin{
    [User hideUsers];
    
    NSDate* dtLastLogin = [[NSUserDefaults standardUserDefaults] objectForKey:kUDLastLoginDate];
    NSDate* dtNow = [NSDate date];
    if ((dtLastLogin != nil) && ([dtNow timeIntervalSinceDate:dtLastLogin] < kLoginTimePasswordOnly)){
//    if ((dtLastLogin != nil) && ([dtNow timeIntervalSinceDate:dtLastLogin] < 10)){
        NSString* lastLogin = [[NSUserDefaults standardUserDefaults] objectForKey:kUDLastLoginDate];
        if(lastLogin != nil){
            self.currentUser = [User userWithLogin:lastLogin];
            if (_currentUser != nil) {
                return;
            }
        }
    }
    
    AGLoginController* loginCtl = [[AGLoginController alloc] initWithNibName:@"AGLoginView" bundle:nil];
    loginCtl.state = LoginStateLogin;
    if ((dtLastLogin != nil) && ([dtNow timeIntervalSinceDate:dtLastLogin] < kLoginTime)){
//    if ((dtLastLogin != nil) && ([dtNow timeIntervalSinceDate:dtLastLogin] < 20)){
        loginCtl.state = LoginStateLogged;
    }
    
    UINavigationController* navCtl = [[UINavigationController alloc] initWithRootViewController:loginCtl];
    navCtl.navigationBar.barStyle = UIBarStyleBlackOpaque;
    navCtl.toolbar.barStyle = UIBarStyleBlackOpaque;
    navCtl.toolbarHidden = YES;
    
    [self presentModalViewController:navCtl animated:YES];
}

- (void) restartControllersOnUserChange{
    [self createTabViewControllers];
}

-(void)setCurrentUser:(User *)currentUser{
    if (currentUser == nil) {
        return;
    }
    _currentUser = currentUser;
    [self performSelector:@selector(syncAuto:)
               withObject:nil
               afterDelay:3];
}

#pragma mark - slide views
- (void) systemKeyboardWillShow{
//    [self tapRecognizerAction];
}
- (void) systemKeyboardWillHide{
//    [self tapRecognizerAction];
}

- (void) showDatePickerWithDate:(NSDate*)date
                         target:(id)targer
                         action:(SEL)action{
    if (_dpDate) {
        return;
    }

    _dpDate = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 320, 216)];
    [self.view addSubview:_dpDate];
    _dpDate.date = date;
    _dpDate.datePickerMode = UIDatePickerModeDate;
    [_dpDate addTarget:targer action:action forControlEvents:UIControlEventValueChanged];
    _dpDate.tag = -1000;
    [[NSNotificationCenter defaultCenter] postNotificationName:kEventUIDatePickerWillShow object:nil];
    [self showSlideView:_dpDate
               animated:YES];
}

- (void) showKeyboardWithState:(AGKBState)state
                      delegate:(id<AGKeyboardDelegate>)delegate
                      animated:(BOOL)animated{
    if (self.keyboard) {
        return;
    }

    _keyboard = [[AGKeyboardController alloc] initWithNibName:@"AGKeyboardView"
                                                       bundle:nil];
    _keyboard.delegate = delegate;
    _keyboard.state = state;
    _keyboard.view.frame = CGRectMake(0, 460, 320, 216);
    _keyboard.view.tag = -1001;
    [self.view addSubview:_keyboard.view];
    [[NSNotificationCenter defaultCenter] postNotificationName:kEventAGKeyboardWillShow
                                                        object:nil];

    [self showSlideView:_keyboard.view
               animated:animated];
}

- (void) showPickerWithDelegate:(id<UIPickerViewDelegate>)delegate
                    selectedRow:(int)row{
    if (self.picker) {
        return;
    }

    _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 320, 216)];
    [self.view addSubview:_picker];
    _picker.delegate = delegate;
    _picker.showsSelectionIndicator = YES;
    _picker.tag = -1002;
    [[NSNotificationCenter defaultCenter] postNotificationName:kEventUIPickerWillShow
                                                        object:nil];
    [_picker selectRow:row
           inComponent:0
              animated:NO];

    [self showSlideView:_picker
               animated:YES];
}

- (void) showSlideView:(UIView*)view
              animated:(BOOL)animated{
    [self.view endEditing:YES];
    if (animated) {
        [view slideToScreenBottom];
    }else{
        self.hideOnNavigate = NO;
        [view moveToScreenBottom];
    }
    [self setupTapRecognizer];
}

- (void) setupTapRecognizer{
    if (self.tapRecognizer) {
        [self performSelector:@selector(setupTapRecognizer)
                   withObject:nil
                   afterDelay:kResetupTime];
        return;
    }
    _tapRecognizer = [[UITapGestureRecognizer alloc]
                      initWithTarget:self
                      action:@selector(tapRecognizerAction)];
    _tapRecognizer.delegate = self;
    _tapRecognizer.cancelsTouchesInView = NO;
    _respondToTap = YES;
    [self.view addGestureRecognizer:_tapRecognizer];
}
- (void) tapRecognizerAction {
    if (self.respondToTap) {
        self.respondToTap = NO;
        id vSlideControl = nil;
        if(self.dpDate){
            [[NSNotificationCenter defaultCenter] postNotificationName:kEventUIDatePickerWillHide object:nil];
            vSlideControl = self.dpDate;
        }
        if(self.keyboard){
            [[NSNotificationCenter defaultCenter] postNotificationName:kEventAGKeyboardWillHide object:nil];
            vSlideControl = self.keyboard.view;
        }
        if (_picker) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kEventUIPickerWillHide object:nil];
            vSlideControl = self.picker;
        }
        if (vSlideControl) {
            [vSlideControl slideOutWithCompletion:^(BOOL finished) {
                [self slideControlClean:vSlideControl];
            }];
        }
    }
}

- (void) slideControlClean:(UIView*)slideControl{
    if (slideControl) {
        [((UIView*)slideControl) removeFromSuperview];
        if ([slideControl isKindOfClass:[UIDatePicker class]]){
            self.dpDate = nil;
        }else if ([slideControl isKindOfClass:[UIPickerView class]]){
            self.picker = nil;
        }else{
            self.keyboard = nil;
        }
    }
    if (self.tapRecognizer) {
        [self.tapRecognizer.view removeGestureRecognizer:_tapRecognizer];
        self.tapRecognizer = nil;
    }
}

#pragma mark - UIGestureRecognizer
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
      shouldReceiveTouch:(UITouch *)touch{
    UIView* viewHit = [self.view hitTest:[touch locationInView:self.view]
                               withEvent:nil];
    if (([viewHit isDescendantOfView:self.keyboard.view]) ||
        ([viewHit isDescendantOfView:self.dpDate]) ||
        ([viewHit isDescendantOfView:self.picker])) {
        return NO;
    }
    if ((viewHit) &&
        (([viewHit isKindOfClass:[UIControl class]]) ||
         ([viewHit isKindOfClass:[UILabel class]]) ||
         ([viewHit isKindOfClass:[UITableViewCell class]]) ||
         ([NSStringFromClass([viewHit class]) isEqualToString:@"UITableViewCellContentView"]))) {
            [self tapRecognizerAction];
            return NO;
        }
    return YES;
}

#pragma mark - UITabBarControllerDelegate
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    _tabController.tabBar.backgroundImage = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar-%d", _tabController.selectedIndex]];
}

#pragma mark - UINavigationControllerDelegate
-(void)navigationController:(UINavigationController *)navigationController
     willShowViewController:(UIViewController *)viewController
                   animated:(BOOL)animated{
    if (self.hideOnNavigate) {
        [self tapRecognizerAction];
    }else{
        self.hideOnNavigate = YES;
    }
    [self.view endEditing:YES];    
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated{
    self.hideOnNavigate = YES;
}

@end
