//
//  AGPlotTableController.h
//  AllMine
//
//  Created by Allgoritm LLC on 14.12.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGPlotTableViewCell.h"

#import "AGPlotController.h"

@interface AGPlotTableViewController : UITableViewController

@property(nonatomic, strong) id<AGPlotTableViewCellDelegate> delegate;

@property(nonatomic, assign) AGPlotController* parent;

- (id)initWithFrame:(CGRect)frame;
- (void) reloadData:(NSArray*)data;

@end
