//
//  User+EntityWorker.h
//  AllMine
//
//  Created by Allgoritm LLC on 01.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "User.h"

typedef enum{
    ReportItemMonth = 0,
    ReportItemWeek = 1,
    ReportItemDay = 2
}ReportItem;

typedef enum{
    ReportTypeYIn = 0,
    ReportTypeYOut = 1,
    ReportTypeYCapital = 2
}ReportTypeY;

typedef enum{
    ReportTypeXTime,
    ReportTypeXCategories,
    ReportTypeXAccounts
}ReportTypeX;

@interface User (EntityWorker)

+ (User*) insertUserWithLogin:(NSString *)login password:(NSString *)password;

+ (User*) userWithLogin:(NSString*)login;
+ (User*) userWithLogin:(NSString*)login
                context:(NSManagedObjectContext*)context;

+ (NSArray*) usersToShow;
+ (void) hideUsers;

- (void) addStandardData;

- (NSArray*) currenciesMainAdditionalSorted;
- (NSArray*) currenciesAdditionalSorted;

-(NSSet*) paymentsNotHidden;
-(NSSet*) payments;
-(NSSet*) paymentsContext:(NSManagedObjectContext*)context;
-(NSSet*) paymentsAll;
-(NSSet*) paymentsAllContext:(NSManagedObjectContext*)context;
-(NSSet*) paymentsRemovedContext:(NSManagedObjectContext*)context;
-(NSArray*) paymentsFinishedSortedByDateWithAccount:(Account*)account
                                              first:(int)first;
-(NSArray*) paymentsNotFinishedWithAccount:(Account*)account;

-(NSSet*) templates;
-(NSSet*) templatesContext:(NSManagedObjectContext*)context;
-(NSSet*) templatesAll;
-(NSSet*) templatesAllContext:(NSManagedObjectContext*)context;
-(NSSet*) templatesRemovedContext:(NSManagedObjectContext*)context;
-(NSArray*) templateSortedList;

-(void) recalculatePayments;

-(double) balanceForCurrentMonthWithCategoryType:(int)type;
-(double) balanceWithAccountGroup:(int)group;

-(NSArray*) categoriesRootWithType:(NSInteger)type;
-(NSSet*) categories;
-(NSSet*) categoriesContext:(NSManagedObjectContext*)context;
-(NSSet*) categoriesAll;
-(NSSet*) categoriesAllContext:(NSManagedObjectContext*)context;
-(NSSet*) categoriesRemovedContext:(NSManagedObjectContext*)context;

-(NSSet*) accounts;
-(NSSet*) accountsContext:(NSManagedObjectContext*)context;
-(NSArray*) accountsSortedByTitle;
-(NSSet*) accountsAll;
-(NSSet*) accountsAllContext:(NSManagedObjectContext*)context;
-(NSSet*) accountsRemovedContext:(NSManagedObjectContext*)context;
-(NSArray*) accountsByType:(int)type;

- (NSArray*)reportWithItem:(ReportItem)item
                     typeY:(ReportTypeY)typeY
                     typeX:(ReportTypeX)typeX
                      from:(NSDate*)dtFrom
                        to:(NSDate*)dtTo
             supercategory:(Category*)supercat
                   account:(Account*)account;

- (void) resetData;

@end
