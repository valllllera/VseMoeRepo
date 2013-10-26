//
//  AGConfirmSubscribeView.h
//  Всё моё
//
//  Created by Evgeniy Tka4enko on 26.10.13.
//  Copyright (c) 2013 Viacheslav Kaloshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGConfirmSubscribeView : UIView

@property (copy, nonatomic) void (^successBlock)(NSUInteger index);
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end
