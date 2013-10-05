//
//  Template.h
//  AllMine
//
//  Created by Allgoritm LLC on 07.12.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Account, Category, Payment, User;

@interface Template : NSManagedObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * idTemplate;
@property (nonatomic, retain) NSDate * modifiedDate;
@property (nonatomic, retain) NSNumber * removed;
@property (nonatomic, retain) Account *account;
@property (nonatomic, retain) Account *accountAsCategory;
@property (nonatomic, retain) Category *category;
@property (nonatomic, retain) NSSet *payments;
@property (nonatomic, retain) User *user;
@end

@interface Template (CoreDataGeneratedAccessors)

- (void)addPaymentsObject:(Payment *)value;
- (void)removePaymentsObject:(Payment *)value;
- (void)addPayments:(NSSet *)values;
- (void)removePayments:(NSSet *)values;

@end
