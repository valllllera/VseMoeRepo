//
//  UIView+Additions.h
//  Всё моё
//
//  Created by Evgeniy Tka4enko on 24.10.13.
//  Copyright (c) 2013 Viacheslav Kaloshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Additions)

- (void)hide:(BOOL)animated;
- (void)show:(BOOL)animated;

- (void)hide:(BOOL)animated completion:(void(^)())completionBlock;
- (void)show:(BOOL)animated completion:(void(^)())completionBlock;

@end
