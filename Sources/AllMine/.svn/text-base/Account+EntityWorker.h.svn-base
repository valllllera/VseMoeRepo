//
//  Account+EntityWorker.h
//  AllMine
//
//  Created by Allgoritm LLC on 01.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "Account.h"

typedef enum{
    AccGroupAllMine = 1,
    AccGroupDebts = 2,
    AccGroupNone = 0
}AccGroup;

typedef enum{
    AccTypeCash = 0,
    AccTypeBank = 1,
    AccTypeCardCredit = 2,
    AccTypeLoan = 3,
}AccType;

@interface Account (EntityWorker)

+ (Account*) insertAccountWithUser:(User*)user
                             title:(NSString*)title
                          currency:(Currency*)currency
                              date:(NSDate*)date
                             group:(AccGroup)group
                              type:(AccType)type
                           comment:(NSString*)comment
                              save:(BOOL)save;

+ (Account*) insertAccountWithUser:(User*)user
                             title:(NSString*)title
                          currency:(Currency*)currency
                              date:(NSDate*)date
                             group:(AccGroup)group
                              type:(AccType)type
                           comment:(NSString*)comment
                              save:(BOOL)save
                           context:(NSManagedObjectContext*)context;

- (double) balance;
- (double) balanceFromDate:(NSDate*)dtFrom toDate:(NSDate*)dtTo;
- (double) balanceWithCurrency:(Currency*)currency;

- (Payment*) lastPayment;

- (void) markRemovedSave:(BOOL)save;
- (void) markRemovedSave:(BOOL)save
                 context:(NSManagedObjectContext*)context;

+ (Account*) accountWithId:(int)idAccount context:(NSManagedObjectContext*)context;

+ (NSString*)entityName;

-(NSSet*)payments;
-(NSSet*)paymentsAsCategory;

-(NSArray*) templatesSortedByTitle;

@end
