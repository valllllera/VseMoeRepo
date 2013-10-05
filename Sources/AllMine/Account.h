//
//  Account.h
//  Все мое
//
//  Created by Allgoritm LLC on 15.02.13.
//  Copyright (c) 2013 Allgoritm LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Currency, Payment, Template, User;

@interface Account : NSManagedObject

@property (nonatomic, retain) NSString * bank;
@property (nonatomic, retain) NSString * card;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSDate * dateOpen;
@property (nonatomic, retain) NSNumber * group;
@property (nonatomic, retain) NSNumber * idAccount;
@property (nonatomic, retain) NSDate * modifiedDate;
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSString * paymentSystem;
@property (nonatomic, retain) NSNumber * removed;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * creditLimit;
@property (nonatomic, retain) Currency *currency;
@property (nonatomic, retain) NSSet *payments;
@property (nonatomic, retain) NSSet *paymentsAsCategory;
@property (nonatomic, retain) NSSet *templates;
@property (nonatomic, retain) NSSet *templatesAsCategory;
@property (nonatomic, retain) User *user;
@end

@interface Account (CoreDataGeneratedAccessors)

- (void)addPaymentsObject:(Payment *)value;
- (void)removePaymentsObject:(Payment *)value;
- (void)addPayments:(NSSet *)values;
- (void)removePayments:(NSSet *)values;

- (void)addPaymentsAsCategoryObject:(Payment *)value;
- (void)removePaymentsAsCategoryObject:(Payment *)value;
- (void)addPaymentsAsCategory:(NSSet *)values;
- (void)removePaymentsAsCategory:(NSSet *)values;

- (void)addTemplatesObject:(Template *)value;
- (void)removeTemplatesObject:(Template *)value;
- (void)addTemplates:(NSSet *)values;
- (void)removeTemplates:(NSSet *)values;

- (void)addTemplatesAsCategoryObject:(Template *)value;
- (void)removeTemplatesAsCategoryObject:(Template *)value;
- (void)addTemplatesAsCategory:(NSSet *)values;
- (void)removeTemplatesAsCategory:(NSSet *)values;

@end
