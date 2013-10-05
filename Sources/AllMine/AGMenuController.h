//
//  AGMenuController.h
//  AllMine
//
//  Created by Allgoritm LLC on 01.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;

@interface AGMenuController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) IBOutlet UITableView* tvMenu;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImageBalance;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImageTotal;

@end
