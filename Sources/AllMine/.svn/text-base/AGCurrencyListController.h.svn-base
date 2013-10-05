//
//  AGCurrencyListController.h
//  AllMine
//
//  Created by Allgoritm LLC on 07.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AGCurrencyListController;
@class Currency;
@protocol AGCurrencyListDelegate <NSObject>

- (void) currencyListController:(AGCurrencyListController*)controller didFinishedSelectingCurrency:(Currency*)currency;

@end

@interface AGCurrencyListController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, assign) int tag;

@property(nonatomic, strong) id<AGCurrencyListDelegate> delegate;

@property(nonatomic, strong) NSArray* currencies;
@property(nonatomic, strong) NSArray* currenciesDisabled;

@end
