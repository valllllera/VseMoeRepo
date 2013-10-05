//
//  User+EntityWorker.m
//  AllMine
//
//  Created by Allgoritm LLC on 01.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "User+EntityWorker.h"
#import "NSDate+AGExtensions.h"
#import "AGDBWorker.h"
#import "Payment+EntityWorker.h"
#import "Account+EntityWorker.h"
#import "Template+EntityWorker.h"
#import "Currency+EntityWorker.h"
#import "Category+EntityWorker.h"
#import "NSString+AGExtensions.h"

static NSString *entityName = @"User";

@implementation User (EntityWorker)
+ (User*) insertUserWithLogin:(NSString *)login
                     password:(NSString *)password{
    AGDBWorker* dbw = [AGDBWorker sharedWorker];

    User* user = (User*)[NSEntityDescription insertNewObjectForEntityForName:entityName
                                                inManagedObjectContext:dbw.managedObjectContext];
    user.login = login;
    user.password = password;
    user.dateIn = [NSDate today];
    user.hidden = [NSNumber numberWithBool:NO];
    user.syncAuto = [NSNumber numberWithBool:NO];
    user.syncViaWiFiOnly = [NSNumber numberWithBool:YES];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user == nil"];
    user.currencyMain = [[dbw fetchManagedObjectsWithEntityName:[Currency entityName]
                                                     predicate:predicate
                                               sortDescriptors:nil
                                                         first:1] objectAtIndex:0];
    [dbw saveManagedContext];
    return user;
}

+ (User*) userWithLogin:(NSString*)login
                context:(NSManagedObjectContext*)context{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"login == %@", login];
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"login" ascending:YES]];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    User *user = (User *) [dbw fetchManagedObjectWithEntityName:entityName
                                                      predicate:predicate
                                                sortDescriptors:sortDescriptors
                                                        context:context];
    
    return user;
}

+ (User*) userWithLogin:(NSString*)login{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"login == %@", login];
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"login" ascending:YES]];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    User *user = (User *) [dbw fetchManagedObjectWithEntityName:entityName
                                                      predicate:predicate
                                                sortDescriptors:sortDescriptors];
    
    return user;
}

+ (NSArray*) usersToShow{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hidden == NO"];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    NSArray* arr = [dbw fetchManagedObjectsWithEntityName:entityName
                                                predicate:predicate
                                          sortDescriptors:nil
                                                    first:0];
    return arr;
}

+ (void) hideUsers{
    NSArray* arr = [User usersToShow];
    NSDate* dtNow = [NSDate date];
    for (User* usr in arr) {
        if ([dtNow timeIntervalSinceDate:usr.dateIn] > 5*24*60*60) {
            usr.hidden = [NSNumber numberWithBool:YES];
        }
    }
    [[AGDBWorker sharedWorker] saveManagedContext];
}

#pragma mark - currencies
- (NSArray*) currenciesMainAdditionalSorted{
    NSMutableArray* arr = [NSMutableArray array];
    [arr addObject:self.currencyMain];
    [arr addObjectsFromArray:[self.currenciesAdditional allObjects]];
    NSArray* result = [arr sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"comment" ascending:YES]]];
    return result;
}

- (NSArray*) currenciesAdditionalSorted{
    NSArray* result = [self.currenciesAdditional allObjects];
    result = [result sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"comment" ascending:YES]]];
    return result;
}

#pragma mark - templates
-(NSSet*) templates{
    return [self templatesContext:[AGDBWorker sharedWorker].managedObjectContext];
}
-(NSSet*) templatesContext:(NSManagedObjectContext*)context{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"removed == NO AND user == %@", self];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    NSArray* arr = [dbw fetchManagedObjectsWithEntityName:[Template entityName]
                                                predicate:predicate
                                          sortDescriptors:nil
                                                    first:0
                                                  context:context];
    return [NSSet setWithArray:arr];
}

-(NSSet*) templatesAll{
    return [self templatesAllContext:[AGDBWorker sharedWorker].managedObjectContext];
}
-(NSSet*) templatesAllContext:(NSManagedObjectContext*)context{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user == %@", self];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    NSArray* arr = [dbw fetchManagedObjectsWithEntityName:[Template entityName]
                                                predicate:predicate
                                          sortDescriptors:nil
                                                    first:0
                                                  context:context];
    return [NSSet setWithArray:arr];
}
-(NSSet*) templatesRemovedContext:(NSManagedObjectContext*)context{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"removed == YES AND user == %@", self];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    NSArray* arr = [dbw fetchManagedObjectsWithEntityName:[Template entityName]
                                                predicate:predicate
                                          sortDescriptors:nil
                                                    first:0
                                                  context:context];
    return [NSSet setWithArray:arr];
}

