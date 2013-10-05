//
//  NSDate+AGExtensions.h
//  AllMine
//
//  Created by Allgoritm LLC on 06.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (AGExtensions)

- (NSDateComponents*) dateComponents;

- (NSString*) weekdayTitle;
- (NSString*) weekMonthTitle;
- (NSString*) weekMonthTitleForDay;
- (NSString*) monthTitleShort;

- (NSString*) dateTitle;
- (NSString*) dateTitleFull;
- (NSString*) dateTitle2Lined;
- (NSString*) dateTitleWeekDay;
- (NSString*) dateTitleDayMonthShort;
- (NSString*) dateTitleHourMinute;
- (NSString*) dateStringJson;
- (NSString*) dateTitleMonthYear;

- (NSDate*) dateWithoutTime;

+ (NSDate*) today;
+ (NSDate*) yesterday;
+ (NSDate*) dayBeforeYesterday;
+ (NSDate*) dayBeforeBeforeYesterday;
+ (NSDate*) dateFromString:(NSString*)dateString;

- (NSDate*) dayNext;
- (NSDate*) dayPrevious;

- (NSDate*) weekCurrent;
- (NSDate*) weekNext;
- (NSDate*) weekPrevious;

- (NSDate*) monthCurrent;
- (NSDate*) monthNext;
- (NSDate*) monthPrevious;

- (NSDate*) halfYearCurrent;
- (NSDate*) halfYearNext;
- (NSDate*) halfYearPrevious;

- (NSComparisonResult) compareYear:(NSDate*)dt;
- (NSComparisonResult) compareMonth:(NSDate*)dt;
- (NSComparisonResult) compareWeek:(NSDate*)dt;

@end
