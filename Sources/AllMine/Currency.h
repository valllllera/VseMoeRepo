//
//  Currency.h
//  AllMine
//
//  Created by Allgoritm LLC on 30.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Account, Payment, Rate, User;

@interface Currency : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSNumber * idCurrency;
@property (nonatomic, retain) NSDate * modifiedDate;
@property (nonatomic, retain) NSNumber * removed;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *accounts;
@property (nonatomic, retain) NSSet *payments;
@property (nonatomic, retain) NSSet *rates;
@property (nonatomic, retain) NSSet *usersAdditional;
@property (nonatomic, retain) NSSet *usersMain;
@property (nonatomic, retain) User *user;
@end

@interface Currency (CoreDataGeneratedAccessors)

- (void)addAccountsObject:(Account *)value;
- (void)removeAccountsObject:(Account *)value;
- (void)addAccounts:(NSSet *)values;
- (void)removeAccounts:(NSSet *)values;

- (void)addPaymentsObject:(Payment *)value;
- (void)removePaymentsObject:(Payment *)value;
- (void)addPayments:(NSSet *)values;
- (void)removePayments:(NSSet *)values;

- (void)addRatesObject:(Rate *)value;
- (void)removeRatesObject:(Rate *)value;
- (void)addRates:(NSSet *)values;
- (void)removeRates:(NSSet *)values;

- (void)addUsersAdditionalObject:(User *)value;
- (void)removeUsersAdditionalObject:(User *)value;
- (void)addUsersAdditional:(NSSet *)values;
- (void)removeUsersAdditional:(NSSet *)values;

- (void)addUsersMainObject:(User *)value;
- (void)removeUsersMainObject:(User *)value;
- (void)addUsersMain:(NSSet *)values;
- (void)removeUsersMain:(NSSet *)values;

@end
