//
//  AGConfirmSubscribeView.m
//  Всё моё
//
//  Created by Evgeniy Tka4enko on 26.10.13.
//  Copyright (c) 2013 Viacheslav Kaloshin. All rights reserved.
//

#import "AGConfirmSubscribeView.h"

@interface AGConfirmSubscribeView ()

@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@end

@implementation AGConfirmSubscribeView

- (void)awakeFromNib
{
    _bgView.image = [_bgView.image resizableImageWithCapInsets:UIEdgeInsetsMake(91, 0, 91, 0)];
}

- (IBAction)buttonPressed:(id)sender
{
    if(_successBlock)
    {
        _successBlock([sender tag]);
    }
}

@end
