//
//  AGLoginListController.h
//  AllMine
//
//  Created by Allgoritm LLC on 02.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AGLoginListController;
@protocol AGLoginListDelegate <NSObject>

- (void) loginListController:(AGLoginListController*)controller didFinishedSelectingLogin:(NSString*)login;

@end

@interface AGLoginListController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, assign) id<AGLoginListDelegate> delegate;
@end

