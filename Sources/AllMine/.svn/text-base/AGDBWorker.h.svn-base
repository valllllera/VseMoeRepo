//
//  AGDBWorker.h
//  AllMine
//
//  Created by Allgoritm LLC on 31.10.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGDBWorker : NSObject

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (AGDBWorker*) sharedWorker;

- (BOOL) saveManagedContext;
- (BOOL) saveContext:(NSManagedObjectContext*)context;

- (NSArray*) fetchManagedObjectsWithEntityName:(NSString*) entityName
                                     predicate:(NSPredicate*) predicate
                               sortDescriptors:(NSArray*) sortDescriptors
                                         first:(int)first;

- (NSArray*) fetchManagedObjectsWithEntityName:(NSString*) entityName
                                     predicate:(NSPredicate*) predicate
                               sortDescriptors:(NSArray*) sortDescriptors
                                         first:(int)first
                                       context:(NSManagedObjectContext*)context;


- (NSManagedObject*) fetchManagedObjectWithEntityName:(NSString*)entityName
                                            predicate:(NSPredicate*)predicate
                                      sortDescriptors:(NSArray*) sortDescriptors;

- (NSManagedObject*) fetchManagedObjectWithEntityName:(NSString*)entityName
                                            predicate:(NSPredicate*)predicate
                                      sortDescriptors:(NSArray*) sortDescriptors
                                              context:(NSManagedObjectContext*)context;

-(void) rollback;

-(NSManagedObjectContext*)managedContextTemporary;

@end
