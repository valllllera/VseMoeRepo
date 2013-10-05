//
//  AGSettingsCategoryParentSelectController.h
//  Всё моё
//
//  Created by Allgoritm LLC on 27.02.13.
//  Copyright (c) 2013 Allgoritm LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Category+EntityWorker.h"

@class AGSettingsCategoryParentSelectController;
@protocol AGSettingsCategoryParentSelectControllerDelegate <NSObject>

- (void) settingsCategoryParentSelectController:(AGSettingsCategoryParentSelectController*)ctl didSelectCategory:(Category*)category;

@end

@interface AGSettingsCategoryParentSelectController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) Category* catSelected;
@property(nonatomic, assign) CatType type;

@property(nonatomic, strong) Category* supercat;

@property(nonatomic, assign) id<AGSettingsCategoryParentSelectControllerDelegate> delegate;

@end
