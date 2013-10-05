//
//  AGServerAccess.m
//  AllMine
//
//  Created by Allgoritm LLC on 26.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "AGServerAccess.h"
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

typedef enum{
    StatusErrorParamsMissing = 0,
    StatusOK = 1,
    StatusErrorParamEmpty = -1,
    StatusErrorTokenDead = -2,
    StatusErrorParamNotValid = -3,
}Status;

#define kRequestTimeout 5.0f

@implementation AGServerAccess

#pragma mark - shared

+ (AGServerAccess*) sharedAccess {
    static AGServerAccess* _inst = nil;
    if (_inst == nil) {
        _inst = [[AGServerAccess alloc] init];
    }
    return _inst;
}

#pragma mark - sync
- (void) cleanupWithToken:(NSString*)token user:(User*)usr{
    {
        NSArray* arr = [self categoryListWithToken:token];
        for (NSDictionary* d in arr) {
            [self categoryDeleteWithToken:token idCategory:[NSNumber numberWithInt: [[d objectForKey:kServAccountId] intValue]]];
        }
    }
    {
        NSArray* arr = [self accountListWithToken:token];
        for (NSDictionary* d in arr) {
            [self accountDeleteWithToken:token idAccount:[NSNumber numberWithInt: [[d objectForKey:kServAccountId] intValue]]];
        }
    }
    {
        NSArray* arr = [self templateListWithToken:token];
        for (NSDictionary* d in arr) {
            [self templateDeleteWithToken:token idTemplate:[NSNumber numberWithInt: [[d objectForKey:kServPaymentId] intValue]]];
        }
    }
    {
        NSArray* arr = [self paymentListWithToken:token];
        for (NSDictionary* d in arr) {
            [self paymentDeleteWithToken:token idPayment:[NSNumber numberWithInt:[[d objectForKey:kServPaymentId] intValue]]];
        }
    }
    
}

-(void)changeServ:(NSString*)token{
//    NSNumber* idCategory = [NSNumber numberWithInt:503];
//    [self categoryUpdateWithToken:token
//                       idCategory:idCategory
//                         property:kServAccountDescription
//                            value:@"asdqwe"];
//    [self categoryDeleteWithToken:token
//                       idCategory:idCategory];
    
//    [self accountUpdateWithToken:token
//                       idAccount:[NSNumber numberWithInt:540]
//                        property:kServAccountDescription
//                           value:@"qwerty"];
//    [self accountDeleteWithToken:token
//                       idAccount:[NSNumber numberWithInt:541]];

//    [self templateUpdateWithToken:token
//                       idTemplate:[NSNumber numberWithInt:86]
//                         property:kServPaymentDescription
//                            value:@"qwertyasd"];
//    [self templateUpdateWithToken:token
//                       idTemplate:[NSNumber numberWithInt:86]
//                         property:kServPaymentComment
//                            value:@"QQQasd"];
//    [self templateUpdateWithToken:token
//                       idTemplate:[NSNumber numberWithInt:86]
//                         property:kServPaymentIdFrom
//                            valueInt:599];
//    [self templateUpdateWithToken:token
//                       idTemplate:[NSNumber numberWithInt:86]
//                         property:kServPaymentIdTo
//                            valueInt:598];
//    [self templateDeleteWithToken:token
//                       idTemplate:[NSNumber numberWithInt:85]];
    
//    [self paymentDeleteWithToken:token
//                       idPayment:[NSNumber numberWithInt:105]];
//    [self paymentUpdateWithToken:token
//                       idPayment:[NSNumber numberWithInt:106]
//                        property:kServPaymentAmount
//                     valueDouble:300.0];
//    [self paymentUpdateWithToken:token
//                       idPayment:[NSNumber numberWithInt:106]
//                        property:kServPaymentComment
//                           value:@"qwerty"];
//    [self paymentUpdateWithToken:token
//                       idPayment:[NSNumber numberWithInt:106]
//                        property:kServPaymentIdCurrency
//                           valueInt:363];
//    [self paymentUpdateWithToken:token
//                       idPayment:[NSNumber numberWithInt:106]
//                        property:kServPaymentIdFrom
//                        valueInt:670];
//    [self paymentUpdateWithToken:token
//                       idPayment:[NSNumber numberWithInt:106]
//                        property:kServPaymentIdTo
//                        valueInt:671];
//    [self paymentUpdateWithToken:token
//                       idPayment:[NSNumber numberWithInt:106]
//                        property:kServPaymentTemplateId
//                        valueInt:0];
//    [self paymentUpdateWithToken:token
//                       idPayment:[NSNumber numberWithInt:106]
//                        property:kServPaymentFinished
//                        valueInt:0];
}

