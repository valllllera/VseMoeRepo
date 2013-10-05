//
//  RequestManager.m
//  TestJSONVseMoe
//
//  Created by Alexandr Kolesnik on 27.06.13.
//  Copyright (c) 2013 Alexandr Kolesnik. All rights reserved.
//

#import "RequestManager.h"
#import "AFNetworking.h"
#import "User.h"


#import "NSString+AGExtensions.h"

#import "AGDBWorker.h"
#import "User+EntityWorker.h"
#import "Account+EntityWorker.h"
#import "Category+EntityWorker.h"
#import "Currency+EntityWorker.h"
#import "Payment+EntityWorker.h"
#import "Rate+EntityWorker.h"
#import "NSDate+AGExtensions.h"
#import "Template+EntityWorker.h"
#import "AGTools.h"

#import "AGExceptionNetworkURLConnectionFailed.h"
#import "AGExceptionSyncFailed.h"
#import "AGExceptionServerResponseBadStatus.h"
#import "AGExceptionServerResponseBadJSON.h"

#ifdef DEBUG
#define kBaseURL    @"http://dev.vsemoe.com"
#else
#define kBaseURL    @"http://api.vsemoe.com"
#endif

#define kServStatus     @"status"
#define kServData       @"data"
#define kServSync       @"sync"
#define kServToken      @"token"
#define kServModified   @"modified"
#define kServDeleted    @"deleted"
#define kServValue      @"value"
#define kServLanguage   @"lang"
#define kServLanguageEn @"en"
#define kServLanguageRu @"ru"

#define kServUserLogin          @"user"
#define kServUserPassword       @"password"
#define kServUserPasswordNew    @"newpassword"

#define kServPaymentId          @"transaction_id"
#define kServPaymentIdFrom      @"from_id"
#define kServPaymentIdTo        @"to_id"
#define kServPaymentDescription @"description"
#define kServPaymentComment     @"comment"
#define kServPaymentSplitParent @"split"
#define kServPaymentAmount      @"amount"
#define kServPaymentIdCurrency  @"currency_id"
#define kServPaymentDate        @"created"
#define kServPaymentFinished    @"finished"
#define kServPaymentHidden      @"hidden"
#define kServPaymentTemplateId  @"template_id"
#define kServPaymentIsTemplate  @"template"

#define kServCurrencyId         @"currency_id"
#define kServCurrencyCode       @"code"
#define kServCurrencyShortname  @"shortname"
#define kServCurrencyDescription @"description"
#define kServCurrencyRate       @"rate"
#define kServCurrencyRateDate   @"date"

#define kServAccountId          @"account_id"
#define kServAccountDescription @"description"
#define kServAccountParent      @"parent"
#define kServAccountCreateDate  @"createdate"
#define kServAccountComment     @"comment"
#define kServAccountIdCurrency  @"currency_id"
#define kServAccountGroup       @"group"

#define kServAccountType        @"type"
#define kServAccountTypeIn      @"IN"
#define kServAccountTypeOut     @"OUT"
#define kServAccountTypeCash    @"CASH"
#define kServAccountTypeBank    @"BANK"
#define kServAccountTypeCard    @"CARD"
#define kServAccountTypeOther   @"OTHER"

#define kServSettingsData               @"data"
#define kServSettingsSyncAuto           @"iphone_syncAuto"
#define kServSettingsSyncViaWiFIOnly    @"iphone_syncViaWiFiOnly"


@implementation RequestManager

+ (RequestManager*) sharedRequest {
    static RequestManager* _inst = nil;
    if (_inst == nil) {
        _inst = [[RequestManager alloc] init];
    }
    return _inst;
}

-(id)initWithToken:(NSString*)token
{
    self = [super init];
    if (self)
        _token = token;
    return self;
}



-(void)sendRequestWithAction:(NSString*)action
                  withParams:(NSDictionary *)params
                 withSuccess:(void (^)(id json))success
                 withFailure:(void (^)(NSError *error))failure
{
    
    NSString *apiString = kBaseURL;
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:apiString]];
    
    NSLog(@"params %@",params);
    
    NSURLRequest *request = [client requestWithMethod:@"POST" path:action parameters:params];
    
    NSLog(@"request %@",request);
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        //NSLog(@"JSON %@", JSON);
        
        if(success)
        {
            success(JSON);
        }
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        if(failure)
        {
            failure(error);
            NSLog(@"fail send request");
        }
        
    }];
    
    [operation start];    
}

#pragma mark - login

-(void)checkLoginWithUser:(User*)user
               withParams:(NSDictionary*)params
              withSuccess:(void(^)(BOOL isLoged))success
              withFailure:(void (^)(NSError *error))failure
{
    
    @try {
        if (user)
        {
            [self sendRequestWithAction:@"/user/login" withParams:@{@"user":user.login, @"password":user.password} withSuccess:^(id json) {
                if ([json objectForKey:@"status"] == [NSNumber numberWithInt:1])
                {
                    _token = [[json objectForKey:@"data"]objectForKey:@"token"];
                    success(YES);
                }
            else
                success(NO);
            } withFailure:^(NSError *error) {
                failure(error);
            }];
        }
        else
        {
            if (params)
            {
                [self sendRequestWithAction:@"/user/login" withParams:params withSuccess:^(id json) {
                    if ([json objectForKey:@"status"] == [NSNumber numberWithInt:1])
                    {
                        _token = [[json objectForKey:@"data"]objectForKey:@"token"];
                        success(YES);
                    }
                    else
                        success(NO);
                } withFailure:^(NSError *error) {
                    failure(error);
                }];
            }
        }
    }
    @catch (NSException *exception) {
        success(NO);
    }

    
}

#pragma mark - get data

-(void)getCurrencyListWithSuccess:(void(^)(id json))success
                      withFailure:(void (^)(NSError *error))failure
{
    if(!_token)
    {
        NSString *login = [[NSUserDefaults standardUserDefaults] objectForKey:kUDLastLogin];
        
        NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
        
        [self sendRequestWithAction:@"" withParams:@{@"user":login, @"password":password} withSuccess:nil withFailure:nil];
        
    }
    
    [self sendRequestWithAction:@"/currency/list" withParams:@{@"token":_token} withSuccess:^(id json) {
        success(json);
    } withFailure:nil];
}


-(void)getBankListWithSuccess:(void(^)(id json))success
                  withFailure:(void (^)(NSError *error))failure
{
    [self sendRequestWithAction:@"/bank/list" withParams:@{@"token":_token} withSuccess:^(id json) {
        success(json);
    } withFailure:^(NSError *error) {
        ;
    }];
}

-(void)getAccountListWithSuccess:(void(^)(id json))success
                     withFailure:(void (^)(NSError *error))failure
{
    [self sendRequestWithAction:@"/account/list" withParams:@{@"token":_token} withSuccess:^(id json) {
        success(json);
    } withFailure:nil];
    
}

-(void)getTransactionListWithSuccess:(void(^)(id json))success
                         withFailure:(void (^)(NSError *error))failure
{ 
    [self sendRequestWithAction:@"/transaction/list" withParams:@{@"token":_token, kServSync:@"1"} withSuccess:^(id json) {
        success(json);
    } withFailure:nil];
    
}


#pragma mark - sync

- (void) synchronizeDataForUser:(User*)usr
                    withSuccess:(void(^)(void))success
                    withFailure:(void (^)(NSError *error))failure{
   
    NSManagedObjectContext* context = [AGDBWorker sharedWorker].managedObjectContext;
    usr = (User*)[context objectWithID:usr.objectID];
    __block NSInteger counter = 0;
    
    
    void (^successBlock)(int) = ^(int count)
    {        
        if (count == 6)
        {
            [[AGDBWorker sharedWorker] saveManagedContext];
            [self settingsSendJSONWithToken:_token user:usr withSuccess:^{
                if (success)
                {
                    success();
                }
            } withFailure:nil];
        }
    };
    
    
    
    NSLog(@"start sync");
    
    //currency 100%
  [self synchCurrencyWithContext:context withUser:usr withSuccess:^{
        NSLog(@"finish currency");
        counter++;
        successBlock(counter);
    } withFailure:^(NSError *error) {
        
    } ];
    
    //category 100%
    [self synchCategoryWithContext:context withUser:usr withSuccess:^{
        NSLog(@"finish category");
        counter++;
        successBlock(counter);
    } withFailure:^(NSError *error) {
        NSLog(@"fail");
    } ];
    
    //rates 100%
    NSLog(@"start rates");
    [self synchRatesWithToken:_token withContext:context withSuccess:^{
        NSLog(@"finish rates");
        counter++;
        successBlock(counter);
    }withFailure:nil];
    ///

    //accounts
  [self synchAccountsWithToken:_token withContext:context withUser:usr withSuccess:^{
        NSLog(@"finish accounts");
        counter++;
        successBlock(counter);
    } withFailure:nil];
    

    //templates
    [self synchTemplatesWithToken:_token withContext:context withUser:usr withSuccess:^{
        NSLog(@"finish templates");
        counter++;
        successBlock(counter);
    } withFailure:nil];
    
    //payments 50%
    [self synchPaymentWithToken:_token withContext:context withUser:usr withSuccess:^{
        NSLog(@"finish payment");
        counter++;
        successBlock(counter);
    } withFailure:nil];


    //currency
    /*[self synchCurrencyWithContext:context withUser:usr withSuccess:^{
        
        NSLog(@"finish currency");
        
        [self synchRatesWithToken:_token withContext:context withSuccess:^{
            NSLog(@"finish rates");
            
            [self synchCategoryWithContext:context withUser:usr withSuccess:^{
                NSLog(@"finish category");
                
                [self synchAccountsWithToken:_token withContext:context withUser:usr withSuccess:^{
                    NSLog(@"finish accounts");
                    
                    [self synchTemplatesWithToken:_token withContext:context withUser:usr withSuccess:^{
                        NSLog(@"finish templates");
                        
                        [self synchPaymentWithToken:_token withContext:context withUser:usr withSuccess:^{
                            NSLog(@"finish payment");
                            
                            [[AGDBWorker sharedWorker] saveManagedContext];
                            [self settingsSendJSONWithToken:_token user:usr withSuccess:^{
                                if (success)
                                {
                                    success();
                                }
                            } withFailure:nil];
                            
                        } withFailure:nil];
                        
                    } withFailure:nil];

                    
                } withFailure:nil];

            } withFailure:^(NSError *error) {
                NSLog(@"fail");
            } ];
            
        }withFailure:nil];
        
    } withFailure:^(NSError *error) {
        
    } ];*/
    
    //category
    
    
    //rates

    ///
     
    //accounts
   
    
    
    //templates
    
    
    //payments
    
    
}

