//
//  AGExtendSubscribeView.h
//  Всё моё
//
//  Created by Evgeniy Tka4enko on 24.10.13.
//  Copyright (c) 2013 Viacheslav Kaloshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGExtendSubscribeView : UIView

@property (copy, nonatomic) void (^successBlock)(NSUInteger index);

@end