-(NSArray*) templateSortedList{
    NSArray* templates = [self.templates allObjects];
    templates = [templates sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        int first = [((Template*)a).payments count];
        int second = [((Template*)b).payments count];
        //        AGLog(@"%@ = %d", ((Template*)a).title, first);
        //        AGLog(@"%@ = %d", ((Template*)b).title, second);
        NSComparisonResult res = NSOrderedSame;
        if (first < second) {
            res = NSOrderedDescending;
        }else if (first > second){
            res = NSOrderedAscending;
        }
        return res;
    }];

    NSMutableArray* templatesExpense = [NSMutableArray array];
    NSMutableArray* templatesTransfer = [NSMutableArray array];
    NSMutableArray* templatesIncome = [NSMutableArray array];
    for (Template* tmpl in templates) {
        if(tmpl.category != nil){
            if (tmpl.category.type.intValue == CatTypeExpense) {
                [templatesExpense addObject:tmpl];
            }else{
                [templatesIncome addObject:tmpl];
            }
        }else{
            [templatesTransfer addObject:tmpl];
        }
    }
    NSMutableArray* result = [NSMutableArray array];
    [result removeAllObjects];
    [result addObjectsFromArray:templatesExpense];
    [result addObjectsFromArray:templatesTransfer];
    [result addObjectsFromArray:templatesIncome];
    return result;
}

#pragma mark - payments
-(NSSet*) paymentsNotHidden{
    NSSet* payments = self.payments;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hidden == NO", self];
    return [payments filteredSetUsingPredicate:predicate];
}

-(NSSet*) payments{
    return [self paymentsContext:[AGDBWorker sharedWorker].managedObjectContext];
}

-(NSSet*) paymentsContext:(NSManagedObjectContext*)context{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"removed == NO AND user == %@ AND superpayment == nil", self];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    NSArray* arr = [dbw fetchManagedObjectsWithEntityName:[Payment entityName]
                                                predicate:predicate
                                          sortDescriptors:nil
                                                    first:0
                                                  context:context];
    return [NSSet setWithArray:arr];
}

-(NSSet*) paymentsAll{
    return [self paymentsAllContext:[AGDBWorker sharedWorker].managedObjectContext];
}
-(NSSet*) paymentsAllContext:(NSManagedObjectContext*)context{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user == %@ AND superpayment == nil", self];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    NSArray* arr = [dbw fetchManagedObjectsWithEntityName:[Payment entityName]
                                                predicate:predicate
                                          sortDescriptors:nil
                                                    first:0
                                                  context:context];
    return [NSSet setWithArray:arr];
}

-(NSSet*) paymentsRemovedContext:(NSManagedObjectContext*)context{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"removed == YES AND user == %@", self];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    NSArray* arr = [dbw fetchManagedObjectsWithEntityName:[Payment entityName]
                                                predicate:predicate
                                          sortDescriptors:nil
                                                    first:0
                                                  context:context];
    return [NSSet setWithArray:arr];
}

-(NSArray*) paymentsNotFinishedWithAccount:(Account*)account{
    NSPredicate *predicate = nil;
    if (account == nil) {
        predicate = [NSPredicate predicateWithFormat:@"hidden == NO AND finished == NO AND removed == NO AND superpayment == nil AND user == %@", self];
    }else{
        predicate = [NSPredicate predicateWithFormat:@"hidden == NO AND finished == NO AND removed == NO AND superpayment == nil AND account == %@", account];
    }
    NSArray* sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    NSArray* payments = [dbw fetchManagedObjectsWithEntityName:[Payment entityName]
                                                     predicate:predicate
                                               sortDescriptors:sortDescriptors
                                                         first:0];
    
    return payments;
}

