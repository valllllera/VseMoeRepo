//
//  AGMenuController.m
//  AllMine
//
//  Created by Allgoritm LLC on 01.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "AGMenuController.h"
#import "AGAppDelegate.h"
#import "NSDate+AGExtensions.h"
#import "AGRootController.h"
#import "AGSettingsController.h"
#import "AGTools.h"

#import "UIColor+AGExtensions.h"
#import "UILabel+AGExtensions.h"
#import <QuartzCore/QuartzCore.h>

#import "User.h"
#import "Currency.h"

#import "AGAccountListController.h"
#import "AGPaymentListController.h"
#import "AGPaymentEditController.h"
#import "AGPaymentAddFavouriteController.h"

#import "User+EntityWorker.h"
#import "Account+EntityWorker.h"
#import "Category+EntityWorker.h"

#import "AGDBWorker.h"

#import "AGLoginController.h"

@interface AGMenuController ()

@end

@implementation AGMenuController

@synthesize tvMenu = _tvMenu;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.navigationItem.title = NSLocalizedString(@"MenuReview", @"");
    self.navigationItem.leftBarButtonItem = [AGTools navigationBarButtonItemWithImageNamed:@"button-settings" target:self action:@selector(toSettings)];
    self.navigationItem.rightBarButtonItem = [AGTools navigationBarButtonItemWithImageNamed:@"button-sync" target:self action:@selector(synchronize)];
    
    _tvMenu.scrollEnabled = NO;
    _tvMenu.delegate = self;
    _tvMenu.dataSource = self;

//    NSArray* familyNames = [UIFont familyNames];
//    for (int indFamily=0; indFamily<[familyNames count]; ++indFamily){
//        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
//        NSArray* fontNames = [[NSArray alloc] initWithArray:[UIFont fontNamesForFamilyName:[familyNames objectAtIndex:indFamily]]];
//        for (int indFont=0; indFont<[fontNames count]; ++indFont){
//            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
//        }
//    }
//    UIFont* font1 = [UIFont fontWithName:kFont1 size:10.0f];
//    UIFont* font2 = [UIFont fontWithName:kFont2 size:10.0f];
//    int a =1;
}

-(void)viewWillAppear:(BOOL)animated{
    [_tvMenu reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(eventSyncFinishedHandler)
                                                 name:kEventSyncFinished
                                               object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)eventSyncFinishedHandler{
    [_tvMenu reloadData];
}

#pragma  mark - Buttons
- (void) toFavourite{
    AGPaymentAddFavouriteController* ctl = [[AGPaymentAddFavouriteController alloc] initWithNibName:@"AGPaymentAddFavouriteView" bundle:nil];
    ctl.hidesBottomBarWhenPushed = YES;    
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void) toPaymentAdd{
    AGPaymentEditController* ctl = [[AGPaymentEditController alloc] initWithNibName:@"AGPaymentEditView" bundle:nil];
    ctl.hidesBottomBarWhenPushed = YES;                
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void) toSettings{
    AGSettingsController* ctl = [[AGSettingsController alloc] initWithNibName:@"AGSettingsView" bundle:nil];
    ctl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void) synchronize{
    if ([AGTools isReachableForSyncWithAlert]) {
        [(kRoot) blockWindowWithActivityIndicator:YES];
        [(kRoot) synchronize];
        [(kRoot) blockWindowWithActivityIndicator:NO];
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* CellIdentifier = [NSString stringWithFormat:@"%@%d", @"menuCell", indexPath.row];
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
        cell.tag = 0;
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }else{
        for (UIView* v in cell.contentView.subviews) {
            if (([v isKindOfClass:[UILabel class]]) || ([v isKindOfClass:[UIButton class]])) {
                [v removeFromSuperview];
            }
        }
    }

    User* usr = kUser;
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.userInteractionEnabled = NO;
    
        UILabel* lb = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 200, 22)];
        lb.backgroundColor = [UIColor clearColor];
        lb.textColor = [UIColor colorWithHex:kColorHexBrown];
        lb.font = [UIFont fontWithName:kFont1
                                  size:14.0f];
        lb.text = [[NSDate date] dateTitle];
        [cell.contentView addSubview:lb];

        UILabel* lbDetail = [[UILabel alloc] initWithFrame:CGRectMake(260, 15, 40, 22)];
        lbDetail.backgroundColor = [UIColor clearColor];
        lbDetail.textColor = [UIColor colorWithHex:kColorHexGray];
        lbDetail.font = [UIFont fontWithName:kFont1
                                  size:13.0f];
        lbDetail.text = usr.currencyMain.title;
        [cell.contentView addSubview:lbDetail];
        
        UIImageView *background;
        background=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell-top-main-menu"]];
        [cell setBackgroundView:background];
                //  gradient