-(void)synchPaymentWithToken:(NSString*) token
                 withContext:(NSManagedObjectContext*)context
                    withUser:(User*)usr
                 withSuccess:(void(^)(void))success
                 withFailure:(void (^)(NSError *error))failure
{

    [self paymentListAllWithToken:_token withSuccess:^(NSArray *result) {
      __block  NSArray* servPaymentListAll = result;
        for (NSDictionary* d in servPaymentListAll) {
            Account* servAccount = [Account accountWithId:[[d objectForKey:kServPaymentIdFrom] intValue]
                                                  context:context];
            Category* servCategory = [Category categoryWithId:[[d objectForKey:kServPaymentIdTo] intValue]
                                                      context:context];
            Account* servAccountAsCategory = [Account accountWithId:[[d objectForKey:kServPaymentIdTo] intValue]
                                                            context:context];
            Currency* servCurrency = [Currency currencyWithId:[[d objectForKey:kServPaymentIdCurrency] intValue]
                                                      context:context];
            double servSum = [[d objectForKey:kServPaymentAmount] doubleValue];
            NSDate* servDate = [NSDate dateWithTimeIntervalSince1970:[[d objectForKey:kServPaymentDate] intValue]];
            NSString* servComment = [d objectForKey:kServPaymentComment];
            Template* servTmpl = [Template templateWithId:[[d objectForKey:kServPaymentTemplateId] intValue]
                                                  context:context];
            BOOL servFinished = [[d objectForKey:kServPaymentFinished] intValue] == 1;
            BOOL servHidden = [[d objectForKey:kServPaymentHidden] intValue] == 1;
            int servIdPayment = [[d objectForKey:kServPaymentId] intValue];
            
            Payment* servSuperpayment = nil;
            if([d objectForKey:kServPaymentSplitParent] != 0){
                servSuperpayment = [Payment paymentWithId:[[d objectForKey:kServPaymentSplitParent] intValue]
                                                  context:context];
            }
            
            Payment* pay = [Payment paymentWithId:servIdPayment
                                          context:context];
            if(pay == nil){
                // ------ PAYMENT - create local
                pay = [Payment insertPaymentWithUser:usr
                                             account:servAccount
                                            category:servCategory
                                   accountAsCategory:servAccountAsCategory
                                            currency:servCurrency
                                                 sum:servSum
                                             sumMain:0
                                           rateValue:0.0
                                                date:servDate
                                             comment:servComment
                                           ptemplate:servTmpl
                                            finished:servFinished
                                              hidden:servHidden
                                                save:NO
                                             context:context];
                if([pay.removed intValue] == 0)
                {
                    NSLog(@"ggg %@ %lf", pay.sum, servSum);
                }
                pay.idPayment = [NSNumber numberWithInt:servIdPayment];
                pay.superpayment = servSuperpayment;
                //                [dbw saveManagedContext];
            }else{
                for (Payment* subpay in [pay subpaymentsContext:context]) {
                    if (subpay.idPayment.intValue == -1) {
                        [self paymentCreateWithToken:_token payment:subpay withSuccess:^(NSNumber *result) {
                            subpay.idPayment = result;
                        } withFailure:nil];

                        //                        [dbw saveManagedContext];
                    }
                }
                // ------ PAYMENT - modify
                int modLocal = pay.modifiedDate.timeIntervalSince1970;
                int modRemote = [[d objectForKey:kServModified] intValue];
                if(modLocal < modRemote){
                    // ------ PAYMENT - modify local
                    pay.account = servAccount;
                    pay.category = servCategory;
                    pay.accountAsCategory = servAccountAsCategory;
                    pay.currency = servCurrency;
                    pay.sum = [NSNumber numberWithDouble:servSum];
                    pay.date = servDate;
                    pay.comment = servComment;
                    pay.template = servTmpl;
                    pay.finished = [NSNumber numberWithBool: servFinished];
                    pay.hidden = [NSNumber numberWithBool:servHidden];
                    pay.modifiedDate = [NSDate dateWithTimeIntervalSince1970:modRemote];
                    //                    [dbw saveManagedContext];
                }else if(modLocal > modRemote){
                    // ------ PAYMENT - modify remote
                    if (pay.account != servAccount) {
                        [self paymentUpdateWithToken:token
                                           idPayment:pay.idPayment
                                            property:kServPaymentIdFrom
                                            valueInt:pay.account.idAccount.intValue];
                    }
                    if (pay.category != servCategory) {
                        [self paymentUpdateWithToken:token
                                           idPayment:pay.idPayment
                                            property:kServPaymentIdTo
                                            valueInt:pay.category.idCategory.intValue];
                    }
                    if (pay.accountAsCategory != servAccountAsCategory) {
                        [self paymentUpdateWithToken:token
                                           idPayment:pay.idPayment
                                            property:kServPaymentIdTo
                                            valueInt:pay.accountAsCategory.idAccount.intValue];
                    }
                    if (pay.currency != servCurrency) {
                        [self paymentUpdateWithToken:token
                                           idPayment:pay.idPayment
                                            property:kServPaymentIdCurrency
                                            valueInt:pay.currency.idCurrency.intValue];
                    }
                    if (pay.sum.doubleValue != servSum) {
                        [self paymentUpdateWithToken:token
                                           idPayment:pay.idPayment
                                            property:kServPaymentAmount
                                         valueDouble:pay.sum.doubleValue];
                    }
                    if (pay.date.timeIntervalSince1970 != servDate.timeIntervalSince1970) {
                        [self paymentUpdateWithToken:token
                                           idPayment:pay.idPayment
                                            property:kServPaymentDate
                                            valueInt:servDate.timeIntervalSince1970];
                    }
                    if ([pay.comment isEqualToString:servComment] == NO) {
                        //                        AGLog(@"%@, %@", pay.comment, servComment);
                        [self paymentUpdateWithToken:token
                                           idPayment:pay.idPayment
                                            property:kServPaymentComment
                                               value:pay.comment];
                    }
                    if (pay.template != servTmpl) {
                        [self paymentUpdateWithToken:token
                                           idPayment:pay.idPayment
                                            property:kServPaymentTemplateId
                                            valueInt:pay.template.idTemplate.intValue];
                    }
                    if (pay.finished.boolValue != servFinished) {
                        [self paymentUpdateWithToken:token
                                           idPayment:pay.idPayment
                                            property:kServPaymentFinished
                                            valueInt:(pay.finished.boolValue == YES) ? 1 : 0];
                    }
                    if (pay.hidden.boolValue != servHidden) {
                        [self paymentUpdateWithToken:token
                                           idPayment:pay.idPayment
                                            property:kServPaymentHidden
                                            valueInt:(pay.hidden.boolValue == YES) ? 1 : 0];
                    }
                }
            }
        }
        // --- PAYMENT - create remote
        for (Payment* pay in [usr paymentsAllContext:context]) {
            if (pay.idPayment.intValue == -1) {
                NSLog(@"%@", pay.idPayment);
                [self paymentCreateWithToken:_token payment:pay withSuccess:^(NSNumber *result) {
                    pay.idPayment = result;
                    NSLog(@"%@", pay.idPayment);
                } withFailure:nil];

                //                [dbw saveManagedContext];
                for (Payment* subpay in [pay subpaymentsContext:context]) {
                    [self paymentCreateWithToken:_token payment:subpay withSuccess:^(NSNumber *result) {
                        subpay.idPayment = result;
                    } withFailure:nil];
                    //                    [dbw saveManagedContext];
                }
            }
        }
        // --- PAYMENT - remove local if remote was removed
        [self paymentListAllWithToken:_token withSuccess:^(NSArray *result) {
            servPaymentListAll = result;
            NSArray* servPaymentListDeleted = [servPaymentListAll objectsAtIndexes:[servPaymentListAll indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                //
                NSDictionary* dict = (NSDictionary*)obj;
                int deleted = [[dict objectForKey:kServDeleted] intValue];
                return deleted == 1;
            }]];
            for (NSDictionary* d in servPaymentListDeleted) {
                Payment* pay = [Payment paymentWithId:[[d objectForKey:kServPaymentId] intValue]
                                              context:context];
                if((pay != nil) && ([pay.removed boolValue] == NO)){
                    [pay markRemovedSave:NO
                                 context:context];
                }
            }
            // --- PAYMENT - remove remote if local was removed
            for (Payment* pay in [usr paymentsRemovedContext:context]) {
                NSDictionary* dict = [self dictionaryWithId:[pay.idPayment intValue]
                                                        key:kServPaymentId
                                                  fromArray:servPaymentListAll];
                if((dict != nil) && ([[dict objectForKey:kServDeleted] intValue] == 0)){
                    [self paymentDeleteWithToken:token
                                       idPayment:pay.idPayment];
                }
            }
            if (success)
                success();

        } withFailure:nil];

    } withFailure:^(NSError *error) {
        NSLog(@"fail payment");
        failure(error);
    }];
    
}

-(void)synchTemplatesWithToken:(NSString*) token
                   withContext:(NSManagedObjectContext*)context
                      withUser:(User*)usr
                   withSuccess:(void(^)(void))success
                   withFailure:(void (^)(NSError *error))failure
{
    
    [self getTransactionListWithSuccess:^(id json) {
        

        NSArray* servTemplateListAll = [json objectForKey:kServData];
        for (NSDictionary* d in servTemplateListAll ) {
            Account* servAccount = [Account accountWithId:[[d objectForKey:kServPaymentIdFrom] intValue]
                                                  context:context];
            Category* servCategory = [Category categoryWithId:[[d objectForKey:kServPaymentIdTo] intValue]
                                                      context:context];
            Account* servAccountAsCategory = [Account accountWithId:[[d objectForKey:kServPaymentIdTo] intValue]
                                                            context:context];
            NSString* servComment = [d objectForKey:kServPaymentComment];
            NSString* servTitle = [d objectForKey:kServPaymentDescription];
            int servIdTemplate = [[d objectForKey:kServPaymentId] intValue];
            
            Template* tmpl = [Template templateWithId:servIdTemplate
                                              context:context];
            if(tmpl == nil){
                // ------ TEMPLATE - create local
                tmpl = [Template insertTemplateWithUser:usr
                                                  title:servTitle
                                                account:servAccount
                                               category:servCategory
                                      accountAsCategory:servAccountAsCategory
                                                comment:servComment
                                                   save:NO
                                                context:context];
                tmpl.idTemplate = [NSNumber numberWithInt:servIdTemplate];
                //[[AGDBWorker sharedWorker]saveContext:context];
                //                [dbw saveManagedContext];
            }else{
                // ------ TEMPLATE - modify
                int modLocal = tmpl.modifiedDate.timeIntervalSince1970;
                int modRemote = [[d objectForKey:kServModified] intValue];
                if(modLocal < modRemote){
                    // ------ TEMPLATE - modify local
                    tmpl.account = servAccount;
                    tmpl.category = servCategory;
                    tmpl.accountAsCategory = servAccountAsCategory;
                    tmpl.comment = servComment;
                    tmpl.title = servTitle;
                    tmpl.modifiedDate = [NSDate dateWithTimeIntervalSince1970:modRemote];
                    //                    [dbw saveManagedContext];
                }else if(modLocal > modRemote){
                    // ------ TEMPLATE - modify remote
                    if (tmpl.account != servAccount) {
                        [self templateUpdateWithToken:token
                                           idTemplate:tmpl.idTemplate
                                             property:kServPaymentIdFrom
                                             valueInt:tmpl.account.idAccount.intValue];
                    }
                    if (tmpl.category != servCategory) {
                        [self templateUpdateWithToken:token
                                           idTemplate:tmpl.idTemplate
                                             property:kServPaymentIdTo
                                             valueInt:tmpl.category.idCategory.intValue];
                    }
                    if (tmpl.accountAsCategory != servAccountAsCategory) {
                        [self templateUpdateWithToken:token
                                           idTemplate:tmpl.idTemplate
                                             property:kServPaymentIdTo
                                             valueInt:tmpl.accountAsCategory.idAccount.intValue];
                    }
                    if ([tmpl.comment isEqualToString:servComment] == NO) {
                        [self templateUpdateWithToken:_token idTemplate:tmpl.idTemplate property:kServPaymentComment valueInt:tmpl.comment];

                    }
                    if ([tmpl.title isEqualToString:servTitle] == NO) {
                        [self templateUpdateWithToken:_token idTemplate:tmpl.idTemplate property:kServPaymentDescription valueInt:tmpl.title];
                    }
                }
            }
            //[[AGDBWorker sharedWorker]saveContext:context];
        }
        [[AGDBWorker sharedWorker]saveContext:context];
        
        __block NSInteger startCreateRemote = 0;
        __block NSInteger finishCreateRemote = 0;
        
        void (^successRemoteBlock)() = ^{
            finishCreateRemote++;
            if(finishCreateRemote >= startCreateRemote)
            {
                [[AGDBWorker sharedWorker] saveContext:context];
                // --- TEMPLATE - remove local if remote was removed
                
                [self getTransactionListWithSuccess:^(id json) {
                    NSArray* servTemplateListAll = [json objectForKey:kServData];
                    NSArray* servTemplateListDeleted = [servTemplateListAll objectsAtIndexes:[servTemplateListAll indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                        //
                        NSDictionary* dict = (NSDictionary*)obj;
                        int deleted = [[dict objectForKey:kServDeleted] intValue];
                        return deleted == 1;
                    }]];
                    for (NSDictionary* d in servTemplateListDeleted) {
                        Template* tmpl = [Template templateWithId:[[d objectForKey:kServPaymentId] intValue]
                                                          context:context];
                        if((tmpl != nil) && (tmpl.removed.boolValue == NO)){
                            tmpl.removed = [NSNumber numberWithBool:YES];
                            //                [dbw saveManagedContext];
                        }
                    }
                    //[[AGDBWorker sharedWorker]saveContext:context];
                    // --- TEMPLATE - remove remote if local was removed
                    for (Template* tmpl in [usr templatesRemovedContext:context]) {
                        NSDictionary* dict = [self dictionaryWithId:tmpl.idTemplate.intValue
                                                                key:kServPaymentId
                                                          fromArray:servTemplateListAll];
                        if((dict != nil) && ([[dict objectForKey:kServDeleted] intValue] == 0)){
                            [self templateDeleteWithToken:token
                                               idTemplate:tmpl.idTemplate];
                            
                        }
                    }
                    //[[AGDBWorker sharedWorker]saveContext:context];
                    
                    if (success)
                        success();
                    
                } withFailure:nil];
                
            }};
        
        // --- TEMPLATE - create remote
        for (Template* tmpl in [usr templatesAllContext:context]) {
            if (tmpl.idTemplate.intValue == -1) {
                startCreateRemote++;
                [self templateCreateWithToken:_token template:tmpl withSuccess:^(NSNumber *result) {
                    NSLog(@"ppp %@ %@", tmpl.title, result);
                    tmpl.idTemplate = result;
                    successRemoteBlock();
                } withFailure:nil];

                //                [dbw saveManagedContext];
            }
        }
        if(startCreateRemote == 0)
        {
            successRemoteBlock();
        }
        //[[AGDBWorker sharedWorker]saveContext:context];
        
       
    } withFailure:^(NSError *error) {
        NSLog(@"sync transcation failed");
    }];
    
       
}


