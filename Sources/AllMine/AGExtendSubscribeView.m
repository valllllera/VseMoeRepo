//
//  AGExtendSubscribeView.m
//  Всё моё
//
//  Created by Evgeniy Tka4enko on 24.10.13.
//  Copyright (c) 2013 Viacheslav Kaloshin. All rights reserved.
//

#import "AGExtendSubscribeView.h"

@interface AGExtendSubscribeView ()

@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@end

@implementation AGExtendSubscribeView

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
