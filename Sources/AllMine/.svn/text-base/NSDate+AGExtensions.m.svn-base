//
//  NSDate+AGExtensions.m
//  AllMine
//
//  Created by Allgoritm LLC on 06.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "NSDate+AGExtensions.h"

@interface NSDate (AGExtensionsPrivate)
+ (NSCalendar*) calendar;

- (NSString*) monthTitleShortWithIndex:(int)index;
- (NSString*) monthTitleWithIndex:(int)index;
- (NSString*) weekdayTitleWithIndex:(int)index;
@end

@implementation NSDate (AGExtensions)

+ (NSCalendar*) calendar{
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setTimeZone:[NSTimeZone localTimeZone]];
//    calendar.timeZone = [NSTimeZone localTimeZone];
//    calendar.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    return  calendar;
}

- (NSDateComponents*) dateComponents{
    NSCalendar* calendar = [NSDate calendar];
    NSCalendarUnit flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit| NSSecondCalendarUnit;
    return [calendar components:flags fromDate:self];
}

#pragma mark - title

- (NSString*) weekdayTitle{
    NSDateComponents* comp = [self dateComponents];
    return [self weekdayTitleWithIndex:comp.weekday];
}

- (NSString*) weekMonthTitleForDay{
    NSDate* dt1 = self.weekCurrent;
    NSDate* dt2 = self.weekNext;
    NSDate* dt3 = dt2.dayPrevious;
    
    int day1 = dt1.dateComponents.day;
    int day2 = dt2.dayPrevious.dateComponents.day;
    
    
    if (day1 == day2) {
        return [NSString stringWithFormat:@"%d", day1];
    }else{
        if ([dt1 compareMonth:dt3]!=NSOrderedSame) {
            return [NSString stringWithFormat:@"%d %@ -%d %@", day1, self.monthTitleShort, day2, dt2.dayPrevious.dateTitleMonthYear];
        }
        else
        {
        return [NSString stringWithFormat:@"%d -%d %@", day1, day2, dt3.dateTitleMonthYear];
        }
    }
}



- (NSString*) weekMonthTitle{
    NSDate* dt1 = self.weekCurrent;
    NSDate* dt2 = self.weekNext;
 /*   if ([self compareMonth:dt] == NSOrderedAscending) {
        return dt.monthCurrent;
    }
    return dt;
*/
 /*   if ([dt1 compareMonth:dt2] == NSOrderedAscending) {
        if ([self compareMonth:dt1] == NSOrderedSame) {
            dt2 = dt2.monthCurrent;
        }else{
            dt1 = dt1.monthNext;
        }
    }
   */ 
    int day1 = dt1.dateComponents.day;
    int day2 = dt2.dayPrevious.dateComponents.day;
    if (day1 == day2) {
        return [NSString stringWithFormat:@"%d", day1];
    }else{
        return [NSString stringWithFormat:@"%d-%d", day1, day2];
    }
}
- (NSString*) monthTitleShort{
    NSDateComponents* comp = [self dateComponents];
    return [self monthTitleShortWithIndex:comp.month];
}

- (NSString*) monthTitleWithIndex:(int)index{
    NSString* title = nil;
    switch (index) {
        case 1:
            title = @"January";
            break;
        case 2:
            title = @"February";
            break;
        case 3:
            title = @"March";
            break;
        case 4:
            title = @"April";
            break;
        case 5:
            title = @"May";
            break;
        case 6:
            title = @"June";
            break;
        case 7:
            title = @"July";
            break;
        case 8:
            title = @"August";
            break;
        case 9:
            title = @"September";
            break;
        case 10:
            title = @"October";
            break;
        case 11:
            title = @"November";
            break;
        case 12:
            title = @"December";
            break;
        default:
            title = @"Unknown";
            break;
    }
    return NSLocalizedString(title, @"");
}

- (NSString*) dateTitle{
    NSDateComponents* components = [self dateComponents];
    return [NSString stringWithFormat:@"%d %@", components.day, [self monthTitleWithIndex:components.month]];
}

- (NSString*) monthTitleShortWithIndex:(int)index{
    NSString* title = nil;
    switch (index) {
        case 1:
            title = @"Jan";
            break;
        case 2:
            title = @"Feb";
            break;
        case 3:
            title = @"Mar";
            break;
        case 4:
            title = @"Apr";
            break;
        case 5:
            title = @"May";
            break;
        case 6:
            title = @"Jun";
            break;
        case 7:
            title = @"Jul";
            break;
        case 8:
            title = @"Aug";
            break;
        case 9:
            title = @"Sep";
            break;
        case 10:
            title = @"Oct";
            break;
        case 11:
            title = @"Nov";
            break;
        case 12:
            title = @"Dec";
            break;
        default:
            title = @"Unknown";
            break;
    }
    return NSLocalizedString(title, @"");
}