-(void)synchAccountsWithToken:(NSString*) token
                  withContext:(NSManagedObjectContext*)context
                     withUser:(User*)usr
                  withSuccess:(void(^)(void))success
                  withFailure:(void (^)(NSError *error))failure
{
    [self accountListAllWithToken:_token withSuccess:^(NSArray *result) {
       __block NSArray* servAccountListAll = result;

        for (NSDictionary* d in servAccountListAll) {
            NSString* servTitle = [d objectForKey:kServAccountDescription];
            Currency* servCurrency = [Currency currencyWithId:[[d objectForKey:kServAccountIdCurrency] intValue]
                                                      context:context];
            NSDate* servDate = [NSDate dateWithTimeIntervalSince1970:[[d objectForKey:kServAccountCreateDate] intValue]];
            
            int servGroupInt = [[d objectForKey:kServAccountGroup] intValue];
            AccGroup servGroup = ((servGroupInt > -1)&&(servGroupInt < 3)) ? servGroupInt : AccGroupNone;
            
            AccType servType = AccTypeCash;
            NSString* servTypeStr = [d objectForKey:kServAccountType];
            if ([servTypeStr isEqualToString:kServAccountTypeBank]) {
                servType = AccTypeBank;
            }else if ([servTypeStr isEqualToString:kServAccountTypeCard]){
                servType = AccTypeCardCredit;
            }else if ([servTypeStr isEqualToString:kServAccountTypeOther]){
                servType = AccTypeLoan;
            }
            
            NSString* servComment = [d objectForKey:kServAccountComment];
            
            Account* acc = [Account accountWithId:[[d objectForKey:kServAccountId] intValue]
                                          context:context];
            if(acc == nil){
                // ------ ACCOUNT - create local
                acc = [Account insertAccountWithUser:usr
                                               title:servTitle
                                            currency:servCurrency
                                                date:servDate
                                               group:servGroup
                                                type:servType
                                             comment:servComment
                                                save:NO
                                             context:context];
                acc.idAccount = [NSNumber numberWithInt:[[d objectForKey:kServAccountId] intValue]];
                [[AGDBWorker sharedWorker]saveContext:context];
                //                [dbw saveManagedContext];
            }else{
                // ------ ACCOUNT - modify
                int modLocal = [acc.modifiedDate timeIntervalSince1970];
                int modRemote = [[d objectForKey:kServModified] intValue];
                if(modLocal < modRemote){
                    // ------ ACCOUNT - modify local
                    acc.title = servTitle;
                    acc.currency = servCurrency;
                    acc.dateOpen = servDate;
                    acc.group = [NSNumber numberWithInt: servGroup];
                    acc.type = [NSNumber numberWithInt: servType];
                    acc.comment = servComment;
                    acc.modifiedDate = [NSDate dateWithTimeIntervalSince1970:modRemote];
                    //                    [dbw saveManagedContext];
                }else if(modLocal > modRemote){
                    // ------ ACCOUNT - modify remote
                    if (![acc.title isEqualToString:servTitle]) {
                        [self accountUpdateWithToken:token
                                           idAccount:acc.idAccount
                                            property:kServAccountDescription
                                               value:acc.title];
                    }
                    if (acc.currency != servCurrency) {
                        [self accountUpdateWithToken:token
                                           idAccount:acc.idAccount
                                            property:kServAccountIdCurrency
                                            valueInt:acc.currency.idCurrency.intValue];
                    }
                    if ([acc.dateOpen timeIntervalSince1970] != [servDate timeIntervalSince1970]) {
                        [self accountUpdateWithToken:token
                                           idAccount:acc.idAccount
                                            property:kServAccountCreateDate
                                            valueInt:[acc.dateOpen timeIntervalSince1970]];
                    }
                    if (acc.group.intValue != servGroup) {
                        [self accountUpdateWithToken:token
                                           idAccount:acc.idAccount
                                            property:kServAccountGroup
                                            valueInt:acc.group.intValue];
                    }
                    if (acc.type.intValue != servType) {
                        NSString* typeStr = kServAccountTypeOther;
                        switch (acc.type.intValue) {
                            case AccTypeBank:
                                typeStr = kServAccountTypeBank;
                                break;
                            case AccTypeCash:
                                typeStr = kServAccountTypeCash;
                                break;
                            case AccTypeCardCredit:
                                typeStr = kServAccountTypeCard;
                                break;
                            default:
                                typeStr = kServAccountTypeOther;
                                break;
                        }
                        [self accountUpdateWithToken:token
                                           idAccount:acc.idAccount
                                            property:kServAccountType
                                               value:typeStr];
                    }
                    if (![acc.comment isEqualToString:servComment]) {
                        [self accountUpdateWithToken:token
                                           idAccount:acc.idAccount
                                            property:kServAccountComment
                                               value:acc.comment];
                    }
                }
            }
        }
        [[AGDBWorker sharedWorker]saveContext:context];
        // --- ACCOUNT - create remote
        NSLog(@"ACCOUNTSS %@",[usr accountsAllContext:context]);
        for (Account* acc in [usr accountsAllContext:context]) {
            if ([acc.idAccount intValue] == -1) {
                
                [self accountCreateWithToken:_token account:acc withSuccess:^(NSNumber *result) {
                    acc.idAccount = result;
                    NSLog(@"account id %@",acc.idAccount);
                } withFailure:^(NSError *error) {
                    NSLog(@"fail account");
                }];
                //                [dbw saveManagedContext];
            }
        }
        [[AGDBWorker sharedWorker]saveContext:context];
        // --- ACCOUNT - remove local if remote was removed
        [self accountListAllWithToken:_token withSuccess:^(NSArray *result) {
            servAccountListAll = result;
            NSArray* servAccountListDeleted = [servAccountListAll objectsAtIndexes:[servAccountListAll indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                
                NSDictionary* dict = (NSDictionary*)obj;
                int deleted = [[dict objectForKey:kServDeleted] intValue];
                return deleted == 1;
            }]];
            
            for (NSDictionary* d in servAccountListDeleted) {
                
                Account* acc = [Account accountWithId:[[d objectForKey:kServAccountId] intValue]
                                              context:context];

                if((acc != nil) && ([acc.removed boolValue] == NO)){
                    [acc markRemovedSave:NO
                                 context:context];
                }
            }
            [[AGDBWorker sharedWorker]saveContext:context];
            // --- ACCOUNT - remove remote if local was removed
            for (Account* acc in [usr accountsRemovedContext:context]) {
                NSDictionary* dict = [self dictionaryWithId:[acc.idAccount intValue]
                                                        key:kServAccountId
                                                  fromArray:servAccountListAll];
                if((dict != nil) && ([[dict objectForKey:kServDeleted] intValue] == 0)){
                    [self accountDeleteWithToken:token
                                       idAccount:acc.idAccount];
                }
            }
            [[AGDBWorker sharedWorker]saveContext:context];
            if (success)
                success();
        } withFailure:nil];

        

    } withFailure:^(NSError *error) {
        failure(error);
        NSLog(@"fail accounts");
    }];
    
}

-(void)synchRatesWithToken:(NSString*) token withContext:(NSManagedObjectContext*)context
               withSuccess:(void(^)(void))success
               withFailure:(void (^)(NSError *error))failure
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSDate* dt = nil;
    if([ud objectForKey:kUDSyncLastDate] != nil){
        dt = [ud objectForKey:kUDSyncLastDate];
    }
    [self currencyRatesWithToken:_token date:dt withSuccess:^(NSArray *result) {        
        NSArray* rates = result;
        
        
        for (NSDictionary* dict in rates) {
            Currency* crncy = [Currency currencyWithId:[[dict objectForKey:kServCurrencyId] intValue]
                                               context:context];

                
                if (crncy != nil) {
                    NSDate* date = [NSDate dateFromString:[dict objectForKey:kServCurrencyRateDate]];
                    //                AGLog(@"%@ = %@", [dict objectForKey:kServCurrencyRateDate], date);
                    double rateValue = 1.0f/[[dict objectForKey:kServCurrencyRate] doubleValue];
                    Rate* rate = [crncy rateWithDate:date];
                    if (rate == nil) {
                        [Rate insertRateWithCurrency:crncy
                                                date:date
                                               value:rateValue
                                                save:NO
                                             context:context];
                    }else{
                        rate.value = [NSNumber numberWithDouble:rateValue];
                        //                    [dbw saveManagedContext];
                    }
                }
        }
     if(success)
     {
         success();
     }
     
    } withFailure:^(NSError *error) {
       failure(error) ;
    }];
    
    
}


