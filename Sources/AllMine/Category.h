//
//  Category.h
//  AllMine
//
//  Created by Allgoritm LLC on 30.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category, Payment, Template, User;

@interface Category : NSManagedObject

@property (nonatomic, retain) NSNumber * idCategory;
@property (nonatomic, retain) NSDate * modifiedDate;
@property (nonatomic, retain) NSNumber * removed;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSSet *payments;
@property (nonatomic, retain) NSSet *subcats;
@property (nonatomic, retain) Category *supercat;
@property (nonatomic, retain) NSSet *templates;
@property (nonatomic, retain) User *user;
@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addPaymentsObject:(Payment *)value;
- (void)removePaymentsObject:(Payment *)value;
- (void)addPayments:(NSSet *)values;
- (void)removePayments:(NSSet *)values;

- (void)addSubcatsObject:(Category *)value;
- (void)removeSubcatsObject:(Category *)value;
- (void)addSubcats:(NSSet *)values;
- (void)removeSubcats:(NSSet *)values;

- (void)addTemplatesObject:(Template *)value;
- (void)removeTemplatesObject:(Template *)value;
- (void)addTemplates:(NSSet *)values;
- (void)removeTemplates:(NSSet *)values;

@end
