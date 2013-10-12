//
//  AGCPTBarPlot.h
//  Всё Моё
//
//  Created by Allgoritm LLC on 3/26/13.
//  Copyright (c) 2013 Allgoritm LLC. All rights reserved.
//


#import "CPTBarPlot.h"



@class AGCPTBarPlot;

@protocol AGCPTBarPlotDelegate <NSObject>

- (void) barPlot:(AGCPTBarPlot *)plot barLongPressedAtRecordIndex:(NSUInteger)index;
- (void) barPlot:(AGCPTBarPlot *)plot barShortPressedAtRecordIndex:(NSUInteger)index;

@end


@interface AGCPTBarPlot : CPTBarPlot

@property(nonatomic, strong) id<AGCPTBarPlotDelegate> delegate;

@property (nonatomic,assign) NSTimeInterval startTimeEvent;
@property (nonatomic,assign) CGPoint bufPoint;


- (void) barPlot:(AGCPTBarPlot *)plot barLongPressedAtRecordIndex:(NSUInteger)index;
- (void) barPlot:(AGCPTBarPlot *)plot barShortPressedAtRecordIndex:(NSUInteger)index;

-(BOOL) pointingDeviceUpEvent:(UIEvent *)event atPoint:(CGPoint)interactionPoint;
-(BOOL) pointingDeviceDownEvent:(UIEvent *)event atPoint:(CGPoint)interactionPoint;


@end