- (void) synchronizeDataForUser:(User*)usr{
    NSManagedObjectContext* context = [AGDBWorker sharedWorker].managedContextTemporary;
//    usr = [User userWithLogin:usr.login context:context];
    usr = (User*)[context objectWithID:usr.objectID];
    @try {
        // token
        NSString* token = [self userToken:usr];
        //-------------------------------
        // CLEANUP
    //    [self cleanupWithToken:token user:usr];
    //    return;
    //    [self changeServ:token];
    //    return;
        
        //-------------------------------------
        // SYNC CURRENCIES
        {
            AGLog(@"\r\n----------------------------------------------------------------------------");
            AGLog(@"SYNC CURRENCIES");
            // --- CURRENCY - create local from remote
            NSArray* servCurrencyListAll = [self currencyListAllWithToken:token];
            for (NSDictionary* d in servCurrencyListAll) {
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
        }
        //-------------------------------------
        // SYNC RATES
        {
            AGLog(@"\r\n----------------------------------------------------------------------------");
            AGLog(@"SYNC RATES");
            NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
            NSDate* dt = nil;
            if([ud objectForKey:kUDSyncLastDate] != nil){
                dt = [ud objectForKey:kUDSyncLastDate];
            }
            NSArray* rates = [self currencyRatesWithToken:token date:dt];
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
        }
        //-------------------------------------
        // SYNC CATEGORIES
        {
            AGLog(@"\r\n----------------------------------------------------------------------------");
            AGLog(@"SYNC CATEGORIES");
            // --- CATEGORY - create local from remote
            NSArray* servCategoryListAll = [self categoryListAllWithToken:token];
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
            // --- CATEGORY - create remote from local
            for (Category* cat in [usr categoriesAllContext:context]) {
                if ([cat.idCategory intValue] == -1) {
                    cat.idCategory = [self categoryCreateWithToken:token
                                                          category:cat];
                    //                [dbw saveManagedContext];
                    [servCategoriesNew addObject:cat];
                }
            }
            // --- CATEGORY - sync new local: supercat to remote
            servCategoryListAll = [self categoryListAllWithToken:token];
            for (Category* cat in servCategoriesNew) {
                if (cat.supercat == nil) {
                    continue;
                }
                [self categoryUpdateWithToken:token
                                   idCategory:cat.idCategory
                                     property:kServAccountParent
                                     valueInt:cat.supercat.idCategory.intValue];
            }
            // --- CATEGORY - sync new remote: parent to local
            for (Category* cat in userCategoriesNew) {
                NSDictionary* dict = [self dictionaryWithId:[cat.idCategory intValue]
                                                        key:kServAccountId
                                                  fromArray:servCategoryListAll];
                cat.supercat = [Category categoryWithId:[[dict objectForKey:kServAccountParent] intValue]
                                                context:context];
                //            [[AGDBWorker sharedWorker] saveManagedContext];
            }        
            // --- CATEGORY - modify local or remote depending on modifiedDate
            servCategoryListAll = [self categoryListAllWithToken:token];
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
                            [self categoryUpdateWithToken:token
                                               idCategory:cat.idCategory
                                                 property:kServAccountDescription
                                                    value:cat.title];
                        }
                        if (cat.type.intValue != servType) {
                            [self categoryUpdateWithToken:token
                                               idCategory:cat.idCategory
                                                 property:kServAccountType
                                                    value:cat.type.intValue == CatTypeIncome ? kServAccountTypeIn : kServAccountTypeOut];
                        }
                        if (cat.supercat.idCategory.intValue != servSupercatId) {
                            [self categoryUpdateWithToken:token
                                               idCategory:cat.idCategory
                                                 property:kServAccountParent
                                                    valueInt:cat.supercat.idCategory.intValue];
                        }
                    }
                }
            }
            // --- CATEGORY - remove local if remote was removed
            servCategoryListAll = [self categoryListAllWithToken:token];
            NSArray* servCategoryListDeleted = [servCategoryListAll objectsAtIndexes:[servCategoryListAll indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                
                NSDictionary* dict = (NSDictionary*)obj;
                int deleted = [[dict objectForKey:kServDeleted] intValue];
                return deleted == 1;
            }]];
            for (NSDictionary* d in servCategoryListDeleted) {
                
                Category* cat = [Category categoryWithId:[[d objectForKey:kServAccountId] intValue]
                                                 context:context];
                if((cat != nil) && ([cat.removed boolValue] == NO)){
                    [cat markRemovedSave:NO
                                 context:context];
                }
            }
            // --- CATEGORY - remove remote if local was removed
            for (Category* cat in [usr categoriesRemovedContext:context]) {
                NSDictionary* dict = [self dictionaryWithId:[cat.idCategory intValue]
                                                        key:kServAccountId
                                                  fromArray:servCategoryListAll];
                if((dict != nil) && ([[dict objectForKey:kServDeleted] intValue] == 0)){
                    [self accountDeleteWithToken:token
                                       idAccount:cat.idCategory];
                }
            }
        }
        AGLog(@"SERVER CATEGORIES = %@", [self categoryListWithToken:token]);
        //-------------------------------------
        // SYNC ACCOUNTS
        {
            AGLog(@"\r\n----------------------------------------------------------------------------");
            AGLog(@"SYNC ACCOUNTS");
            // --- ACCOUNT - create local from remote
            // --- ACCOUNT - modify local or remote depending on modifiedDate
            NSArray* servAccountListAll = [self accountListAllWithToken:token];
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
            for (Account* acc in [usr accountsAllContext:context]) {
                if ([acc.idAccount intValue] == -1) {
                    acc.idAccount = [self accountCreateWithToken:token
                                                           account:acc];
    //                [dbw saveManagedContext];
                }
            }
            // --- ACCOUNT - remove local if remote was removed
            servAccountListAll = [self accountListAllWithToken:token];
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
        }
        AGLog(@"SERVER ACCOUNTS = %@", [self accountListWithToken:token]);
        //-------------------------------------
        // SYNC TEMPLATES
        {
            AGLog(@"\r\n----------------------------------------------------------------------------");
            AGLog(@"SYNC TEMPLATES");
            // --- TEMPLATE - create local from remote
            // --- TEMPLATE - modify local or remote depending on modifiedDate
            NSArray* servTemplateListAll = [self templateListAllWithToken:token];
            for (NSDictionary* d in servTemplateListAll) {
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
                            [self templateUpdateWithToken:token
                                               idTemplate:tmpl.idTemplate
                                                 property:kServPaymentComment
                                                    value:tmpl.comment];
                        }
                        if ([tmpl.title isEqualToString:servTitle] == NO) {
                            [self templateUpdateWithToken:token
                                               idTemplate:tmpl.idTemplate
                                                 property:kServPaymentDescription
                                                    value:tmpl.title];
                        }
                    }
                }
            }
            // --- TEMPLATE - create remote
            for (Template* tmpl in [usr templatesAllContext:context]) {
                if (tmpl.idTemplate.intValue == -1) {
                    tmpl.idTemplate = [self templateCreateWithToken:token
                                                           template:tmpl];
    //                [dbw saveManagedContext];
                }
            }
            // --- TEMPLATE - remove local if remote was removed
            servTemplateListAll = [self templateListAllWithToken:token];
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
        }
        AGLog(@"SERVER TEMPLATES = %@", [self templateListWithToken:token]);
        //-------------------------------------
        // SYNC PAYMENTS
        {
            AGLog(@"\r\n----------------------------------------------------------------------------");
            AGLog(@"SYNC PAYMENTS");
            // --- PAYMENT - create local from remote
            // --- PAYMENT - modify local or remote depending on modifiedDate
            NSArray* servPaymentListAll = [self paymentListAllWithToken:token];
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
                            subpay.idPayment = [self paymentCreateWithToken:token
                                                                    payment:subpay];
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
                    pay.idPayment = [self paymentCreateWithToken:token
                                                         payment:pay];
    //                [dbw saveManagedContext];                
                    for (Payment* subpay in [pay subpaymentsContext:context]) {
                        subpay.idPayment = [self paymentCreateWithToken:token
                                                                payment:subpay];
    //                    [dbw saveManagedContext];
                    }
                }
            }
            // --- PAYMENT - remove local if remote was removed
            servPaymentListAll = [self paymentListAllWithToken:token];
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
        }
        AGLog(@"SERVER PAYMENTS = %@", [self paymentListWithToken:token]);
        //-------------------------------------
        // SYNC SETTINGS
        {
            [self settingsSendJSONWithToken:token user:usr];
        }
    }
    @catch (AGExceptionNetworkURLConnectionFailed* exception) {
//        [AGTools showAlertOkWithTitle:NSLocalizedString(@"Error", @"")
//                              message:exception.reason];
        @throw [AGExceptionSyncFailed exceptionWithName:nil
                                                 reason:nil
                                               userInfo:nil];
    }
    @finally {
        [[AGDBWorker sharedWorker] saveContext:context];
    }
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

