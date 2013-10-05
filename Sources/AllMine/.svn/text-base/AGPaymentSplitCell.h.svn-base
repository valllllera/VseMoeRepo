//
//  AGPaymentSplitCell.h
//  Всё моё
//
//  Created by Allgoritm LLC on 07.03.13.
//  Copyright (c) 2013 Allgoritm LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AGPaymentSplitCell;
@protocol AGPaymentSplitCellDelegate <NSObject>

- (void) paymentSplitCellBalancePressed:(AGPaymentSplitCell*)cell;
- (void) paymentSplitCellCategoryPressed:(AGPaymentSplitCell*)cell;

@end

@interface AGPaymentSplitCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
           delegate:(id<AGPaymentSplitCellDelegate>)delegate
         cellHeight:(float)cellHeight;

- (void) setTitleCategory:(NSString*)value;
- (void) setTitleBalance:(NSString*)value;

- (void) setColorCategory:(UIColor*)value;
- (void) setColorBalance:(UIColor*)value;

@end
