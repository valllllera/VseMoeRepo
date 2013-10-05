//
//  AGSettingsCategoryEditController.m
//  AllMine
//
//  Created by Allgoritm LLC on 08.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "AGSettingsCategoryEditController.h"
#import "AGTools.h"
#import "AGDBWorker.h"
#import "UIColor+AGExtensions.h"
#import "AGAppDelegate.h"
#import "AGRootController.h"
#import "User+EntityWorker.h"
#import "UIView+AGExtensions.h"
#import <QuartzCore/QuartzCore.h>
#import "AGSettingsCategoryParentSelectController.h"

@interface AGSettingsCategoryEditController ()
@property(nonatomic, strong) IBOutlet UITableView* tvCatInfo;
@property(nonatomic, strong) IBOutlet UIButton* bnSave;


@property(nonatomic, strong) UITextField* tfCatTitle;

@property(nonatomic, strong) NSMutableArray* categories;

@end

@implementation AGSettingsCategoryEditController

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
    self.type = self.type % 2;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [AGTools navigationBarButtonItemWithImageNamed:@"button-back" target:self action:@selector(back)];
    
    if(_category == nil){
        self.navigationItem.title = NSLocalizedString(@"CategoryEditNew", @"");
        if (_supercat != nil) {
            _type = _supercat.type.intValue;
        }
    }else{
        self.navigationItem.title = _category.title;
        _tfCatTitle.text = _category.title;
        _supercat = _category.supercat;
        if (_supercat == nil) {
            _type = [_category.type intValue];
        }else{
            _type = [_supercat.type intValue];
        }
    }

    _tfCatTitle = [[UITextField alloc] initWithFrame:CGRectMake(-2, 0, 304, [AGTools cellStandardHeight])];
    _tfCatTitle.font = [UIFont fontWithName:kFont1 size:18.0f];
    _tfCatTitle.textColor = [UIColor colorWithHex:kColorHexBlack];
    _tfCatTitle.placeholder = NSLocalizedString(@"CategoryEditTitle", @"");
    _tfCatTitle.text = _category.title;
    _tfCatTitle.delegate = self;
    _tfCatTitle.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _tfCatTitle.layer.masksToBounds = YES;
    _tfCatTitle.layer.cornerRadius = 8.0f;
    _tfCatTitle.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    
    _categories = [NSMutableArray arrayWithArray:[(kUser).categories allObjects]];
    if(_category){
        [_categories removeObject:_category];
        [_categories removeObjectsInArray:_category.subcats.allObjects];
    }
    
    _tvCatInfo.scrollEnabled = NO;
    _tvCatInfo.delegate = self;
    _tvCatInfo.dataSource = self;
    [_tvCatInfo reloadData];

    self.bnSave.titleLabel.font = [UIFont fontWithName:kFont1 size:16.0f];
    [self.bnSave setTitleColor:[UIColor colorWithHex:kColorHexWhite]
                      forState:UIControlStateNormal];
    [self.bnSave setTitle:NSLocalizedString(@"Save", @"")
                 forState:UIControlStateNormal];
}

-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pickerWillShow)
                                                 name:kEventUIPickerWillShow
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pickerWillHide)
                                                 name:kEventUIPickerWillHide
                                               object:nil];
}
- (void) viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tvCatInfo reloadData];
}

- (void) pickerWillShow{
    [self.tvCatInfo slideToPoint:CGPointMake(0, -48)];
}

- (void) pickerWillHide{
    [self.tvCatInfo slideOut];
}

#pragma mark - buttons
- (void) back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender{
    if([_tfCatTitle.text length] > 0){
        NSString* title = _tfCatTitle.text;
        if(_category){
            _category.title = title;
            _category.supercat = _supercat;
            [_category changeType:_type save:YES];
            _category.modifiedDate = [NSDate date];
            [[AGDBWorker sharedWorker] saveManagedContext];
        }else{
            title = [[[title substringToIndex:1] uppercaseString] stringByAppendingString:[title substringFromIndex:1]];
            [Category insertCategoryWithUser:kUser
                                       title:title
                                        type:_type
                                    supercat:_supercat
                                        save:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }
        [self back];
    }else{
        [_tfCatTitle shake];
    }
}

#pragma mark - UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;

        default:
            return 3;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* CellIdentifier = @"settingsCategoryEditCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }else{
        for (UIView* v in cell.subviews) {
            if ([v isKindOfClass:[UITextField class]]) {
                [v removeFromSuperview];
            }
        }
    }

    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.textColor = [UIColor colorWithHex:kColorHexBlack];
    cell.textLabel.backgroundColor=[UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:kFont1 size:18.0f];
    switch (indexPath.section) {
        case 0:
            [cell.contentView addSubview:_tfCatTitle];
            break;
            
        case 1:
            if(indexPath.row == 0){
                cell.textLabel.text = NSLocalizedString(@"MenuExpense", @"");
                if(_type == CatTypeExpense){
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }else{
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }else if(indexPath.row == 1){
                cell.textLabel.text = NSLocalizedString(@"MenuIncome", @"");
                if(_type == CatTypeIncome){
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }else{
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }else{
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                if (self.supercat) {
                    cell.textLabel.textColor = [UIColor colorWithHex:kColorHexBlack];
                    cell.textLabel.text = self.supercat.title;
                }else{
                    cell.textLabel.textColor = [UIColor colorWithHex:kColorHexGray];
                    cell.textLabel.text = NSLocalizedString(@"CategoryEditParent", @"");
                }
            }
            break;
    }

    [AGTools tableViewGrouped:tableView
                configureCell:cell
                withIndexPath:indexPath];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [AGTools cellStandardHeight];
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                _type = CatTypeExpense;
                if(_supercat.type.intValue != _type){
                    _supercat = nil;
                }
                break;
                
            case 1:
                _type = CatTypeIncome;
                if(_supercat.type.intValue != _type){
                    _supercat = nil;
                }
                break;
                
            default:{
                AGSettingsCategoryParentSelectController* ctl = [[AGSettingsCategoryParentSelectController alloc] initWithNibName:@"AGSettingsCategoryParentSelectController"
                                                                                                                           bundle:nil];
                ctl.type = self.type;
                ctl.catSelected = self.supercat;
                ctl.supercat = nil;
                ctl.delegate = self;
                [self.navigationController pushViewController:ctl
                                                     animated:YES];
                break;
            }
        }
    }
    [_tvCatInfo reloadData];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGSize size = _tvCatInfo.frame.size;
    size.height = 200;
    if (isIphoneRetina4) {
        size.height = 288;
    }
    [_tvCatInfo sizeChangeAnimated:size];
    _tvCatInfo.scrollEnabled = YES;
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [_tvCatInfo sizeReturn];
    _tvCatInfo.scrollEnabled=NO;
}

#pragma mark - AGSettingsCategoryParentSelectControllerDelegate
-(void)settingsCategoryParentSelectController:(AGSettingsCategoryParentSelectController *)ctl
                            didSelectCategory:(Category *)category{
    
    _supercat = category;
    _type = [_supercat.type intValue];
    [self.navigationController popToViewController:self
                                          animated:YES];
}

@end
