//
//  AGSettingsCategoriesController.h
//  AllMine
//
//  Created by Allgoritm LLC on 08.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Category;
@class Account;

@protocol AGSettingsCategoriesDelegate <NSObject>

- (void) selectedCategory:(Category*) category;
@optional - (void) selectedAccount:(Account*) account;

@end

@interface AGSettingsCategoriesController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate>

@property(nonatomic, strong) NSArray* subCats;
@property(nonatomic, strong) Category* category;
@property(nonatomic, assign) int segmentIndex;
@property(nonatomic, strong) AGSettingsCategoriesController* rootCtl;
@property(nonatomic, strong) id<AGSettingsCategoriesDelegate> delegate;

- (void) segmentSelectionChanged;

@end