-(void)synchCurrencyWithContext:(NSManagedObjectContext*)context
                       withUser:(User*)usr
                    withSuccess:(void(^)(void))success
                    withFailure:(void (^)(NSError *error))failure
{
    [self getCurrencyListWithSuccess:^(id json) {

    
        for (NSDictionary *d in [json objectForKey:@"data"])
        {
           
            int servIdCurrency = [[d objectForKey:kServCurrencyId] intValue];
            NSString* servCode = [d objectForKey:kServCurrencyCode];
            NSString* servComment = [d objectForKey:kServCurrencyDescription];
            NSString* servTitle = [d objectForKey:kServCurrencyShortname];
            int servRemoved = [[d objectForKey:kServDeleted] intValue];
            int modRemote = [[d objectForKey:kServModified] intValue];
            
            Currency* cur = [Currency currencyWithId:servIdCurrency
                                             context:context];
            if(cur == nil){
                if([servCode isEqualToString:@"000"] == NO){
                    cur = [Currency currencyWithCode:servCode
                                             context:context];
                }
                if(cur == nil){
                    cur = [Currency insertCurrencyWithTitle:servTitle
                                                    comment:servComment
                                                       save:NO
                                                    context:context];
                    cur.code = servCode;
                }else{
                    AGLog(@"%@", cur);
                    cur.title = servTitle;
                    cur.comment = servComment;
                    cur.modifiedDate = [NSDate dateWithTimeIntervalSince1970:modRemote];
                    cur.removed = [NSNumber numberWithBool:servRemoved];
                    AGLog(@"%@", cur);
                }
                cur.idCurrency = [NSNumber numberWithInt:servIdCurrency];
                if ([cur.code isEqualToString:@"000"]) {
                    cur.user = usr;
                }
                //                [dbw saveManagedContext];
            }else{
                // --- CURRENCY - modify/remove local
                //                AGLog(@"%@", cur);
                //                    int modLocal = cur.modifiedDate.timeIntervalSince1970;
                //                    if(modLocal < modRemote){
                cur.title = servTitle;
                cur.comment = servComment;
                cur.modifiedDate = [NSDate dateWithTimeIntervalSince1970:modRemote];
                cur.removed = [NSNumber numberWithBool:servRemoved];
                //                    [dbw saveManagedContext];
                //                    }
            }

        }

        if (success)
            success();
     
     } withFailure:^(NSError *error) {
         NSLog(@"fail currency");
         failure(error);
     } ];
}

-(void)synchCategoryWithContext:(NSManagedObjectContext*)context
                       withUser:(User*)usr
                    withSuccess:(void(^)(void))success
                    withFailure:(void (^)(NSError *error))failure
{
    
    [self categoryListAllWithToken:_token withSuccess:^(NSArray *result) {
      
        AGDBWorker *dbw = [AGDBWorker sharedWorker];
        NSLog(@"1");
        [dbw saveContext:context];
        __block NSArray* servCategoryListAll = result;
        NSMutableArray* servCategoriesNew = [NSMutableArray array];
        NSMutableArray* userCategoriesNew = [NSMutableArray array];
        for (NSDictionary* d in servCategoryListAll) {
            Category* cat = [Category categoryWithId:[[d objectForKey:kServAccountId] intValue]
                                             context:context];
            if(cat == nil){
                NSString* servTitle = [d objectForKey:kServAccountDescription];
                CatType servType = [[d objectForKey:kServAccountType] isEqualToString:kServAccountTypeIn] ? CatTypeIncome : CatTypeExpense;
                
                cat = [Category insertCategoryWithUser:usr
                                                 title:servTitle
                                                  type:servType
                                              supercat:nil
                                                  save:NO
                                               context:context];
                cat.idCategory = [NSNumber numberWithInt:[[d objectForKey:kServAccountId] intValue]];
                //                [dbw saveManagedContext];
                [userCategoriesNew addObject:cat];
            }
        }
        NSLog(@"2");
        [dbw saveContext:context];
        
        __block NSInteger startCreateRemote = 0;
        __block NSInteger finishCreateRemote = 0;
        
        void (^successRemoteBlock)() = ^{
            finishCreateRemote++;
            if(finishCreateRemote >= startCreateRemote)
            {
                NSLog(@"3");
                [dbw saveContext:context];
                // --- CATEGORY - sync new local: supercat to remote
                [self categoryListAllWithToken:_token withSuccess:^(NSArray *result) {
                    servCategoryListAll = result;
                    for (Category* cat in servCategoriesNew) {
                        if (cat.supercat == nil) {
                            continue;
                        }
                        NSLog(@"%@",cat.supercat);
                        [self categoryUpdateWithToken:_token
                                           idCategory:cat.idCategory
                                             property:kServAccountParent
                                             valueInt:cat.supercat.idCategory.intValue];
                    }
                    NSLog(@"4");
                    [dbw saveContext:context];
                    // --- CATEGORY - sync new remote: parent to local
                    for (Category* cat in userCategoriesNew) {
                        NSDictionary* dict = [self dictionaryWithId:[cat.idCategory intValue]
                                                                key:kServAccountId
                                                          fromArray:servCategoryListAll];
                        cat.supercat = [Category categoryWithId:[[dict objectForKey:kServAccountParent] intValue]
                                                        context:context];
                        //            [[AGDBWorker sharedWorker] saveManagedContext];
                    }
                    
                    NSLog(@"5");
                    [dbw saveContext:context];
                    [self categoryListAllWithToken:_token withSuccess:^(NSArray *result) {
                        servCategoryListAll = result;
                        for (NSDictionary* d in servCategoryListAll) {
                            NSString* servTitle = [d objectForKey:kServAccountDescription];
                            CatType servType = [[d objectForKey:kServAccountType] isEqualToString:kServAccountTypeIn] ? CatTypeIncome : CatTypeExpense;
                            int servSupercatId = [[d objectForKey:kServAccountParent] intValue];
                            
                            Category* cat = [Category categoryWithId:[[d objectForKey:kServAccountId] intValue]
                                                             context:context];
                            if(cat != nil){
                                //                AGLog(@"%@", cat);
                                int modLocal = [cat.modifiedDate timeIntervalSince1970];
                                int modRemote = [[d objectForKey:kServModified] intValue];
                                if(modLocal < modRemote){
                                    // ------ CATEGORY - modify local
                                    if (servSupercatId != 0) {
                                        cat.supercat = [Category categoryWithId:servSupercatId
                                                                        context:context];
                                    }else{
                                        cat.supercat = nil;
                                    }
                                    cat.title = servTitle;
                                    cat.type = [NSNumber numberWithInt:servType];
                                    cat.modifiedDate = [NSDate dateWithTimeIntervalSince1970:modRemote];
                                    //                    [dbw saveManagedContext];
                                }else if (modLocal > modRemote){
                                    // ------ CATEGORY - modify remote
                                    if (![cat.title isEqualToString:servTitle]) {
                                        [self categoryUpdateWithToken:_token
                                                           idCategory:cat.idCategory
                                                             property:kServAccountDescription
                                                                value:cat.title];
                                    }
                                    if (cat.type.intValue != servType) {
                                        [self categoryUpdateWithToken:_token
                                                           idCategory:cat.idCategory
                                                             property:kServAccountType
                                                                value:cat.type.intValue == CatTypeIncome ? kServAccountTypeIn : kServAccountTypeOut];
                                    }
                                    if (cat.supercat.idCategory.intValue != servSupercatId) {
                                        [self categoryUpdateWithToken:_token
                                                           idCategory:cat.idCategory
                                                             property:kServAccountParent
                                                             valueInt:cat.supercat.idCategory.intValue];
                                    }
                                }
                            }
                        }
                        // --- CATEGORY - remove local if remote was removed
                        [self categoryListAllWithToken:_token withSuccess:^(NSArray *result) {
                            servCategoryListAll = result;
                            NSArray* servCategoryListDeleted = [servCategoryListAll objectsAtIndexes:[servCategoryListAll indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                                
                                NSDictionary* dict = (NSDictionary*)obj;
                                int deleted = [[dict objectForKey:kServDeleted] intValue];
                                return deleted == 1;
                            }]];
                            [dbw saveContext:context];
                            NSLog(@"some start");
                            for (NSDictionary* d in servCategoryListDeleted) {
                                
                                Category* cat = [Category categoryWithId:[[d objectForKey:kServAccountId] intValue]
                                                                 context:context];
                                //NSLog(@"%@: %@", cat.title, cat.removed);
                                if((cat != nil) && ([cat.removed boolValue] == NO)){
                                    [cat markRemovedSave:NO
                                                 context:context];
                                    //NSLog(@"%@: %@", cat.title, cat.removed);
                                }
                                
                            }
                            
                            NSLog(@"some stop");
                            [dbw saveContext:context];
                            
                            
                            [self categoryListAllWithToken:_token withSuccess:^(NSArray *result) {
                                servCategoryListAll = result;
                                for (Category* cat in [usr categoriesRemovedContext:context])
                                {
                                    NSDictionary* dict = [self dictionaryWithId:[cat.idCategory intValue]
                                                                            key:kServAccountId
                                                                      fromArray:servCategoryListAll];
                                    if((dict != nil) && ([[dict objectForKey:kServDeleted] intValue] == 0)){
                                        [self accountDeleteWithToken:_token
                                                           idAccount:cat.idCategory];
                                    }
                                }
                                [dbw saveContext:context];
                            } withFailure:nil];
                            
                            if (success)
                                success();
                            
                        } withFailure:^(NSError *error) {
                            NSLog(@"fail");
                        }];
                        
                        
                        
                    } withFailure:nil];
                    // --- CATEGORY - modify local or remote depending on modifiedDate
                    
                    // --- CATEGORY - remove remote if local was removed
                    
                } withFailure:nil];
            }
        };
        // --- CATEGORY - create remote from local
        for (Category* cat in [usr categoriesAllContext:context]) {
            if ([cat.idCategory intValue] == -1) {
                
                startCreateRemote++;
                [self categoryCreateWithToken:_token category:cat withSuccess:^(int result) {                    
                    cat.idCategory = [NSNumber numberWithInt: result];
                    [servCategoriesNew addObject:cat];
                    successRemoteBlock();
                } withFailure:^(NSError *error) {
                    successRemoteBlock();
                    NSLog(@"create category failed");
                    //failure(error);
                }];

                //                [dbw saveManagedContext];
                
            }
        }
        if(startCreateRemote == 0)
        {
            successRemoteBlock();
        }
        
        } withFailure:^(NSError *error) {
            NSLog(@"fail category");
            failure(error);
        }];
               // --- CATEGORY - sync new remote: parent to local
}

#pragma mark - payment

- (void) paymentUpdateWithToken:(NSString*)token
                      idPayment:(NSNumber*)idPayment
                       property:(NSString*)property
                    valueDouble:(double)valueDouble{
    [self paymentUpdateWithToken:token
                       idPayment:idPayment
                        property:property
                           value:[NSString stringWithFormat:@"%f", valueDouble]];
}

- (void) paymentListAllWithToken:(NSString*)token
                         withSuccess:(void(^)(NSArray* result))success
                         withFailure:(void (^)(NSError *error))failure{


        [self sendRequestWithAction:@"/transaction/list" withParams:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     token,     kServToken,
                                                                     @"1",      kServSync, nil]
                        withSuccess:^(id json) {
                            
                            NSDictionary* dict = json;
                            NSArray* result = nil;
                            result = [dict objectForKey:kServData];
                            result = [result objectsAtIndexes:[result indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                                
                                NSDictionary* dict = (NSDictionary*)obj;
                                int isTemplate = [[dict objectForKey:kServPaymentIsTemplate] intValue];
                                return isTemplate == 0;
                            }]];
                            
                            if (success)
                                success(result);
        } withFailure:^(NSError *error) {
            NSLog(@"fail payment list");
            failure(error);
        }];


}

