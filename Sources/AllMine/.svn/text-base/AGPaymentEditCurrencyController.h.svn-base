//
//  AGPaymentEditCurrencyController.h
//  AllMine
//
//  Created by Allgoritm LLC on 13.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGCurrencyListController.h"
#import "AGKeyboardController.h"

@class Currency;

@protocol AGPaymentEditCurrencyDelegate <NSObject>

-(void)currencySelected:(Currency*)currency withRateValue:(double)rateValue;

@end

@interface AGPaymentEditCurrencyController : UIViewController<UITableViewDataSource, UITableViewDelegate, AGCurrencyListDelegate>

@property(nonatomic, strong) Currency* currency;
@property(nonatomic, strong) id<AGPaymentEditCurrencyDelegate> delegate;
@property(nonatomic, assign) double sum;
@property(nonatomic, strong) NSDate* date;
@property(nonatomic, assign) double rateValue;

@end
