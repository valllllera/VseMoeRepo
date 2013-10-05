//
//  AGPaymentListController.h
//  AllMine
//
//  Created by Allgoritm LLC on 12.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Account;

@interface AGPaymentListController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) Account* account;
@property (weak, nonatomic) IBOutlet UIImageView *addImg;

@property(assign,nonatomic) BOOL isTapped;
@property(strong,nonatomic) NSMutableArray *arrayForCell;
@property(strong,nonatomic) NSMutableArray *arrayForCategories;
@property(strong,nonatomic) NSMutableArray *arrayForSum;
@property(strong,nonatomic) NSMutableArray *arrayForDate;
@property(strong,nonatomic) NSString *paymentTitle;

@property (strong,nonatomic) NSIndexPath * indexPathForCell;
@property(assign,nonatomic)NSInteger cellTag;

@end
