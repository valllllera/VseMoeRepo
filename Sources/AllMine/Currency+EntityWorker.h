//
//  Currency+EntityWorker.h
//  AllMine
//
//  Created by Allgoritm LLC on 01.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "Currency.h"

@class Rate;

@interface Currency (EntityWorker)

+ (Currency*) insertCurrencyWithTitle:(NSString*) title
                              comment:(NSString*) commment
                                 save:(BOOL)save;

+ (Currency*) insertCurrencyWithTitle:(NSString*) title
                              comment:(NSString*) commment
                                 save:(BOOL)save
                              context:(NSManagedObjectContext*)context;

+ (Currency*) currencyWithTitle:(NSString*)title;

+ (NSArray*) currenciesWithUser:(User*)usr;

- (Rate*) rateWithDate:(NSDate*)date;
- (double) rateValueWithDate:(NSDate*)date;
- (double) rateValueWithDate:(NSDate*)date mainCurrency:(Currency*)main;

+ (Currency*) currencyWithId:(int)idCurrency context:(NSManagedObjectContext*)context;
+ (Currency*) currencyWithCode:(NSString*)code context:(NSManagedObjectContext*)context;

+ (NSString*)entityName;

@end
