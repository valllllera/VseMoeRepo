//
//  AGPaymentAddFavouriteNewController.h
//  AllMine
//
//  Created by Allgoritm LLC on 16.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGSettingsCategoriesController.h"
#import "AGAccountListController.h"

@class Currency;
@class Template;
@class Payment;
@class AGTemplateEditController;
@protocol AGAccountListControllerSelectDelegate;

@protocol AGTemplateEditControllerDelegate <NSObject>

- (void) templateEditController:(AGTemplateEditController*)templateEditController
                didAddedPayment:(Payment*)payment;

@end

@interface AGTemplateEditController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, AGSettingsCategoriesDelegate, AGAccountListControllerSelectDelegate>

@property(nonatomic, assign) double sum;

@property(nonatomic, strong) Currency* currency;
@property(nonatomic, assign) double rateValue;

@property(nonatomic, strong) NSMutableArray* subpayments;

@property(nonatomic, strong) Template* ptemplate;

@property(nonatomic, assign) BOOL addPayment;

@property(nonatomic, strong) id<AGTemplateEditControllerDelegate> delegate;

@end
