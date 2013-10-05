//
//  AGCPTBarPlot.m
//  Всё Моё
//
//  Created by Allgoritm LLC on 3/25/13.
//  Copyright (c) 2013 Allgoritm LLC. All rights reserved.
//

#import "AGCPTBarPlot.h"

@implementation AGCPTBarPlot

-(BOOL)plotSpace:(CPTPlotSpace *)space
shouldHandlePointingDeviceDownEvent:(id)event atPoint:(CGPoint)point
{
    
}

-(BOOL)pointingDeviceDownEvent:(CPTNativeEvent *)event atPoint:(CGPoint)interactionPoint
{
    CPTGraph *theGraph       = self.graph;
    CPTPlotArea *thePlotArea = self.plotArea;
    
    if ( !theGraph || !thePlotArea ) {
        return NO;
    }
    
    id<CPTBarPlotDelegate> theDelegate = self.delegate;
      
    return [super pointingDeviceDownEvent:event atPoint:interactionPoint];
}

@end
