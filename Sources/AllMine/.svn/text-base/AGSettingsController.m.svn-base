//
//  AGSettingsController.m
//  AllMine
//
//  Created by Allgoritm LLC on 06.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "AGSettingsController.h"
#import "AGTools.h"
#import "UIColor+AGExtensions.h"
#import "AGSettingsCurrencyController.h"
#import "AGSettingsMainController.h"
#import "AGSettingsMailController.h"
#import "AGSettingsSyncController.h"
#import "AGSettingsTemplatesController.h"
#import "AGSettingsAboutController.h"
#import "AGSettingsCategoriesController.h"

@interface AGSettingsController ()
@property(nonatomic, retain) IBOutlet UITableView* tvMenu;

@end

@implementation AGSettingsController

@synthesize tvMenu = _tvMenu;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = NSLocalizedString(@"Settings", @"");
    self.navigationItem.leftBarButtonItem = [AGTools navigationBarButtonItemWithImageNamed:@"button-back" target:self action:@selector(back)];
    
    _tvMenu.scrollEnabled = NO;
    _tvMenu.delegate = self;
    _tvMenu.dataSource = self;
}

-(void)viewWillAppear:(BOOL)animated{
    [_tvMenu reloadData];
}

#pragma mark - buttons
- (void) back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* CellIdentifier = @"settingsCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        CGRect frame = cell.frame;
        frame.size.height = [self tableView:_tvMenu heightForRowAtIndexPath:indexPath];
        cell.frame = frame;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }else{
        for (UIView* v in cell.contentView.subviews) {
            if ([v isKindOfClass:[UILabel class]] || [v isKindOfClass:[UIImageView class]] ) {
                [v removeFromSuperview];
            }
        }
    }
    
    UILabel* lb = [[UILabel alloc] initWithFrame:CGRectMake(58, 20, 245, 22)];
    lb.backgroundColor = [UIColor clearColor];
    lb.font = [UIFont fontWithName:kFont1 size:18.0f];
    lb.textColor = [UIColor colorWithHex:kColorHexBlack];
    if (isIphoneRetina4) {
        CGRect frame = lb.frame;
        frame.origin.y += 5;
        lb.frame = frame;
    }
    
    UIImageView * imageView = [[UIImageView alloc] init];
    UIImage *img;
    switch (indexPath.row) {
        case 0:
            lb.text = NSLocalizedString(@"SettingsMain", @"");
            img=[UIImage imageNamed:@"settings-main"];
            imageView.frame=CGRectMake(22, 20, img.size.width, img.size.height);
            imageView.image = img;
            imageView.highlightedImage=[UIImage imageNamed:@"settings-main-pressed"];
            [cell.contentView addSubview:imageView];
            break;
        case 1:
            lb.text = NSLocalizedString(@"SettingsMail", @"");
            img=[UIImage imageNamed:@"settings-mail"];
            imageView.frame=CGRectMake(19, 20, img.size.width, img.size.height);
            imageView.image = img;
            imageView.highlightedImage=[UIImage imageNamed:@"settings-mail-pressed"];
            [cell.contentView addSubview:imageView];
            break;
        case 2:
            lb.text = NSLocalizedString(@"SettingsCurrency", @"");
            img=[UIImage imageNamed:@"settings-currency"];
            imageView.frame=CGRectMake(21, 18, img.size.width, img.size.height);
            imageView.image = img;
            imageView.highlightedImage=[UIImage imageNamed:@"settings-currency-pressed"];
            [cell.contentView addSubview:imageView];
            break;
        case 3:
            lb.text = NSLocalizedString(@"SettingsSync", @"");
            img=[UIImage imageNamed:@"settings-sync"];
            imageView.frame=CGRectMake(21, 17, img.size.width, img.size.height);
            imageView.image = img;
            imageView.highlightedImage=[UIImage imageNamed:@"settings-sync-pressed"];
            [cell.contentView addSubview:imageView];
            break;
        case 4:
            lb.text = NSLocalizedString(@"SettingsCategories", @"");
            img=[UIImage imageNamed:@"settings-categories"];
            imageView.frame=CGRectMake(21, 18, img.size.width, img.size.height);
            imageView.image = img;
            imageView.highlightedImage=[UIImage imageNamed:@"settings-categories-pressed"];
            [cell.contentView addSubview:imageView];
            break;
        case 5:
            lb.text = NSLocalizedString(@"SettingsFavourites", @"");
            img=[UIImage imageNamed:@"settings-favourites"];
            imageView.frame=CGRectMake(21, 17, img.size.width, img.size.height);
            imageView.image = img;
            imageView.highlightedImage=[UIImage imageNamed:@"settings-favourites-pressed"];
            [cell.contentView addSubview:imageView];
            break;
        case 6:
            lb.text = NSLocalizedString(@"SettingsAbout", @"");
            img=[UIImage imageNamed:@"settings-about"];
            imageView.frame=CGRectMake(24, 16, img.size.width, img.size.height);
            imageView.image = img;
            imageView.highlightedImage=[UIImage imageNamed:@"settings-about-pressed"];
            [cell.contentView addSubview:imageView];
            break;
        default:
            break;
    }

    [cell.contentView addSubview:lb];
    
    [AGTools tableViewPlain:tableView
              configureCell:cell
              withIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            AGSettingsMainController* ctl = [[AGSettingsMainController alloc] initWithNibName:@"AGSettingsMainView" bundle:nil];
            [self.navigationController pushViewController:ctl animated:YES];
            break;
        }
        case 1:{
            AGSettingsMailController* ctl = [[AGSettingsMailController alloc] initWithNibName:@"AGSettingsMailView" bundle:nil];
            [self.navigationController pushViewController:ctl animated:YES];
            break;
        }
        case 2:{
            AGSettingsCurrencyController* ctl = [[AGSettingsCurrencyController alloc]initWithNibName:@"AGSettingsCurrencyView" bundle:nil];
            [self.navigationController pushViewController:ctl animated:YES];
            break;
        }
        case 3:{
            AGSettingsSyncController* ctl = [[AGSettingsSyncController alloc] initWithNibName:@"AGSettingsSyncView" bundle:nil];
            [self.navigationController pushViewController:ctl animated:YES];
            break;
        }
        case 4:{
            AGSettingsCategoriesController* ctl = [[AGSettingsCategoriesController alloc] initWithNibName:@"AGSettingsCategoriesView" bundle:nil];
            ctl.category = nil;
            [self.navigationController pushViewController:ctl animated:YES];
            break;
        }
        case 5:{
            AGSettingsTemplatesController* ctl = [[AGSettingsTemplatesController alloc] initWithNibName:@"AGSettingsTemplatesView" bundle:nil];
            [self.navigationController pushViewController:ctl animated:YES];
            break;
        }
        case 6:{
            AGSettingsAboutController* ctl = [[AGSettingsAboutController alloc] initWithNibName:@"AGSettingsAboutView" bundle:nil];
            [self.navigationController pushViewController:ctl animated:YES];
            break;
        }
        default:
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isIphoneRetina4) {
        return 72.0f;
    }else{
        return 60.0f;
    }
}

@end
