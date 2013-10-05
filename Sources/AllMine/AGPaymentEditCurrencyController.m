//
//  AGPaymentEditCurrencyController.m
//  AllMine
//
//  Created by Allgoritm LLC on 13.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "AGPaymentEditCurrencyController.h"
#import "AGTools.h"
#import "User+EntityWorker.h"
#import "Rate+EntityWorker.h"
#import "AGAppDelegate.h"
#import "AGRootController.h"
#import "NSDate+AGExtensions.h"
#import "Currency+EntityWorker.h"
#import "AGDBWorker.h"
#import "UILabel+AGExtensions.h"
#import "UIColor+AGExtensions.h"
#import "AGAppDelegate.h"
#import "AGRootController.h"
#import "UIView+AGExtensions.h"

@interface AGPaymentEditCurrencyController ()

@property(nonatomic, strong) IBOutlet UITableView* tvCurrencies;
@property(nonatomic, strong) NSArray* currencies;
@property(nonatomic, strong) Currency* mainCurrency;
@property(nonatomic, strong) IBOutlet UILabel* lbRateLeft;
@property(nonatomic, strong) IBOutlet UILabel* lbRateRight;
@property(nonatomic, strong) IBOutlet UILabel* lbRateSub;
//®@property(nonatomic, strong) IBOutlet UILabel* lbRate;
@property(nonatomic, strong) IBOutlet UILabel* lbBalance;
@property(nonatomic, strong) IBOutlet UIView* vInfo;

@end

@implementation AGPaymentEditCurrencyController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _date = [NSDate date];
    }
    return self;
}

-(void)setStartContent
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _scrollView.contentSize = CGSizeMake(320.0f, 800.0f);
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = NSLocalizedString(@"SettingsCurrencyTitle", @"");
    self.navigationItem.leftBarButtonItem = [AGTools navigationBarButtonItemWithImageNamed:@"button-back" target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [AGTools navigationBarButtonItemWithTitle:NSLocalizedString(@"Save", @"") imageNamed:@"button-save" target:self action:@selector(save)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    _tvCurrencies.delegate = self;
    _tvCurrencies.dataSource = self;
    
    CGRect frame = _lbBalance.frame;
    frame.origin.y -=20;
    _lbBalance.frame = frame;
    _lbBalance.textColor=[UIColor colorWithHex:kColorHexPaymentResult];
    _lbBalance.adjustsFontSizeToFitWidth = YES;
    _lbBalance.font = [UIFont fontWithName:kFont2 size:40.0f];

    _lbRateLeft.font = [UIFont fontWithName:kFont1 size:20.0f];
    _lbRateLeft.textColor = [UIColor colorWithHex:kColorHexBrown];
    
    _lbRateRight.font = [UIFont fontWithName:kFont1 size:20.0f];
    _lbRateRight.textColor = [UIColor colorWithHex:kColorHexBrown];
    
    _lbRateSub.font = [UIFont fontWithName:kFont1 size:12.0f];
    _lbRateSub.textColor = [UIColor colorWithHex:kColorHexBrown];
    _lbRateSub.text = NSLocalizedString(@"PaymentEidtCurrencyRate", @"");
    
    _lbRate.font = [UIFont fontWithName:kFont1 size:20.0f];
    _lbRate.textColor = [UIColor colorWithHex:kColorHexBrown];
//    _lbRate.backgroundColor = [UIColor colorWithHex:kColorHexWhite];
    _lbRate.adjustsFontSizeToFitWidth = YES;
//    _lbRate.userInteractionEnabled = YES;
//    [_lbRate addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeRateValue)]];
    
    _lbRateRight.text = [@" " stringByAppendingString: (kUser).currencyMain.title];
    [self setStartContent];
    if(_rateValue == 0.0f){
        _rateValue = [_currency rateValueWithDate:_date mainCurrency:(kUser).currencyMain];
    }else{
        _rateValue /= ([(kUser).currencyMain rateValueWithDate:_date]);
    }
}

- (void) viewWillAppear:(BOOL)animated{
    User* usr = (kUser);
    _lbBalance.textColor=[UIColor colorWithHex:kColorHexPaymentResult];
    _mainCurrency = usr.currencyMain;
    _currencies = [usr currenciesMainAdditionalSorted];
    [_tvCurrencies reloadData];
    
    self.currency = _currency;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:kEventAGKeyboardWillHide object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:kEventAGKeyboardWillShow object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - buttons
- (void) back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)save{
    if([_delegate respondsToSelector:@selector(currencySelected:withRateValue:)]){
        double rt = [_currency rateValueWithDate:_date mainCurrency:_mainCurrency];
        if ([[NSString stringWithFormat:@"%.2f",rt] isEqualToString:[NSString stringWithFormat:@"%.2f",_rateValue]]) {
            [_delegate currencySelected:_currency withRateValue:0.0f];
        }else{
            _rateValue *= [(kUser).currencyMain rateValueWithDate:_date];
            [_delegate currencySelected:_currency withRateValue:_rateValue];
        }
    }
    [self back];
}

-(void) changeRateValue{
    if (_currency == _mainCurrency) return;
//    [(kRoot) showKeyboardWithState:AGKBStateFull
//                          delegate:self
//                          animated:YES];
}

#pragma mark - setters
-(void)setCurrency:(Currency *)currency{
    if((_currency != nil)&&(_currency != currency)) {
        self.rateValue = [currency rateValueWithDate:_date mainCurrency:_mainCurrency];
    }else{
        self.rateValue = _rateValue;
    }
    _currency = currency;
    _lbRateLeft.text = [NSString stringWithFormat:@"%@ 1 = ", _currency.title];
}

-(void)setRateValue:(double)rateValue{
    if (rateValue <= 0) return;
    if (_rateValue > 0){
        _sum *= _rateValue;
        self.sum /= rateValue;
    }
    _rateValue = rateValue;
    _lbRate.text = [NSString stringWithFormat:@"%.2f", _rateValue];
}

-(void)setSum:(double)sum
{
    _sum = sum;
    [_lbBalance setTextFromNumber:_sum asInteger:NO withColor:[UIColor colorWithHex:kColorHexPaymentResult]];
    NSLog(@"Third: %f", _sum);
}

#pragma mark - keyBoarActions

- (void)keyboardWasShown:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    CGRect aRect = self.view.frame;
    _scrollView.contentSize = CGSizeMake(320.0f, 1000.0f);
    aRect.size.height -= keyboardSize.height;
    if (!CGRectContainsPoint(aRect, _lbRate.frame.origin) )
    {
        CGPoint scrollPoint = CGPointMake(0.0, _lbRate.frame.origin.y - (keyboardSize.height-15));
        [_scrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void) keyboardWillHide:(NSNotification *)notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - AGCurrencyListDelegate
-(void)currencyListController:(AGCurrencyListController *)controller didFinishedSelectingCurrency:(Currency *)currency{
    User* usr = (kUser);
    [usr addCurrenciesAdditionalObject:currency];
    [[AGDBWorker sharedWorker] saveManagedContext];
    _currencies = [usr currenciesMainAdditionalSorted];
    [_tvCurrencies reloadData];
}

//#pragma mark - AGKeyboardDelegate
//- (void) operationStringChanged:(NSString *)opString{
//    _lbRate.text = opString;
//}
//-(void)resultPressed:(double)result{
//    if(result > 0)
//        self.rateValue = result;
//}
//-(void)keyboardWillShow{
//    [_tvCurrencies hideAnimated];
//    _vInfo.tag = 1;
//    [_vInfo slideToPoint:CGPointMake(0, -140)];
//}
//-(void)keyboardWillHide{
//    [_tvCurrencies showAnimated];
//    _lbRate.text = [NSString stringWithFormat:@"%.2f", _rateValue];
//    [_vInfo slideOut];
//}

#pragma mark - UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1 + [_currencies count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* CellIdentifier = @"paymentEditCurrencyCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;        
    }

    cell.textLabel.font = [UIFont fontWithName:kFont1 size:18.0];
    if (indexPath.row == [_currencies count]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor colorWithHex:kColorHexGray];
        cell.textLabel.backgroundColor=[UIColor clearColor];
        cell.textLabel.text = NSLocalizedString(@"SettingsCurrencyAddCurrency", @"");
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        Currency* cur = [_currencies objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor colorWithHex:kColorHexGray];
        cell.textLabel.backgroundColor=[UIColor clearColor];
        if (cur == _currency) {
            cell.textLabel.textColor = [UIColor colorWithHex:kColorHexBlack];            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        cell.textLabel.text = cur.title;
    }
    
    [AGTools tableViewGrouped:tableView
                configureCell:cell
                withIndexPath:indexPath];
    
    return cell;
}

