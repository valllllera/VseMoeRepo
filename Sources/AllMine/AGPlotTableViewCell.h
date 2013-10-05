//
//  AGPlotTableCellView.h
//  AllMine
//
//  Created by Allgoritm LLC on 14.12.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    AGPlotUnSigned,
    AGPlotSigned
}AGPlotTableCellStyle;

@class AGPlotTableViewCell;
@protocol AGPlotTableViewCellDelegate <NSObject>

- (void) agplotTableViewCellSelectedBarWithObject:(id)object barCenterY:(double)barCenterY;

@end

@interface AGPlotTableViewCell : UITableViewCell

@property(nonatomic, strong) id<AGPlotTableViewCellDelegate> delegate;

- (void)changeStateWithBarRect:(CGRect)rect
                     titleLeft:(NSString*)titleLeft
                    titleRight:(NSString*)titleRight
                       percent:(int)percent
                          sign:(int)sign
                        object:(id)object
                         style:(AGPlotTableCellStyle)style;

@end
