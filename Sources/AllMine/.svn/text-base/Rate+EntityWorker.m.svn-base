//
//  Rate+EntityWorker.m
//  AllMine
//
//  Created by Allgoritm LLC on 01.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "Rate+EntityWorker.h"
#import "AGDBWorker.h"
#import "Currency+EntityWorker.h"
#import "NSDate+AGExtensions.h"

static NSString *entityName = @"Rate";

@implementation Rate (EntityWorker)

+ (Rate*) insertRateWithCurrency:(Currency *) currency
                            date:(NSDate *) date
                           value:(double)value
                            save:(BOOL)save{

    return [Rate insertRateWithCurrency:currency
                                   date:date
                                  value:value
                                   save:save
                                context:[AGDBWorker sharedWorker].managedObjectContext];
}

+ (Rate*) insertRateWithCurrency:(Currency *)currency
                            date:(NSDate *)date
                           value:(double)value
                            save:(BOOL)save
                         context:(NSManagedObjectContext*)context{
    
    Rate* rate = (Rate*)[NSEntityDescription insertNewObjectForEntityForName:entityName
                                                      inManagedObjectContext:context];
    rate.value = [NSNumber numberWithDouble:value];
    rate.date = [date dateWithoutTime];
    rate.currency = currency;
    
    if (save) {
        [[AGDBWorker sharedWorker] saveContext:context];
    }
    
    return rate;    
}

@end
