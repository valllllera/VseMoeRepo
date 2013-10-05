//
//  AGTools.m
//  AllMine
//
//  Created by Allgoritm LLC on 06.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "AGTools.h"
#import "UIColor+AGExtensions.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "AGAppDelegate.h"
#import "AGRootController.h"
#import "User+EntityWorker.h"

@implementation AGTools

+(void) navigationBarSetOffsetZero:(UINavigationBar*)navBar
{
    [navBar setTitleVerticalPositionAdjustment:kNavigationBarVerticalOffsetZero
                                                        forBarMetrics: UIBarMetricsDefault];
}

+(void) navigationBarSetOffsetStandart:(UINavigationBar*)navBar
{
    [navBar setTitleVerticalPositionAdjustment:kNavigationBarVerticalOffsetStandart
                                                       forBarMetrics:UIBarMetricsDefault];
}
+ (UIBarButtonItem*) navigationBarButtonItemWithImageNamed:(NSString*)imgName target:(id)target action:(SEL)action{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* img = [UIImage imageNamed:imgName];
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:[imgName stringByAppendingString:@"-pressed"]] forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

+ (UIBarButtonItem*) navigationBarButtonItemWithTitle:(NSString*)title imageNamed:(NSString*)imgName target:(id)target action:(SEL)action{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* img = [UIImage imageNamed:imgName];
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:[imgName stringByAppendingString:@"-pressed"]] forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    
    btn.titleLabel.font = [UIFont fontWithName:kFont1 size:12.0f];
    [btn setTitleColor:[UIColor colorWithHex:kColorHexWhite] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];}

+ (NSString*) accountGroupTitleWithGroup:(int)group{
    NSString* title = [NSString stringWithFormat:@"AccountGroup%d", group];
    return NSLocalizedString(title, @"");
}

+(UIView*) addStandardGradientSublayerToView:(UIView*)view{
    CALayer *layer = view.layer;
    layer.masksToBounds = YES;
    layer.borderWidth = 1.0f;
    layer.borderColor = [UIColor colorWithWhite:0.2f alpha:0.2f].CGColor;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.layer.bounds;
    
//    gradientLayer.colors = [NSArray arrayWithObjects:
//                            (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
//                            (id)[UIColor colorWithWhite:0.8f alpha:0.2f].CGColor,
//                            nil];
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
                            (id)[UIColor colorWithHex:0x7F97A4 alpha:0.1f].CGColor,
                            nil];
    
    gradientLayer.locations = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.0f],
                               [NSNumber numberWithFloat:1.0f],
                               nil];
    
    [view.layer addSublayer:gradientLayer];
    return view;
}

#pragma mark - table view
+ (void) tableViewPlain:(UITableView*)tableView
            configureCell:(UITableViewCell*)cell
            withIndexPath:(NSIndexPath*)indexPath{
    
    UIImageView *background;
    UIImageView* backgroundHighlighted;
    background=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_1"]];
    backgroundHighlighted=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_1-highlighted"]];
    [cell setBackgroundView:background];
    [cell setSelectedBackgroundView:backgroundHighlighted];
    cell.textLabel.highlightedTextColor=cell.textLabel.textColor;
    cell.detailTextLabel.highlightedTextColor=cell.detailTextLabel.textColor;
    [AGTools tableView:tableView
changeAccessoryArrowForCell:cell];
}

+ (void) tableViewGrouped:(UITableView*)tableView
            configureCell:(UITableViewCell*)cell
            withIndexPath:(NSIndexPath*)indexPath{

    UIImageView *background;
    UIImageView* backgroundHighlighted;
    if ([tableView numberOfRowsInSection:indexPath.section] == 1) {
        background = [[UIImageView alloc] initWithImage:
                      [UIImage imageNamed:@"cell-single"]];
        backgroundHighlighted = [[UIImageView alloc] initWithImage:
                                 [UIImage imageNamed:@"cell-single-highlighted"]];
    } else if (indexPath.row == 0) {
        background = [[UIImageView alloc] initWithImage:
                      [UIImage imageNamed:@"cell-top"]];
        backgroundHighlighted = [[UIImageView alloc] initWithImage:
                                 [UIImage imageNamed:@"cell-top-highlighted"]];
    } else if (indexPath.row ==
               [tableView numberOfRowsInSection:indexPath.section] - 1) {
        background = [[UIImageView alloc] initWithImage:
                      [UIImage imageNamed:@"cell-bottom"]];
        backgroundHighlighted = [[UIImageView alloc] initWithImage:
                                 [UIImage imageNamed:@"cell-bottom-highlighted"]];
    } else {
        background = [[UIImageView alloc] initWithImage:
                      [UIImage imageNamed:@"cell-middle"]];
        backgroundHighlighted = [[UIImageView alloc] initWithImage:
                                 [UIImage imageNamed:@"cell-middle-highlighted"]];
    }
    [cell setBackgroundView:background];
    cell.textLabel.highlightedTextColor=cell.textLabel.textColor;
    cell.detailTextLabel.highlightedTextColor=cell.detailTextLabel.textColor;
    [cell setSelectedBackgroundView:backgroundHighlighted];
    [AGTools tableView:tableView
changeAccessoryArrowForCell:cell];
}

