//
//  AGAccountListController.h
//  AllMine
//
//  Created by Allgoritm LLC on 12.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    AccountListStateNone = 0,
    AccountListStateSelect
}AccountListState;

@class AGAccountListController;
@class Account;
@protocol AGAccountListControllerSelectDelegate <NSObject>

- (void) accountListController:(AGAccountListController*)accountListCtl didSelectAccount:(Account*)account;

@end

@interface AGAccountListController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, assign) AccountListState ctlState;
@property(nonatomic, assign) id<AGAccountListControllerSelectDelegate> delegateSelect;

@end
