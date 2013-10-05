//
//  AGSettingsCategoryEditController.h
//  AllMine
//
//  Created by Allgoritm LLC on 08.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Category+EntityWorker.h"
#import "AGSettingsCategoryParentSelectController.h"

@interface AGSettingsCategoryEditController : UIViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, AGSettingsCategoryParentSelectControllerDelegate>

@property(nonatomic, strong) Category* category;
@property(nonatomic, strong) Category* supercat;
@property(nonatomic, assign) CatType type;

@end