- (NSString*) dateTitleFull{
    NSDateComponents* components = [self dateComponents];
    
    return [NSString stringWithFormat:@"%d %@ %d", components.day, [self monthTitleShortWithIndex:components.month], components.year];
}

- (NSString*) dateTitleDayMonthShort{
    NSDateComponents* components = [self dateComponents];
    
    return [NSString stringWithFormat:@"%d %@", components.day, [self monthTitleShortWithIndex:components.month]];
}

- (NSString*) dateTitle2Lined{
    NSDateComponents* components = [self dateComponents];
    
    return [NSString stringWithFormat:@"%d\n%@", components.day, [self monthTitleShortWithIndex:components.month]];
}

- (NSString*) weekdayTitleWithIndex:(int)index{
    NSString* weekday = @"";
    switch (index) {
        case 1:
            weekday = @"Sun";
            break;
        case 2:
            weekday = @"Mon";
            break;
        case 3:
            weekday = @"Tue";
            break;
        case 4:
            weekday = @"Wed";
            break;
        case 5:
            weekday = @"Thu";
            break;
        case 6:
            weekday = @"Fri";
            break;
        case 7:
            weekday = @"Sat";
            break;
        default:
            weekday = @"Unknown";
            break;
    }
    return NSLocalizedString(weekday, @"");
}

- (NSString*) dateTitleWeekDay{
    NSDateComponents* components = [self dateComponents];
    
    NSString* dateRel = [NSString stringWithFormat:@"%d %@", components.day, [self monthTitleShortWithIndex:components.month]];
    
    if ([[[NSDate today] dateWithoutTime] compare:[self dateWithoutTime]] == NSOrderedSame) {
        dateRel = NSLocalizedString(@"Today", @"");
    }else if ([[[NSDate yesterday] dateWithoutTime] compare:[self dateWithoutTime]] == NSOrderedSame){
        dateRel = NSLocalizedString(@"Yesterday", @"");
    }else if ([[[NSDate dayBeforeYesterday] dateWithoutTime] compare:[self dateWithoutTime]] == NSOrderedSame){
        dateRel = NSLocalizedString(@"DayBeforeYesterday", @"");
    }
    
    return [NSString stringWithFormat:@"%@, %@", dateRel, [self weekdayTitleWithIndex:components.weekday]];
}

- (NSString*) dateTitleHourMinute{
    NSDateComponents* components = [self dateComponents];
    return [NSString stringWithFormat:@"%02d:%02d", components.hour, components.minute];
}
- (NSString*) dateStringJson{
    NSDateComponents* components = [self dateComponents];
    return [NSString stringWithFormat:@"%04d-%02d-%02d", components.year, components.month, components.day];
}

- (NSString*) dateTitleMonthYear{
    return [NSString stringWithFormat:@"%@, %d", self.monthTitleShort, self.dateComponents.year];
}

#pragma mark - date creation
- (NSDate*) dateWithoutTime {
    NSCalendar* calendar = [NSDate calendar];
    NSCalendarUnit flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents* components = [calendar components:flags fromDate:self];
    return [calendar dateFromComponents:components];
}

+ (NSDate*) today{
    return [[NSDate date] dateWithoutTime];
}

+ (NSDate*) yesterday{
    return [[NSDate today] dateByAddingTimeInterval:-86400.0];
}

+ (NSDate*) dayBeforeYesterday{
    return [[NSDate today] dateByAddingTimeInterval:-86400.0*2];
}

+ (NSDate*) dayBeforeBeforeYesterday{
#warning TODO: remove, for fakedb only
    return [[NSDate today] dateByAddingTimeInterval:-86400.0*3];
}

+ (NSDate*) dateFromString:(NSString*)dateString{
    int year = [[dateString substringWithRange:NSMakeRange(0, 4)] intValue];
    int month = [[dateString substringWithRange:NSMakeRange(5, 2)] intValue];
    int day = [[dateString substringWithRange:NSMakeRange(8, 2)] intValue];
    NSDateComponents* comp = [[NSDateComponents alloc] init];
    comp.year = year;
    comp.month = month;
    comp.day = day;
    return [[[self calendar] dateFromComponents:comp] dateWithoutTime];
}

#pragma mark - day creation
- (NSDate*) dayNext{
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.day = 1;
    return [[[NSDate calendar] dateByAddingComponents:components toDate:self options:0] dateWithoutTime];
}
- (NSDate*) dayPrevious{
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.day = -1;
    return [[[NSDate calendar] dateByAddingComponents:components toDate:self options:0] dateWithoutTime];
}