/*        if (cell.tag == 0) {
            cell.tag = 1;
            CALayer *layer = cell.layer;
            
            CGRect frame = layer.bounds;
            frame.size.height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
            layer.bounds = frame;
            
            layer.masksToBounds = YES;
            layer.borderWidth = 1.0f;
            layer.borderColor = [UIColor colorWithWhite:0.2f alpha:0.2f].CGColor;
            
            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
            gradientLayer.frame = cell.layer.bounds;
            
            gradientLayer.colors = [NSArray arrayWithObjects:
                                 (id)[UIColor colorWithWhite:0.4f alpha:0.2f].CGColor,
                                 (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
                                 (id)[UIColor colorWithWhite:0.6f alpha:0.2f].CGColor,
                                 (id)[UIColor colorWithWhite:0.4f alpha:0.2f].CGColor,
                                 (id)[UIColor colorWithWhite:0.8f alpha:0.2f].CGColor,
                                 nil];
            gradientLayer.locations = [NSArray arrayWithObjects:
                                    [NSNumber numberWithFloat:0.0f],
                                    [NSNumber numberWithFloat:0.1f],
                                    [NSNumber numberWithFloat:0.3f],
                                    [NSNumber numberWithFloat:0.8f],
                                    [NSNumber numberWithFloat:1.0f],
                                    nil];
            
            [cell.layer addSublayer:gradientLayer];
        }
 */
    }else if ((indexPath.row == 1) || (indexPath.row == 2)){
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.userInteractionEnabled = YES;
        
        float yOffsetRetina = isIphoneRetina4 ? 26 : 0;
        
        // ......
        UILabel* lbDots1 = [[UILabel alloc] initWithFrame:CGRectMake(90, 50 + yOffsetRetina, 200, 22)];
        lbDots1.font = [UIFont fontWithName:kFont1 size:10.0f];
        lbDots1.textColor = [UIColor colorWithHex:kColorHexBrown];
        lbDots1.backgroundColor=[UIColor clearColor];
        lbDots1.text = @". . . . . . . . . . . . . . . . . . . . . . .";
        [cell.contentView addSubview:lbDots1];
        
        UILabel* lbDots2 = [[UILabel alloc] initWithFrame:CGRectMake(90, 72 + yOffsetRetina, 200, 22)];
        lbDots2.font = [UIFont fontWithName:kFont1 size:10.0f];
        lbDots2.textColor = [UIColor colorWithHex:kColorHexBrown];
        lbDots2.backgroundColor=[UIColor clearColor];
        lbDots2.text = @". . . . . . . . . . . . . . . . . . . . . . .";
        [cell.contentView addSubview:lbDots2];
        
        //  title1
        UILabel* lbTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(30, 20 + yOffsetRetina, 120, 24)];
        lbTitle1.font = [UIFont fontWithName:kFont1 size:18.0f];
        lbTitle1.backgroundColor=[UIColor clearColor];
        lbTitle1.textColor = [UIColor colorWithHex:kColorHexBlue];
        lbTitle1.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:lbTitle1];
        
        UILabel* lbSum1 = [[UILabel alloc] initWithFrame:CGRectMake(150, 20 + yOffsetRetina, 140, 24)];
        lbSum1.font = [UIFont fontWithName:kFont1 size:18.0f];
        lbSum1.textColor = [UIColor colorWithHex:kColorHexBlue];
        lbSum1.backgroundColor=[UIColor clearColor];
        lbSum1.adjustsFontSizeToFitWidth = YES;
        lbSum1.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:lbSum1];
        
        //  title2
        UILabel* lbTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(30, 48 + yOffsetRetina, 260, 24)];
        lbTitle2.font = [UIFont fontWithName:kFont1 size:10.0f];
        lbTitle2.textColor = [UIColor colorWithHex:kColorHexBrown];
        lbTitle2.backgroundColor = [UIColor clearColor];        
        [cell.contentView addSubview:lbTitle2];
        
        UILabel* lbSum2 = [[UILabel alloc] initWithFrame:CGRectMake(150, 48 + yOffsetRetina, 140, 24)];
        lbSum2.font = [UIFont fontWithName:kFont1 size:16.0f];
        lbSum2.adjustsFontSizeToFitWidth = YES;
        lbSum2.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:lbSum2];
        
        //  title3
        UILabel* lbTitle3 = [[UILabel alloc] initWithFrame:CGRectMake(30, 70 + yOffsetRetina, 260, 24)];
        lbTitle3.font = [UIFont fontWithName:kFont1 size:10.0f];
        lbTitle3.textColor = [UIColor colorWithHex:kColorHexBrown];
        lbTitle3.backgroundColor = [UIColor clearColor];        
        [cell.contentView addSubview:lbTitle3];
        
        UILabel* lbSum3 = [[UILabel alloc] initWithFrame:CGRectMake(150, 70 + yOffsetRetina, 140, 24)];
        lbSum3.font = [UIFont fontWithName:kFont1 size:16.0f];
        lbSum3.adjustsFontSizeToFitWidth = YES;
        lbSum3.backgroundColor = [UIColor clearColor];        
        [cell.contentView addSubview:lbSum3];
        
        if(indexPath.row == 1){
            double income = [usr balanceForCurrentMonthWithCategoryType:CatTypeIncome];
            double expense = [usr balanceForCurrentMonthWithCategoryType:CatTypeExpense];
            
            lbTitle1.text = NSLocalizedString(@"MenuRemainder", @"");
            [lbSum1 setTextFromNumber:(income+expense) asInteger:YES withColor:[UIColor colorWithHex:kColorHexBlue]];
            
            lbTitle2.text = [NSLocalizedString(@"MenuIncome", @"") uppercaseString];
            [lbSum2 setTextFromNumber:income asInteger:NO withColor:nil];
            
            lbTitle3.text = [NSLocalizedString(@"MenuExpense", @"") uppercaseString];
            [lbSum3 setTextFromNumber:expense
                            asInteger:NO
                            withColor:nil];
        }else{
            double allMine = [usr balanceWithAccountGroup:AccGroupAllMine];
            double debts = [usr balanceWithAccountGroup:AccGroupDebts];
            double none = [usr balanceWithAccountGroup:AccGroupNone];
            
            lbTitle1.text = NSLocalizedString(@"MenuTotal", @"");
            [lbSum1 setTextFromNumber:(allMine+debts+none) asInteger:YES withColor:[UIColor colorWithHex:kColorHexBlue]];
            lbTitle2.text = [[AGTools accountGroupTitleWithGroup:AccGroupAllMine] uppercaseString];
            [lbSum2 setTextFromNumber:allMine asInteger:NO withColor:nil];
            lbTitle3.text = [[AGTools accountGroupTitleWithGroup:AccGroupDebts] uppercaseString];
            [lbSum3 setTextFromNumber:debts
                            asInteger:NO
                            withColor:nil];
        }
        [lbSum2 sizeToFit];
        if(lbSum2.frame.size.width > 140){
            CGRect frame = lbSum2.frame;
            frame.size.width = 140;
            lbSum2.frame = frame;
        }else{
            CGRect frame = lbSum2.frame;
            frame.origin.x = 290 - frame.size.width;
            lbSum2.frame = frame;
        }
        [lbSum3 sizeToFit];
        if(lbSum3.frame.size.width > 140){
            CGRect frame = lbSum3.frame;
            frame.size.width = 140;
            lbSum3.frame = frame;
        }else{
            CGRect frame = lbSum3.frame;
            frame.origin.x = 290 - frame.size.width;
            lbSum3.frame = frame;
        }
        
        if (cell.tag == 0) {
            cell.tag = 1;
            
            CGRect frame = cell.frame;
            frame.size.height = [self tableView:tableView
                        heightForRowAtIndexPath:indexPath];
            cell.frame = frame;
            cell = (UITableViewCell*)[AGTools addStandardGradientSublayerToView:cell];
        }
        
        UIImageView *background;
        UIImageView* backgroundHighlighted;
        background=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell-main-menu"]];
        backgroundHighlighted=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell-main-menu-highlighted"]];
        [cell setBackgroundView:background];
        [cell setSelectedBackgroundView:backgroundHighlighted];
        [AGTools tableView:tableView
changeAccessoryArrowForCell:cell];
        
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;            
        
        UIButton* bnFavourite = [UIButton buttonWithType:UIButtonTypeCustom];
        bnFavourite.frame = CGRectMake(22, 10, 124, 72);
        [bnFavourite setImage:[UIImage imageNamed:@"button-favorites"] forState:UIControlStateNormal];
        [bnFavourite setImage:[UIImage imageNamed:@"button-favorites-pressed"] forState:UIControlStateHighlighted];
        [bnFavourite addTarget:self action:@selector(toFavourite) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:bnFavourite];
        
        UILabel* lbFav = [[UILabel alloc] initWithFrame:CGRectMake(60, 82, 100, 25)];
        lbFav.font = [UIFont fontWithName:kFont1 size:10.0f];
        lbFav.backgroundColor = [UIColor clearColor];
        lbFav.textColor = [UIColor colorWithHex:kColorHexBrown];
        lbFav.text = NSLocalizedString(@"MenuFavourites", @"");
        [lbFav sizeToFit];
        [cell.contentView addSubview:lbFav];
        
        UIButton* bnPaymentAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        bnPaymentAdd.frame = CGRectMake(171, 10, 124, 72);
        [bnPaymentAdd setImage:[UIImage imageNamed:@"button-paymentAdd"] forState:UIControlStateNormal];
        [bnPaymentAdd setImage:[UIImage imageNamed:@"button-paymentAdd-pressed"] forState:UIControlStateHighlighted];            
        [bnPaymentAdd addTarget:self action:@selector(toPaymentAdd) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:bnPaymentAdd];
        
        UILabel* lbPaym = [[UILabel alloc] initWithFrame:CGRectMake(215, 82, 100, 25)];
        lbPaym.font = [UIFont fontWithName:kFont1 size:10.0f];
        lbPaym.backgroundColor = [UIColor clearColor];
        lbPaym.textColor = [UIColor colorWithHex:kColorHexBrown];
        lbPaym.text = NSLocalizedString(@"MenuPayments", @"");
        [lbPaym sizeToFit];
        [cell.contentView addSubview:lbPaym];
        
        UIImageView *background;
        background=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell-favorite-background"]];
        [cell setBackgroundView:background];
        
        if(cell.tag == 0){
            cell.tag = 1;
            CGRect frame = cell.frame;
            frame.size.height = [self tableView:tableView
                        heightForRowAtIndexPath:indexPath];
            cell.frame = frame;
        //    cell = (UITableViewCell*)[AGTools addStandardGradientSublayerToView:cell];
        }
    }
   
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isIphoneRetina4) {
        switch (indexPath.row) {
            case 0:
                return 50.0f;
                break;
            case 1:
                return 154.0f;
                break;
            case 2:
                return 154.0f;
                break;
            case 3:
                return 100.0f;
                break;
            default:
                return 0.0f;
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:
                return 50.0f;
                break;
            case 1:
                return 109.0f;
                break;
            case 2:
                return 109.0f;
                break;
            case 3:
                return 100.0f;
                break;
            default:
                return 0.0f;
                break;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 1:{
            AGPaymentListController* ctl = [[AGPaymentListController alloc] initWithNibName:@"AGPaymentListView" bundle:nil];
            [self.navigationController pushViewController:ctl animated:YES];
            break;
        }
        case 2:{
            AGAccountListController* ctl = [[AGAccountListController alloc] initWithNibName:@"AGAccountListView" bundle:nil];
            [self.navigationController pushViewController:ctl animated:YES];
            break;
        }
        default:
            break;
    }
}

@end