- (void) paymentCreateWithToken:(NSString*)token
                             payment:(Payment*)payment
                         withSuccess:(void(^)(NSNumber* result))success
                         withFailure:(void (^)(NSError *error))failure{
    //    AGLog(@"%@", payment);
    NSNumber* zero = [NSNumber numberWithInt:0];
    
    NSNumber* idFrom = (payment.account != nil) ? payment.account.idAccount : zero;
    
    NSNumber* idTo = zero;
    if (payment.category != nil) {
        idTo = payment.category.idCategory;
    }else if (payment.accountAsCategory != nil) {
        idTo = payment.accountAsCategory.idAccount;
    }
    
    NSNumber* idCurrency = (payment.currency != nil) ? payment.currency.idCurrency : zero;
    NSNumber* sum = payment.sum;
    NSNumber* date = [NSNumber numberWithInt:payment.date.timeIntervalSince1970];
    NSString* comment = (payment.comment) ? payment.comment : @"";
    NSNumber* idTmpl = (payment.template != nil) ? payment.template.idTemplate : zero;
    NSNumber* finished = payment.finished;
    NSNumber* hidden = payment.hidden;
    id descript = hidden.boolValue==YES ? sum : @"";
    
        [self sendRequestWithAction:@"/transaction/create" withParams:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                       token,     kServToken,
                                                                       idFrom,    kServPaymentIdFrom,
                                                                       idTo,      kServPaymentIdTo,
                                                                       idCurrency,    kServPaymentIdCurrency,
                                                                       sum,       kServPaymentAmount,
                                                                       date,      kServPaymentDate,
                                                                       comment,   kServPaymentComment,
                                                                       idTmpl,    kServPaymentTemplateId,
                                                                       finished,  kServPaymentFinished,
                                                                       hidden,    kServPaymentHidden,
                                                                       descript,  kServPaymentDescription,
                                                                       nil] withSuccess:^(id json) {
            NSDictionary *dict = json;
            NSLog(@"dict for tansaction create %@",dict);
            int newResult  = -1;
            @try {
                newResult = [[[dict objectForKey:kServData] objectForKey:kServPaymentId] intValue];
            }
            @catch (NSException *exception) {
                newResult = -1;
            }
            @finally {
                if (newResult < 1) {
                    newResult = -1;
                }
                if (success)
                    success([NSNumber numberWithInt:newResult]);
            }

            
        } withFailure:^(NSError *error) {
            NSLog(@"fail payment create");
            failure(error);
        }];


}


#pragma mark - templates

- (void) templateDeleteWithToken:(NSString*)token
                      idTemplate:(NSNumber*)idTemplate{
    [self paymentDeleteWithToken:token
                       idPayment:idTemplate];
}

- (void) paymentDeleteWithToken:(NSString*)token
                      idPayment:(NSNumber*)idPayment{
    @try {
        [self sendRequestWithAction:@"/transaction/delete" withParams:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                      token,     kServToken,
                                                                      idPayment, kServPaymentId, nil] withSuccess:^(id json) {
            NSLog(@"payment deleted ok");
        } withFailure:^(NSError *error) {
             NSLog(@"payment deleted failed");
        }];

    }
    @catch (AGExceptionServerResponseBadJSON *exception) {
    }
    @catch (AGExceptionServerResponseBadStatus *exception) {
    }
    @finally {
    }
}

- (void) templateCreateWithToken:(NSString*)token
                             template:(Template*)tmpl
                          withSuccess:(void(^)(NSNumber* result))success
                          withFailure:(void (^)(NSError *error))failure{
    //    AGLog(@"%@", template);
    NSNumber* zero = [NSNumber numberWithInt:0];
    
    NSNumber* idFrom = (tmpl.account != nil) ? tmpl.account.idAccount : zero;
    
    NSNumber* idTo = zero;
    if (tmpl.category != nil) {
        idTo = tmpl.category.idCategory;
    }else if (tmpl.accountAsCategory != nil) {
        idTo = tmpl.accountAsCategory.idAccount;
    }
    
    NSString* comment = (tmpl.comment) ? tmpl.comment : @"";
    NSString* title = (tmpl.title) ? tmpl.title : @"";
    NSNumber* isTemplate = [NSNumber numberWithInt:1];
    
    [self sendRequestWithAction:@"/transaction/create" withParams:
     [NSDictionary dictionaryWithObjectsAndKeys:token,     kServToken,
                                                idFrom,    kServPaymentIdFrom,
                                               idTo,      kServPaymentIdTo,
                                               comment,   kServPaymentComment,
                                               title, kServPaymentDescription,
                                               isTemplate, kServPaymentIsTemplate,
                                               nil] withSuccess:^(id json) {
            int result = -1;
            NSDictionary* dict = json;
            
            @try {
                result = [[[dict objectForKey:kServData] objectForKey:kServPaymentId] intValue];
            }
            @catch (NSException *exception) {
                result = -1;
            }
            @finally {
                if (result < 1) {
                    result = -1;
                }
            }
         
         success([NSNumber numberWithInt:result]);
            
        } withFailure:^(NSError *error) {
            NSLog(@"create transaction failed");
        }];

}

- (void) templateUpdateWithToken:(NSString*)token
                      idTemplate:(NSNumber*)idTemplate
                        property:(NSString*)property
                        valueInt:(int)valueInt{
    [self paymentUpdateWithToken:token
                       idPayment:idTemplate
                        property:property
                        valueInt:valueInt];
}

- (void) paymentUpdateWithToken:(NSString*)token
                      idPayment:(NSNumber*)idPayment
                       property:(NSString*)property
                       valueInt:(int)valueInt{
    [self paymentUpdateWithToken:token
                       idPayment:idPayment
                        property:property
                           value:[NSString stringWithFormat:@"%d", valueInt]];
}

- (void) paymentUpdateWithToken:(NSString*)token
                      idPayment:(NSNumber*)idPayment
                       property:(NSString*)property
                          value:(NSString*)value{
    @try {
        [self sendRequestWithAction:[@"/transaction/update/" stringByAppendingString:property] withParams:@{kServToken:_token, kServPaymentId:idPayment, kServValue:value} withSuccess:^(id json) {

        } withFailure:^(NSError *error) {
             NSLog(@"transaction update fail");
        }];
    }

    @catch (AGExceptionServerResponseBadJSON* exception) {
    }
    @catch (AGExceptionServerResponseBadStatus* exception) {
    }
    @finally {
    }
}


#pragma mark - acount

- (void) accountCreateWithToken:(NSString*)token
                             account:(Account*)account
                         withSuccess:(void(^)(NSNumber* result))success
                         withFailure:(void (^)(NSError *error))failure{
    NSString* title = (account.title) ? account.title : @"";
    NSString* comment = (account.comment) ? account.comment : @"";
    NSNumber* dateOpen = [NSNumber numberWithInt:[account.dateOpen timeIntervalSince1970]];
    NSNumber* idCurrency = account.currency.idCurrency;
    NSNumber* idParent = [NSNumber numberWithInt:0];
    NSString* typeStr = kServAccountTypeOther;
    switch (account.type.intValue) {
        case AccTypeBank:
            typeStr = kServAccountTypeBank;
            break;
        case AccTypeCash:
            typeStr = kServAccountTypeCash;
            break;
        case AccTypeCardCredit:
            typeStr = kServAccountTypeCard;
            break;
        default:
            typeStr = kServAccountTypeOther;
            break;
    }
    NSNumber* group = account.group;
    
    
    [self sendRequestWithAction:@"/account/create" withParams:@{kServToken:_token,kServAccountDescription:title,kServAccountComment:comment,kServAccountCreateDate:dateOpen,kServAccountIdCurrency:idCurrency,kServAccountParent:idParent,kServAccountType:typeStr,kServAccountGroup:group} withSuccess:^(id json) {
        int result = -1;
        
        NSLog(@"account create %@",json);
        NSDictionary* dict = json;
        @try {
            result = [[[dict objectForKey:kServData] objectForKey:kServAccountId] intValue];
        }
        @catch (NSException *exception) {
            result = -1;
        }
        @finally {
            if (result < 1) {
                result = -1;
            }
            success ([NSNumber numberWithInt:result]);
        }

     
    } withFailure:^(NSError *error) {
        NSLog(@"fail account create");
        failure(error);
    }];

}

-(void) accountSumWithAccountID:(NSNumber*)accountID
                    withSuccess:(void(^)(NSNumber* result))success
                    withFailure:(void (^)(NSError *error))failure{
    [self sendRequestWithAction:@"/account/sum" withParams:@{@"token":_token,@"account_id":accountID} withSuccess:^(id json) {
        if ([[json objectForKey:@"data"] objectForKey:@"sum"])
        {
            if (success)
                success([[json objectForKey:@"data"] objectForKey:@"sum"]);
        }
        else
            success(0);
        
    } withFailure:nil];

    
}


- (void) accountListAllWithToken:(NSString*)token
                         withSuccess:(void(^)(NSArray* result))success
                         withFailure:(void (^)(NSError *error))failure{
    
    [self sendRequestWithAction:@"/account/list" withParams:@{kServToken:_token,kServSync:@"1"} withSuccess:^(id json) {
        NSDictionary* dict = json;

        NSArray* result = nil;
        @try {
            result = [dict objectForKey:kServData];
            result = [result objectsAtIndexes:[result indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                
                NSDictionary* dict = (NSDictionary*)obj;
                NSString* type = [dict objectForKey:kServAccountType];
                
                return !([type isEqual:kServAccountTypeIn] || [type isEqual:kServAccountTypeOut]);
            }]];
        }
        @catch (NSException *exception) {
            result = [NSArray array];
        }
        @finally {
            if (success)
                success(result);
        }


    } withFailure:^(NSError *error) {
        failure(error);
    }];
}
 

- (void) categoryUpdateWithToken:(NSString*)token idCategory:(NSNumber*)idCategory property:(NSString*)property value:(NSString*)value{
    [self accountUpdateWithToken:token
                       idAccount:idCategory
                        property:property
                           value:value];
}

- (void) accountDeleteWithToken:(NSString*)token
                      idAccount:(NSNumber*)idAccount{
    
    [self sendRequestWithAction:@"/account/delete" withParams:@{kServToken:_token,kServAccountId:idAccount} withSuccess:^(id json) {
        NSLog(@"delete account -  ok");
    } withFailure:^(NSError *error) {
        NSLog(@"delete account - no");
    }];
}

- (void) accountUpdateWithToken:(NSString*)token
                      idAccount:(NSNumber*)idAccount
                       property:(NSString*)property
                       valueInt:(int)valueInt{
    [self accountUpdateWithToken:token
                       idAccount:idAccount
                        property:property
                           value:[NSString stringWithFormat:@"%d", valueInt]];
}

- (void) accountUpdateWithToken:(NSString*)token
                      idAccount:(NSNumber*)idAccount
                       property:(NSString*)property
                          value:(NSString*)value{
   
    
    [self sendRequestWithAction:[@"/account/update/" stringByAppendingString:property] withParams:@{kServToken:_token,kServAccountId:idAccount,kServValue:value} withSuccess:^(id json) {
         NSLog(@"idACCOUNT %@",idAccount);
        NSLog(@"account update %@",json);

    } withFailure:^(NSError *error) {
    }];
  
}


#pragma mark - category


- (void) categoryCreateWithToken:(NSString*)token
                        category:(Category*)category
                     withSuccess:(void(^)(int result))success
                     withFailure:(void (^)(NSError *error))failure
{
    
    NSNumber* parentId = [NSNumber numberWithInt:0];
    if ((category.supercat != nil)&&(category.supercat.idCategory.intValue > -1))
    {
        parentId = [NSNumber numberWithInt:category.supercat.idCategory.intValue];
    }
    
      NSString* type = (category.type.intValue == CatTypeIncome) ? kServAccountTypeIn : kServAccountTypeOut;
    
    [self sendRequestWithAction:@"/account/create" withParams:@{kServToken:_token,kServAccountDescription:((category.title) ? category.title : @""),kServAccountParent:parentId,kServAccountType:type} withSuccess:^(id json)
     {
        
       
        int result = -1;
        NSDictionary *dict = json;
         NSLog(@"category create %@",json);
        @try {
            result = [[[dict objectForKey:kServData] objectForKey:kServAccountId] intValue];
        }
        @catch (NSException *exception) {
            if (result < 1) {
                result = -1;
            }
        }
        @finally {
            if (success)
                success([NSNumber numberWithInt:result]);
        }

       
    } withFailure:^(NSError *error) {
        failure(error);
    }];
}

- (void) categoryUpdateWithToken:(NSString*)token idCategory:(NSNumber*)idCategory property:(NSString*)property valueInt:(int)valueInt{
    [self accountUpdateWithToken:token
                       idAccount:idCategory
                        property:property
                        valueInt:valueInt];
}

