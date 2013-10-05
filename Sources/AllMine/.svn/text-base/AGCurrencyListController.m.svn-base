//
//  AGCurrencyListController.m
//  AllMine
//
//  Created by Allgoritm LLC on 07.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "AGCurrencyListController.h"
#import "User.h"
#import "AGAppDelegate.h"
#import "AGRootController.h"
#import "Currency+EntityWorker.h"
#import "AGTools.h"
#import "UIColor+AGExtensions.h"

@interface AGCurrencyListController ()

@property(nonatomic, strong) IBOutlet UITableView* tvCurrencies;

- (void) selfDismiss;
- (void) back;

@end

@implementation AGCurrencyListController

@synthesize  tvCurrencies = _tvCurrencies;
@synthesize currencies = _currencies;
@synthesize currenciesDisabled = _currenciesDisabled;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _currencies = [NSArray array];
        _currenciesDisabled = [NSArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = NSLocalizedString(@"CurrencyList", @"");
    self.navigationItem.leftBarButtonItem = [AGTools navigationBarButtonItemWithImageNamed:@"button-back" target:self action:@selector(back)];
    
    _tvCurrencies.delegate = self;
    _tvCurrencies.dataSource = self;
}

-(void)viewWillAppear:(BOOL)animated{
    [_tvCurrencies reloadData];
    if (_currenciesDisabled.count == 1) {
        [_tvCurrencies scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:
                                               [_currencies indexOfObject:[_currenciesDisabled objectAtIndex:0]]
                                                                 inSection:0]
                             atScrollPosition:UITableViewScrollPositionMiddle
                                     animated:YES];
    }
}

#pragma mark - UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_currencies count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* CellIdentifier = @"currencyListCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.textLabel.font = [UIFont fontWithName:kFont1 size:18.0f];
    cell.textLabel.backgroundColor=[UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithHex:kColorHexBlack];
    cell.detailTextLabel.font = [UIFont fontWithName:kFont1 size:16.0];
    cell.detailTextLabel.backgroundColor=[UIColor clearColor];
    cell.detailTextLabel.textColor = [UIColor colorWithHex:kColorHexBrown];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.userInteractionEnabled = YES;
    Currency* cur = [_currencies objectAtIndex:indexPath.row];
    if([_currenciesDisabled indexOfObject:cur] != NSNotFound){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.userInteractionEnabled = NO;
    }
    cell.textLabel.text = cur.title;
    cell.detailTextLabel.text = cur.comment;
    
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
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    tableView.userInteractionEnabled = NO;
    
    if ([self.delegate respondsToSelector:@selector(currencyListController:didFinishedSelectingCurrency:)]) {
        [self.delegate currencyListController:self
                 didFinishedSelectingCurrency:(Currency*)[_currencies objectAtIndex:indexPath.row]];
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
