//
//  AGTools.h
//  AllMine
//
//  Created by Allgoritm LLC on 06.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGTools : NSObject

+(void) navigationBarSetOffsetZero:(UINavigationBar*)navBar;
+(void) navigationBarSetOffsetStandart:(UINavigationBar*)navBar;
+ (UIBarButtonItem*) navigationBarButtonItemWithImageNamed:(NSString*)imgName target:(id)target action:(SEL)action;
+ (UIBarButtonItem*) navigationBarButtonItemWithTitle:(NSString*)title imageNamed:(NSString*)imgName target:(id)target action:(SEL)action;

+ (NSString*) accountGroupTitleWithGroup:(int)group;

+(UIView*) addStandardGradientSublayerToView:(UIView*)view;

+ (void) tableViewGrouped:(UITableView*)tableView
            configureCell:(UITableViewCell*)cell
            withIndexPath:(NSIndexPath*)indexPath;

+ (void) tableViewPlain:(UITableView*)tableView
            configureCell:(UITableViewCell*)cell
            withIndexPath:(NSIndexPath*)indexPath;

+ (void) tableView:(UITableView*)tableView
changeAccessoryArrowForCell:(UITableViewCell*)cell;

+(UIView*) tableViewHeaderViewWithTitle:(NSString*)title
                                 height:(double)height;

+(UIView*) tableViewGroupedHeaderViewWithTitle:(NSString*)title
                                        height:(double)height;
+(UIView*) tableViewGroupedFooterViewWithTitle:(NSString*)title
                                        height:(double)height
                                    numOfLines:(NSInteger)lines;
+ (float) cellStandardHeight;


+ (BOOL) isReachable;
+ (BOOL) isReachableWithAlert;
+ (BOOL) isReachableForSync;
+ (BOOL) isReachableForSyncWithAlert;

+ (void) showAlertOkWithTitle:(NSString*)title message:(NSString*)message;

@end