- (void) categoryListAllWithToken:(NSString*)token
                      withSuccess:(void(^)(NSArray *result))success
                      withFailure:(void (^)(NSError *error))failure{
    
    [self sendRequestWithAction:@"/account/list" withParams:@{@"token":_token,@"sync":[NSNumber numberWithInt:1]} withSuccess:^(id json) {
        
        //NSLog(@"category list %@",json);
        
        NSDictionary* dict = nil;
        @try {
            dict = json;
            
        }
        @catch (AGExceptionServerResponseBadJSON* exception) {
            dict = [NSDictionary dictionary];
        }
        @catch (AGExceptionServerResponseBadStatus* exception) {
            dict = [NSDictionary dictionary];
        }
        @finally {
        }
        
        NSArray* result = nil;
        @try {
            result = [dict objectForKey:kServData];
            result = [result objectsAtIndexes:[result indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                
                NSDictionary* dict = (NSDictionary*)obj;
                NSString* type = [dict objectForKey:kServAccountType];
               return ([type isEqual:kServAccountTypeIn] || [type isEqual:kServAccountTypeOut]);
            }]];
        }
        @catch (NSException *exception) {
            result = [NSArray array];
            success(result);
        }
        @finally {
            success(result);
        }
        
    } withFailure:^(NSError *error) {
        failure(error);
        NSLog(@"fail category list");
    }];
       
    
}

#pragma mark - currancy

- (void) currencyRatesWithToken:(NSString*)token
                               date:(NSDate*)date
                        withSuccess:(void(^)(NSArray *result))success
                        withFailure:(void (^)(NSError *error))failure{
    NSLog(@"rate start");
  
    if (date == nil)
    {
        [self sendRequestWithAction:@"/currency/rate" withParams:@{@"token":_token} withSuccess:^(id json) {
            NSArray* arr = nil;
            NSDictionary* dict = nil;
             dict = json;
            @try {
                arr = [dict objectForKey:kServData];
            }
            @catch (NSException *exception) {
                arr = [NSArray array];
            }
            
         @finally {
             if (success)
                 success(arr);
         }
        } withFailure:^(NSError *error) {
            ;
        }];
    
    }
    else
    {
        [self sendRequestWithAction:@"/currency/rate" withParams:@{@"token":_token,kServCurrencyRateDate:[date dateStringJson]} withSuccess:^(id json) {
            NSDictionary* dict = nil;
              NSArray* arr = nil;
            dict = json;
            @try {
                arr = [dict objectForKey:kServData];
            }
            @catch (NSException *exception) {
                arr = [NSArray array];
            }
            @finally {
                if (success)
                    success(arr);
            }

        } withFailure:^(NSError *error) {
            ;
        }];
    }
    NSLog(@"rate finis");
}

#pragma mark - json

-(void) settingsSendJSONWithToken:(NSString*)token
                             user:(User*)usr
                      withSuccess:(void(^)(void))success
                      withFailure:(void (^)(NSError *error))failure{
     NSString* dataJSON = [NSString stringWithFormat:@"{\"%@\" : %d, \"%@\" : %d}", kServSettingsSyncAuto, usr.syncAuto.boolValue==YES ? 1:0, kServSettingsSyncViaWiFIOnly, usr.syncViaWiFiOnly.boolValue==YES ? 1:0];
    [self sendRequestWithAction:@"/settings/setjson" withParams:@{kServToken:_token,kServSettingsData:dataJSON} withSuccess:^(id json) {
        success();
    } withFailure:^(NSError *error) {
        failure(error);
    }];

}

#pragma mark - dictionary search
- (NSDictionary*) dictionaryWithId:(int)objectId key:(NSString*)key fromArray:(NSArray*)arr {
    NSDictionary* dict = nil;
    NSArray* arrTmp = [arr objectsAtIndexes:[arr indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary* d = (NSDictionary*)obj;
        //                    AGLog(@"%d = %d", acc.idAccount.intValue, [[d objectForKey:@"id"] intValue]);
        return [[d objectForKey:key] intValue] == objectId;
    }]];
    if([arrTmp count] > 0){
        dict = [arrTmp objectAtIndex:0];
        //        AGLog(@"%d", [[dict objectForKey:key] intValue]);
    }
    return dict;
}


#pragma mark - test


-(void)synchCurrencyWithContext:(NSManagedObjectContext*)context
                       withUser:(User*)usr
{
    [self getCurrencyListWithSuccess:^(id json) {
        
        for (NSDictionary *d in [json objectForKey:@"data"])
        {
            int servIdCurrency = [[d objectForKey:@"currency_id"] intValue];
            NSString* servCode = [d objectForKey:@"code"];
            NSString* servComment = [d objectForKey:@"description"];
            NSString* servTitle = [d objectForKey:@"shortname"];
            int servRemoved = [[d objectForKey:@"deleted"] intValue];
            int modRemote = [[d objectForKey:@"modified"] intValue];
            
            
            Currency* cur = [Currency currencyWithId:servIdCurrency
                                             context:context];
            if(cur == nil){
                if([servCode isEqualToString:@"000"] == NO){
                    cur = [Currency currencyWithCode:servCode
                                             context:context];
                }
                if(cur == nil){
                    cur = [Currency insertCurrencyWithTitle:servTitle
                                                    comment:servComment
                                                       save:NO
                                                    context:context];
                    cur.code = servCode;
                }else{
                    AGLog(@"%@", cur);
                    cur.title = servTitle;
                    cur.comment = servComment;
                    cur.modifiedDate = [NSDate dateWithTimeIntervalSince1970:modRemote];
                    cur.removed = [NSNumber numberWithBool:servRemoved];
                    AGLog(@"%@", cur);
                }
                cur.idCurrency = [NSNumber numberWithInt:servIdCurrency];
                if ([cur.code isEqualToString:@"000"]) {
                    cur.user = usr;
                }
                //                [dbw saveManagedContext];
            }else{
                // --- CURRENCY - modify/remove local
                //                AGLog(@"%@", cur);
                //                    int modLocal = cur.modifiedDate.timeIntervalSince1970;
                //                    if(modLocal < modRemote){
                cur.title = servTitle;
                cur.comment = servComment;
                cur.modifiedDate = [NSDate dateWithTimeIntervalSince1970:modRemote];
                cur.removed = [NSNumber numberWithBool:servRemoved];
                //                    [dbw saveManagedContext];
                //                    }
            }
        }

        NSLog(@"currency finished");
    } withFailure:^(NSError *error) {
        NSLog(@"fail currency");
    } ];

}

-(void)synchRatesWithToken:(NSString*) token withContext:(NSManagedObjectContext*)context
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSDate* dt = nil;
    if([ud objectForKey:kUDSyncLastDate] != nil){
        dt = [ud objectForKey:kUDSyncLastDate];
    }
    [self currencyRatesWithToken:_token date:dt withSuccess:^(NSArray *result) {
        NSArray* rates = result;
        
        
        for (NSDictionary* dict in rates) {
            Currency* crncy = [Currency currencyWithId:[[dict objectForKey:kServCurrencyId] intValue]
                                               context:context];
            
            
            if (crncy != nil) {
                NSDate* date = [NSDate dateFromString:[dict objectForKey:kServCurrencyRateDate]];
                //                AGLog(@"%@ = %@", [dict objectForKey:kServCurrencyRateDate], date);
                double rateValue = 1.0f/[[dict objectForKey:kServCurrencyRate] doubleValue];
                Rate* rate = [crncy rateWithDate:date];
                if (rate == nil) {
                    [Rate insertRateWithCurrency:crncy
                                            date:date
                                           value:rateValue
                                            save:NO
                                         context:context];
                }else{
                    rate.value = [NSNumber numberWithDouble:rateValue];
                    //                    [dbw saveManagedContext];
                }
            }
        }
        NSLog(@"rates finished");
    } withFailure:^(NSError *error) {
    }];

}

-(void)synchCategoryWithContext:(NSManagedObjectContext*)context
                       withUser:(User*)usr
{
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    
    [self categoryListAllWithToken:_token withSuccess:^(NSArray *result) {
        
        NSLog(@"1");
        
        NSArray* servCategoryListAll = result;
        NSMutableArray* servCategoriesNew = [NSMutableArray array];
        NSMutableArray* userCategoriesNew = [NSMutableArray array];
        for (NSDictionary* d in servCategoryListAll) {
            Category* cat = [Category categoryWithId:[[d objectForKey:kServAccountId] intValue]
                                             context:context];
            if(cat == nil){
                NSString* servTitle = [d objectForKey:kServAccountDescription];
                CatType servType = [[d objectForKey:kServAccountType] isEqualToString:kServAccountTypeIn] ? CatTypeIncome : CatTypeExpense;
                
                cat = [Category insertCategoryWithUser:usr
                                                 title:servTitle
                                                  type:servType
                                              supercat:nil
                                                  save:NO
                                               context:context];
                cat.idCategory = [NSNumber numberWithInt:[[d objectForKey:kServAccountId] intValue]];
                //                [dbw saveManagedContext];
                [userCategoriesNew addObject:cat];
            }
        }
        NSLog(@"2");
        
        [dbw saveContext:context];
        
        // --- CATEGORY - create remote from local
        for (Category* cat in [usr categoriesAllContext:context]) {
            if ([cat.idCategory intValue] == -1) {
                
                [self categoryCreateWithToken:_token category:cat withSuccess:^(int result) {
                    cat.idCategory = [NSNumber numberWithInt: result];
                    [servCategoriesNew addObject:cat];
                } withFailure:^(NSError *error) {
                    NSLog(@"create category failed");

                }];
                
                //                [dbw saveManagedContext];
                
            }
        }
        NSLog(@"3");
        // --- CATEGORY - sync new local: supercat to remote
        for (Category* cat in servCategoriesNew) {
            if (cat.supercat == nil) {
                continue;
            }
            NSLog(@"%@",cat.supercat);
            [self categoryUpdateWithToken:_token
                               idCategory:cat.idCategory
                                 property:kServAccountParent
                                 valueInt:cat.supercat.idCategory.intValue];
        }
        [dbw saveContext:context];
        NSLog(@"4");
        // --- CATEGORY - sync new remote: parent to local
        for (Category* cat in userCategoriesNew) {
            NSDictionary* dict = [self dictionaryWithId:[cat.idCategory intValue]
                                                    key:kServAccountId
                                              fromArray:servCategoryListAll];
            cat.supercat = [Category categoryWithId:[[dict objectForKey:kServAccountParent] intValue]
                                            context:context];
            //            [[AGDBWorker sharedWorker] saveManagedContext];
        }
        [dbw saveContext:context];
        NSLog(@"5");
        // --- CATEGORY - modify local or remote depending on modifiedDate
        for (NSDictionary* d in servCategoryListAll) {
            NSString* servTitle = [d objectForKey:kServAccountDescription];
            CatType servType = [[d objectForKey:kServAccountType] isEqualToString:kServAccountTypeIn] ? CatTypeIncome : CatTypeExpense;
            int servSupercatId = [[d objectForKey:kServAccountParent] intValue];
            
            Category* cat = [Category categoryWithId:[[d objectForKey:kServAccountId] intValue]
                                             context:context];
            if(cat != nil){
                //                AGLog(@"%@", cat);
                int modLocal = [cat.modifiedDate timeIntervalSince1970];
                int modRemote = [[d objectForKey:kServModified] intValue];
                if(modLocal < modRemote){
                    // ------ CATEGORY - modify local
                    if (servSupercatId != 0) {
                        cat.supercat = [Category categoryWithId:servSupercatId
                                                        context:context];
                    }else{
                        cat.supercat = nil;
                    }
                    cat.title = servTitle;
                    cat.type = [NSNumber numberWithInt:servType];
                    cat.modifiedDate = [NSDate dateWithTimeIntervalSince1970:modRemote];
                    //                    [dbw saveManagedContext];
                }else if (modLocal > modRemote){
                    // ------ CATEGORY - modify remote
                    if (![cat.title isEqualToString:servTitle]) {
                        [self categoryUpdateWithToken:_token
                                           idCategory:cat.idCategory
                                             property:kServAccountDescription
                                                value:cat.title];
                    }
                    if (cat.type.intValue != servType) {
                        [self categoryUpdateWithToken:_token
                                           idCategory:cat.idCategory
                                             property:kServAccountType
                                                value:cat.type.intValue == CatTypeIncome ? kServAccountTypeIn : kServAccountTypeOut];
                    }
                    if (cat.supercat.idCategory.intValue != servSupercatId) {
                        [self categoryUpdateWithToken:_token
                                           idCategory:cat.idCategory
                                             property:kServAccountParent
                                             valueInt:cat.supercat.idCategory.intValue];
                    }
                }
            }
        }
        // --- CATEGORY - remove local if remote was removed
        NSArray* servCategoryListDeleted = [servCategoryListAll objectsAtIndexes:[servCategoryListAll indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            
            NSDictionary* dict = (NSDictionary*)obj;
            int deleted = [[dict objectForKey:kServDeleted] intValue];
            return deleted == 1;
        }]];
        [dbw saveContext:context];
        
        NSLog(@"some start");
        for (NSDictionary* d in servCategoryListDeleted) {
            
            Category* cat = [Category categoryWithId:[[d objectForKey:kServAccountId] intValue]
                                             context:context];
            //NSLog(@"%@: %@", cat.title, cat.removed);
            if((cat != nil) && ([cat.removed boolValue] == NO)){
                [cat markRemovedSave:NO
                             context:context];
                //NSLog(@"%@: %@", cat.title, cat.removed);
            }
            
        }
        
        NSLog(@"some stop");
        [dbw saveContext:context];
        
        // --- CATEGORY - remove remote if local was removed
        for (Category* cat in [usr categoriesRemovedContext:context])
        {
            NSDictionary* dict = [self dictionaryWithId:[cat.idCategory intValue]
                                                    key:kServAccountId
                                              fromArray:servCategoryListAll];
            if((dict != nil) && ([[dict objectForKey:kServDeleted] intValue] == 0)){
                [self accountDeleteWithToken:_token
                                   idAccount:cat.idCategory];
            }
        }
        [dbw saveContext:context];
        
    } withFailure:^(NSError *error) {
        NSLog(@"fail category");

    }];

}