-(NSArray*) paymentsFinishedSortedByDateWithAccount:(Account*)account first:(int)first{
    NSPredicate *predicate = nil;
    if (account == nil) {
        predicate = [NSPredicate predicateWithFormat:@"hidden == NO AND finished == YES AND removed == NO AND superpayment == nil AND user == %@", self];
    }else{
        predicate = [NSPredicate predicateWithFormat:@"hidden == NO AND finished == YES AND removed == NO AND superpayment == nil AND account == %@", account];
    }
    NSArray* sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    NSArray* payments = [dbw fetchManagedObjectsWithEntityName:[Payment entityName]
                                                predicate:predicate
                                          sortDescriptors:sortDescriptors
                                                    first:first];
        
    payments = [payments sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [((Payment*)a).date dateWithoutTime];
        NSDate *second = [((Payment*)b).date dateWithoutTime];
//        AGLog(@"%@ = %@", [first dateTitleFull], [second dateTitleFull]);
        NSComparisonResult res = [first compare:second];
        if (res == NSOrderedAscending) {
            res = NSOrderedDescending;
        }else if (res == NSOrderedDescending){
            res = NSOrderedAscending;
        }
        return res;
    }];

    if ([payments count] == 0) {
        return [NSArray array];
    }
    NSDate* date = [((Payment*) [payments objectAtIndex:0]).date dateWithoutTime];
    NSMutableArray* result = [NSMutableArray array];
    NSMutableArray* resultForDate = [NSMutableArray array];
    for (int i = 0; i < [payments count]; i++) {
        NSDate* dt = [((Payment*) [payments objectAtIndex:i]).date dateWithoutTime];
        if ([date compare:dt] == NSOrderedSame) {
            [resultForDate addObject:[payments objectAtIndex:i]];
        }else{
            [result addObject:resultForDate];
            resultForDate = [NSMutableArray array];
            [resultForDate addObject:[payments objectAtIndex:i]];
            date = dt;
        }
    }
    [result addObject:resultForDate];
    
    return result;
}

-(void) recalculatePayments{
    for (Payment* p in self.payments) {
        p.sumMain = [NSNumber numberWithDouble:[p.sum doubleValue] * [p.currency rateValueWithDate:p.date mainCurrency:self.currencyMain]];
    }
    [[AGDBWorker sharedWorker] saveManagedContext];
}

#pragma mark - balance
-(double) balanceForCurrentMonthWithCategoryType:(int)type{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"finished == YES AND  date >= %@ AND date < %@ AND category.type == %d", [[NSDate date] monthCurrent], [[NSDate date] monthNext], type];
    NSNumber* num = [[self.payments filteredSetUsingPredicate:predicate] valueForKeyPath:@"@sum.sumMain"];
    return [num doubleValue];
}

-(double) balanceWithAccountGroup:(int)group{
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"finished == YES AND account.group == %d AND account.removed == NO", group];
//    double sum = [[[self.payments filteredSetUsingPredicate:predicate] valueForKeyPath:@"@sum.sumMain"] doubleValue];
//    predicate = [NSPredicate predicateWithFormat:@"group == %d AND removed == NO", group];
//    sum += [[[self.accounts filteredSetUsingPredicate:predicate] valueForKeyPath:@"@sum.sumMain"] doubleValue];
//    return sum;
    double sum = 0;
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"group == %d", group];
    for (Account* acc in [self.accounts filteredSetUsingPredicate:predicate]) {
        sum += acc.balance;
    }
    return sum;
}

#pragma mark - categories
- (NSArray*) categoriesRootWithType:(NSInteger)type{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"supercat == nil AND type == %d AND removed == NO AND user == %@", type, self];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    NSArray* arr = [dbw fetchManagedObjectsWithEntityName:[Category entityName]
                                                predicate:predicate
                                          sortDescriptors:nil
                                                    first:0];
    return arr;
}

-(NSSet*) categories{
    return [self categoriesContext:[AGDBWorker sharedWorker].managedObjectContext];
}

-(NSSet*) categoriesContext:(NSManagedObjectContext*)context{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"removed == NO AND user == %@", self];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    NSArray* arr = [dbw fetchManagedObjectsWithEntityName:[Category entityName]
                                                predicate:predicate
                                          sortDescriptors:nil
                                                    first:0
                                                  context:context];
    return [NSSet setWithArray:arr];
}

-(NSSet*) categoriesAll{
    return [self categoriesAllContext:[AGDBWorker sharedWorker].managedObjectContext];
}
-(NSSet*) categoriesAllContext:(NSManagedObjectContext*)context{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user == %@", self];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    NSArray* arr = [dbw fetchManagedObjectsWithEntityName:[Category entityName]
                                                predicate:predicate
                                          sortDescriptors:nil
                                                    first:0
                                                  context:context];
    return [NSSet setWithArray:arr];
}

-(NSSet*) categoriesRemovedContext:(NSManagedObjectContext*)context{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"removed == YES AND user == %@", self];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    NSArray* arr = [dbw fetchManagedObjectsWithEntityName:[Category entityName]
                                                predicate:predicate
                                          sortDescriptors:nil
                                                    first:0
                                                  context:context];
    return [NSSet setWithArray:arr];
}

#pragma mark - accounts
- (NSArray*) accountsByType:(int)type{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"removed == NO AND user == %@ AND type == %d", self, type];
    NSArray* sortDescr = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    NSArray* arr = [dbw fetchManagedObjectsWithEntityName:[Account entityName]
                                                predicate:predicate
                                          sortDescriptors:sortDescr
                                                    first:0
                                                  context:[AGDBWorker sharedWorker].managedObjectContext];
    
    return arr;
}