#pragma mark - template
- (void) templateDeleteWithToken:(NSString*)token
                      idTemplate:(NSNumber*)idTemplate{
    [self paymentDeleteWithToken:token
                       idPayment:idTemplate];
}

- (NSNumber*) templateCreateWithToken:(NSString*)token
                             template:(Template*)tmpl{
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
    
    int result = -1;
    @try {
        NSDictionary* dict = [self sendRequest:
                              [self requestWithPath:@"/transaction/create"
                                             params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                     token,     kServToken,
                                                     idFrom,    kServPaymentIdFrom,
                                                     idTo,      kServPaymentIdTo,
                                                     comment,   kServPaymentComment,
                                                     title, kServPaymentDescription,
                                                     isTemplate, kServPaymentIsTemplate,
                                                     nil]]];        
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
    }
    @catch (AGExceptionServerResponseBadJSON* exception) {
        result = -1;
    }
    @catch (AGExceptionServerResponseBadStatus* exception) {
        result = -1;
    }
    @finally {
        return [NSNumber numberWithInt:result];
    }
}

- (void) templateUpdateWithToken:(NSString*)token
                      idTemplate:(NSNumber*)idTemplate
                        property:(NSString*)property
                           value:(NSString*)value{
    [self paymentUpdateWithToken:token
                       idPayment:idTemplate
                        property:property
                           value:value];
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
- (void) templateUpdateWithToken:(NSString*)token
                      idTemplate:(NSNumber*)idTemplate
                        property:(NSString*)property
                     valueDouble:(double)valueDouble{
    [self paymentUpdateWithToken:token
                       idPayment:idTemplate
                        property:property
                     valueDouble:valueDouble];
}

- (NSArray*) templateListAllWithToken:(NSString*)token{
    NSDictionary* dict = nil;
    @try {
        dict = [self sendRequest:
                [self requestWithPath:@"/transaction/list"
                               params:[NSDictionary dictionaryWithObjectsAndKeys:
                                       token,     kServToken,
                                       @"1",      kServSync, nil]]];
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
            int isTemplate = [[dict objectForKey:kServPaymentIsTemplate] intValue];
            return isTemplate == 1;
        }]];
    }
    @catch (NSException *exception) {
        result = [NSArray array];
    }
    @finally {
        return result;
    }
}

