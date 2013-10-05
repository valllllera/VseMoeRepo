//
//  Payment+EntityWorker.h
//  AllMine
//
//  Created by Allgoritm LLC on 01.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "Payment.h"

@interface Payment (EntityWorker)

+ (Payment*) insertPaymentWithUser:(User*)user
                           account:(Account*)account
                          category:(Category*)category
                 accountAsCategory:(Account*)accountAsCategory
                          currency:(Currency*)currency
                               sum:(double)sum
                           sumMain:(double)sumMain
                         rateValue:(double)rateValue
                              date:(NSDate*)date
                           comment:(NSString*)comment
                         ptemplate:(Template*)ptemplate
                          finished:(BOOL)finished
                            hidden:(BOOL)hidden
                              save:(BOOL)save;

+ (Payment*) insertPaymentWithUser:(User*)user
                           account:(Account*)account
                          category:(Category*)category
                 accountAsCategory:(Account*)accountAsCategory
                          currency:(Currency*)currency
                               sum:(double)sum
                           sumMain:(double)sumMain
                         rateValue:(double)rateValue
                              date:(NSDate*)date
                           comment:(NSString*)comment
                         ptemplate:(Template*)ptemplate
                          finished:(BOOL)finished
                            hidden:(BOOL)hidden
                              save:(BOOL)save
                           context:(NSManagedObjectContext *)context;

+ (Payment*) insertSubPaymentWithCategory:(Category*)category
                                      sum:(double)sum
                             superpayment:(Payment*)superpayment
                                     save:(BOOL)save;

+ (Payment*) insertSubPaymentWithCategory:(Category*)category
                                      sum:(double)sum
                             superpayment:(Payment*)superpayment
                                     save:(BOOL)save
                                  context:(NSManagedObjectContext *)context;

- (void) markRemovedSave:(BOOL)save;
- (void) markRemovedSave:(BOOL)save
                 context:(NSManagedObjectContext*)context;

//- (NSNumber*) idAccountTo;

-(NSSet*) subpayments;
-(NSSet*)subpaymentsContext:(NSManagedObjectContext *)context;
-(NSSet*) subpaymentsAll;

+ (NSString*)entityName;

+ (Payment*) paymentWithId:(int)idPayment
                   context:(NSManagedObjectContext*)context;

@end