-(NSSet*) accounts{
    return [self accountsContext:[AGDBWorker sharedWorker].managedObjectContext];
}
-(NSSet*) accountsContext:(NSManagedObjectContext*)context{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"removed == NO AND user == %@", self];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    NSArray* arr = [dbw fetchManagedObjectsWithEntityName:[Account entityName]
                                                predicate:predicate
                                          sortDescriptors:nil
                                                    first:0
                                                  context:context];
    return [NSSet setWithArray:arr];
}

-(NSArray*) accountsSortedByTitle{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"removed == NO AND user == %@", self];
    
    NSArray* sortDescr = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    NSArray* arr = [dbw fetchManagedObjectsWithEntityName:[Account entityName]
                                                predicate:predicate
                                          sortDescriptors:sortDescr
                                                    first:0
                                                  context:[AGDBWorker sharedWorker].managedObjectContext];
    return arr;
}

-(NSSet*) accountsAll{
    return [self accountsAllContext:[AGDBWorker sharedWorker].managedObjectContext];
}
-(NSSet*) accountsAllContext:(NSManagedObjectContext*)context{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user == %@", self];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    NSArray* arr = [dbw fetchManagedObjectsWithEntityName:[Account entityName]
                                                predicate:predicate
                                          sortDescriptors:nil
                                                    first:0
                                                  context:context];
    return [NSSet setWithArray:arr];
}

-(NSSet*) accountsRemovedContext:(NSManagedObjectContext*)context{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"removed == YES AND user == %@", self];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    NSArray* arr = [dbw fetchManagedObjectsWithEntityName:[Account entityName]
                                                predicate:predicate
                                          sortDescriptors:nil
                                                    first:0
                                                  context:context];
    return [NSSet setWithArray:arr];
}

#pragma mark - report
- (NSArray*)reportWithItem:(ReportItem)item
                     typeY:(ReportTypeY)typeY
                     typeX:(ReportTypeX)typeX
                      from:(NSDate*)dtFrom
                        to:(NSDate*)dtTo
             supercategory:(Category*)supercat
                   account:(Account*)account{
    switch (typeX) {
        case ReportTypeXTime:
            return [self reportTimeWithItem:item
                                      typeY:typeY
                                       from:dtFrom
                                         to:dtTo
                                    account:account];
            break;
        case ReportTypeXCategories:
            return [self reportCategoriesWithItem:item
                                            typeY:typeY
                                    supercategory:(Category*)supercat
                                             from:dtFrom
                                               to:dtTo];
            break;
        default:
            return [self reportAccountsWithItem:item
                                          typeY:typeY
                                           from:dtFrom
                                             to:dtTo];
            break;
    }
}

#pragma mark - report accounts
- (NSArray*)reportAccountsWithItem:(ReportItem)item
                             typeY:(ReportTypeY)typeY
                              from:(NSDate*)dtFrom
                                to:(NSDate*)dtTo{
    NSMutableArray* result = [NSMutableArray array];
    for (Account* acc in self.accounts) {
        [result addObject:[self dictForReportAccount:acc sum:[acc balanceFromDate:dtFrom toDate:dtTo]]];
    }
    return result;
}


-(NSDictionary*) dictForReportAccount:(Account*)account sum:(double)sum{
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithDouble:sum] forKey:kReportFieldSum];
    [dict setObject:account forKey:kReportFieldObject];
    [dict setObject:account.title forKey:kReportFieldTitle];
    return dict;
}

#pragma mark - report categories
- (NSArray*)reportCategoriesWithItem:(ReportItem)item
                               typeY:(ReportTypeY)typeY
                       supercategory:(Category*)supercat
                                from:(NSDate*)dtFrom
                                  to:(NSDate*)dtTo{
    
    NSArray* sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"category" ascending:YES]];

    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"superpayment == nil AND removed == NO AND finished == YES AND user == %@ AND date >= %@ AND date < %@ AND category != nil AND category.type == %d", self, dtFrom, dtTo, typeY==ReportTypeYIn?CatTypeIncome:CatTypeExpense];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    reportCategoriesPayments = [dbw fetchManagedObjectsWithEntityName:[Payment entityName]
                                                predicate:predicate
                                          sortDescriptors:sortDescriptors
                                                    first:0];
    
    reportCategoriesSupercat = supercat;
    reportCategoriesResult = [NSMutableArray array];
    
    NSArray* cats = nil;
    if (supercat == nil) {
        cats = [self categoriesRootWithType:typeY == ReportTypeYIn ? CatTypeIncome : CatTypeExpense];
    }else{
        cats = [supercat.subcats allObjects];
    }
    for (Category* cat in cats) {
        [self reportCategory:cat];
    }
    reportCategoriesPayments = nil;
    NSArray* result = [NSArray arrayWithArray:reportCategoriesResult];
    reportCategoriesResult = nil;
    return result;
}