- (NSArray*) templateListWithToken:(NSString*)token{
    NSDictionary* dict = nil;
    @try {
        dict = [self sendRequest:
                [self requestWithPath:@"/transaction/list"
                               params:[NSDictionary dictionaryWithObjectsAndKeys:
                                       token, kServToken,
                                       nil]]];
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
            int isTemplate = [[dict objectForKey:kServPaymentIsTemplate] intValue];
            return isTemplate == 1;
        }]];
    }
    @catch (NSException *exception) {
        result = [NSArray array];
    }
    @finally {
        return result;
    }
}

#pragma mark - payment
- (void) paymentDeleteWithToken:(NSString*)token
                      idPayment:(NSNumber*)idPayment{
    @try {
        [self sendRequest:
         [self requestWithPath:@"/transaction/delete"
                        params:[NSDictionary dictionaryWithObjectsAndKeys:
                                token,     kServToken,
                                idPayment, kServPaymentId, nil]]];
    }
    @catch (AGExceptionServerResponseBadJSON *exception) {
    }
    @catch (AGExceptionServerResponseBadStatus *exception) {
    }
    @finally {
    }
}

- (NSNumber*) paymentCreateWithToken:(NSString*)token
                             payment:(Payment*)payment{
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
    
    int result = -1;
    @try {
        NSDictionary* dict = [self sendRequest:
                              [self requestWithPath:@"/transaction/create"
                                             params:[NSDictionary dictionaryWithObjectsAndKeys:
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
                                                     nil]]];

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
    }
    @catch (AGExceptionServerResponseBadJSON* exception) {
        result = -1;
    }
    @catch (AGExceptionServerResponseBadStatus* exception) {
        result = -1;
    }
    @finally {
        return [NSNumber numberWithInt:result];
    }
}

