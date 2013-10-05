//
//  AGSettingsCategoriesController.m
//  AllMine
//
//  Created by Allgoritm LLC on 08.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "AGSettingsCategoriesController.h"
#import "AGTools.h"
#import "Category+EntityWorker.h"
#import "AGSettingsCategoryEditController.h"
#import "AGDBWorker.h"
#import "UIColor+AGExtensions.h"

#import "AGAppDelegate.h"
#import "AGRootController.h"
#import "User+EntityWorker.h"
#import "Account+EntityWorker.h"

@interface AGSettingsCategoriesController ()

@property(nonatomic, strong) IBOutlet UITableView* tvSubCats;
@property(nonatomic, strong) IBOutlet UISegmentedControl* sgCatType;

@property(nonatomic, assign) BOOL editMode;
@property(nonatomic, assign) int catIndexSelected;

@property(nonatomic, strong) UIColor* clrSegmentSelection;

- (void) back;
- (void) enterEditMode;
- (void) addSubCategory;
@end

@implementation AGSettingsCategoriesController

@synthesize tvSubCats = _tvSubCats;
@synthesize sgCatType = _sgCatType;
@synthesize category = _category;
@synthesize segmentIndex = _segmentIndex;
@synthesize subCats = _subCats;
@synthesize rootCtl = _rootCtl;
@synthesize editMode = _editMode;
@synthesize catIndexSelected = _catIndexSelected;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _category = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [AGTools navigationBarButtonItemWithImageNamed:@"button-back" target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [AGTools navigationBarButtonItemWithTitle:NSLocalizedString(@"Edit", @"") imageNamed:@"button-save" target:self action:@selector(enterEditMode)];
    
    {// xib layout fix
        float dy = 10;
        CGRect frame = _sgCatType.frame;
        frame.size.height += dy;
        _sgCatType.frame = frame;
        
        frame = _tvSubCats.frame;
        frame.origin.y += dy;
        frame.size.height -= dy;
        _tvSubCats.frame = frame;
    }
    
    _sgCatType.tintColor = [UIColor colorWithHex:kColorHexMarine];
    [_sgCatType setTitle:NSLocalizedString(@"MenuExpense", @"") forSegmentAtIndex:0];
    [_sgCatType setTitle:NSLocalizedString(@"MenuIncome", @"") forSegmentAtIndex:1];
    [_sgCatType setTitle:NSLocalizedString(@"SettingsCategoriesTransfer", @"") forSegmentAtIndex:2];
    _sgCatType.selectedSegmentIndex = _segmentIndex;
    [_sgCatType addTarget:self
                   action:@selector(segmentSelectionChanged)
         forControlEvents:UIControlEventValueChanged];

    [self.sgCatType setBackgroundImage:[UIImage imageNamed:@"segment-category"]
                              forState:UIControlStateNormal
                            barMetrics:UIBarMetricsDefault];
    [self.sgCatType setBackgroundImage:[UIImage imageNamed:@"segment-category-pressed"]
                              forState:UIControlStateSelected
                            barMetrics:UIBarMetricsDefault];
    
    
    _tvSubCats.delegate = self;
    _tvSubCats.dataSource = self;
    _tvSubCats.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.clrSegmentSelection = [UIColor colorWithHex:kColorHexMarineDark];
}

-(void)viewWillAppear:(BOOL)animated{
    if(_category == nil){
        self.navigationItem.title = NSLocalizedString(@"SettingsCategoriesCategories", @"");
        if(_segmentIndex != 2){
            _subCats = [kUser categoriesRootWithType:_segmentIndex];
        }else{
            _subCats = [(kUser).accounts allObjects];
        }
    }else{
        self.navigationItem.title = _category.title;
        _subCats = [_category.subcats allObjects];
    }
    [self leaveEditMode];
    [_tvSubCats reloadData];
}

#pragma mark - buttons
- (void) back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) segmentSelectionChanged{
    if(_rootCtl){
        _rootCtl.sgCatType.selectedSegmentIndex = _sgCatType.selectedSegmentIndex;
        [_rootCtl segmentSelectionChanged];
        [self.navigationController popToViewController:_rootCtl animated:YES];
        return;
    }
    _segmentIndex = _sgCatType.selectedSegmentIndex;
    if(_segmentIndex == CatTypeExpense){
        _subCats = [kUser categoriesRootWithType:CatTypeExpense];
    }else if (_segmentIndex == CatTypeIncome){
        _subCats = [kUser categoriesRootWithType:CatTypeIncome];
    }else{
        _subCats = [(kUser).accounts allObjects];
    }
    [_tvSubCats reloadData];
    [self leaveEditMode];
}