//header
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* v = [[UIView alloc] init];
    v.frame = CGRectMake(0, 0, 320, 14);
    
    //  title
    UILabel* lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(25, 4, 270.0, v.frame.size.height)];
    lbTitle.font = [UIFont fontWithName:kFont1 size:14.0];
    lbTitle.textColor = [UIColor colorWithHex:kColorHexBrown];
    lbTitle.textAlignment = UITextAlignmentLeft;
    lbTitle.backgroundColor = [UIColor clearColor];
    
    [v addSubview:lbTitle];
    switch (section) {
        case 0:
            lbTitle.text = [NSLocalizedString(@"PaymentEditCurrencySelect", @"") uppercaseString];

            return v;
            /*return [AGTools tableViewGroupedHeaderViewWithTitle:[NSLocalizedString(@"PaymentEditCurrencySelect", @"") uppercaseString]
                                                         height:[self tableView:tableView heightForHeaderInSection:section]];*/
        default:
            return nil;
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return kTableHeaderStandardHeight;
            
        default:
            return 0;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [AGTools cellStandardHeight];
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == [_currencies count]){
        AGCurrencyListController* ctl = [[AGCurrencyListController alloc] initWithNibName:@"AGCurrencyListView" bundle:nil];
        ctl.delegate = self;
        ctl.currencies = [Currency currenciesWithUser:kUser];
        User* usr = (kUser);
        ctl.currenciesDisabled = [usr currenciesMainAdditionalSorted];
        ctl.mainCurrency = [usr currencyMain];
        ctl.isAccount = NO;
        ctl.isMainCurrencyEdit = NO;
        [self.navigationController pushViewController:ctl animated:YES];
    }else{
        self.currency = (Currency*)[_currencies objectAtIndex:indexPath.row];
        [_tvCurrencies reloadData];
    }
}

@end
