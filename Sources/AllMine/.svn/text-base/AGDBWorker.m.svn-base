//
//  AGDBWorker.m
//  AllMine
//
//  Created by Allgoritm LLC on 31.10.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "AGDBWorker.h"

#import "AGAppDelegate.h"

@implementation AGDBWorker

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - shared

+ (AGDBWorker*) sharedWorker {
    static AGDBWorker* _srv = nil;
    if (nil == _srv) {
        _srv = [[AGDBWorker alloc] init];
    }
    return _srv;
}

- (void) rollback{
    [_managedObjectContext rollback];
}

-(NSManagedObjectContext*)managedContextTemporary{
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    NSManagedObjectContext* context = nil;
    if (coordinator != nil){
        context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:coordinator];
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
    }
    return context;
}

#pragma mark - Save context

- (BOOL) saveManagedContext{
    return [self saveContext:self.managedObjectContext];
}
- (BOOL) saveContext:(NSManagedObjectContext*)context{
    @synchronized(self){
        NSError *error = nil;
        if (![context save:&error]) {
            // Save failed
            AGLog(@"Core Data Save Error: %@, %@", error, [error userInfo]);
            return NO;
        }
        return YES;
    }
}

#pragma mark - Core Data

- (NSManagedObjectContext*) managedObjectContext{
    if (_managedObjectContext != nil){
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil){
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        _managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    }
    return _managedObjectContext;
}

- (NSPersistentStoreCoordinator*) persistentStoreCoordinator{
    if (_persistentStoreCoordinator != nil){
        return _persistentStoreCoordinator;
    }
    
    AGAppDelegate* d = [[UIApplication sharedApplication] delegate];
    NSURL *storeURL = [[d documentsDirectory] URLByAppendingPathComponent:@"AllMineCoreData.sqlite"];
    AGLog(@"Core Data store path = \"%@\"", [storeURL path]);
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil URL:storeURL options:nil error:&error]){
        AGLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil){
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Database" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

#pragma mark - fetch

- (NSArray*) fetchManagedObjectsWithEntityName:(NSString*) entityName
                                     predicate:(NSPredicate*) predicate
                               sortDescriptors:(NSArray*) sortDescriptors
                                         first:(int)first{
    
    return [self fetchManagedObjectsWithEntityName:entityName
                                         predicate:predicate
                                   sortDescriptors:sortDescriptors
                                             first:first
                                           context:self.managedObjectContext];
}
//	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//	[fetchRequest setEntity:[NSEntityDescription entityForName:entityName
//                                        inManagedObjectContext:self.managedObjectContext]];
//	
//	// Add a sort descriptor. Mandatory.
//    if(sortDescriptors != nil){
//        fetchRequest.sortDescriptors = sortDescriptors;
//    }
//    if (predicate != nil) {
//        fetchRequest.predicate = predicate;
//    }
//    if (groupBy != nil) {
//        fetchRequest.propertiesToGroupBy = groupBy;
//    }
//    if (first != 0) {
//        fetchRequest.fetchLimit = first;
//    }
//    if(skip != 0){
//        fetchRequest.fetchOffset = skip;
//    }
//    
//	NSError *error;
//	NSArray *fetchResults = [self.managedObjectContext executeFetchRequest:fetchRequest
//                                                                 error:&error];
//	
//	if (fetchResults == nil) {
//		// Handle the error.
//		AGLog(@"executeFetchRequest failed with error: %@", [error localizedDescription]);
//	}
//	
//
//	
//	return fetchResults;
//}

- (NSArray*) fetchManagedObjectsWithEntityName:(NSString*) entityName
                                     predicate:(NSPredicate*) predicate
                               sortDescriptors:(NSArray*) sortDescriptors
                                         first:(int)first
                                       context:(NSManagedObjectContext *)context{
    
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[NSEntityDescription entityForName:entityName
                                        inManagedObjectContext:context]];
	
	// Add a sort descriptor. Mandatory.
    if(sortDescriptors != nil){
        fetchRequest.sortDescriptors = sortDescriptors;
    }
    if (predicate != nil) {
        fetchRequest.predicate = predicate;
    }
    if (first != 0) {
        fetchRequest.fetchLimit = first;
    }
    
	NSError *error;
	NSArray *fetchResults = [context executeFetchRequest:fetchRequest
                                                   error:&error];
	
	if (fetchResults == nil) {
		// Handle the error.
		AGLog(@"executeFetchRequest failed with error: %@", [error localizedDescription]);
	}
	
    
	
	return fetchResults;
}

- (NSManagedObject*) fetchManagedObjectWithEntityName:(NSString*) entityName
                                            predicate:(NSPredicate*) predicate
                                      sortDescriptors:(NSArray*) sortDescriptors{
    
//	NSArray *fetchResults = [self fetchManagedObjectsWithEntityName:entityName
//                                                          predicate:predicate
//                                                    sortDescriptors:sortDescriptors
//                                                              first:1];
//	
//	NSManagedObject *managedObject = nil;
//	
//	if (fetchResults && [fetchResults count] > 0) {
//		// Found record
//		managedObject = [fetchResults objectAtIndex:0];
//	}
//	
//	return managedObject;
    return [self fetchManagedObjectWithEntityName:entityName
                                        predicate:predicate
                                  sortDescriptors:sortDescriptors
                                          context:self.managedObjectContext];
}
- (NSManagedObject*) fetchManagedObjectWithEntityName:(NSString*)entityName
                                            predicate:(NSPredicate*)predicate
                                      sortDescriptors:(NSArray*) sortDescriptors
                                              context:(NSManagedObjectContext*)context{
    
	NSArray *fetchResults = [self fetchManagedObjectsWithEntityName:entityName
                                                          predicate:predicate
                                                    sortDescriptors:sortDescriptors
                                                              first:1
                                                            context:context];
	
	NSManagedObject *managedObject = nil;
	
	if (fetchResults && [fetchResults count] > 0) {
		// Found record
		managedObject = [fetchResults objectAtIndex:0];
	}
	
	return managedObject;
}


@end
