//
//  UIView+Additions.m
//  Всё моё
//
//  Created by Evgeniy Tka4enko on 24.10.13.
//  Copyright (c) 2013 Viacheslav Kaloshin. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)

static CGFloat const kAnimationDuration = 0.4f;

- (void)hide:(BOOL)animated
{
    [self hide:animated completion:nil];
}

- (void)show:(BOOL)animated
{
    [self show:animated completion:nil];
}

- (void)hide:(BOOL)animated completion:(void(^)())completionBlock
{
    if(self.hidden)
    {
        if(completionBlock)
        {
            completionBlock();
        }
        
        return;
    }
    if(animated)
    {
        [UIView animateWithDuration:kAnimationDuration delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction animations:^{
            self.alpha = 0.0f;
        } completion:^(BOOL finished) {
            if(finished)
            {
                self.hidden = YES;
                self.alpha = 1.0f;
                
                if(completionBlock)
                {
                    completionBlock();
                }
            }
        }];
    }
    else
    {
        self.hidden = YES;
        
        if(completionBlock)
        {
            completionBlock();
        }
    }
}

- (void)show:(BOOL)animated completion:(void(^)())completionBlock
{
    if(animated)
    {
        if(self.hidden)
        {
            self.alpha = 0.0f;
            self.hidden = NO;
        }
        
        [UIView animateWithDuration:kAnimationDuration delay:0.0f options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.alpha = 1.0f;
        } completion:^(BOOL finished) {
            
            if(completionBlock && finished)
            {
                completionBlock();
            }
            
        }];
    }
    else
    {
        if(self.hidden)
        {
            self.hidden = NO;
        }
        self.alpha = 1.0f;
        
        if(completionBlock)
        {
            completionBlock();
        }
    }
}

@end