NSMutableArray* reportCategoriesResult;
NSArray* reportCategoriesPayments;
Category* reportCategoriesSupercat;

-(double) reportCategory:(Category*)category{
    double sum = 0;
    for (Payment* p in reportCategoriesPayments) {
        if (p.category == category) {
            sum += p.sumMain.doubleValue;
        }
    }
    for (Category* subcat in category.subcats) {
        sum += [self reportCategory:subcat];
    }
    if (category.supercat == reportCategoriesSupercat) {
        [reportCategoriesResult addObject:[self dictForReportCategory:category sum:sum]];
    }
    return sum;
}

-(NSDictionary*) dictForReportCategory:(Category*)category sum:(double)sum{
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithDouble:sum] forKey:kReportFieldSum];
    [dict setObject:category forKey:kReportFieldObject];
    [dict setObject:category.title forKey:kReportFieldTitle];
    return dict;
}

#pragma mark - report time
- (NSArray*)reportTimeWithItem:(ReportItem)item
                         typeY:(ReportTypeY)typeY
                          from:(NSDate*)dtFrom
                            to:(NSDate*)dtTo
                       account:(Account*)account{
    
    NSArray* sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"superpayment == nil AND removed == NO AND finished == YES AND user == %@ AND date >= %@ AND date < %@ AND accountAsCategory == nil", self, dtFrom, dtTo];
    switch (typeY) {
        case ReportTypeYIn:
            predicate = [NSPredicate predicateWithFormat:@"superpayment == nil AND removed == NO AND finished == YES AND user == %@ AND date >= %@ AND date < %@ AND category.type == %d", self, dtFrom, dtTo, CatTypeIncome];
            break;
            
        case ReportTypeYOut:
            predicate = [NSPredicate predicateWithFormat:@"superpayment == nil AND removed == NO AND finished == YES AND user == %@ AND date >= %@ AND date < %@ AND category.type == %d", self, dtFrom, dtTo, CatTypeExpense];
            break;
            
        default:
            break;
    }
    if (account) {
        predicate = [NSPredicate predicateWithFormat:@"superpayment == nil AND removed == NO AND finished == YES AND user == %@ AND date >= %@ AND date < %@ AND (account == %@ OR accountAsCategory == %@)", self, dtFrom, dtTo, account, account];
    }
    

    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    NSArray* arr = [dbw fetchManagedObjectsWithEntityName:[Payment entityName]
                                                predicate:predicate
                                          sortDescriptors:sortDescriptors
                                                    first:0];

    NSMutableArray* result = [NSMutableArray array];
//    if ((item == ReportItemWeek)&&(dtTo.dateComponents.weekday != 2)) {
//        dtTo = dtTo.weekNext;
//    }
    for(NSDate* dtLast = [self reportTimeInitDate:dtFrom reportItem:item];
            [self sameDate1:dtLast date2:dtTo reportItem:item] == NO;
            dtLast = [self reportTimeIncrementDate:dtLast reportItem:item]){
        AGLog(@"dLast %@" , dtLast);
        double sum = 0;
        for(int i = 0; i < [arr count]; i++){
            Payment* p = (Payment*)[arr objectAtIndex:i];
            NSDate* dtPayment = [p.date dateWithoutTime];
            if ([self sameDate1:dtLast date2:dtPayment reportItem:item]) {
                if (account) {
                    if (p.account == account) {
                        sum += [p.sumMain doubleValue];
                    }else if (p.accountAsCategory == account) {
                        sum -= [p.sumMain doubleValue];
                    }
                }else{
                    sum += [p.sumMain doubleValue];
                }
            }
        }
        [result addObject:[self dictForReportTimeDate:dtLast sum:sum reportItem:item]];
    }
    return result;
}

-(NSDate*) reportTimeInitDate:(NSDate*)dt reportItem:(ReportItem)item{
    switch (item) {
//        case ReportItemMonth:
//            return dt.monthCurrent;
//            break;
//        case ReportItemWeek:
//            return dt.weekCurrent;
//            break;
        default:
            return dt;
            break;
    }
}
-(NSDate*) reportTimeIncrementDate:(NSDate*)dt reportItem:(ReportItem)item{
    switch (item) {
        case ReportItemMonth:
            return dt.monthNext;
            break;
        case ReportItemWeek:
            return dt.weekNext;
            break;
        default:
            return dt.dayNext;
            break;
    }
}

