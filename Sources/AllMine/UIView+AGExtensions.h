//
//  UIView+AGExtensions.h
//  AllMine
//
//  Created by Allgoritm LLC on 09.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^AGAnimationCompletion)(BOOL finished);

@interface UIView (AGExtensions)

- (void) moveToPoint:(CGPoint)point;
- (void) moveToScreenBottom;
- (void) moveOut;

- (void) slideToPoint:(CGPoint)point;
- (void) slideToScreenBottom;
- (void) slideOut;

- (void) slideToPoint:(CGPoint)point
       withCompletion:(AGAnimationCompletion)completion;
- (void) slideToScreenBottom:(AGAnimationCompletion)completion;
- (void) slideOutWithCompletion:(AGAnimationCompletion)completion;

- (void) hideAnimated;
- (void) showAnimated;

- (void) sizeChangeAnimated:(CGSize)sizeNew;
- (void) sizeChange:(CGSize)sizeNew;
- (void) sizeReturnAnimated;
- (void) sizeReturn;

- (void) shake;

@end