- (void) paymentUpdateWithToken:(NSString*)token
                      idPayment:(NSNumber*)idPayment
                       property:(NSString*)property
                          value:(NSString*)value{
    @try {
        [self sendRequest:
         [self requestWithPath:[@"/transaction/update/" stringByAppendingString:property]
                        params:[NSDictionary dictionaryWithObjectsAndKeys:
                                token,     kServToken,
                                idPayment, kServPaymentId,
                                value,     kServValue, nil]]];
    }
    @catch (AGExceptionServerResponseBadJSON* exception) {
    }
    @catch (AGExceptionServerResponseBadStatus* exception) {
    }
    @finally {
    }
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
                    valueDouble:(double)valueDouble{
    [self paymentUpdateWithToken:token
                       idPayment:idPayment
                        property:property
                           value:[NSString stringWithFormat:@"%f", valueDouble]];
}

- (NSArray*) paymentListAllWithToken:(NSString*)token{
    NSDictionary* dict = nil;
    @try {
        dict = [self sendRequest:
                [self requestWithPath:@"/transaction/list"
                               params:[NSDictionary dictionaryWithObjectsAndKeys:
                                       token,     kServToken,
                                       @"1",      kServSync, nil]]];
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
            int isTemplate = [[dict objectForKey:kServPaymentIsTemplate] intValue];
            return isTemplate == 0;
        }]];
    }
    @catch (NSException *exception) {
        result = [NSArray array];
    }
    @finally {
        return result;
    }
}

- (NSArray*) paymentListWithToken:(NSString*)token{
    NSDictionary* dict = nil;
    @try {
        dict = [self sendRequest:
                [self requestWithPath:@"/transaction/list"
                               params:[NSDictionary dictionaryWithObjectsAndKeys:
                                       token,     kServToken,
                                       nil]]];
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
            int isTemplate = [[dict objectForKey:kServPaymentIsTemplate] intValue];
            return isTemplate == 0;
        }]];
    }
    @catch (NSException *exception) {
        result = [NSArray array];
    }
    @finally {
        return result;
    }
}

#pragma mark - currency
- (NSArray*) currencyRatesWithToken:(NSString*)token date:(NSDate*)date{
    NSDictionary* dict = nil;
    NSArray* arr = nil;
    @try {
        if (date == nil) {
            dict = [self sendRequest:
                    [self requestWithPath:@"/currency/rate"
                                   params:[NSDictionary dictionaryWithObjectsAndKeys:
                                           token, kServToken,
                                           nil]]];
        }else{
            dict = [self sendRequest:
                    [self requestWithPath:@"/currency/rate"
                                   params:[NSDictionary dictionaryWithObjectsAndKeys:
                                           token, kServToken,
                                           [date dateStringJson], kServCurrencyRateDate,
                                           nil]]];
        }
        @try {
            arr = [dict objectForKey:kServData];
        }
        @catch (NSException *exception) {
            arr = [NSArray array];
        }
        @finally {
        }
    }
    @catch (AGExceptionServerResponseBadJSON* exception) {
        arr = [NSArray array];
    }
    @catch (AGExceptionServerResponseBadStatus* exception) {
        arr = [NSArray array];
    }
    @finally {
        return arr;
    }
}

- (NSArray*) currencyListAllWithToken:(NSString*)token{
    NSDictionary* dict = nil;
    NSArray* arr = nil;
    NSString* lang = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([lang isEqualToString:@"ru"]) {
        lang = kServLanguageRu;
    }else{
        lang = kServLanguageEn;
    }
    @try {
        dict = [self sendRequest:
                  [self requestWithPath:@"/currency/list"
                                 params:[NSDictionary dictionaryWithObjectsAndKeys:
                                         token, kServToken,
                                         @"1",  kServSync,
                                         lang,  kServLanguage,
                                         nil]]];
        @try {
            arr = [dict objectForKey:kServData];
        }
        @catch (NSException *exception) {
            arr = [NSArray array];
        }
        @finally {
        }
    }
    @catch (AGExceptionServerResponseBadJSON* exception) {
        arr = [NSArray array];
    }
    @catch (AGExceptionServerResponseBadStatus* exception) {
        arr = [NSArray array];
    }
    @finally {
        return arr;
    }
}

//#pragma mark - banks
//- (NSArray*) bankListWithToken:(NSString*)token{
//    NSDictionary* dict = [self sendRequest:
//                          [self requestWithPath:@"/bank/list"
//                                         params:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                 token, kServToken,
//                                                 nil]]];
//    return [dict objectForKey:kServData];
//}

