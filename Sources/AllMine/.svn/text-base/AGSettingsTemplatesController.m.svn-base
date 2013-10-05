//
//  AGSettingsFavouritesController.m
//  AllMine
//
//  Created by Allgoritm LLC on 08.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "AGSettingsTemplatesController.h"
#import "AGTools.h"
#import "User+EntityWorker.h"
#import "Account+EntityWorker.h"
#import "Template+EntityWorker.h"
#import "AGAppDelegate.h"
#import "AGRootController.h"
#import "UIColor+AGExtensions.h"
#import "AGTemplateEditController.h"

@interface AGSettingsTemplatesController ()

@property(nonatomic, strong) IBOutlet UITableView* tvTemplates;

@property(nonatomic, strong) NSArray* templates;
@property(nonatomic, strong) NSArray* accounts;

- (void) back;
@end

@implementation AGSettingsTemplatesController

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
    self.navigationItem.title = NSLocalizedString(@"SettingsFavourites", @"");
    self.navigationItem.leftBarButtonItem = [AGTools navigationBarButtonItemWithImageNamed:@"button-back" target:self action:@selector(back)];
    
    _tvTemplates.delegate = self;
    _tvTemplates.dataSource = self;
}

-(void)viewWillAppear:(BOOL)animated{
    _accounts = [(kUser) accountsSortedByTitle];
    NSMutableArray* tmp = [NSMutableArray array];
    for (Account* acc in _accounts) {
        NSArray* arr = [acc templatesSortedByTitle];
        if (arr.count > 0) {
            [tmp addObject:arr];
        }
    }
    _templates = [NSArray arrayWithArray:tmp];
    [_tvTemplates reloadData];
}

#pragma mark - buttons
- (void) back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_templates count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_templates objectAtIndex:section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* CellIdentifier = @"settingsTemplatesCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;        
    }
    cell.textLabel.font = [UIFont fontWithName:kFont1 size:18.0f];
    cell.textLabel.backgroundColor=[UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithHex:kColorHexBlack];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    cell.textLabel.text = ((Template*)[[_templates objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]).title;

    [AGTools tableViewGrouped:tableView
                configureCell:cell
                withIndexPath:indexPath];
    
    return cell;
}

//header
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [AGTools tableViewGroupedHeaderViewWithTitle:[((Account*)[_accounts objectAtIndex:section]).title uppercaseString]
                                                 height:[self tableView:tableView heightForHeaderInSection:section]];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kTableHeaderStandardHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [AGTools cellStandardHeight];
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AGTemplateEditController* ctl = [[AGTemplateEditController alloc] initWithNibName:@"AGTemplateEditView" bundle:nil];
    ctl.ptemplate = (Template*)[[_templates objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    ctl.addPayment = NO;
    [self.navigationController pushViewController:ctl animated:YES];
}


@end
