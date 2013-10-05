//
//  AGPaymentSplitController.h
//  AllMine
//
//  Created by Allgoritm LLC on 14.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGSettingsCategoriesController.h"
#import "AGKeyboardController.h"
#import "AGPaymentSplitCell.h"

@class Category;
@protocol AGPaymentSplitDelegate <NSObject>

- (void) splitFinishedWithArray:(NSArray*) result;

@end

@interface AGPaymentSplitController : UIViewController<UITableViewDataSource, UITableViewDelegate, AGSettingsCategoriesDelegate, AGKeyboardDelegate, AGPaymentSplitCellDelegate>

@property(nonatomic, assign) double sum;
@property(nonatomic, strong) Category* category;
@property(nonatomic, strong) id<AGPaymentSplitDelegate> delegate;
@property(nonatomic, strong) NSMutableArray* subpayments;

@end