#pragma mark - category
- (NSNumber*) categoryCreateWithToken:(NSString*)token
                             category:(Category*)category{
    NSString* title = (category.title) ? category.title : @"";
    NSNumber* parentId = [NSNumber numberWithInt:0];
    if ((category.supercat != nil)&&(category.supercat.idCategory.intValue > -1)) {
        parentId = [NSNumber numberWithInt:category.supercat.idCategory.intValue];
    }
    NSString* type = (category.type.intValue == CatTypeIncome) ? kServAccountTypeIn : kServAccountTypeOut;
    
    int result = -1;
    @try {
        NSDictionary* dict = [self sendRequest:
                              [self requestWithPath:@"/account/create"
                                             params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                     token,     kServToken,
                                                     title,     kServAccountDescription,
                                                     parentId,  kServAccountParent,
                                                     type,      kServAccountType,
                                                     nil]]];
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
        }
    }
    @catch (AGExceptionServerResponseBadJSON* exception) {
        result = -1;
    }
    @catch (AGExceptionServerResponseBadStatus* exception) {
        result = -1;
    }
    @finally {
        return [NSNumber numberWithInt:result];
    }
}
- (NSArray*) categoryListAllWithToken:(NSString*)token{
    NSDictionary* dict = nil;
    @try {
        dict = [self sendRequest:
                [self requestWithPath:@"/account/list"
                               params:[NSDictionary dictionaryWithObjectsAndKeys:
                                       token, kServToken,
                                       @"1",   kServSync, nil]]];
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
    }
    @finally {
        return result;
    }
}

- (NSArray*) categoryListWithToken:(NSString*)token{
    NSDictionary* dict = nil;
    @try {
        dict = [self sendRequest:
                [self requestWithPath:@"/account/list"
                               params:[NSDictionary dictionaryWithObjectsAndKeys:
                                       token, kServToken, nil]]];
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
    }
    @finally {
        return result;
    }
}
- (void) categoryDeleteWithToken:(NSString*)token idCategory:(NSNumber*)idCategory{
    [self accountDeleteWithToken:token
                       idAccount:idCategory];
}
- (void) categoryUpdateWithToken:(NSString*)token idCategory:(NSNumber*)idCategory property:(NSString*)property value:(NSString*)value{
    [self accountUpdateWithToken:token
                       idAccount:idCategory
                        property:property
                           value:value];
}
- (void) categoryUpdateWithToken:(NSString*)token idCategory:(NSNumber*)idCategory property:(NSString*)property valueInt:(int)valueInt{
    [self accountUpdateWithToken:token
                       idAccount:idCategory
                        property:property
                        valueInt:valueInt];
}

#pragma mark - account
- (void) accountDeleteWithToken:(NSString*)token
                      idAccount:(NSNumber*)idAccount{
    @try {
        [self sendRequest:
         [self requestWithPath:@"/account/delete"
                        params:[NSDictionary dictionaryWithObjectsAndKeys:
                                token,     kServToken,
                                idAccount, kServAccountId, nil]]];
    }
    @catch (AGExceptionServerResponseBadJSON *exception) {
    }
    @catch (AGExceptionServerResponseBadStatus *exception) {
    }
    @finally {
    }
}

- (NSNumber*) accountCreateWithToken:(NSString*)token
                             account:(Account*)account{
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
    
    int result = -1;
    @try {
        NSDictionary* dict = [self sendRequest:
                              [self requestWithPath:@"/account/create"
                                             params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                     token,     kServToken,
                                                     title,     kServAccountDescription,
                                                     comment,   kServAccountComment,
                                                     dateOpen,  kServAccountCreateDate,
                                                     idCurrency,kServAccountIdCurrency,
                                                     idParent,  kServAccountParent,
                                                     typeStr,   kServAccountType,
                                                     group,     kServAccountGroup,
                                                     nil]]];
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
        }
    }
    @catch (AGExceptionServerResponseBadJSON* exception) {
        result = -1;
    }
    @catch (AGExceptionServerResponseBadStatus* exception) {
        result = -1;
    }
    @finally {
        return [NSNumber numberWithInt:result];
    }
}

