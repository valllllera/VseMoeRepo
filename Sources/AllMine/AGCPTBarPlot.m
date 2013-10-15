//
//  AGCPTBarPlot.m
//  Всё Моё
//
//  Created by Allgoritm LLC on 3/26/13.
//  Copyright (c) 2013 Allgoritm LLC. All rights reserved.
//

#import "AGCPTBarPlot.h"
#import "UIColor+AGExtensions.h"

#import "AGAllMineDefines.h"

#import "CPTGraph.h"
#import "CPTPlotArea.h"
#import "CPTLayer.h"
#import "CPTPlot.h"

static NSTimeInterval startTimeEvent = 0;

@interface AGCPTBarPlot ()
-(CGMutablePathRef) newBarPathWithContext:(id) ctx recordIndex:(NSUInteger) i;
@end

@implementation AGCPTBarPlot

+(AGCPTBarPlot *)tubularBarPlotWithColor:(CPTColor *)color horizontalBars:(BOOL)horizontal {
    AGCPTBarPlot *barPlot =[[AGCPTBarPlot alloc] init];
    
    return barPlot;
}


-(NSUInteger)dataIndexFromInteractionPoint:(CGPoint)point
{
    NSUInteger barCount = self.cachedDataCount;
    NSUInteger ii       = 0;
    
    while (ii < barCount) {
        CGPathRef path = [self newBarPathWithContext:NULL recordIndex:ii];
        CGRect r =   CGPathGetBoundingBox(path);
        if(r.size.height != 0)
        {
            r.origin.y = 0;
            r.size.height = self.frame.size.height;
        }
        if (CGRectContainsPoint(r, point))
        {
            return ii;
        }
        
        CGPathRelease(path);
        ii++;
    }
    return NSNotFound;
}

-(BOOL) pointingDeviceUpEvent:(UIEvent *)event atPoint:(CGPoint)interactionPoint
{
    if([self.identifier isEqual:kPlotNeg] && self.cachedDataCount > 7)
    {
        return NO;
    }
    NSTimeInterval eventTime;
    
    CPTGraph *theGraph       = self.graph;
    CPTPlotArea *thePlotArea = self.plotArea;
    
    CGPoint plotAreaPoint = [theGraph convertPoint:interactionPoint toLayer:thePlotArea];
    NSUInteger idx   = [self dataIndexFromInteractionPoint:plotAreaPoint];
    
    if ( !theGraph || !thePlotArea || self.hidden || idx == NSNotFound) {
        if([self.delegate respondsToSelector:@selector(barPlot:barShortPressedAtRecordIndex:)])
        {
            [self.delegate barPlot:self barShortPressedAtRecordIndex:NSNotFound];
        }
        return NO;
    }
    
    eventTime=event.timestamp-startTimeEvent;
    if (eventTime>0.2) {
        if ([self.delegate respondsToSelector:@selector(barPlot:barLongPressedAtRecordIndex:)])
        {
            
            [self.delegate barPlot:self barLongPressedAtRecordIndex:idx];
        }
        
    }
    else
    {
        if([self.delegate respondsToSelector:@selector(barPlot:barShortPressedAtRecordIndex:)])
        {
            
            [self.delegate barPlot:self barShortPressedAtRecordIndex:idx];
        }
    }
    return YES;
}



-(BOOL) pointingDeviceDownEvent:(UIEvent *)event atPoint:(CGPoint)interactionPoint
{
    if([self.identifier isEqual:kPlotNeg] && self.cachedDataCount > 7)
    {
        return NO;
    }
    [self reloadData];
    startTimeEvent=event.timestamp;
    return YES;
}



/*- (void) barPlot:(AGCPTBarPlot *)plot barLongPressedAtRecordIndex:(NSUInteger)index
 {
 NSLog(@"LONG pres");
 }
 - (void) barPlot:(AGCPTBarPlot *)plot barShortPressedAtRecordIndex:(NSUInteger)index
 {
 NSLog(@"SHORT pres");
 }
 */

@end
