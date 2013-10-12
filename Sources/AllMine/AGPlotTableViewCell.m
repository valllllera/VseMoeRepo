//
//  AGPlotTableCellView.m
//  AllMine
//
//  Created by Allgoritm LLC on 14.12.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "AGPlotTableViewCell.h"

#import "UIColor+AGExtensions.h"

@interface AGPlotTableViewCell ()

@property(nonatomic, assign) CGRect barRect;
@property(nonatomic, strong) NSString* titleName;
@property(nonatomic, strong) NSString* titleSum;
@property(nonatomic, strong) NSString* titlePercent;
@property(nonatomic, assign) int sign;
@property(nonatomic, strong) id object;
@property(nonatomic, assign) AGPlotTableCellStyle style;

@end

@implementation AGPlotTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self registerTapRecognizer];
    }
    return self;
}
- (void) registerTapRecognizer{
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)]];
}
- (void) tapGestureHandler:(UITapGestureRecognizer*) tapRecognizer{
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [tapRecognizer locationInView:self];
        if (CGRectContainsPoint(_barRect, point)) {
            if ([_delegate respondsToSelector:@selector(agplotTableViewCellSelectedBarWithObject:barCenterY:)]) {
                double barCenterY = self.frame.origin.y + _barRect.origin.y + _barRect.size.height/2;
                [_delegate agplotTableViewCellSelectedBarWithObject:_object barCenterY:barCenterY];
            }
        }
    }
}
- (void)changeStateWithBarRect:(CGRect)barRect
                     titleLeft:(NSString*)titleLeft
                    titleRight:(NSString*)titleRight
                       percent:(int)percent
                          sign:(int)sign
                        object:(id)object
                         style:(AGPlotTableCellStyle)style{
    _barRect = barRect;
    _titleName = [NSString stringWithString:titleLeft];
    _titleSum = [NSString stringWithString:titleRight];
    _sign = sign;
    _style = style;
    _object = object;
    if (self.style == AGPlotUnSigned) {
        self.titleSum = [NSString stringWithFormat:@"%@",
                           self.titleSum
                         ];
        self.titlePercent = [NSString stringWithFormat:@"%3d",percent];
    }else{
        if (sign<0) {
            NSString* buf_str=self.titleName;
            self.titleName=self.titleSum;
            self.titleSum=buf_str;
            self.titleSum = [NSString stringWithFormat:@"%@",
                               self.titleSum];
            self.titlePercent = [NSString stringWithFormat:@"%3d",percent];
        }else{
            self.titlePercent = [NSString stringWithFormat:@"%3d",percent];
        }
        
    }
    self.backgroundColor = [UIColor clearColor];
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    UIImage *plotBarImage = [[UIImage alloc] init];

    UIColor* clr = [UIColor colorWithHex:kColorHexPlotGreen];
    if (_sign > 0) {
        plotBarImage = [UIImage imageNamed:@"Column-plot-profit.png"];
    }else{
        plotBarImage = [UIImage imageNamed:@"Column-plot-Less.png"];
    }
    plotBarImage = [plotBarImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10) resizingMode:UIImageResizingModeStretch];
    /*const CGFloat* comp = CGColorGetComponents(clr.CGColor);
    CGContextSetRGBFillColor(context, comp[0], comp[1], comp[2], 1);
    CGContextFillRect(context, _barRect);*/

    clr = [UIColor colorWithHex:kColorHexPlotDarkGrey];
    //comp = CGColorGetComponents(clr.CGColor);
    //CGContextSetRGBFillColor(context, comp[0], comp[1], comp[2], 1);
    CGRect imageRect = _barRect;
    if(imageRect.origin.x < 5)
    {
        imageRect.origin.x = 5;
    }
    imageRect.origin.y += 2;
    imageRect.size.height -= 7;
    [plotBarImage drawInRect:imageRect];
    double fontSize = 14.0f;
    UIFont* font = [UIFont fontWithName:kFont1 size:fontSize];
    
    CGSize titleNameSize = [_titleName sizeWithFont:font];
    CGSize titleSumSize = [_titleSum sizeWithFont:font];
    double y = (_barRect.size.height-titleNameSize.height)/2 + _barRect.origin.y;
    
    double distance = 10.0f;
    [clr set];
    if (_style == AGPlotSigned) {

        double rightX = 0;   
        double rightWidth = _barRect.origin.x-distance;
        double leftX = _barRect.origin.x+distance;
        double leftWidth = rect.size.width-_barRect.origin.x;
        
        if (_sign < 0) {
            leftX = 0;
            leftWidth = _barRect.origin.x+_barRect.size.width-distance;
            rightX = _barRect.origin.x+_barRect.size.width+ distance;
            rightWidth = rect.size.width-_barRect.origin.x-_barRect.size.width-distance;
        }
        
    //    double dl = _sign>0 ? leftWidth - titleLeftSize.width : leftWidth - titleRightSize.width;
    //    if (dl < 0) {
    //        dl = abs(dl);
    //        leftWidth += dl;
    //        rightX += dl;
    //    }else{
    //        dl = _sign>0 ? rightWidth - titleRightSize.width : rightWidth - titleLeftSize.width;
    //        if (dl < 0) {
    //            dl = abs(dl);
    //            rightWidth += dl*1.1;
    //            rightX -= dl;
    //            leftX -= dl;
    //        }
    //    }
        if (_sign > 0) {            
            [_titleSum drawInRect:CGRectMake(leftX,
                                              y,
                                              leftWidth,
                                              titleNameSize.height)
                          withFont:font
                     lineBreakMode:NSLineBreakByTruncatingTail
                         alignment:NSTextAlignmentLeft];
            
            [_titleName drawInRect:CGRectMake(rightX+7,
                                               y,
                                               rightWidth,
                                               titleSumSize.height)
                           withFont:font
                      lineBreakMode:NSLineBreakByTruncatingTail
                          alignment:NSTextAlignmentRight];
            [[UIColor colorWithHex:0xA4A6A9] set];
            [_titlePercent drawInRect:CGRectMake(leftX-1,
                                                 y,
                                                 rightWidth,
                                                 titleSumSize.height)
                             withFont:font
                        lineBreakMode:NSLineBreakByTruncatingTail
                            alignment:NSTextAlignmentRight];
        }else{
            [_titleSum drawInRect:CGRectMake(rightX,
                                              y,
                                              rightWidth,
                                              titleNameSize.height)
                          withFont:font
                     lineBreakMode:NSLineBreakByTruncatingTail
                         alignment:NSTextAlignmentLeft];

            [_titleName drawInRect:CGRectMake(leftX+7,
                                               y,
                                               leftWidth,
                                               titleSumSize.height)
                           withFont:font
                      lineBreakMode:NSLineBreakByTruncatingTail
                          alignment:NSTextAlignmentRight];
            [[UIColor colorWithHex:0xA4A6A9] set];
            [_titlePercent drawInRect:CGRectMake(rightX-1,
                                              y,
                                              rightWidth,
                                              titleSumSize.height)
                          withFont:font
                     lineBreakMode:NSLineBreakByTruncatingTail
                         alignment:NSTextAlignmentRight];

        }
    }else if (_style == AGPlotUnSigned) {
                distance = 15;
        [_titleName drawInRect:CGRectMake(distance,
                                          y,
                                          self.frame.size.width/1.5-distance*2,
                                          titleSumSize.height)
                      withFont:font
                 lineBreakMode:NSLineBreakByTruncatingTail
                     alignment:NSTextAlignmentLeft];

 
        [_titleSum drawInRect:CGRectMake(self.frame.size.width/2+distance-23,
                                          y,
                                          self.frame.size.width/2-distance*2,
                                          titleNameSize.height)
                      withFont:font
                 lineBreakMode:NSLineBreakByTruncatingTail
                     alignment:NSTextAlignmentRight];
               [[UIColor colorWithHex:0xA4A6A9] set];
        [_titlePercent drawInRect:CGRectMake(self.frame.size.width/2+distance+15,
                                             y,
                                             self.frame.size.width/2-distance*2,
                                             titleNameSize.height)
                         withFont:font
                    lineBreakMode:NSLineBreakByTruncatingTail
                        alignment:NSTextAlignmentRight];


          }else{
        distance = 15;
        [_titleName drawInRect:CGRectMake(self.frame.size.width/2+distance,
                                           y,
                                           self.frame.size.width/2-distance*2,
                                           titleSumSize.height)
                       withFont:font
                  lineBreakMode:NSLineBreakByTruncatingTail
                      alignment:NSTextAlignmentRight];
    
        
        [_titleSum drawInRect:CGRectMake(distance-30,
                                         y,
                                         self.frame.size.width/2-distance*2,
                                         titleNameSize.height)
                     withFont:font
                lineBreakMode:NSLineBreakByTruncatingTail
                    alignment:NSTextAlignmentLeft];
        [[UIColor colorWithHex:0xA4A6A9] set];
              [_titlePercent drawInRect:CGRectMake(distance,
                                                   y,
                                                   self.frame.size.width/2-distance*2,
                                                   titleNameSize.height)
                               withFont:font
                          lineBreakMode:NSLineBreakByTruncatingTail
                              alignment:NSTextAlignmentRight];


    }
}

@end
