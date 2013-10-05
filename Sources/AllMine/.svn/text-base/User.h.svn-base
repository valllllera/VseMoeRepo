//
//  User.h
//  AllMine
//
//  Created by Allgoritm LLC on 06.12.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Account, Category, Currency, Payment, Template;

@interface User : NSManagedObject

@property (nonatomic, retain) NSDate * dateIn;
@property (nonatomic, retain) NSString * login;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSNumber * hidden;
@property (nonatomic, retain) NSNumber * syncAuto;
@property (nonatomic, retain) NSNumber * syncViaWiFiOnly;
@property (nonatomic, retain) NSSet *accounts;
@property (nonatomic, retain) NSSet *categories;
@property (nonatomic, retain) NSSet *currencies;
@property (nonatomic, retain) NSSet *currenciesAdditional;
@property (nonatomic, retain) Currency *currencyMain;
@property (nonatomic, retain) NSSet *payments;
@property (nonatomic, retain) NSSet *templates;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addAccountsObject:(Account *)value;
- (void)removeAccountsObject:(Account *)value;
- (void)addAccounts:(NSSet *)values;
- (void)removeAccounts:(NSSet *)values;

- (void)addCategoriesObject:(Category *)value;
- (void)removeCategoriesObject:(Category *)value;
- (void)addCategories:(NSSet *)values;
- (void)removeCategories:(NSSet *)values;

- (void)addCurrenciesObject:(Currency *)value;
- (void)removeCurrenciesObject:(Currency *)value;
- (void)addCurrencies:(NSSet *)values;
- (void)removeCurrencies:(NSSet *)values;

- (void)addCurrenciesAdditionalObject:(Currency *)value;
- (void)removeCurrenciesAdditionalObject:(Currency *)value;
- (void)addCurrenciesAdditional:(NSSet *)values;
- (void)removeCurrenciesAdditional:(NSSet *)values;

- (void)addPaymentsObject:(Payment *)value;
- (void)removePaymentsObject:(Payment *)value;
- (void)addPayments:(NSSet *)values;
- (void)removePayments:(NSSet *)values;

- (void)addTemplatesObject:(Template *)value;
- (void)removeTemplatesObject:(Template *)value;
- (void)addTemplates:(NSSet *)values;
- (void)removeTemplates:(NSSet *)values;

@end
