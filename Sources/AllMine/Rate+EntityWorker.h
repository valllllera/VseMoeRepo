//
//  Rate+EntityWorker.h
//  AllMine
//
//  Created by Allgoritm LLC on 01.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "Rate.h"

@interface Rate (EntityWorker)

+ (Rate*) insertRateWithCurrency:(Currency *)currency
                            date:(NSDate *)date
                           value:(double)value
                            save:(BOOL)save;

+ (Rate*) insertRateWithCurrency:(Currency *)currency
                            date:(NSDate *)date
                           value:(double)value
                            save:(BOOL)save
                         context:(NSManagedObjectContext*)context;

@end