- (void) enterEditMode{
    _editMode = YES;
    self.navigationItem.leftBarButtonItem = [AGTools navigationBarButtonItemWithTitle:NSLocalizedString(@"Cancel", @"") imageNamed:@"button-save" target:self action:@selector(leaveEditMode)];
    self.navigationItem.rightBarButtonItem = [AGTools navigationBarButtonItemWithImageNamed:@"button-add" target:self action:@selector(addSubCategory)];
    [_tvSubCats reloadData];
}

- (void) leaveEditMode{
    _editMode = NO;
    self.navigationItem.leftBarButtonItem = [AGTools navigationBarButtonItemWithImageNamed:@"button-back" target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [AGTools navigationBarButtonItemWithTitle:NSLocalizedString(@"Edit", @"") imageNamed:@"button-save" target:self action:@selector(enterEditMode)];
    [_tvSubCats reloadData];    
}

- (void) addSubCategory{
    AGSettingsCategoryEditController* ctl = [[AGSettingsCategoryEditController alloc] initWithNibName:@"AGSettingsCategoryEditView" bundle:nil];
    ctl.supercat = _category;
    ctl.type = _sgCatType.selectedSegmentIndex;
    [self.navigationController pushViewController:ctl animated:YES];
}

#pragma mark - UIActionSheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            Category* cat = [_subCats objectAtIndex:_catIndexSelected];
            [cat markRemovedSave:YES];
            [self viewWillAppear:YES];
            break;
        }
            
        case 1:{
            AGSettingsCategoryEditController* ctl = [[AGSettingsCategoryEditController alloc] initWithNibName:@"AGSettingsCategoryEditView" bundle:nil];
            ctl.category = [_subCats objectAtIndex:_catIndexSelected];
            [self.navigationController pushViewController:ctl animated:YES];
            break;
        }
            
        default:
            break;
    }
    [_tvSubCats deselectRowAtIndexPath:[NSIndexPath indexPathForRow:_catIndexSelected inSection:0] animated:YES];
}

#pragma mark - UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_subCats count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* CellIdentifier = @"settingsCategoriesCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
        CGRect frame = cell.frame;
        frame.size.height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
        cell.frame = frame;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;        
    }
    cell.textLabel.font = [UIFont fontWithName:kFont1 size:18.0f];
    cell.textLabel.textColor = [UIColor colorWithHex:kColorHexBlack];
    
    if (_segmentIndex == 2) {
        Account* acc = [_subCats objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = acc.title;
    }else{
        Category* cat = [_subCats objectAtIndex:indexPath.row];
        if(([cat.subcats count] > 0)&&(_editMode == NO)){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.textLabel.text = cat.title;
    }
    
    [AGTools tableViewPlain:tableView
                configureCell:cell
                withIndexPath:indexPath];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [AGTools cellStandardHeight];
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_segmentIndex != 2) {
        Category* cat = [_subCats objectAtIndex:indexPath.row];
        if(_editMode == NO){
            UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
            if(cell.accessoryType == UITableViewCellAccessoryDisclosureIndicator){
                AGSettingsCategoriesController* ctl = [[AGSettingsCategoriesController alloc] initWithNibName:@"AGSettingsCategoriesView" bundle:nil];
                ctl.category = cat;
                ctl.segmentIndex = _segmentIndex;
                ctl.delegate = _delegate;
                if(_rootCtl){
                    ctl.rootCtl = _rootCtl;
                }else{
                    ctl.rootCtl = self;
                }
                [self.navigationController pushViewController:ctl animated:YES];
            }else{
                if ([self.delegate respondsToSelector:@selector(selectedCategory:)]) {
                    [self.delegate selectedCategory:cat];
                }
            }
        }else{
            _catIndexSelected = indexPath.row;
            UIActionSheet* as = [[UIActionSheet alloc]
                                 initWithTitle:nil
                                 delegate:self
                                 cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                 destructiveButtonTitle:NSLocalizedString(@"Remove", @"")
                                 otherButtonTitles:NSLocalizedString(@"Edit2", @""), nil];
            [as showInView:self.view];
//            AGSettingsCategoryEditController* ctl = [[AGSettingsCategoryEditController alloc] initWithNibName:@"AGSettingsCategoryEditView" bundle:nil];
//            ctl.category = cat;
//            [self.navigationController pushViewController:ctl animated:YES];
        }
    }else{
        Account* acc = [_subCats objectAtIndex:indexPath.row];
        if (_editMode == NO) {
            if ([self.delegate respondsToSelector:@selector(selectedAccount:)]) {
                [self.delegate selectedAccount:acc];
            }
        }
    }
}


@end