+ (void) tableView:(UITableView*)tableView
changeAccessoryArrowForCell:(UITableViewCell*)cell{
    if (cell.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
        cell.accessoryView = [[UIImageView alloc]
                              initWithImage:[UIImage imageNamed:@"accessory-arrow"]];
    }else{
        cell.accessoryView = nil;
    }
}

+ (float) cellStandardHeight{
    //    if (isIphoneRetina4) {
    //        return 72.0f;
    //    }else{
    //        return 60.0f;
    //    }
    return kTableCellStandardHeight;
}

+(UIView*) tableViewGroupedHeaderViewWithTitle:(NSString*)title
                                        height:(double)height{
    UIView* v = [[UIView alloc] init];
    v.frame = CGRectMake(0, 0, 320, height);
    
    //  title
    UILabel* lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 270.0, v.frame.size.height)];
    lbTitle.font = [UIFont fontWithName:kFont1 size:14.0];
    lbTitle.textColor = [UIColor colorWithHex:kColorHexBrown];
    lbTitle.textAlignment = UITextAlignmentLeft;
    lbTitle.backgroundColor = [UIColor clearColor];
    lbTitle.text = title;

    [v addSubview:lbTitle];
    
    return v;
}

+(UIView*) tableViewGroupedFooterViewWithTitle:(NSString*)title
                                        height:(double)height
                                    numOfLines:(NSInteger)lines{
    UIView* v = [[UIView alloc] init];
    v.frame = CGRectMake(0, 0, 320, height);
    
    //  title
    UILabel* lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, v.frame.size.height)];
    lbTitle.font = [UIFont fontWithName:kFont1 size:13.0];
    lbTitle.textColor = [UIColor colorWithHex:kColorHexBrown];
    lbTitle.textAlignment = UITextAlignmentLeft;
    lbTitle.backgroundColor = [UIColor clearColor];
    lbTitle.text = title;
    lbTitle.numberOfLines = lines;
    lbTitle.textAlignment = NSTextAlignmentCenter;
    
    [v addSubview:lbTitle];
    
    return v;
}

+(UIView*) tableViewHeaderViewWithTitle:(NSString*)title height:(double)height{
    UIView* v = [[UIView alloc] init];
    v.frame = CGRectMake(0, 0, 320, height);
    
    v.backgroundColor = [UIColor colorWithHex:kColorHexHeader];
    v = [AGTools addStandardGradientSublayerToView:v];
    
    //  title
    UILabel* lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 290.0, v.frame.size.height)];
    lbTitle.font = [UIFont fontWithName:kFont1 size:14.0];
    lbTitle.textColor = [UIColor colorWithHex:kColorHexWhite];
    lbTitle.textAlignment = UITextAlignmentLeft;
    lbTitle.backgroundColor = [UIColor clearColor];
    lbTitle.text = title;
    
    lbTitle.layer.shadowOpacity = 1.0;
    lbTitle.layer.shadowRadius = 0.0;
    lbTitle.layer.shadowColor = [UIColor colorWithHex:kColorHexBlue].CGColor;
    lbTitle.layer.shadowOffset = CGSizeMake(0.0, -1.0);
    [v addSubview:lbTitle];
    
    return v;
}

#pragma mark - reachability
+ (BOOL) isReachable{
    Reachability* reachability = [Reachability reachabilityForInternetConnection];
    return [reachability isReachable];
}

+ (BOOL) isReachableWithAlert{
    BOOL reachable = [self isReachable];
    if (!reachable) {
        [self showAlertOkWithTitle:NSLocalizedString(@"Error", @"")
                           message:NSLocalizedString(@"NoConnection", @"")];
    }
    return reachable;
}

+ (BOOL) isReachableForSync{
    Reachability* reachability = [Reachability reachabilityForInternetConnection];
    BOOL reachable = YES;
    if ((kUser).syncViaWiFiOnly) {
        reachable = [reachability isReachableViaWiFi];
    }else{
        reachable = [reachability isReachable];
    }
    return reachable;
}

+ (BOOL) isReachableForSyncWithAlert{
    BOOL reachable = [self isReachableForSync];
    if (!reachable) {
        [self showAlertOkWithTitle:NSLocalizedString(@"Error", @"")
                           message:NSLocalizedString(@"NoConnection", @"")];
    }
    return reachable;
}

+ (void) showAlertOkWithTitle:(NSString*)title message:(NSString*)message{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