-(void)synchAccountsWithToken:(NSString*) token
                  withContext:(NSManagedObjectContext*)context
                     withUser:(User*)usr
{
    [self accountListAllWithToken:_token withSuccess:^(NSArray *result) {
        NSArray* servAccountListAll = result;
        for (NSDictionary* d in servAccountListAll) {
            NSString* servTitle = [d objectForKey:kServAccountDescription];
            Currency* servCurrency = [Currency currencyWithId:[[d objectForKey:kServAccountIdCurrency] intValue]
                                                      context:context];
            NSDate* servDate = [NSDate dateWithTimeIntervalSince1970:[[d objectForKey:kServAccountCreateDate] intValue]];
            
            int servGroupInt = [[d objectForKey:kServAccountGroup] intValue];
            AccGroup servGroup = ((servGroupInt > -1)&&(servGroupInt < 3)) ? servGroupInt : AccGroupNone;
            
            AccType servType = AccTypeCash;
            NSString* servTypeStr = [d objectForKey:kServAccountType];
            if ([servTypeStr isEqualToString:kServAccountTypeBank]) {
                servType = AccTypeBank;
            }else if ([servTypeStr isEqualToString:kServAccountTypeCard]){
                servType = AccTypeCardCredit;
            }else if ([servTypeStr isEqualToString:kServAccountTypeOther]){
                servType = AccTypeLoan;
            }
            
            NSString* servComment = [d objectForKey:kServAccountComment];
            
            Account* acc = [Account accountWithId:[[d objectForKey:kServAccountId] intValue]
                                          context:context];
            if(acc == nil){
                // ------ ACCOUNT - create local
                acc = [Account insertAccountWithUser:usr
                                               title:servTitle
                                            currency:servCurrency
                                                date:servDate
                                               group:servGroup
                                                type:servType
                                             comment:servComment
                                                save:NO
                                             context:context];
                acc.idAccount = [NSNumber numberWithInt:[[d objectForKey:kServAccountId] intValue]];
                //                [dbw saveManagedContext];
            }else{
                // ------ ACCOUNT - modify
                int modLocal = [acc.modifiedDate timeIntervalSince1970];
                int modRemote = [[d objectForKey:kServModified] intValue];
                if(modLocal < modRemote){
                    // ------ ACCOUNT - modify local
                    acc.title = servTitle;
                    acc.currency = servCurrency;
                    acc.dateOpen = servDate;
                    acc.group = [NSNumber numberWithInt: servGroup];
                    acc.type = [NSNumber numberWithInt: servType];
                    acc.comment = servComment;
                    acc.modifiedDate = [NSDate dateWithTimeIntervalSince1970:modRemote];
                    //                    [dbw saveManagedContext];
                }else if(modLocal > modRemote){
                    // ------ ACCOUNT - modify remote
                    if (![acc.title isEqualToString:servTitle]) {
                        [self accountUpdateWithToken:token
                                           idAccount:acc.idAccount
                                            property:kServAccountDescription
                                               value:acc.title];
                    }
                    if (acc.currency != servCurrency) {
                        [self accountUpdateWithToken:token
                                           idAccount:acc.idAccount
                                            property:kServAccountIdCurrency
                                            valueInt:acc.currency.idCurrency.intValue];
                    }
                    if ([acc.dateOpen timeIntervalSince1970] != [servDate timeIntervalSince1970]) {
                        [self accountUpdateWithToken:token
                                           idAccount:acc.idAccount
                                            property:kServAccountCreateDate
                                            valueInt:[acc.dateOpen timeIntervalSince1970]];
                    }
                    if (acc.group.intValue != servGroup) {
                        [self accountUpdateWithToken:token
                                           idAccount:acc.idAccount
                                            property:kServAccountGroup
                                            valueInt:acc.group.intValue];
                    }
                    if (acc.type.intValue != servType) {
                        NSString* typeStr = kServAccountTypeOther;
                        switch (acc.type.intValue) {
                            case AccTypeBank:
                                typeStr = kServAccountTypeBank;
                                break;
                            case AccTypeCash:
                                typeStr = kServAccountTypeCash;
                                break;
                            case AccTypeCardCredit:
                                typeStr = kServAccountTypeCard;
                                break;
                            default:
                                typeStr = kServAccountTypeOther;
                                break;
                        }
                        [self accountUpdateWithToken:token
                                           idAccount:acc.idAccount
                                            property:kServAccountType
                                               value:typeStr];
                    }
                    if (![acc.comment isEqualToString:servComment]) {
                        [self accountUpdateWithToken:token
                                           idAccount:acc.idAccount
                                            property:kServAccountComment
                                               value:acc.comment];
                    }
                }
            }
        }
        // --- ACCOUNT - create remote
        NSLog(@"ACCOUNTS %@",[usr accountsAllContext:context]);
        for (Account* acc in [usr accountsAllContext:context]) {
            if ([acc.idAccount intValue] == -1) {
                
                [self accountCreateWithToken:_token account:acc withSuccess:^(NSNumber *result) {
                    acc.idAccount = result;
                } withFailure:^(NSError *error) {
                    NSLog(@"fail account");
                }];
                //                [dbw saveManagedContext];
            }
        }
        // --- ACCOUNT - remove local if remote was removed
        
        NSArray* servAccountListDeleted = [servAccountListAll objectsAtIndexes:[servAccountListAll indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            
            NSDictionary* dict = (NSDictionary*)obj;
            int deleted = [[dict objectForKey:kServDeleted] intValue];
            return deleted == 1;
        }]];
        for (NSDictionary* d in servAccountListDeleted) {
            Account* acc = [Account accountWithId:[[d objectForKey:kServAccountId] intValue]
                                          context:context];
            if((acc != nil) && ([acc.removed boolValue] == NO)){
                [acc markRemovedSave:NO
                             context:context];
            }
        }
        // --- ACCOUNT - remove remote if local was removed
        for (Account* acc in [usr accountsRemovedContext:context]) {
            NSDictionary* dict = [self dictionaryWithId:[acc.idAccount intValue]
                                                    key:kServAccountId
                                              fromArray:servAccountListAll];
            if((dict != nil) && ([[dict objectForKey:kServDeleted] intValue] == 0)){
                [self accountDeleteWithToken:token
                                   idAccount:acc.idAccount];
            }
        }
        
        NSLog(@"account finised");
    } withFailure:^(NSError *error) {

    }];

}

-(void)synchTemplatesWithToken:(NSString*) token
                   withContext:(NSManagedObjectContext*)context
                      withUser:(User*)usr
{
    [self getTransactionListWithSuccess:^(id json) {
        
        NSArray* servTemplateListAll = [json objectForKey:@"data"];
        for (NSDictionary* d in servTemplateListAll ) {
            Account* servAccount = [Account accountWithId:[[d objectForKey:kServPaymentIdFrom] intValue]
                                                  context:context];
            Category* servCategory = [Category categoryWithId:[[d objectForKey:kServPaymentIdTo] intValue]
                                                      context:context];
            Account* servAccountAsCategory = [Account accountWithId:[[d objectForKey:kServPaymentIdTo] intValue]
                                                            context:context];
            NSString* servComment = [d objectForKey:kServPaymentComment];
            NSString* servTitle = [d objectForKey:kServPaymentDescription];
            int servIdTemplate = [[d objectForKey:kServPaymentId] intValue];
            
            Template* tmpl = [Template templateWithId:servIdTemplate
                                              context:context];
            if(tmpl == nil){
                // ------ TEMPLATE - create local
                tmpl = [Template insertTemplateWithUser:usr
                                                  title:servTitle
                                                account:servAccount
                                               category:servCategory
                                      accountAsCategory:servAccountAsCategory
                                                comment:servComment
                                                   save:NO
                                                context:context];
                tmpl.idTemplate = [NSNumber numberWithInt:servIdTemplate];
                //                [dbw saveManagedContext];
            }else{
                // ------ TEMPLATE - modify
                int modLocal = tmpl.modifiedDate.timeIntervalSince1970;
                int modRemote = [[d objectForKey:kServModified] intValue];
                if(modLocal < modRemote){
                    // ------ TEMPLATE - modify local
                    tmpl.account = servAccount;
                    tmpl.category = servCategory;
                    tmpl.accountAsCategory = servAccountAsCategory;
                    tmpl.comment = servComment;
                    tmpl.title = servTitle;
                    tmpl.modifiedDate = [NSDate dateWithTimeIntervalSince1970:modRemote];
                    //                    [dbw saveManagedContext];
                }else if(modLocal > modRemote){
                    // ------ TEMPLATE - modify remote
                    if (tmpl.account != servAccount) {
                        [self templateUpdateWithToken:token
                                           idTemplate:tmpl.idTemplate
                                             property:kServPaymentIdFrom
                                             valueInt:tmpl.account.idAccount.intValue];
                    }
                    if (tmpl.category != servCategory) {
                        [self templateUpdateWithToken:token
                                           idTemplate:tmpl.idTemplate
                                             property:kServPaymentIdTo
                                             valueInt:tmpl.category.idCategory.intValue];
                    }
                    if (tmpl.accountAsCategory != servAccountAsCategory) {
                        [self templateUpdateWithToken:token
                                           idTemplate:tmpl.idTemplate
                                             property:kServPaymentIdTo
                                             valueInt:tmpl.accountAsCategory.idAccount.intValue];
                    }
                    if ([tmpl.comment isEqualToString:servComment] == NO) {
                        [self templateUpdateWithToken:_token idTemplate:tmpl.idTemplate property:kServPaymentComment valueInt:tmpl.comment];
                        
                    }
                    if ([tmpl.title isEqualToString:servTitle] == NO) {
                        [self templateUpdateWithToken:_token idTemplate:tmpl.idTemplate property:kServPaymentDescription valueInt:tmpl.title];
                    }
                }
            }
        }
        // --- TEMPLATE - create remote
        for (Template* tmpl in [usr templatesAllContext:context]) {
            if (tmpl.idTemplate.intValue == -1) {
                [self templateCreateWithToken:_token template:tmpl withSuccess:^(NSNumber *result) {
                    tmpl.idTemplate = result;
                } withFailure:nil];

                //                [dbw saveManagedContext];
            }
        }
        // --- TEMPLATE - remove local if remote was removed
        
        NSArray* servTemplateListDeleted = [servTemplateListAll objectsAtIndexes:[servTemplateListAll indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            //
            NSDictionary* dict = (NSDictionary*)obj;
            int deleted = [[dict objectForKey:kServDeleted] intValue];
            return deleted == 1;
        }]];
        for (NSDictionary* d in servTemplateListDeleted) {
            Template* tmpl = [Template templateWithId:[[d objectForKey:kServPaymentId] intValue]
                                              context:context];
            if((tmpl != nil) && (tmpl.removed.boolValue == NO)){
                tmpl.removed = [NSNumber numberWithBool:YES];
                //                [dbw saveManagedContext];
            }
        }
        // --- TEMPLATE - remove remote if local was removed
        for (Template* tmpl in [usr templatesRemovedContext:context]) {
            NSDictionary* dict = [self dictionaryWithId:tmpl.idTemplate.intValue
                                                    key:kServPaymentId
                                              fromArray:servTemplateListAll];
            if((dict != nil) && ([[dict objectForKey:kServDeleted] intValue] == 0)){
                [self templateDeleteWithToken:token
                                   idTemplate:tmpl.idTemplate];
                
            }
        }
        
        NSLog(@"templates finised");
        
    } withFailure:^(NSError *error) {
        NSLog(@"sync transcation failed");
    }];
    

}

