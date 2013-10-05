//
//  AGCPTBarPlot.h
//  Всё Моё
//
//  Created by Allgoritm LLC on 3/25/13.
//  Copyright (c) 2013 Allgoritm LLC. All rights reserved.
//

#import "CPTBarPlot.h"

@interface AGCPTBarPlot : CPTBarPlot

-(BOOL)plotSpace:(CPTPlotSpace *)space
shouldHandlePointingDeviceDownEvent:(id)event atPoint:(CGPoint)point;
-(BOOL)plotSpace:(CPTPlotSpace *)space
shouldHandlePointingDeviceUpEvent:(id)event atPoint:(CGPoint)point;

@end
