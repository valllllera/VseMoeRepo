//
//  Tariff+EntityWorker.h
//  Всё моё
//
//  Created by Evgeniy Tka4enko on 12.11.13.
//  Copyright (c) 2013 Viacheslav Kaloshin. All rights reserved.
//

#import "Tariff.h"

@interface Tariff (EntityWorker)

+ (Tariff *)tariffWithId:(int)idTariff;

+ (Tariff *)tariffWithId:(int)idTariff
                 context:(NSManagedObjectContext*)context;

+ (Tariff *)insertTariffWithId:(int)idTariff
                         start:(int)start
                           end:(int)end
                         descr:(NSString *)descr
                        amount:(float)amount
                      currency:(Currency *)currency
                          save:(BOOL)save;

+ (Tariff *)insertTariffWithId:(int)idTariff
                         start:(int)start
                           end:(int)end
                         descr:(NSString *)descr
                        amount:(float)amount
                      currency:(Currency *)currency
                          save:(BOOL)save
                       context:(NSManagedObjectContext*)context;

@end
