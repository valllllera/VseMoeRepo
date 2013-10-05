//
//  Payment+EntityWorker.m
//  AllMine
//
//  Created by Allgoritm LLC on 01.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "Payment+EntityWorker.h"
#import "AGDBWorker.h"
#import "Account+EntityWorker.h"
#import "Category+EntityWorker.h"

static NSString *entityName = @"Payment";

@implementation Payment (EntityWorker)

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
                              save:(BOOL)save{

    return [Payment insertPaymentWithUser:user
                                  account:account
                                 category:category
                        accountAsCategory:accountAsCategory
                                 currency:currency
                                      sum:sum
                                  sumMain:sumMain
                                rateValue:rateValue
                                     date:date
                                  comment:comment
                                ptemplate:ptemplate
                                 finished:finished
                                   hidden:hidden
                                     save:save
                                  context:[AGDBWorker sharedWorker].managedObjectContext];
}

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
                           context:(NSManagedObjectContext *)context{
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    
    Payment* payment = (Payment*)[NSEntityDescription insertNewObjectForEntityForName:entityName
                                                            inManagedObjectContext:context];
    payment.user = user;
    payment.account = account;
    payment.category = category;
    payment.currency = currency;
    payment.accountAsCategory = accountAsCategory;
    payment.sum = [NSNumber numberWithDouble:sum];
    payment.sumMain = [NSNumber numberWithDouble:sumMain];
    payment.rateValue = [NSNumber numberWithDouble:rateValue];
    payment.date = date;
    payment.comment = comment;
    payment.template = ptemplate;
    payment.finished = [NSNumber numberWithBool:finished];
    payment.hidden = [NSNumber numberWithBool:hidden];
    payment.idPayment = [NSNumber numberWithInt:-1];
    payment.modifiedDate = [NSDate date];
    payment.removed = [NSNumber numberWithBool:NO];
    
    if (save) {
        [dbw saveContext:context];
    }
    return payment;
}

+ (Payment*) insertSubPaymentWithCategory:(Category*)category
                                      sum:(double)sum
                             superpayment:(Payment*)superpayment
                                     save:(BOOL)save{
    
    return [Payment insertSubPaymentWithCategory:category
                                             sum:sum
                                    superpayment:superpayment
                                            save:save
                                         context:[AGDBWorker sharedWorker].managedObjectContext];
}

+ (Payment*) insertSubPaymentWithCategory:(Category*)category
                                      sum:(double)sum
                             superpayment:(Payment*)superpayment
                                     save:(BOOL)save
                                  context:(NSManagedObjectContext *)context{
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    
    Payment* payment = (Payment*)[NSEntityDescription insertNewObjectForEntityForName:entityName
                                                               inManagedObjectContext:context];
    payment.comment = @"";
    payment.category = category;
    payment.accountAsCategory = nil;
    payment.sum = [NSNumber numberWithDouble:sum];
    payment.finished = [NSNumber numberWithBool:NO];
    payment.superpayment = superpayment;
    payment.date = superpayment.date;
    payment.idPayment = [NSNumber numberWithInt:-1];
    payment.modifiedDate = [NSDate date];
    payment.removed = [NSNumber numberWithBool:NO];
    payment.user = superpayment.user;
    
    if (save) {
        [dbw saveContext:context];
    }
    return payment;
}

- (void) markRemovedSave:(BOOL)save{
    [self markRemovedSave:save
                  context:[AGDBWorker sharedWorker].managedObjectContext];
}
- (void) markRemovedSave:(BOOL)save
                 context:(NSManagedObjectContext *)context{
    self.removed = [NSNumber numberWithBool:YES];
    for (Payment* subp in self.subpayments) {
        subp.removed = [NSNumber numberWithBool:YES];
    }
    if (save) {
        [[AGDBWorker sharedWorker] saveContext:context];
    }
}

- (NSNumber*) idAccountTo{
    if (self.category != nil) {
        return self.category.idCategory;
    }else if (self.accountAsCategory != nil) {
        return self.accountAsCategory.idAccount;
    }else{
        return [NSNumber numberWithInt:0];
    }
}

+ (Payment*) paymentWithId:(int)idPayment
                   context:(NSManagedObjectContext*)context{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idPayment == %d", idPayment];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    Payment *payment = (Payment*) [dbw fetchManagedObjectWithEntityName:entityName
                                                              predicate:predicate
                                                        sortDescriptors:nil
                                                                context:context];
    return payment;
}

-(NSSet*)subpayments{
    return [self subpaymentsContext:[AGDBWorker sharedWorker].managedObjectContext];
}
-(NSSet*)subpaymentsContext:(NSManagedObjectContext *)context{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"superpayment == %@ AND removed == NO", self];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    NSArray* arr = [dbw fetchManagedObjectsWithEntityName:entityName
                                                predicate:predicate
                                          sortDescriptors:nil
                                                    first:0
                                                  context:context];
    return [NSSet setWithArray:arr];
}
-(NSSet *)subpaymentsAll{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"superpayment == %@", self];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    NSArray* arr = [dbw fetchManagedObjectsWithEntityName:entityName
                                                predicate:predicate
                                          sortDescriptors:nil
                                                    first:0];
    return [NSSet setWithArray:arr];
}

+ (NSString*)entityName{
    return entityName;
}

@end
