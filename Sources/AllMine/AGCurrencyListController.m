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
#import "CurrencyCellController.h"

@interface AGCurrencyListController ()

@property(nonatomic, strong) IBOutlet UITableView* tvCurrencies;

- (void) selfDismiss;
- (void) back;

@end

@implementation AGCurrencyListController

@synthesize  tvCurrencies = _tvCurrencies;
@synthesize currencies = _currencies;
@synthesize currenciesDisabled = _currenciesDisabled;
@synthesize mainCurrency = _mainCurrency;
@synthesize isAccount = _isAccount;
@synthesize isMainCurrencyEdit = _isMainCurrencyEdit;

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
    
    [self configureCurrencies];
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
    [self configureCurrencies];
}

#pragma mark - UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_currencies count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* CellIdentifier = @"CurrencyCellView";
    
    
    CurrencyCellController* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.currencyName.font = [UIFont fontWithName:kFont1 size:18.0f];
        cell.currencyName.backgroundColor=[UIColor clearColor];
        cell.currencyName.textColor = [UIColor colorWithHex:kColorHexBlack];
        cell.currencyName.highlightedTextColor = [UIColor colorWithHex:kColorHexBlack];
        
        cell.currencyDetail.font = [UIFont fontWithName:kFont1 size:16.0];
        cell.currencyDetail.backgroundColor=[UIColor clearColor];
        cell.currencyDetail.textColor = [UIColor colorWithHex:kColorHexBrown];
        
        cell.currencyDetail.highlightedTextColor = [UIColor colorWithHex:kColorHexBrown];

        
        cell.checkmarkImage.hidden = YES;
        cell.userInteractionEnabled = YES;
    }
    Currency* cur;
    if(indexPath.section ==0 && indexPath.row == 0){
        cur = _mainCurrency;
        if(!_isAccount)
            cell.userInteractionEnabled = NO;
    }
    else
    {
        cur = [_currencies objectAtIndex:indexPath.row];
    }
    if([_currenciesDisabled indexOfObject:cur] != NSNotFound && !_isMainCurrencyEdit){
        cell.checkmarkImage.hidden = NO;
        //cell.userInteractionEnabled = NO;
    }else{
         if(indexPath.section ==0 && indexPath.row == 0){
             cell.checkmarkImage.hidden = NO;
         }else{
             cell.checkmarkImage.hidden = YES;

         }
    }
    cell.currencyName.text = cur.title;
    cell.currencyDetail.text = cur.comment;
    
    [self tableCellAccessory:cell withIndex:indexPath];
    
    /*[AGTools tableViewGrouped:tableView
                configureCell:cell
                withIndexPath:indexPath];*/
    
    
    return cell;
}

-(void)configureCurrencies{
    NSMutableArray* currenc = [NSMutableArray arrayWithArray:_currencies];
    [currenc removeObject: _mainCurrency];
    [currenc insertObject:_mainCurrency atIndex:0];
    _currencies = currenc;
}

-(void) tableCellAccessory:(UITableViewCell*)cell withIndex:(NSIndexPath*)indexPath{
    if(indexPath.row%4==0){
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:
                                 [UIImage imageNamed:@"cell-middle"]]];
        [cell setSelectedBackgroundView:[[UIImageView alloc] initWithImage:
                                         [UIImage imageNamed:@"cell-middle-highlighted"]]];
        
    }else{
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:
                                 [UIImage imageNamed:@"cell-currency"]]];
        [cell setSelectedBackgroundView:[[UIImageView alloc] initWithImage:
                                         [UIImage imageNamed:@"cell-middle-highlighted"]]];
    }
    
    if(indexPath.row==0){
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:
                                 [UIImage imageNamed:@"cell-top"]]];
        [cell setSelectedBackgroundView:[[UIImageView alloc] initWithImage:
                                         [UIImage imageNamed:@"cell-top-highlighted"]]];
    }
    
    if(indexPath.row == [_currencies count]-2){
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:
                                 [UIImage imageNamed:@"cell-middle"]]];
        [cell setSelectedBackgroundView:[[UIImageView alloc] initWithImage:
                                         [UIImage imageNamed:@"cell-middle-highlighted"]]];
    }

    
    if(indexPath.row == [_currencies count]-1){
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:
                                 [UIImage imageNamed:@"cell-bottom"]]];
        [cell setSelectedBackgroundView:[[UIImageView alloc] initWithImage:
                                         [UIImage imageNamed:@"cell-bottom-highlighted"]]];
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [AGTools cellStandardHeight];

}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CurrencyCellController* cell = (CurrencyCellController*)[tableView cellForRowAtIndexPath:indexPath];
    //cell.accessoryType = UITableViewCellAccessoryCheckmark;
    //tableView.userInteractionEnabled = NO;
    
    if(cell.checkmarkImage.hidden==NO){
        if ([self.delegate respondsToSelector:@selector(currencyListController:deleteCurrency:)]) {
            [self.delegate currencyListController:self
                     deleteCurrency:(Currency*)[_currencies objectAtIndex:indexPath.row]];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(currencyListController:didFinishedSelectingCurrency:)]) {
        [self.delegate currencyListController:self
                 didFinishedSelectingCurrency:(Currency*)[_currencies objectAtIndex:indexPath.row]];
        }
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
