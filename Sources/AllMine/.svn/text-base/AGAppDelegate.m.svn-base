//
//  AGAppDelegate.m
//  AllMine
//
//  Created by Pavel Jaoshvili on 30.10.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "AGAppDelegate.h"
#import "AGRootController.h"

#import "AGDBWorker.h"
#import "User+EntityWorker.h"
#import "Currency+EntityWorker.h"
#import "Rate+EntityWorker.h"
#import "Category+EntityWorker.h"
#import "Account+EntityWorker.h"
#import "NSDate+AGExtensions.h"
#import "Payment+EntityWorker.h"

#import "Template+EntityWorker.h"

@implementation AGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    if ([ud objectForKey:kUDFirstLoad] == nil) {
        [self initFakeDB];
        [ud setBool:NO forKey:kUDFirstLoad];
        [ud synchronize];
    }
    
    self.rootController = [[AGRootController alloc] init];
    self.window.rootViewController = self.rootController;
    [self.window makeKeyAndVisible];

    [self.rootController performSelector:@selector(showLogin)
                              withObject:nil
                              afterDelay:0.1f];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self.rootController syncTimerStop];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self.rootController performSelector:@selector(showLogin) withObject:nil afterDelay:kSlideAnimationTime];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
 // Optional UITabBarControllerDelegate method.
 - (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
 {
 }
 */

/*
 // Optional UITabBarControllerDelegate method.
 - (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
 {
 }
 */

- (void) initFakeDB{
    Currency* crncyRub = [Currency insertCurrencyWithTitle:@"RUB" comment:@"russian rubbles"save:YES];
    crncyRub.code = @"810";
    return;
    
    //////////////////
    // this fake db was used in development
//    Currency* crncyUsd = [Currency insertCurrencyWithTitle:@"USD" comment:@"american dollars" save:YES];
//    crncyUsd.code = @"840";
//    Currency* crncyEur = [Currency insertCurrencyWithTitle:@"EUR" comment:@"euro" save:YES];
//    crncyEur.code = @"978";
//    Currency* crncyUah = [Currency insertCurrencyWithTitle:@"UAH" comment:@"grivna" save:YES];
//    crncyUah.code = @"980";
//    [[AGDBWorker sharedWorker] saveManagedContext];
//    #warning add at least one currency
////    [Rate insertRateWithCurrency:crncyRub date:[NSDate today] value:0.031941f];
////    [Rate insertRateWithCurrency:crncyRub date:[NSDate yesterday] value:0.031941f];
////    [Rate insertRateWithCurrency:crncyRub date:[NSDate dayBeforeYesterday] value:0.031941f];
////    [Rate insertRateWithCurrency:crncyRub date:[NSDate dayBeforeBeforeYesterday] value:0.031941f];
////    
////    [Rate insertRateWithCurrency:crncyUsd date:[NSDate today] value:1.0f];
////    [Rate insertRateWithCurrency:crncyUsd date:[NSDate yesterday] value:1.0f];
////    [Rate insertRateWithCurrency:crncyUsd date:[NSDate dayBeforeYesterday] value:1.0f];
////    [Rate insertRateWithCurrency:crncyUsd date:[NSDate dayBeforeBeforeYesterday] value:1.0f];
////    
////    [Rate insertRateWithCurrency:crncyEur date:[NSDate today] value:1.2839f];
////    [Rate insertRateWithCurrency:crncyEur date:[NSDate yesterday] value:1.2839f];
////    [Rate insertRateWithCurrency:crncyEur date:[NSDate dayBeforeYesterday] value:1.2839f];
////    [Rate insertRateWithCurrency:crncyEur date:[NSDate dayBeforeBeforeYesterday] value:1.2839f];
////    
////    [Rate insertRateWithCurrency:crncyUah date:[NSDate today] value:0.122175f];
////    [Rate insertRateWithCurrency:crncyUah date:[NSDate yesterday] value:0.122175f];
////    [Rate insertRateWithCurrency:crncyUah date:[NSDate dayBeforeYesterday] value:0.122175f];
////    [Rate insertRateWithCurrency:crncyUah date:[NSDate dayBeforeBeforeYesterday] value:0.122175f];
//
////    User* usr2 = [User insertUserWithLogin:@"user2" password:@"user2"];
////    usr2.currencyMain = crncyUsd;
////    [[AGDBWorker sharedWorker] saveManagedContext];
//    
//    User* usr = [User insertUserWithLogin:@"test2@test.com" password:@"11111"];
//    usr.currencyMain = crncyRub;
//    [usr addCurrenciesAdditionalObject:crncyUsd];
//
//    [[AGDBWorker sharedWorker] saveManagedContext];
//    
//    Category* exp1 = [Category insertCategoryWithUser: usr title:@"Entertainment" type:CatTypeExpense supercat:nil save:YES];
//    Category* exp11 = [Category insertCategoryWithUser: usr title:@"Movie" type:CatTypeExpense supercat:exp1 save:YES];
//    Category* exp12 = [Category insertCategoryWithUser: usr title:@"Performance" type:CatTypeExpense supercat:exp1 save:YES];
//    /*Category* exp2 = */[Category insertCategoryWithUser: usr title:@"Auto" type:CatTypeExpense supercat:nil save:YES];
//    
//    /*Category* inc1 = */[Category insertCategoryWithUser: usr title:@"Salary" type:CatTypeIncome supercat:nil save:YES];
//    Category* inc2 = [Category insertCategoryWithUser: usr title:@"Shop" type:CatTypeIncome supercat:nil save:YES];
//    Category* inc21 = [Category insertCategoryWithUser: usr title:@"Goods" type:CatTypeIncome supercat:inc2 save:YES];
//    Category* inc22 = [Category insertCategoryWithUser: usr title:@"Bread" type:CatTypeIncome supercat:inc2 save:YES];
//    Category* inc221 = [Category insertCategoryWithUser: usr title:@"White Bread" type:CatTypeIncome supercat:inc22 save:YES];
//    /*Category* inc23 = */[Category insertCategoryWithUser: usr title:@"Candy" type:CatTypeIncome supercat:inc2 save:YES];
//    
//    
//   Account* acc1 = [Account insertAccountWithUser:usr
//                                            title:@"Account 1"
//                                         currency:crncyRub
//                                             date:[NSDate today]
//                                            group:AccGroupAllMine
//                                             type:AccTypeCash
//                                          comment:@"my account 1"
//                                             save:YES];
//    [Payment insertPaymentWithUser:usr account:acc1 category:nil accountAsCategory:nil currency:crncyRub sum:-100.0 sumMain:-100.0 rateValue:0.0f date:[NSDate today] comment:@"" ptemplate:nil finished:YES hidden:YES save:YES];
//   Account* acc2 = [Account insertAccountWithUser:usr
//                                            title:@"Account 2"
//                                         currency:crncyUsd
//                                             date:[NSDate date]
//                                            group:AccGroupDebts
//                                             type:AccTypeBank
//                                          comment:@"my account 2"
//                                             save:YES];
//    [Payment insertPaymentWithUser:usr account:acc2 category:nil accountAsCategory:nil currency:crncyRub sum:5000.0 sumMain:5000.0 rateValue:0.0f date:[NSDate today] comment:@"" ptemplate:nil finished:YES hidden:YES save:YES];
////    [acc2 markRemoved];
////    [[AGDBWorker sharedWorker] saveManagedContext];
//    
//    /*Template* tmplt1 = */[Template insertTemplateWithUser:usr title:@"Salary" account:acc1 category:nil accountAsCategory:acc2 comment:@"поступление зарплаты" save:YES];
//    /*Template* tmplt2 = */[Template insertTemplateWithUser:usr title:@"Goods" account:acc2 category:inc21 accountAsCategory:nil comment:@"проданные в магазине товары" save:YES];
//    Template* tmplt3 = [Template insertTemplateWithUser:usr title:@"Performance" account:acc1 category:exp12 accountAsCategory:nil comment:@"поход в театр" save:YES];
//    Template* tmplt4 = [Template insertTemplateWithUser:usr title:@"Movie" account:acc1 category:exp11 accountAsCategory:nil comment:@"поход в кино" save:YES];
//
//    for (int i = 0; i < 1; i++) {
//        [Payment insertPaymentWithUser:usr account:acc1 category:nil accountAsCategory:acc2 currency:crncyRub sum:-100.0 sumMain:-100.0 rateValue:0.0f date:[NSDate today] comment:@"" ptemplate:tmplt4 finished:YES hidden:NO save:YES];
//        [Payment insertPaymentWithUser:usr account:acc1 category:exp12 accountAsCategory:nil currency:crncyRub sum:-200.0 sumMain:-200.0 rateValue:0.0f date:[NSDate today] comment:@"" ptemplate:tmplt3 finished:YES hidden:NO save:YES];
//        [Payment insertPaymentWithUser:usr account:acc2 category:inc221 accountAsCategory:nil currency:crncyRub sum:500.0 sumMain:500.0 rateValue:0.0f date:[NSDate yesterday] comment:@"" ptemplate:nil finished:YES hidden:NO save:YES];
//        [Payment insertPaymentWithUser:usr account:acc1 category:exp12 accountAsCategory:nil currency:crncyRub sum:-400.0 sumMain:-400.0 rateValue:0.0f date:[NSDate dayBeforeYesterday] comment:@"" ptemplate:tmplt3 finished:YES hidden:NO save:YES];
//        [Payment insertPaymentWithUser:usr account:acc1 category:inc21 accountAsCategory:nil currency:crncyRub sum:350.0 sumMain:350 rateValue:0.0f date:[NSDate dayBeforeBeforeYesterday] comment:@"" ptemplate:nil finished:YES hidden:NO save:YES];
//    }
//    [Payment insertPaymentWithUser:usr account:nil category:nil accountAsCategory:nil currency:crncyRub sum:-5000.0 sumMain:-5000.0 rateValue:0.0f date:[NSDate dayBeforeBeforeYesterday] comment:@"" ptemplate:nil finished:NO hidden:NO save:YES];    
}

#pragma mark - documents directory

- (NSURL*) documentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
