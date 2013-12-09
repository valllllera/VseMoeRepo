//
//  Tariff.h
//  Всё моё
//
//  Created by Evgeniy Tka4enko on 12.11.13.
//  Copyright (c) 2013 Viacheslav Kaloshin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Currency;

@interface Tariff : NSManagedObject

@property (nonatomic, retain) NSNumber * idTariff;
@property (nonatomic, retain) NSNumber * start;
@property (nonatomic, retain) NSNumber * end;
@property (nonatomic, retain) NSString * descr;
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) Currency *currency;

@end
