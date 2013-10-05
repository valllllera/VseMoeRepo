//
//  AGSettingsCategoryParentSelectController.m
//  Всё моё
//
//  Created by Allgoritm LLC on 27.02.13.
//  Copyright (c) 2013 Allgoritm LLC. All rights reserved.
//

#import "AGSettingsCategoryParentSelectController.h"

#import "User+EntityWorker.h"
#import "AGAppDelegate.h"
#import "AGRootController.h"
#import "UIColor+AGExtensions.h"
#import "AGTools.h"

@interface AGSettingsCategoryParentSelectController ()

@property(nonatomic, strong) NSArray* categories;
@property(nonatomic, strong) IBOutlet UITableView* tvCategories;

@end

@implementation AGSettingsCategoryParentSelectController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [AGTools navigationBarButtonItemWithImageNamed:@"button-back" target:self action:@selector(back)];
    if(self.supercat == nil){
        self.navigationItem.title = NSLocalizedString(@"SettingsCategoriesCategories", @"");
    }else{
        self.navigationItem.title = self.supercat.title;
    }
    
    if (self.supercat) {
        self.categories = self.supercat.subcats.allObjects;
    }else{
        self.categories = [(kUser) categoriesRootWithType:self.type];
    }

    self.tvCategories.dataSource = self;
    self.tvCategories.delegate = self;
    [self.tvCategories reloadData];
    NSInteger index = [self.categories indexOfObject:self.catSelected];
    if (index != NSNotFound) {
        [self.tvCategories selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                                       animated:NO
                                 scrollPosition:UITableViewScrollPositionMiddle];
    }
}

- (void) back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.categories.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* CellIdentifier = @"settingsCategoryParentCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }

    Category* cat = [self.categories objectAtIndex:indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.imageView.image = [UIImage imageNamed:@"button-radio"];
    cell.imageView.highlightedImage = [UIImage imageNamed:@"button-radio-selected"];
    
    if (cat.subcats.count > 0) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"accessory-arrow"]
                forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"accessory-arrow"]
                forState:UIControlStateHighlighted];
        button.frame = CGRectMake(0, 0, 44, 44);
        [button addTarget: self
                   action: @selector(accessoryButtonTapped:withEvent:)
         forControlEvents: UIControlEventTouchUpInside];
        cell.accessoryView = button;
    }else{
        cell.accessoryView = nil;
    }
    
    cell.textLabel.textColor = [UIColor colorWithHex:kColorHexBlack];
    cell.textLabel.font = [UIFont fontWithName:kFont1 size:18.0f];
    cell.textLabel.text = cat.title;
#warning HARDCODED CELL STYLE
    [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_1"]]];
    [cell setSelectedBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_1-highlighted"]]];
    cell.textLabel.highlightedTextColor=cell.textLabel.textColor;
    cell.detailTextLabel.highlightedTextColor=cell.detailTextLabel.textColor;

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [AGTools cellStandardHeight];
}

#pragma mark - UITableViewDelegate
- (void) accessoryButtonTapped:(UIControl*) button
                     withEvent:(UIEvent*) event
{
    NSIndexPath * indexPath = [self.tvCategories indexPathForRowAtPoint: [[[event touchesForView: button] anyObject] locationInView: self.tvCategories]];
    if ( indexPath == nil )
        return;
    
    [self.tvCategories.delegate tableView: self.tvCategories  accessoryButtonTappedForRowWithIndexPath: indexPath];
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    AGSettingsCategoryParentSelectController* ctl = [[AGSettingsCategoryParentSelectController alloc] initWithNibName:@"AGSettingsCategoryParentSelectController" bundle:nil];
    ctl.supercat = [self.categories objectAtIndex:indexPath.row];
    ctl.catSelected = self.catSelected;
    ctl.type = self.type;
    ctl.delegate = self.delegate;
    [self.navigationController pushViewController:ctl
                                         animated:YES];
}

-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(settingsCategoryParentSelectController:didSelectCategory:)]) {

        [self.delegate settingsCategoryParentSelectController:self
                                            didSelectCategory:[self.categories objectAtIndex:indexPath.row]];
    }
}

@end
