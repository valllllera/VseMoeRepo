//
//  Account+EntityWorker.m
//  AllMine
//
//  Created by Allgoritm LLC on 01.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "Account+EntityWorker.h"
#import "AGDBWorker.h"
#import "NSDate+AGExtensions.h"
#import "Payment+EntityWorker.h"
#import "Currency+EntityWorker.h"
#import "Template+EntityWorker.h"

static NSString *entityName = @"Account";

@implementation Account (EntityWorker)

+ (Account*) insertAccountWithUser:(User*)user
                             title:(NSString*)title
                          currency:(Currency*)currency
                              date:(NSDate*)date
                             group:(AccGroup)group
                              type:(AccType)type
                           comment:(NSString*)comment
                              save:(BOOL)save{

    return [Account insertAccountWithUser:user
                                    title:title
                                 currency:currency
                                     date:date
                                    group:group
                                     type:type
                                  comment:comment
                                     save:save
                                  context:[AGDBWorker sharedWorker].managedObjectContext];
}

+ (Account*) insertAccountWithUser:(User*)user
                             title:(NSString*)title
                          currency:(Currency*)currency
                              date:(NSDate*)date
                             group:(AccGroup)group
                              type:(AccType)type
                           comment:(NSString*)comment
                              save:(BOOL)save
                           context:(NSManagedObjectContext*)context{

    AGDBWorker* dbw = [AGDBWorker sharedWorker];

    Account* account = (Account*)[NSEntityDescription insertNewObjectForEntityForName:entityName
                                                        inManagedObjectContext:context];
    account.idAccount = [NSNumber numberWithInt:-1];
    account.title = title;
    account.currency = currency;
    account.dateOpen = date;
    account.group = [NSNumber numberWithInt:group];
    account.type = [NSNumber numberWithInt:type];
    account.comment = comment;
    account.user = user;
    account.removed = [NSNumber numberWithBool: NO];
    account.modifiedDate = [NSDate date];
    
    if (save) {
        [dbw saveContext:context];
    }

    return account;
}

- (void) markRemovedSave:(BOOL)save{
    [self markRemovedSave:save
                  context:[AGDBWorker sharedWorker].managedObjectContext];
}
- (void) markRemovedSave:(BOOL)save
                 context:(NSManagedObjectContext*)context{
    self.removed = [NSNumber numberWithBool: YES];
    self.modifiedDate = [NSDate date];
    for (Payment* p in self.payments) {
        [p markRemovedSave:NO
                   context:context];
    }
    if (save) {
        [[AGDBWorker sharedWorker] saveContext:context];
    }
}

+ (Account*) accountWithId:(int)idAccount context:(NSManagedObjectContext*)context{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idAccount == %d", idAccount];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    Account *account = (Account*) [dbw fetchManagedObjectWithEntityName:entityName
                                                              predicate:predicate
                                                        sortDescriptors:nil
                                                                context:context];
    return account;
}

- (double) balance{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"finished == YES"];
    NSNumber* sum1 = [[self.payments filteredSetUsingPredicate:predicate] valueForKeyPath:@"@sum.sumMain"];
    NSNumber* sum2 = [[self.paymentsAsCategory filteredSetUsingPredicate:predicate] valueForKeyPath:@"@sum.sumMain"];
    return [sum1 doubleValue] - [sum2 doubleValue];
//    return [self balanceFromDate:[NSDate dateWithTimeIntervalSince1970:0] toDate:[[NSDate date] dayNext]];
}
- (double) balanceFromDate:(NSDate*)dtFrom toDate:(NSDate*)dtTo{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"finished == YES AND date >= %@ AND date < %@", dtFrom, dtTo];
    NSNumber* sum1 = [[self.payments filteredSetUsingPredicate:predicate] valueForKeyPath:@"@sum.sumMain"];
    NSNumber* sum2 = [[self.paymentsAsCategory filteredSetUsingPredicate:predicate] valueForKeyPath:@"@sum.sumMain"];
    return [sum1 doubleValue] - [sum2 doubleValue];
}

- (double) balanceWithCurrency:(Currency*)currency{
    double sum = 0;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"finished == YES"];
    NSSet* paymentsFinished = [self.payments filteredSetUsingPredicate:predicate];
    for (Payment* p in paymentsFinished) {
        sum += ([p.sum doubleValue] * [p.currency rateValueWithDate:p.date mainCurrency:currency]);
    }
    NSSet* paymentsAsCategoryFinished = [self.paymentsAsCategory filteredSetUsingPredicate:predicate];
    for (Payment* p in paymentsAsCategoryFinished) {
        sum -= ([p.sum doubleValue] * [p.currency rateValueWithDate:p.date mainCurrency:currency]);
    }
    return sum; 
}

- (Payment*) lastPayment{
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    
    NSArray* arr = [[self.payments allObjects] sortedArrayUsingDescriptors:sortDescriptors];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date <= %@", [[NSDate date] dateWithoutTime]];
    arr = [arr filteredArrayUsingPredicate:predicate];
    if([arr count] > 0)
        return [arr objectAtIndex:0];
    else
        return nil;
}

+ (NSString*)entityName{
    return entityName;
}

-(NSSet *)payments{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"removed == NO AND account == %@ AND superpayment == nil", self];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    NSArray* arr = [dbw fetchManagedObjectsWithEntityName:[Payment entityName]
                                                predicate:predicate
                                          sortDescriptors:nil
                                                    first:0];
    return [NSSet setWithArray:arr];
}

-(NSSet *)paymentsAsCategory{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"removed == NO AND accountAsCategory == %@ AND superpayment == nil", self];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    NSArray* arr = [dbw fetchManagedObjectsWithEntityName:[Payment entityName]
                                                predicate:predicate
                                          sortDescriptors:nil
                                                    first:0];
    return [NSSet setWithArray:arr];
}

-(NSArray*) templatesSortedByTitle{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"removed == NO AND account == %@", self];
    NSArray* sortDecr = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    NSArray* arr = [dbw fetchManagedObjectsWithEntityName:[Template entityName]
                                                predicate:predicate
                                          sortDescriptors:sortDecr
                                                    first:0];
    return arr;
}


@end
