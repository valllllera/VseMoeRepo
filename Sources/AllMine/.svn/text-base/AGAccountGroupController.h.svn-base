//
//  AGAccountGroupController.h
//  AllMine
//
//  Created by Allgoritm LLC on 09.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AGAccountGroupController;
@protocol AGAccountGroupDelegate <NSObject>

- (void) accountGroupController:(AGAccountGroupController*)controller didFinishedSelectingGroup:(int)group;

@end

@interface AGAccountGroupController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) id<AGAccountGroupDelegate> delegate;
@property(nonatomic, assign) int group;

@end
