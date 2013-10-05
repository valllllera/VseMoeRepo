//
//  AGLoginListController.m
//  AllMine
//
//  Created by Allgoritm LLC on 02.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "AGLoginListController.h"
#import "User+EntityWorker.h"
#import "AGLoginController.h"
#import "UIColor+AGExtensions.h"
#import "AGTools.h"

@interface AGLoginListController ()

@property(nonatomic, retain) NSArray* users;
@property(nonatomic, retain) IBOutlet UITableView* tvLogins;

-(void)back;
@end

@implementation AGLoginListController

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
	// Do any additional setup after loading the view.

    _tvLogins.delegate = self;
    _tvLogins.dataSource = self;
    _tvLogins.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [AGTools navigationBarButtonItemWithImageNamed:@"button-back" target:self action:@selector(back)];
}

-(void)viewWillAppear:(BOOL)animated{
    _users = [User usersToShow];
    [_tvLogins reloadData];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - UITableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_users count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* CellIdentifier = @"loginListCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell = (UITableViewCell*)[AGTools addStandardGradientSublayerToView:cell];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;        
    }

    User* usr = (User*)[_users objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:kFont1 size:18.0f];
    cell.textLabel.textColor = [UIColor colorWithHex:kColorHexBlack];
    cell.textLabel.text = usr.login;
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    tableView.userInteractionEnabled = NO;
    
    if ([self.delegate respondsToSelector:@selector(loginListController:didFinishedSelectingLogin:)]) {
        [self.delegate loginListController:self
                 didFinishedSelectingLogin:((User*)[_users objectAtIndex:indexPath.row]).login];
    }

    [self performSelector:@selector(back) withObject:nil afterDelay:kSlideAnimationTime];
}

-(void)back{
//    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
