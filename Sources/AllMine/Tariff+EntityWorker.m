//
//  Tariff+EntityWorker.m
//  Всё моё
//
//  Created by Evgeniy Tka4enko on 12.11.13.
//  Copyright (c) 2013 Viacheslav Kaloshin. All rights reserved.
//

#import "Tariff+EntityWorker.h"
#import "AGDBWorker.h"

static NSString *entityName = @"Tariff";

@implementation Tariff (EntityWorker)

+ (Tariff *)tariffWithId:(int)idTariff
{
    return [self tariffWithId:idTariff context:[AGDBWorker sharedWorker].managedObjectContext];
}

+ (Tariff *)tariffWithId:(int)idTariff
                context:(NSManagedObjectContext*)context
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idTariff == %d", idTariff];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    Tariff *tariff = (Tariff *) [dbw fetchManagedObjectWithEntityName:entityName
                                                            predicate:predicate
                                                      sortDescriptors:nil
                                                              context:context];
    
    return tariff;
}

+ (Tariff *)insertTariffWithId:(int)idTariff
                         start:(int)start
                           end:(int)end
                         descr:(NSString *)descr
                        amount:(float)amount
                      currency:(Currency *)currency
                          save:(BOOL)save
{
    return [self insertTariffWithId:idTariff start:start end:end descr:descr amount:amount currency:currency save:YES context:[AGDBWorker sharedWorker].managedObjectContext];
}

+ (Tariff *)insertTariffWithId:(int)idTariff
                         start:(int)start
                           end:(int)end
                         descr:(NSString *)descr
                        amount:(float)amount
                      currency:(Currency *)currency
                          save:(BOOL)save
                       context:(NSManagedObjectContext*)context
{
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    
    Tariff* tariff = (Tariff *)[NSEntityDescription insertNewObjectForEntityForName:entityName
                                                             inManagedObjectContext:context];
    
    tariff.idTariff = @(idTariff);
    tariff.start = @(start);
    tariff.end = @(end);
    tariff.descr = descr;
    tariff.amount = @(amount);
    if(currency != nil)
    {
        tariff.currency = currency;
    }
    
    if (save)
    {
        [dbw saveContext:context];
    }
    
    return tariff;
}

@end