-(void)synchPaymentWithToken:(NSString*) token
                 withContext:(NSManagedObjectContext*)context
                    withUser:(User*)usr
{
    [self paymentListAllWithToken:_token withSuccess:^(NSArray *result) {
        NSArray* servPaymentListAll = result;
        for (NSDictionary* d in servPaymentListAll) {
            Account* servAccount = [Account accountWithId:[[d objectForKey:kServPaymentIdFrom] intValue]
                                                  context:context];
            Category* servCategory = [Category categoryWithId:[[d objectForKey:kServPaymentIdTo] intValue]
                                                      context:context];
            Account* servAccountAsCategory = [Account accountWithId:[[d objectForKey:kServPaymentIdTo] intValue]
                                                            context:context];
            Currency* servCurrency = [Currency currencyWithId:[[d objectForKey:kServPaymentIdCurrency] intValue]
                                                      context:context];
            double servSum = [[d objectForKey:kServPaymentAmount] doubleValue];
            NSDate* servDate = [NSDate dateWithTimeIntervalSince1970:[[d objectForKey:kServPaymentDate] intValue]];
            NSString* servComment = [d objectForKey:kServPaymentComment];
            Template* servTmpl = [Template templateWithId:[[d objectForKey:kServPaymentTemplateId] intValue]
                                                  context:context];
            BOOL servFinished = [[d objectForKey:kServPaymentFinished] intValue] == 1;
            BOOL servHidden = [[d objectForKey:kServPaymentHidden] intValue] == 1;
            int servIdPayment = [[d objectForKey:kServPaymentId] intValue];
            
            Payment* servSuperpayment = nil;
            if([d objectForKey:kServPaymentSplitParent] != 0){
                servSuperpayment = [Payment paymentWithId:[[d objectForKey:kServPaymentSplitParent] intValue]
                                                  context:context];
            }
            
            Payment* pay = [Payment paymentWithId:servIdPayment
                                          context:context];
            if(pay == nil){
                // ------ PAYMENT - create local
                pay = [Payment insertPaymentWithUser:usr
                                             account:servAccount
                                            category:servCategory
                                   accountAsCategory:servAccountAsCategory
                                            currency:servCurrency
                                                 sum:servSum
                                             sumMain:0
                                           rateValue:0.0
                                                date:servDate
                                             comment:servComment
                                           ptemplate:servTmpl
                                            finished:servFinished
                                              hidden:servHidden
                                                save:NO
                                             context:context];
                pay.idPayment = [NSNumber numberWithInt:servIdPayment];
                pay.superpayment = servSuperpayment;
                //                [dbw saveManagedContext];
            }else{
                for (Payment* subpay in [pay subpaymentsContext:context]) {
                    if (subpay.idPayment.intValue == -1) {
                        [self paymentCreateWithToken:_token payment:subpay withSuccess:^(NSNumber *result) {
                            subpay.idPayment = result;
                        } withFailure:nil];
                        
                        //                        [dbw saveManagedContext];
                    }
                }
                // ------ PAYMENT - modify
                int modLocal = pay.modifiedDate.timeIntervalSince1970;
                int modRemote = [[d objectForKey:kServModified] intValue];
                if(modLocal < modRemote){
                    // ------ PAYMENT - modify local
                    pay.account = servAccount;
                    pay.category = servCategory;
                    pay.accountAsCategory = servAccountAsCategory;
                    pay.currency = servCurrency;
                    pay.sum = [NSNumber numberWithDouble:servSum];
                    pay.date = servDate;
                    pay.comment = servComment;
                    pay.template = servTmpl;
                    pay.finished = [NSNumber numberWithBool: servFinished];
                    pay.hidden = [NSNumber numberWithBool:servHidden];
                    pay.modifiedDate = [NSDate dateWithTimeIntervalSince1970:modRemote];
                    //                    [dbw saveManagedContext];
                }else if(modLocal > modRemote){
                    // ------ PAYMENT - modify remote
                    if (pay.account != servAccount) {
                        [self paymentUpdateWithToken:token
                                           idPayment:pay.idPayment
                                            property:kServPaymentIdFrom
                                            valueInt:pay.account.idAccount.intValue];
                    }
                    if (pay.category != servCategory) {
                        [self paymentUpdateWithToken:token
                                           idPayment:pay.idPayment
                                            property:kServPaymentIdTo
                                            valueInt:pay.category.idCategory.intValue];
                    }
                    if (pay.accountAsCategory != servAccountAsCategory) {
                        [self paymentUpdateWithToken:token
                                           idPayment:pay.idPayment
                                            property:kServPaymentIdTo
                                            valueInt:pay.accountAsCategory.idAccount.intValue];
                    }
                    if (pay.currency != servCurrency) {
                        [self paymentUpdateWithToken:token
                                           idPayment:pay.idPayment
                                            property:kServPaymentIdCurrency
                                            valueInt:pay.currency.idCurrency.intValue];
                    }
                    if (pay.sum.doubleValue != servSum) {
                        [self paymentUpdateWithToken:token
                                           idPayment:pay.idPayment
                                            property:kServPaymentAmount
                                         valueDouble:pay.sum.doubleValue];
                    }
                    if (pay.date.timeIntervalSince1970 != servDate.timeIntervalSince1970) {
                        [self paymentUpdateWithToken:token
                                           idPayment:pay.idPayment
                                            property:kServPaymentDate
                                            valueInt:servDate.timeIntervalSince1970];
                    }
                    if ([pay.comment isEqualToString:servComment] == NO) {
                        //                        AGLog(@"%@, %@", pay.comment, servComment);
                        [self paymentUpdateWithToken:token
                                           idPayment:pay.idPayment
                                            property:kServPaymentComment
                                               value:pay.comment];
                    }
                    if (pay.template != servTmpl) {
                        [self paymentUpdateWithToken:token
                                           idPayment:pay.idPayment
                                            property:kServPaymentTemplateId
                                            valueInt:pay.template.idTemplate.intValue];
                    }
                    if (pay.finished.boolValue != servFinished) {
                        [self paymentUpdateWithToken:token
                                           idPayment:pay.idPayment
                                            property:kServPaymentFinished
                                            valueInt:(pay.finished.boolValue == YES) ? 1 : 0];
                    }
                    if (pay.hidden.boolValue != servHidden) {
                        [self paymentUpdateWithToken:token
                                           idPayment:pay.idPayment
                                            property:kServPaymentHidden
                                            valueInt:(pay.hidden.boolValue == YES) ? 1 : 0];
                    }
                }
            }
        }
        // --- PAYMENT - create remote
        for (Payment* pay in [usr paymentsAllContext:context]) {
            if (pay.idPayment.intValue == -1) {
                [self paymentCreateWithToken:_token payment:pay withSuccess:^(NSNumber *result) {
                    pay.idPayment = result;
                } withFailure:nil];
                
                //                [dbw saveManagedContext];
                for (Payment* subpay in [pay subpaymentsContext:context]) {
                    [self paymentCreateWithToken:_token payment:subpay withSuccess:^(NSNumber *result) {
                        subpay.idPayment = result;
                    } withFailure:nil];
                    //                    [dbw saveManagedContext];
                }
            }
        }
        // --- PAYMENT - remove local if remote was removed
        
        NSArray* servPaymentListDeleted = [servPaymentListAll objectsAtIndexes:[servPaymentListAll indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            //
            NSDictionary* dict = (NSDictionary*)obj;
            int deleted = [[dict objectForKey:kServDeleted] intValue];
            return deleted == 1;
        }]];
        for (NSDictionary* d in servPaymentListDeleted) {
            Payment* pay = [Payment paymentWithId:[[d objectForKey:kServPaymentId] intValue]
                                          context:context];
            if((pay != nil) && ([pay.removed boolValue] == NO)){
                [pay markRemovedSave:NO
                             context:context];
            }
        }
        // --- PAYMENT - remove remote if local was removed
        for (Payment* pay in [usr paymentsRemovedContext:context]) {
            NSDictionary* dict = [self dictionaryWithId:[pay.idPayment intValue]
                                                    key:kServPaymentId
                                              fromArray:servPaymentListAll];
            if((dict != nil) && ([[dict objectForKey:kServDeleted] intValue] == 0)){
                [self paymentDeleteWithToken:token
                                   idPayment:pay.idPayment];
            }
        }
        
        NSLog(@"payment finised");

    } withFailure:^(NSError *error) {
        NSLog(@"fail payment");
    }];
    

}

-(void) settingsSendJSONWithToken:(NSString*)token
                             user:(User*)usr
{
    NSString* dataJSON = [NSString stringWithFormat:@"{\"%@\" : %d, \"%@\" : %d}", kServSettingsSyncAuto, usr.syncAuto.boolValue==YES ? 1:0, kServSettingsSyncViaWiFIOnly, usr.syncViaWiFiOnly.boolValue==YES ? 1:0];
    [self sendRequestWithAction:@"/settings/setjson" withParams:@{kServToken:_token,kServSettingsData:dataJSON} withSuccess:^(id json) {
        NSLog(@"json finised");
    } withFailure:^(NSError *error) {
    }];

}
- (void) synchronizeDataForUser:(User*)usr
{
    NSManagedObjectContext* context = [AGDBWorker sharedWorker].managedObjectContext;
    usr = (User*)[context objectWithID:usr.objectID];
    
    [self synchCurrencyWithContext:context withUser:usr];
    [self synchRatesWithToken:_token withContext:context];
    [self synchCategoryWithContext:context withUser:usr];
    [self synchAccountsWithToken:_token withContext:context withUser:usr];
    [self synchTemplatesWithToken:_token withContext:context withUser:usr];
    [self synchPaymentWithToken:_token withContext:context withUser:usr];
    [self settingsSendJSONWithToken:_token user:usr];
}

@end