- (void) accountUpdateWithToken:(NSString*)token
                      idAccount:(NSNumber*)idAccount
                       property:(NSString*)property
                          value:(NSString*)value{
    @try {
        [self sendRequest:
         [self requestWithPath:[@"/account/update/" stringByAppendingString:property]
                        params:[NSDictionary dictionaryWithObjectsAndKeys:
                                token,     kServToken,
                                idAccount, kServAccountId,
                                value,     kServValue, nil]]];
    }
    @catch (AGExceptionServerResponseBadJSON* exception) {
    }
    @catch (AGExceptionServerResponseBadStatus* exception) {
    }
    @finally {
    }
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

- (NSArray*) accountListAllWithToken:(NSString*)token{
    NSDictionary* dict = nil;
    @try {
        dict = [self sendRequest:
                  [self requestWithPath:@"/account/list"
                                 params:[NSDictionary dictionaryWithObjectsAndKeys:
                                         token, kServToken,
                                         @"1",   kServSync, nil]]];
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
            return !([type isEqual:kServAccountTypeIn] || [type isEqual:kServAccountTypeOut]);
        }]];
    }
    @catch (NSException *exception) {
        result = [NSArray array];
    }
    @finally {
        return result;
    }
}

- (NSArray*) accountListWithToken:(NSString*)token{
    NSDictionary* dict = nil;
    @try {
        [self sendRequest:
         [self requestWithPath:@"/account/list"
                        params:[NSDictionary dictionaryWithObjectsAndKeys:
                                token, kServToken, nil]]];
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
            return !([type isEqual:kServAccountTypeIn] || [type isEqual:kServAccountTypeOut]);
        }]];
    }
    @catch (NSException *exception) {
        result = [NSArray array];
    }
    @finally {
        return result;
    }
}

#pragma mark - user
- (NSString*) userToken:(User*)usr{
    NSDictionary* dict = [self sendRequest:
                          [self requestWithPath:@"/user/login"
                                         params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 usr.login, kServUserLogin,
                                                 usr.password, kServUserPassword, nil]]];
    return [[dict objectForKey:kServData] objectForKey:kServToken];
}
- (void) userExistWithLogin:(NSString*)login password:(NSString*)password{
    /*NSDictionary* dict =*/ [self sendRequest:
                          [self requestWithPath:@"/user/login"
                                         params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 login, kServUserLogin,
                                                 password, kServUserPassword, nil]]];
//    return [[dict objectForKey:kServStatus] intValue] == StatusOK;
}

- (void) userSetNewPassword:(NSString*)passNew forUser:(User*)usr{
    /*NSDictionary* dict =*/ [self sendRequest:
                          [self requestWithPath:@"/user/changepassword"
                                         params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 usr.login, kServUserLogin,
                                                 usr.password, kServUserPassword,
                                                 passNew, kServUserPasswordNew, nil]]];
}
- (void) userRegisterLogin:(NSString*)login password:(NSString*)password{
    /*NSDictionary* dict =*/ [self sendRequest:
                          [self requestWithPath:@"/user/create"
                                         params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                login, kServUserLogin,
                                                password, kServUserPassword, nil]]];
//    return [[dict objectForKey:kServStatus] intValue];
}

-(void) userRequestPasswordRecoveryForUser:(User*)usr{
    NSString* token = [self userToken:usr];
    /*NSDictionary* dict =*/ [self sendRequest:
                          [self requestWithPath:@"/user/changepasswordemail"
                                         params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 token, kServToken, nil]]];
}

#pragma mark - settings
-(void) settingsSetFromServerForUser:(User*)usr{
    @try {
        NSString* token = [self userToken:usr];
        NSDictionary* dict = [self sendRequest:
                              [self requestWithPath:@"/settings/list"
                                             params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                     token,     kServToken,
                                                     @"iphone_",  @"option",
                                                     @"1",  @"json",
                                                     nil]]];
        usr.syncAuto = [NSNumber numberWithBool:[[dict objectForKey:kServSettingsSyncAuto] intValue] == 1 ? YES : NO];
        usr.syncViaWiFiOnly = [NSNumber numberWithBool:[[dict objectForKey:kServSettingsSyncViaWiFIOnly] intValue] == 1 ? YES : NO];
    }
    @catch (AGExceptionServerResponseBadJSON *exception) {
    }
    @catch (AGExceptionServerResponseBadStatus *exception) {
    }
    @finally {
    }
}
-(void) settingsSendJSONWithToken:(NSString*)token
                             user:(User*)usr{
    @try {
        NSString* dataJSON = [NSString stringWithFormat:@"{\"%@\" : %d, \"%@\" : %d}", kServSettingsSyncAuto, usr.syncAuto.boolValue==YES ? 1:0, kServSettingsSyncViaWiFIOnly, usr.syncViaWiFiOnly.boolValue==YES ? 1:0];
        /*NSDictionary* dict =*/ [self sendRequest:
                                  [self requestWithPath:@"/settings/setjson"
                                                 params:[NSDictionary dictionaryWithObjectsAndKeys:
                                                         token,     kServToken,
                                                         dataJSON,  kServSettingsData,
                                                         nil]]];
    }
    @catch (AGExceptionServerResponseBadJSON *exception) {
    }
    @catch (AGExceptionServerResponseBadStatus *exception) {
    }
    @finally {
    }
}