-(NSDictionary*) dictForReportTimeDate:(NSDate*)date sum:(double)sum reportItem:(ReportItem)item{
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithDouble:sum] forKey:kReportFieldSum];
    [dict setObject:date forKey:kReportFieldObject];
    switch (item) {
        case ReportItemMonth:
            [dict setObject:date.monthTitleShort forKey:kReportFieldTitle];
            break;
        case ReportItemWeek:
            [dict setObject:date.weekMonthTitle forKey:kReportFieldTitle];
            break;
        default:
            [dict setObject:date.weekdayTitle forKey:kReportFieldTitle];
            break;
    }
    return dict;
}

-(BOOL) sameDate1:(NSDate*)dt1 date2:(NSDate*)dt2 reportItem:(ReportItem)item{
    switch (item) {
        case ReportItemMonth:
            return [dt1 compareMonth:dt2] == NSOrderedSame;
            break;
        case ReportItemWeek:
            return [dt1 compareWeek:dt2] == NSOrderedSame;
            break;
        default:
            return [dt1 compare:dt2] == NSOrderedSame;
            break;
    }
}

#pragma mark - standard categories and templates
- (void) addStandardData{
#warning HARDCODED STRINGS
    ////////////// ACCOUNT
    Account* acc = [Account insertAccountWithUser:self
                                 title:@"Бумажник"
                              currency:self.currencyMain
                                  date:[NSDate date]
                                 group:AccGroupAllMine
                                  type:AccTypeCash
                               comment:@""
                                  save:YES];
    
    //////////// CATEGORY INCOME
    Category* cat7 = [Category insertCategoryWithUser:self
                                                title:@"Зарплата"
                                                 type:CatTypeIncome
                                             supercat:nil
                                                 save:YES];
    Category* cat6 = [Category insertCategoryWithUser:self
                                                title:@"Аванс"
                                                 type:CatTypeIncome
                                             supercat:nil
                                                 save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Зарплата в других местах"
                                type:CatTypeIncome
                            supercat:nil
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Аванс в других местах"
                                type:CatTypeIncome
                            supercat:nil
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Премия"
                                type:CatTypeIncome
                            supercat:nil
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Бонус"
                                type:CatTypeIncome
                            supercat:nil
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Студенческий доход"
                                type:CatTypeIncome
                            supercat:nil
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Пенсионный доход"
                                type:CatTypeIncome
                            supercat:nil
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Процентный доход"
                                type:CatTypeIncome
                            supercat:nil
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Дивидендный доход"
                                type:CatTypeIncome
                            supercat:nil
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Деньги в долг"
                                type:CatTypeIncome
                            supercat:nil
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Детские дотации и пособия"
                                type:CatTypeIncome
                            supercat:nil
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Другие доходы"
                                type:CatTypeIncome
                            supercat:nil
                                save:YES];
    
    /////// CATEGORY EXPENSE
    // продукты и еда
    Category* super1 = [Category insertCategoryWithUser:self
                                                  title:@"Продукты и еда"
                                                   type:CatTypeExpense
                                               supercat:nil
                                                   save:YES];
    Category* cat1 = [Category insertCategoryWithUser:self
                                                title:@"Продукты"
                                                 type:CatTypeExpense
                                             supercat:super1
                                                 save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Алкоголь и бары"
                                type:CatTypeExpense
                            supercat:super1
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Фаст Фуд"
                                type:CatTypeExpense
                            supercat:super1
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Ресторан"
                                type:CatTypeExpense
                            supercat:super1
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Обед"
                                type:CatTypeExpense
                            supercat:super1
                                save:YES];
    // Развлечения
    Category* super2 = [Category insertCategoryWithUser:self
                                                  title:@"Развлечения"
                                                   type:CatTypeExpense
                                               supercat:nil
                                                   save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Развлечение"
                                type:CatTypeExpense
                            supercat:super2
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Искусство"
                                type:CatTypeExpense
                            supercat:super2
                                save:YES];
    Category* cat3 = [Category insertCategoryWithUser:self
                                                title:@"Кино и DVD"
                                                 type:CatTypeExpense
                                             supercat:super2
                                                 save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Музыка"
                                type:CatTypeExpense
                            supercat:super2
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Газеты и Журналы"
                                type:CatTypeExpense
                            supercat:super2
                                save:YES];
    // Авто и Транспорт
    Category* super3 = [Category insertCategoryWithUser:self
                                                  title:@"Авто и Транспорт"
                                                   type:CatTypeExpense
                                               supercat:nil
                                                   save:YES];
    Category* cat2 = [Category insertCategoryWithUser:self
                                                title:@"Общественный Транспорт"
                                                 type:CatTypeExpense
                                             supercat:super3
                                                 save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Топливо"
                                type:CatTypeExpense
                            supercat:super3
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Мойка"
                                type:CatTypeExpense
                            supercat:super3
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Парковка"
                                type:CatTypeExpense
                            supercat:super3
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Обслуживание Транспорта"
                                type:CatTypeExpense
                            supercat:super3
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Авторемонт"
                                type:CatTypeExpense
                            supercat:super3
                                save:YES];
    // Счета и Обязательные Платежи
    Category* super4 = [Category insertCategoryWithUser:self
                                                  title:@"Счета и Обязательные Платежи"
                                                   type:CatTypeExpense
                                               supercat:nil
                                                   save:YES];
    Category* cat4 = [Category insertCategoryWithUser:self
                                                title:@"Моб. Телефон"
                                                 type:CatTypeExpense
                                             supercat:super4
                                                 save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Домашний Телефон"
                                type:CatTypeExpense
                            supercat:super4
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Интернет"
                                type:CatTypeExpense
                            supercat:super4
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Коммунальное обслуживание"
                                type:CatTypeExpense
                            supercat:super4
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Электричество"
                                type:CatTypeExpense
                            supercat:super4
                                save:YES];
    // магазины
    Category* super5 = [Category insertCategoryWithUser:self
                                                  title:@"Магазины"
                                                   type:CatTypeExpense
                                               supercat:nil
                                                   save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Одежда"
                                type:CatTypeExpense
                            supercat:super5
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Книги"
                                type:CatTypeExpense
                            supercat:super5
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Электроника"
                                type:CatTypeExpense
                            supercat:super5
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Спортивные товары"
                                type:CatTypeExpense
                            supercat:super5
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Хобби"
                                type:CatTypeExpense
                            supercat:super5
                                save:YES];
    // Дети
    Category* super6 = [Category insertCategoryWithUser:self
                                                  title:@"Дети"
                                                   type:CatTypeExpense
                                               supercat:nil
                                                   save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Содержание Ребенка"
                                type:CatTypeExpense
                            supercat:super6
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Игрушки"
                                type:CatTypeExpense
                            supercat:super6
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Здоровье"
                                type:CatTypeExpense
                            supercat:super6
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Развлечение"
                                type:CatTypeExpense
                            supercat:super6
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Нянечки и сиделки"
                                type:CatTypeExpense
                            supercat:super6
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Обучения"
                                type:CatTypeExpense
                            supercat:super6
                                save:YES];
    // Обучение
    Category* super7 = [Category insertCategoryWithUser:self
                                                  title:@"Обучение"
                                                   type:CatTypeExpense
                                               supercat:nil
                                                   save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Книги"
                                type:CatTypeExpense
                            supercat:super7
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Обучение"
                                type:CatTypeExpense
                            supercat:super7
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Канцелярские товары"
                                type:CatTypeExpense
                            supercat:super7
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Студенческий Долг"
                                type:CatTypeExpense
                            supercat:super7
                                save:YES];
    // Персонально
    Category* super8 = [Category insertCategoryWithUser:self
                                                  title:@"Персонально"
                                                   type:CatTypeExpense
                                               supercat:nil
                                                   save:YES];
    Category* cat5 = [Category insertCategoryWithUser:self
                                                title:@"Стрижка"
                                                 type:CatTypeExpense
                                             supercat:super8
                                                 save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Персональный Уход"
                                type:CatTypeExpense
                            supercat:super8
                                save:YES];
    // Домашние животные
    Category* super9 = [Category insertCategoryWithUser:self
                                                  title:@"Домашние животные"
                                                   type:CatTypeExpense
                                               supercat:nil
                                                   save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Корм"
                                type:CatTypeExpense
                            supercat:super9
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Уход за животными"
                                type:CatTypeExpense
                            supercat:super9
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Ветеринар"
                                type:CatTypeExpense
                            supercat:super9
                                save:YES];
    // Дом
    Category* super10 = [Category insertCategoryWithUser:self
                                                   title:@"Дом"
                                                    type:CatTypeExpense
                                                supercat:nil
                                                    save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Мебель"
                                type:CatTypeExpense
                            supercat:super10
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Содержание Дома"
                                type:CatTypeExpense
                            supercat:super10
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Арендная Плата"
                                type:CatTypeExpense
                            supercat:super10
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Сад и Приусадебный Участок"
                                type:CatTypeExpense
                            supercat:super10
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Ремонт Дома"
                                type:CatTypeExpense
                            supercat:super10
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Текстиль"
                                type:CatTypeExpense
                            supercat:super10
                                save:YES];
    // Подарки
    Category* super11 = [Category insertCategoryWithUser:self
                                                   title:@"Подарки"
                                                    type:CatTypeExpense
                                                supercat:nil
                                                    save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Подарки"
                                type:CatTypeExpense
                            supercat:super11
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Благотворительность"
                                type:CatTypeExpense
                            supercat:super11
                                save:YES];
    // Здоровье и Спорт
    Category* super12 = [Category insertCategoryWithUser:self
                                                   title:@"Здоровье и Спорт"
                                                    type:CatTypeExpense
                                                supercat:nil
                                                    save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Доктор"
                                type:CatTypeExpense
                            supercat:super12
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Больничные Услуги"
                                type:CatTypeExpense
                            supercat:super12
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Аптека"
                                type:CatTypeExpense
                            supercat:super12
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Стоматология"
                                type:CatTypeExpense
                            supercat:super12
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Спортзал"
                                type:CatTypeExpense
                            supercat:super12
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Спорт"
                                type:CatTypeExpense
                            supercat:super12
                                save:YES];
    // Путешествия
    Category* super13 = [Category insertCategoryWithUser:self
                                                   title:@"Путешествия"
                                                    type:CatTypeExpense
                                                supercat:nil
                                                    save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Транспорт"
                                type:CatTypeExpense
                            supercat:super13
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Отель"
                                type:CatTypeExpense
                            supercat:super13
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Такси/Машина"
                                type:CatTypeExpense
                            supercat:super13
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Отпуск"
                                type:CatTypeExpense
                            supercat:super13
                                save:YES];
    // Выплаты по
    Category* super14 = [Category insertCategoryWithUser:self
                                                   title:@"Выплаты по"
                                                    type:CatTypeExpense
                                                supercat:nil
                                                    save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Обязательства и Долги"
                                type:CatTypeExpense
                            supercat:super14
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Кредитная Карта"
                                type:CatTypeExpense
                            supercat:super14
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Потребительский Кредит"
                                type:CatTypeExpense
                            supercat:super14
                                save:YES];
    // Комиссии
    Category* super15 = [Category insertCategoryWithUser:self
                                                   title:@"Комиссии"
                                                    type:CatTypeExpense
                                                supercat:nil
                                                    save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Комиссии за перевод"
                                type:CatTypeExpense
                            supercat:super15
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Комиссии за обслуживание"
                                type:CatTypeExpense
                            supercat:super15
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Комиссии за обмен валют"
                                type:CatTypeExpense
                            supercat:super15
                                save:YES];
    [Category insertCategoryWithUser:self
                               title:@"Комиссии банка"
                                type:CatTypeExpense
                            supercat:super15
                                save:YES];
    
    ///////////// TEMPLATES
    [Template insertTemplateWithUser:self
                               title:@"Продукты"
                             account:acc
                            category:cat1
                   accountAsCategory:nil
                             comment:@""
                                save:YES];
    [Template insertTemplateWithUser:self
                               title:@"Проезд"
                             account:acc
                            category:cat2
                   accountAsCategory:nil
                             comment:@""
                                save:YES];
    [Template insertTemplateWithUser:self
                               title:@"Кино"
                             account:acc
                            category:cat3
                   accountAsCategory:nil
                             comment:@""
                                save:YES];
    [Template insertTemplateWithUser:self
                               title:@"Телефон"
                             account:acc
                            category:cat4
                   accountAsCategory:nil
                             comment:@""
                                save:YES];
    [Template insertTemplateWithUser:self
                               title:@"Стрижка"
                             account:acc
                            category:cat5
                   accountAsCategory:nil
                             comment:@""
                                save:YES];
    [Template insertTemplateWithUser:self
                               title:@"Аванс"
                             account:acc
                            category:cat6
                   accountAsCategory:nil
                             comment:@""
                                save:YES];
    [Template insertTemplateWithUser:self
                               title:@"Зарплата"
                             account:acc
                            category:cat7
                   accountAsCategory:nil
                             comment:@""
                                save:YES];
    
}

- (void) resetData{
    for (Payment* item in self.payments) {
        [item markRemovedSave:NO];
    }
    for (Template* item in self.templates) {
        [item markRemovedSave:NO];
    }
    for (Account* item in self.accounts) {
        [item markRemovedSave:NO];
    }
    for (Category* item in self.categories) {
        [item markRemovedSave:NO];
    }
    [[AGDBWorker sharedWorker] saveManagedContext];
}

@end
