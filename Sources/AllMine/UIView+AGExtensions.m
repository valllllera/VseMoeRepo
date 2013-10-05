//
//  UIView+AGExtensions.m
//  AllMine
//
//  Created by Allgoritm LLC on 09.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//
#import "UIView+AGExtensions.h"

#define kViewInfoKeyOrigin  @"origin"
#define kViewInfoKeySize    @"size"

@implementation UIView (AGExtensions)

NSMutableDictionary* viewInfo;

#pragma mark - key
- (NSString*)keyWithKey:(NSString*)key{
    return [NSString stringWithFormat:@"%@%d", key, self.tag];
}

#pragma mark - slide
- (void) slideToPoint:(CGPoint)point{
    [self slideToPoint:point
        withCompletion:nil];
}
- (void) slideToPoint:(CGPoint)point
       withCompletion:(AGAnimationCompletion)completion{
    if (viewInfo == nil) {
        viewInfo = [NSMutableDictionary dictionary];
    }
    [viewInfo setObject:[NSValue valueWithCGPoint:self.frame.origin]
                 forKey:[self keyWithKey:kViewInfoKeyOrigin]];
    
    [UIView animateWithDuration:kSlideAnimationTime
                          delay:0
                        options:0
                     animations:^{
                         CGRect frame = self.frame;
                         frame.origin.x = point.x;
                         frame.origin.y = point.y;
                         self.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         if (completion) {
                             completion(finished);
                         }
                     }];
}

- (void) slideToScreenBottom{
    [self slideToScreenBottom:nil];
}
- (void) slideToScreenBottom:(AGAnimationCompletion)completion{
	CGPoint point;
    point.y = [[UIScreen mainScreen] bounds].size.height - self.frame.size.height-20;
    [self slideToPoint:point withCompletion:completion];
}

- (void) slideOut{
    [self slideOutWithCompletion:nil];
}
- (void) slideOutWithCompletion:(AGAnimationCompletion)completion{
    if (viewInfo == nil) {
        viewInfo = [NSMutableDictionary dictionary];
    }
    CGPoint origin = [[viewInfo objectForKey:[self keyWithKey:kViewInfoKeyOrigin]] CGPointValue];
    [UIView animateWithDuration:kSlideAnimationTime
                          delay:0
                        options:0
                     animations:^{
                         CGRect frame = self.frame;
                         frame.origin.x = origin.x;
                         frame.origin.y = origin.y;
                         self.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         if (completion) {
                             completion(finished);
                         }
                     }];    
}

#pragma mark - move
- (void) moveToPoint:(CGPoint)point{

    if (viewInfo == nil) {
        viewInfo = [NSMutableDictionary dictionary];
    }
    [viewInfo setObject:[NSValue valueWithCGPoint:self.frame.origin]
                 forKey:[self keyWithKey:kViewInfoKeyOrigin]];
    
	CGRect frame = self.frame;
    frame.origin.x = point.x;
    frame.origin.y = point.y;
    self.frame = frame;
}

- (void) moveToScreenBottom{
	CGPoint point;
    point.y = [[UIScreen mainScreen] bounds].size.height - self.frame.size.height-20;
    [self moveToPoint:point];
}

- (void) moveOut{
    if (viewInfo == nil) {
        viewInfo = [NSMutableDictionary dictionary];
    }
    CGPoint origin = [[viewInfo objectForKey:[self keyWithKey:kViewInfoKeyOrigin]] CGPointValue];
//    [viewInfo removeObjectForKey:[self keyWithKey:kViewInfoKeyOrigin]];
    
    CGRect frame = self.frame;
    frame.origin.x = origin.x;
    frame.origin.y = origin.y;
    self.frame = frame;
}

#pragma mark - hide
- (void) hideAnimated{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kSlideAnimationTime];
    
    self.alpha = 0.0f;
    
    [UIView commitAnimations];
}


- (void) showAnimated{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kSlideAnimationTime];
    
    self.alpha = 1.0f;
    
    [UIView commitAnimations];
}


#pragma mark - size
- (void) sizeChange:(CGSize)sizeNew{
    if (viewInfo == nil) {
        viewInfo = [NSMutableDictionary dictionary];
    }
    [viewInfo setObject:[NSValue valueWithCGSize:self.frame.size] forKey:[self keyWithKey:kViewInfoKeySize]];

    CGRect frame = self.frame;
    frame.size = sizeNew;
    self.frame = frame;
}
- (void) sizeChangeAnimated:(CGSize)sizeNew{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kSlideAnimationTime];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    [self sizeChange:sizeNew];
    
    [UIView commitAnimations];
}

- (void) sizeReturn{
    if (viewInfo == nil) {
        viewInfo = [NSMutableDictionary dictionary];
    }
    if ([viewInfo objectForKey:[self keyWithKey:kViewInfoKeySize]]) {
        CGSize sizeOld = [[viewInfo objectForKey:[self keyWithKey:kViewInfoKeySize]] CGSizeValue];
    //    [viewInfo removeObjectForKey:[self keyWithKey:kViewInfoKeySize]];
        
        CGRect frame = self.frame;
        frame.size = sizeOld;
        self.frame = frame;
    }
}
- (void) sizeReturnAnimated{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kSlideAnimationTime];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    [self sizeReturn];
    
    [UIView commitAnimations];
}

#pragma mark - shake
- (void)shake
{
    CGFloat dx = 2.0;
    CGAffineTransform translateRight  = CGAffineTransformTranslate(CGAffineTransformIdentity, dx, 0.0);
    CGAffineTransform translateLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -dx, 0.0);
	
    self.transform = translateLeft;
	
    UIColor* clr = self.backgroundColor;
    self.backgroundColor = [UIColor redColor];
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundColor = clr;
    }];
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        self.transform = translateRight;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.transform = CGAffineTransformIdentity;
            } completion:nil];
        }
    }];
}

@end
