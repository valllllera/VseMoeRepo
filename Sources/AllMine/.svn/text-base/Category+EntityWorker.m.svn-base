//
//  Category+EntityWorker.m
//  AllMine
//
//  Created by Allgoritm LLC on 01.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "Category+EntityWorker.h"
#import "AGDBWorker.h"

static NSString *entityName = @"Category";

@implementation Category (EntityWorker)

+ (Category*) insertCategoryWithUser:(User*)user
                               title:(NSString*) title
                                type:(CatType)type
                            supercat:(Category*)supercat
                                save:(BOOL)save{
    
    return [Category insertCategoryWithUser:user
                                      title:title
                                       type:type
                                   supercat:supercat
                                       save:save
                                    context:[AGDBWorker sharedWorker].managedObjectContext];
}

+ (Category*) insertCategoryWithUser:(User*)user
                               title:(NSString*) title
                                type:(CatType)type
                            supercat:(Category*)supercat
                                save:(BOOL)save
                             context:(NSManagedObjectContext*)context{
    AGDBWorker* dbw = [AGDBWorker sharedWorker];

    Category* category = (Category*)[NSEntityDescription insertNewObjectForEntityForName:entityName
                                                        inManagedObjectContext:context];
    
    category.user = user;
    category.title = title;
    category.type = [NSNumber numberWithInt:type];
    category.removed = [NSNumber numberWithBool: NO];
    if(supercat != nil){
        category.supercat = supercat;
    }
    category.idCategory = [NSNumber numberWithInt:-1];
    category.modifiedDate = [NSDate date];
    
    if (save) {
        [dbw saveContext:context];
    }
    
    return category;
}

-(NSSet *)subcats{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"removed == NO AND supercat == %@", self];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    NSArray* arr = [dbw fetchManagedObjectsWithEntityName:entityName
                                                predicate:predicate
                                          sortDescriptors:nil
                                                    first:0];
    return [NSSet setWithArray:arr];
}
-(NSSet *)subcats:(NSManagedObjectContext*)context{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"removed == NO AND supercat == %@", self];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    NSArray* arr = [dbw fetchManagedObjectsWithEntityName:entityName
                                                predicate:predicate
                                          sortDescriptors:nil
                                                    first:0
                                                  context:context];
    return [NSSet setWithArray:arr];
}
-(NSSet *)subcatsAll{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"supercat == %@", self];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    NSArray* arr = [dbw fetchManagedObjectsWithEntityName:entityName
                                                predicate:predicate
                                          sortDescriptors:nil
                                                    first:0];
    return [NSSet setWithArray:arr];
}

+ (Category*) categoryWithId:(int)idCategory
                     context:(NSManagedObjectContext*)context{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idCategory == %d", idCategory];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    Category *category = (Category*) [dbw fetchManagedObjectWithEntityName:entityName
                                                                 predicate:predicate
                                                           sortDescriptors:nil
                                                                   context:context];
    return category;
}

- (void) markRemovedSave:(BOOL)save
                 context:(NSManagedObjectContext*)context{
    self.removed = [NSNumber numberWithBool:YES];
    self.modifiedDate = [NSDate date];
    for (Category* ct in [self subcats:context]) {
        [ct markRemovedSave:save
                    context:context];
    }
    if(save){
        [[AGDBWorker sharedWorker] saveManagedContext];
    }
}
- (void) markRemovedSave:(BOOL)save{
    self.removed = [NSNumber numberWithBool:YES];
    self.modifiedDate = [NSDate date];
    for (Category* ct in self.subcats) {
        [ct markRemovedSave:save];
    }
    if(save){
        [[AGDBWorker sharedWorker] saveManagedContext];
    }
}

+ (NSString*)entityName{
    return entityName;
}

-(void)changeType:(CatType)type save:(BOOL)save{
    self.type = [NSNumber numberWithInt:type];
    for (Category* subcat in self.subcats) {
        [subcat changeType:type save:save];
    }
    if(save){
        [[AGDBWorker sharedWorker] saveManagedContext];
    }
}

@end
