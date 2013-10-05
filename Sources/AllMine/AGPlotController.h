//
//  AGPlotController.h
//  AllMine
//
//  Created by Allgoritm LLC on 10.12.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "User+EntityWorker.h"

#import "AGPlotTableViewCell.h"

@interface AGPlotController : UIViewController<CPTPlotDataSource, AGPlotTableViewCellDelegate>

@property(nonatomic, strong) Account* account;
@property(nonatomic, assign) ReportTypeY type;

- (IBAction)timeButtonPressed:(id)sender;
- (IBAction)categoryButtonPressed:(id)sender;


@end
