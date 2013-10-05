//
//  Category+EntityWorker.h
//  AllMine
//
//  Created by Allgoritm LLC on 01.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "Category.h"

typedef enum{
    CatTypeIncome = 1,
    CatTypeExpense = 0
}CatType;

@interface Category (EntityWorker)

+ (NSString*)entityName;

+ (Category*) insertCategoryWithUser:(User*)user
                               title:(NSString*) title
                                 type:(CatType)type
                             supercat:(Category*)supercat
                                save:(BOOL)save;

+ (Category*) insertCategoryWithUser:(User*)user
                               title:(NSString*) title
                                type:(CatType)type
                            supercat:(Category*)supercat
                                save:(BOOL)save
                             context:(NSManagedObjectContext*)context;

-(NSSet*) subcats;
-(NSSet*) subcatsAll;

+ (Category*) categoryWithId:(int)idCategory
                     context:(NSManagedObjectContext*)context;

- (void) markRemovedSave:(BOOL)save;
- (void) markRemovedSave:(BOOL)save
                 context:(NSManagedObjectContext*)context;

-(void)changeType:(CatType)type save:(BOOL)save;

@end
