//
//  AGPlotPopover.h
//  Всё моё
//
//  Created by Evgeniy Tka4enko on 13.10.13.
//  Copyright (c) 2013 Viacheslav Kaloshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGPlotPopover : UIView

- (id)initWithFrame:(CGRect)frame date:(NSString *)dateString sum:(NSString *)sumString;

- (id)initWithFrame:(CGRect)frame date:(NSString *)dateString sum1:(NSString *)sum1String sum2:(NSString *)sum2String total:(NSString *)totalString;

@end