#pragma mark - week creation
- (NSDate*) weekCurrent{
//    return [NSDate weekStart:self];
    NSDate* dt = [NSDate weekStart:self];
    if ([self compareMonth:dt] == NSOrderedDescending) {
        return self.monthCurrent;
    }
    return dt;
}
- (NSDate*) weekNext{
//    NSDateComponents* components = [[NSDateComponents alloc] init];
//    components.day = 7;
//    return [[NSDate calendar] dateByAddingComponents:components toDate:[NSDate weekStart:self] options:0];
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.day = 7;
    NSDate* dt = [[NSDate calendar] dateByAddingComponents:components toDate:[NSDate weekStart:self] options:0];
    
 /*   if ([self compareMonth:dt] == NSOrderedAscending) {
        return dt.monthCurrent;
    }
  */
     return dt;
}
- (NSDate*) weekPrevious{
//    NSDateComponents* components = [[NSDateComponents alloc] init];
//    components.day = -7;
//    return [[NSDate calendar] dateByAddingComponents:components toDate:[NSDate weekStart:self] options:0];
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.day = -7;
    NSDate* dt = [[NSDate calendar] dateByAddingComponents:components toDate:[NSDate weekStart:self] options:0];
 /*   if ([self compareMonth:dt] == NSOrderedDescending){
        if (self.dateComponents.day != 1) return self.monthCurrent;
        else return [NSDate weekStart:self];
    }
*/

    return dt;
}
+ (NSDate*) weekStart:(NSDate*) aDate{
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.day = - (aDate.dateComponents.weekday - 2);
    if (aDate.dateComponents.weekday == 1) {
        components.day = -6;
    }
    return [[[NSDate calendar] dateByAddingComponents:components toDate:aDate options:0] dateWithoutTime];
}

#pragma mark - month creation
- (NSDate*) monthCurrent{
    return [NSDate monthStart:self];
}
- (NSDate*) monthNext{
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.month = 1;
    return [[NSDate calendar] dateByAddingComponents:components toDate:[NSDate monthStart:self] options:0];
}
- (NSDate*) monthPrevious{
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.month = -1;
    return [[NSDate calendar] dateByAddingComponents:components toDate:[NSDate monthStart:self] options:0];
}
+ (NSDate*) monthStart:(NSDate*) aDate{
    NSDateComponents* comp = aDate.dateComponents;
    comp.day = 1;
    return [[[NSDate calendar] dateFromComponents:comp] dateWithoutTime];
}

#pragma mark - halfyear creation
- (NSDate*) halfYearCurrent{
    return [NSDate halfYearStart:self];
}
- (NSDate*) halfYearNext{
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.month = 6;
    return [[NSDate calendar] dateByAddingComponents:components toDate:[NSDate halfYearStart:self] options:0];
}
- (NSDate*) halfYearPrevious{
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.month = -6;
    return [[NSDate calendar] dateByAddingComponents:components toDate:[NSDate halfYearStart:self] options:0];
}
+ (NSDate*) halfYearStart:(NSDate*) aDate{
    NSDateComponents* comp = aDate.dateComponents;
    comp.month = comp.month<7 ? 1:7;
    comp.day = 1;
    return [[[NSDate calendar] dateFromComponents:comp] dateWithoutTime];
}

#pragma mark - compare
- (NSComparisonResult) compareYear:(NSDate*)dt{
    NSDateComponents* comp1 = [self dateComponents];
    NSDateComponents* comp2 = [dt dateComponents];
    if (comp1.year < comp2.year) {
        return NSOrderedAscending;
    }else if (comp1.year > comp2.year) {
        return NSOrderedDescending;
    }else{
        return NSOrderedSame;
    }
}

- (NSComparisonResult) compareMonth:(NSDate*)dt{
    NSDateComponents* comp1 = [self dateComponents];
    NSDateComponents* comp2 = [dt dateComponents];
    NSComparisonResult yearRes = [self compareYear:dt];
    if (yearRes == NSOrderedSame){
        if (comp1.month < comp2.month) {
            return NSOrderedAscending;
        }else if (comp1.month > comp2.month){
            return NSOrderedDescending;
        }else{
            return NSOrderedSame;
        }
    }else{
        return yearRes;
    }
}
- (NSComparisonResult) compareWeek:(NSDate*)dt{
    NSDateComponents* comp1 = self.weekCurrent.dateComponents;
    NSDateComponents* comp2 = dt.weekCurrent.dateComponents;
    int week1 = comp1.week;
    int week2 = comp2.week;
    if (comp1.weekday == 1) {
        week1--;
    }
    if (comp2.weekday == 1) {
        week2--;
    }
    NSComparisonResult monthRes = [self compareMonth:dt];
  //  if (monthRes == NSOrderedSame){
        if (week1 < week2) {
            return NSOrderedAscending;
        }else if (week1 > week2){
            return NSOrderedDescending;
        }else{
            return NSOrderedSame;
        }
 //   }else{
 //       return monthRes;
  //  }
}

@end
