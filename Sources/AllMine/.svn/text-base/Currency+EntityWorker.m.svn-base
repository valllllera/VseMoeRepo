//
//  Currency+EntityWorker.m
//  AllMine
//
//  Created by Allgoritm LLC on 01.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "Currency+EntityWorker.h"
#import "AGDBWorker.h"
#import "Rate+EntityWorker.h"
#import "NSDate+AGExtensions.h"
#import "User+EntityWorker.h"

static NSString *entityName = @"Currency";

@implementation Currency (EntityWorker)

+ (Currency*) insertCurrencyWithTitle:(NSString*) title
                              comment:(NSString*) commment
                                 save:(BOOL)save{

    return [Currency insertCurrencyWithTitle:title
                                 comment:commment
                                    save:save
                                 context:[AGDBWorker sharedWorker].managedObjectContext];
}

+ (Currency*) insertCurrencyWithTitle:(NSString*) title
                              comment:(NSString*) commment
                                 save:(BOOL)save
                              context:(NSManagedObjectContext *)context{

    Currency* currency = (Currency*)[NSEntityDescription insertNewObjectForEntityForName:entityName
                                                        inManagedObjectContext:context];
    currency.title = title;
    currency.comment = commment;
    currency.idCurrency = [NSNumber numberWithInt:-1];
    currency.user = nil;
    currency.removed = [NSNumber numberWithBool:NO];
    currency.modifiedDate = [NSDate date];
    
    if (save) {
        [[AGDBWorker sharedWorker] saveContext:context];
    }
    return currency;
}

+ (Currency*) currencyWithTitle:(NSString*)title{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@", title];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    Currency *currency = (Currency *) [dbw fetchManagedObjectWithEntityName:entityName
                                                                  predicate:predicate
                                                            sortDescriptors:nil];
    
    return currency;
}

+ (NSArray*) currenciesWithUser:(User*)usr{
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user == nil OR user == %@", usr];
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"comment" ascending:YES]];    
    NSMutableArray* arr = [NSMutableArray arrayWithArray:[dbw fetchManagedObjectsWithEntityName:entityName
                                                                                      predicate:predicate
                                                                                sortDescriptors:sortDescriptors
                                                                                          first:0]];
//    [arr addObjectsFromArray:[usr.currencies allObjects]];
    [arr sortUsingDescriptors:sortDescriptors];
    return arr;
}

+ (Currency*) currencyWithId:(int)idCurrency context:(NSManagedObjectContext*)context{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idCurrency == %d", idCurrency];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    Currency *currency = (Currency*) [dbw fetchManagedObjectWithEntityName:entityName
                                                              predicate:predicate
                                                        sortDescriptors:nil
                                                                   context:context];
    return currency;
}
+ (Currency*) currencyWithCode:(NSString*)code context:(NSManagedObjectContext*)context{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"code == %@", code];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    Currency *currency = (Currency*) [dbw fetchManagedObjectWithEntityName:entityName
                                                                 predicate:predicate
                                                           sortDescriptors:nil
                                                                   context:context];
    return currency;
}


- (Rate*) rateWithDate:(NSDate*)date{
    NSSet* st = [self.rates objectsPassingTest:^(id obj,BOOL *stop){
        Rate* rt = (Rate*) obj;
        if([[rt.date dateWithoutTime] compare:[date dateWithoutTime]] == NSOrderedSame){
            return YES;
        }
        return NO;
    }];
    NSArray* arr = [st allObjects];
    if([arr count] > 0){
        return [arr objectAtIndex:0];
    }else{
        return nil;
    }
}

- (double) rateValueWithDate:(NSDate*)date{
    Rate* rt = [self rateWithDate:date];
    if (rt == nil) {
        NSArray* rates = [self.rates allObjects];
        rates = [rates sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            Rate* rate1 = (Rate*)obj1;
            Rate* rate2 = (Rate*)obj2;
            return [rate1.date compare:rate2.date];
        }];
        if ([rates count] == 0) {
            return 1.0f;
        }
        if ([rates count] == 1) {
            return [((Rate*)[rates objectAtIndex:0]).value doubleValue];
        }
        NSDate* dt = [date dateWithoutTime];
        if ([dt compare:((Rate*)[rates objectAtIndex:0]).date] == NSOrderedAscending) {
            return [((Rate*)[rates objectAtIndex:0]).value doubleValue];
        }
        if ([dt compare:((Rate*)[rates objectAtIndex:[rates count]-1]).date] == NSOrderedDescending) {
            return [((Rate*)[rates objectAtIndex:[rates count]-1]).value doubleValue];
        }
        for (int i = 0; i < [rates count]-1; i++) {
            Rate* rate = [rates objectAtIndex:i];
            Rate* rateNext = [rates objectAtIndex:i+1];
            if (([date compare:rate.date] == NSOrderedDescending)
                && ([date compare:rateNext.date] == NSOrderedAscending)) {
                return [rate.value doubleValue];
            }
        }
    }
    return [rt.value doubleValue];
}

- (double) rateValueWithDate:(NSDate*)date mainCurrency:(Currency*)main{
//    Rate* rt1 = [self rateWithDate:date];
//    Rate* rt2 = [main rateWithDate:date];
//    if ((rt1 == nil) || (rt2 == nil)) {
//        return 1.0f;
//    }
//    return [rt1.value doubleValue] / [rt2.value doubleValue];
    double rateValue1 = [self rateValueWithDate:date];
    double rateValue2 = [main rateValueWithDate:date];    
    return rateValue1 / rateValue2;
}

+ (NSString*)entityName{
    return entityName;
}

@end
