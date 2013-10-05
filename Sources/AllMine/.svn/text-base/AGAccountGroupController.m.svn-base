//
//  AGAccountGroupController.m
//  AllMine
//
//  Created by Allgoritm LLC on 09.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "AGAccountGroupController.h"
#import "AGTools.h"

@interface AGAccountGroupController ()
@property(nonatomic, strong) IBOutlet UITableView* tvItems;

@end

@implementation AGAccountGroupController

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
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = NSLocalizedString(@"AccountEditAccGroup", @"");
    self.navigationItem.leftBarButtonItem = [AGTools navigationBarButtonItemWithImageNamed:@"button-back" target:self action:@selector(back)];
    
    _tvItems.delegate = self;
    _tvItems.dataSource = self;
    [_tvItems reloadData];
}

#pragma mark - UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* CellIdentifier = @"currencyListCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    if(indexPath.row == _group) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.backgroundColor=[UIColor clearColor];
    cell.textLabel.text = [AGTools accountGroupTitleWithGroup:indexPath.row];
    
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
    _group = indexPath.row;
    [_tvItems reloadData];
    if ([self.delegate respondsToSelector:@selector(accountGroupController:didFinishedSelectingGroup:)]) {
        [self.delegate accountGroupController:self
                    didFinishedSelectingGroup:_group];
    }
    
    [self performSelector:@selector(selfDismiss) withObject:nil afterDelay:kSlideAnimationTime];
}

-(void)selfDismiss{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - buttons
- (void) back{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
