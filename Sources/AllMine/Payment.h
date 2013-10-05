//
//  Payment.h
//  AllMine
//
//  Created by Allgoritm LLC on 07.12.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Account, Category, Currency, Payment, Template, User;

@interface Payment : NSManagedObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * finished;
@property (nonatomic, retain) NSNumber * idPayment;
@property (nonatomic, retain) NSDate * modifiedDate;
@property (nonatomic, retain) NSNumber * rateValue;
@property (nonatomic, retain) NSNumber * removed;
@property (nonatomic, retain) NSNumber * sum;
@property (nonatomic, retain) NSNumber * sumMain;
@property (nonatomic, retain) NSNumber * hidden;
@property (nonatomic, retain) Account *account;
@property (nonatomic, retain) Account *accountAsCategory;
@property (nonatomic, retain) Category *category;
@property (nonatomic, retain) Currency *currency;
@property (nonatomic, retain) NSSet *subpayments;
@property (nonatomic, retain) Payment *superpayment;
@property (nonatomic, retain) Template *template;
@property (nonatomic, retain) User *user;
@end

@interface Payment (CoreDataGeneratedAccessors)

- (void)addSubpaymentsObject:(Payment *)value;
- (void)removeSubpaymentsObject:(Payment *)value;
- (void)addSubpayments:(NSSet *)values;
- (void)removeSubpayments:(NSSet *)values;

@end