#pragma mark - json request
- (NSString*) stringParamsFromDictionary:(NSDictionary*) params {
    NSMutableArray* pairs = [NSMutableArray array];
    
    for (NSString* key in params.keyEnumerator) {
        id v = [params objectForKey:key];
        NSString* value = [v isKindOfClass:[NSString class]] ? v : [v stringValue];
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, [value encode]]];
    }
    
    return [pairs componentsJoinedByString:@"&"];
}

- (NSURLRequest*) requestWithPath:(NSString*)aPath
                           params:(NSDictionary*) aParams {
    NSString* query = [self stringParamsFromDictionary:aParams];
    AGLog(@"%@", query);
    NSData* data = [NSData dataWithBytes:[query UTF8String] length:[query length]];
    NSString* length = [NSString stringWithFormat:@"%d", [data length]];
    
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[kBaseURL stringByAppendingString:aPath]]
                                                       cachePolicy:NSURLCacheStorageAllowedInMemoryOnly
                                                   timeoutInterval:kRequestTimeout];
//    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:
//                                [NSURL URLWithString:[kBaseURL stringByAppendingString:aPath]]];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:data];
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [req setValue:length forHTTPHeaderField:@"Content-Length"];
    [req setValue:@"application/json-rpc" forHTTPHeaderField:@"Accept"];
    
    return req;
}

- (id) sendRequest:(NSURLRequest*) aRequest {
    AGLog(@"%@", aRequest.URL);

    NSError* error = nil;
	NSData* data = [NSURLConnection sendSynchronousRequest:aRequest
                                         returningResponse:nil
                                                     error:&error];
    if (error != nil) {
        [AGTools showAlertOkWithTitle:NSLocalizedString(@"Error", @"")
                              message:error.localizedFailureReason];
        @throw [AGExceptionNetworkURLConnectionFailed exceptionWithName:nil
                                                                 reason:error.localizedFailureReason
                                                               userInfo:nil];
//        [AGTools showAlertOkWithTitle:NSLocalizedString(@"Error", @"") message:error.localizedDescription];
    }
	if (data){
        NSError* error = nil;
        id response = [NSJSONSerialization JSONObjectWithData:data
                                                      options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves
                                                        error:&error];
        AGLog(@"%@", response);
        if (error != nil) {
            AGLog(@"ServerAPI Response Error: %@, %@", error, [error userInfo]);
            @throw [AGExceptionServerResponseBadJSON exceptionWithName:nil
                                                                reason:nil
                                                              userInfo:nil];
        }
        NSMutableDictionary* dictResponse = nil;
        if ([response respondsToSelector:@selector(objectForKey:)]) {
            dictResponse = response;
        }else{
            dictResponse = [NSMutableDictionary dictionary];
            for (NSDictionary* d in (NSArray*)response) {
                [dictResponse setValuesForKeysWithDictionary:d];
            }
        }
        Status st = [[dictResponse objectForKey:kServStatus] intValue];
        if (st != StatusOK) {
            NSString* statusError = @"";
            switch (st) {
                case StatusErrorParamsMissing:
                    statusError = @"Ошибка. Функция не сделала ничего. Заявленных выходных данных нет.";
                    break;
                case StatusErrorParamEmpty:
                    statusError = @"В функцию передано меньше параметров чем необходимо. Или переданы пустые параметры (которые не должны быть пустыми).";
                    break;
                case StatusErrorTokenDead:
                    statusError = @"Передан протухший токен. Надо заново перелогиниться с сохраненной парой логин-пароль. В некоторых функциях означает что такого пользователя не существует";
                    break;
                case StatusErrorParamNotValid:
                    statusError = @"Один из параметров неверный. То есть параметр существует и проходит первичную валидацию но не содержит валидного значения";
                    break;
                default:
                    statusError = @"unknown";
                    break;
            }
            AGLog(@"ServerAPI status error: %@", statusError);
            @throw [AGExceptionServerResponseBadStatus exceptionWithName:nil
                                                                  reason:nil
                                                                userInfo:dictResponse];
        }
        return dictResponse;
	}
    @throw [AGExceptionServerResponseBadJSON exceptionWithName:nil
                                                        reason:nil
                                                      userInfo:nil];
}


@end
