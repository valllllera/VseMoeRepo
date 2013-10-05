//
//  AGCPTBarPlot.m
//  Всё Моё
//
//  Created by Allgoritm LLC on 3/26/13.
//  Copyright (c) 2013 Allgoritm LLC. All rights reserved.
//

#import "AGCPTBarPlot.h"
#import "UIColor+AGExtensions.h"

#import "CPTGraph.h"
#import "CPTPlotArea.h"
#import "CPTLayer.h"
#import "CPTPlot.h"

@interface AGCPTBarPlot ()
-(CGMutablePathRef) newBarPathWithContext:(id) ctx recordIndex:(NSUInteger) i;
@end

@implementation AGCPTBarPlot

@synthesize startTimeEvent;

+(AGCPTBarPlot *)tubularBarPlotWithColor:(CPTColor *)color horizontalBars:(BOOL)horizontal {
    AGCPTBarPlot *barPlot =[[AGCPTBarPlot alloc] init];
    
    return barPlot;
}


-(NSUInteger)dataIndexFromInteractionPoint:(CGPoint)point
{
    NSUInteger idx      = NSNotFound;
    NSUInteger barCount = self.cachedDataCount;
    NSUInteger ii       = 0;
    
 
    while ( (ii < barCount) && (idx == NSNotFound) ) {
        CGPathRef path = [self newBarPathWithContext:NULL recordIndex:ii];
     CGRect r =   CGPathGetBoundingBox(path);
        r.size.height=self.bounds.size.height;
        if (CGRectContainsPoint(r, point)) {
            idx=ii;
        }

        CGPathRelease(path);
        ii++;
    }
    return idx;
}

-(BOOL) pointingDeviceUpEvent:(UIEvent *)event atPoint:(CGPoint)interactionPoint
{
    NSTimeInterval eventTime;

    CPTGraph *theGraph       = self.graph;
    CPTPlotArea *thePlotArea = self.plotArea;
    
    CGPoint plotAreaPoint = [theGraph convertPoint:interactionPoint toLayer:thePlotArea];
    NSUInteger idx   = [self dataIndexFromInteractionPoint:plotAreaPoint];
    
    if ( !theGraph || !thePlotArea || self.hidden || idx==NSNotFound) {
        return NO;
    }
    
    
    eventTime=event.timestamp-startTimeEvent;
    if (eventTime>1) {
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
    [self reloadData];
    NSUInteger idx   = [self dataIndexFromInteractionPoint:interactionPoint];
    NSLog(@"IDX %d",idx);
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
