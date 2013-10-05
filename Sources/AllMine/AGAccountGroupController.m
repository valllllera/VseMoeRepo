//
//  AGAccountGroupController.m
//  AllMine
//
//  Created by Allgoritm LLC on 09.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "AGAccountGroupController.h"
#import "AGTools.h"
#import "GroupCellController.h"
#import "UIColor+AGExtensions.h"

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
    static NSString* CellIdentifier = @"GroupCellView";
    
    GroupCellController* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.checkmarkImage.hidden = YES;
        cell.groupLabel.font = [UIFont fontWithName:kFont1 size:16.0];
        cell.groupLabel.backgroundColor=[UIColor clearColor];
        cell.groupLabel.textColor = [UIColor colorWithHex:kColorHexBrown];
    }
    cell.groupLabel.backgroundColor=[UIColor clearColor];

    switch (indexPath.row) {
        case 0:
            cell.groupLabel.text = [NSString stringWithFormat:@"%@ %@",[AGTools accountGroupTitleWithGroup:1],NSLocalizedString(@"AccountGroupActive", nil)];
            break;
        case 1:
            cell.groupLabel.text = [NSString stringWithFormat:@"%@ %@",[AGTools accountGroupTitleWithGroup:2],NSLocalizedString(@"AccountGroupPassive", nil)];
            break;
        case 2:
            cell.groupLabel.text = [AGTools accountGroupTitleWithGroup:0];
            break;
        default:
            break;
    }
    
    if(_group == [self calculateGroupWithIndex:indexPath]){
        cell.checkmarkImage.hidden = NO;
    }else{
        cell.checkmarkImage.hidden = YES;
    }
    
    [AGTools tableViewGrouped:tableView
                configureCell:cell
                withIndexPath:indexPath];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [AGTools cellStandardHeight]-10;
}

-(int)calculateGroupWithIndex:(NSIndexPath*)indexPath{
    switch (indexPath.row) {
        case 0:
            return 1;
        case 1:
            return 2;
        case 2:
            return 0;
        default:
            return 0;
    }
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _group = [self calculateGroupWithIndex:indexPath];
    [_tvItems reloadData];
    if ([self.delegate respondsToSelector:@selector(accountGroupController:didFinishedSelectingGroup:)]) {
        [self.delegate accountGroupController:self
                    didFinishedSelectingGroup:_group];
    }
    
    [self performSelector:@selector(selfDismiss) withObject:nil afterDelay:kSlideAnimationTime];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* v = [[UIView alloc] init];
    v.frame = CGRectMake(0, 0, 320, [self tableView:tableView heightForHeaderInSection:section]);
    
    //  title
    UILabel* lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(25, 6, 270.0, v.frame.size.height)];
    lbTitle.font = [UIFont fontWithName:kFont1 size:14.0];
    lbTitle.textColor = [UIColor colorWithHex:kColorHexBrown];
    lbTitle.textAlignment = NSTextAlignmentLeft;
    lbTitle.backgroundColor = [UIColor clearColor];
    lbTitle.text = NSLocalizedString(@"AccountGroupReview", nil);
    
    [v addSubview:lbTitle];
    
    return v;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kTableHeaderStandardHeight;
}

-(void)selfDismiss{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - buttons
- (void) back{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
