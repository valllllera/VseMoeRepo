//
//  AGAccountEditController.m
//  AllMine
//
//  Created by Allgoritm LLC on 09.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "AGAccountEditController.h"
#import "AGTools.h"
#import "User+EntityWorker.h"
#import "AGAppDelegate.h"
#import "AGRootController.h"
#import "Currency+EntityWorker.h"
#import "NSDate+AGExtensions.h"
#import "UIView+AGExtensions.h"
#import "UILabel+AGExtensions.h"
#import "AGDBWorker.h"
#import "UIColor+AGExtensions.h"
#import "UIView+AGExtensions.h"
#import "Payment+EntityWorker.h"
#import "AGPlotController.h"

@interface AGAccountEditController ()
@property(nonatomic, strong) UITextField* tfTitle;
@property(nonatomic, strong) UITextField* tfComment;
@property(nonatomic, strong) UITextField* tfBank;
@property(nonatomic, strong) UITextField* tfNumber;
@property(nonatomic, strong) UITextField* tfCard;
@property(nonatomic, strong) UITextField* tfPaymentSystem;

@property(nonatomic, assign) double balance;
@property(nonatomic, strong) Currency* currency;
@property(nonatomic, assign) int group;
@property(nonatomic, strong) NSDate* date;
@property(nonatomic, strong) NSString* titleAcc;
@property(nonatomic, strong) NSString* comment;

@property(nonatomic, strong) NSString* bank;
@property(nonatomic, strong) NSString* number;
@property(nonatomic, strong) NSString* card;
@property(nonatomic, strong) NSString* paymentSystem;
@property(nonatomic, assign) double creditLimit;

@property(nonatomic, strong) UILabel* lbBalance;
@property(nonatomic, strong) UILabel* lbCreditLimit;

@property(nonatomic, strong) IBOutlet UITableView* tvItems;
@property(nonatomic,strong) IBOutlet UIButton* btnRemove;

@property(nonatomic, assign) BOOL isEnteringBalance;

@end

@implementation AGAccountEditController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _account = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.hidesBackButton = YES;
    if(_account){
        self.navigationItem.title = NSLocalizedString(@"AccountEdit", @"");
    }else{
        self.navigationItem.title = NSLocalizedString(@"AccountEditNew", @"");
    }
    self.navigationItem.leftBarButtonItem = [AGTools navigationBarButtonItemWithImageNamed:@"button-back" target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [AGTools navigationBarButtonItemWithTitle:NSLocalizedString(@"Save", @"") imageNamed:@"button-save" target:self action:@selector(save)];
    
    if(_account){
        _accountType = _account.type.intValue;
        _currency = _account.currency;
        _balance = [_account balanceWithCurrency:_currency];
        _group = [_account.group intValue];
        _date = _account.dateOpen;
        _titleAcc = _account.title;
        _comment = _account.comment;
        _bank = _account.bank;
        _creditLimit = _account.creditLimit.doubleValue;
        _number = _account.number;
        _card = _account.card;
        _paymentSystem = _account.paymentSystem;
    }else{
        _currency = (kUser).currencyMain;
        _balance = 0;
       if ((self.accountType == AccTypeLoan) || (self.accountType==AccTypeCardCredit)) {
            _group = AccGroupDebts;
        }else{
            _group = AccGroupAllMine;
        }
        _date = [NSDate today];
        _titleAcc = @"";
        _comment = @"";
    }
    
    _tvItems.delegate = self;
    _tvItems.dataSource = self;
    _tvItems.separatorStyle = UITableViewCellSeparatorStyleNone;

    if(_account){
        UIButton* btnReport = [[UIButton alloc] initWithFrame:CGRectMake(240, 28, 63, 64)];
//        btnReport.backgroundColor = [UIColor colorWithHex:kColorHexGreen];
        [btnReport setImage:[UIImage imageNamed:@"button-account-plot"] forState:UIControlStateNormal];
        [btnReport setImage:[UIImage imageNamed:@"button-account-plot-pressed"] forState:UIControlStateHighlighted];
        [btnReport addTarget:self action:@selector(toReport) forControlEvents:UIControlEventTouchUpInside];
        [_tvItems addSubview:btnReport];
        self.accountType = _account.type.intValue;
    }
    
    CGRect frameTxt = CGRectMake(10, 21, 300, 21);
    float sizeTxt = 17.0f;
    
    _lbBalance = [[UILabel alloc] initWithFrame:frameTxt];
    _lbBalance.adjustsFontSizeToFitWidth = YES;
    _lbBalance.textColor = [UIColor colorWithHex:kColorHexGray];
    _lbBalance.font = [UIFont fontWithName:kFont1 size:20.0f];
    _lbBalance.backgroundColor = [UIColor clearColor];
    
    _lbCreditLimit = [[UILabel alloc] initWithFrame:frameTxt];
    _lbCreditLimit.adjustsFontSizeToFitWidth = YES;
    _lbCreditLimit.textColor = [UIColor colorWithHex:kColorHexGray];
    _lbCreditLimit.font = [UIFont fontWithName:kFont1 size:sizeTxt];
    _lbCreditLimit.backgroundColor = [UIColor clearColor];
    
    _tfTitle = [[UITextField alloc] initWithFrame:frameTxt];
    _tfTitle.font = [UIFont fontWithName:kFont1 size:sizeTxt];
    _tfTitle.delegate = self;
    _tfTitle.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _tfTitle.placeholder = NSLocalizedString(@"AccountEditTitle", @"");
    _tfTitle.textColor = [UIColor colorWithHex:kColorHexHeader];
    
    _tfComment = [[UITextField alloc] initWithFrame:frameTxt];
    _tfComment.font = [UIFont fontWithName:kFont1 size:sizeTxt];
    _tfComment.delegate = self;
    _tfComment.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _tfComment.placeholder = NSLocalizedString(@"AccountEditComment", @"");
    _tfComment.textColor = [UIColor colorWithHex:kColorHexBlack];
    
    _tfBank = [[UITextField alloc] initWithFrame:frameTxt];
    _tfBank.font = [UIFont fontWithName:kFont1 size:sizeTxt];
    _tfBank.delegate = self;
    _tfBank.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _tfBank.placeholder = NSLocalizedString(@"AccountEditBank", @"");
    if (self.accountType == AccTypeBank) {
        _tfBank.placeholder = NSLocalizedString(@"AccountEditBankCompany", @"");
    }
    _tfBank.textColor = [UIColor colorWithHex:kColorHexBlack];
    
    _tfPaymentSystem = [[UITextField alloc] initWithFrame:frameTxt];
    _tfPaymentSystem.font = [UIFont fontWithName:kFont1 size:sizeTxt];
    _tfPaymentSystem.delegate = self;
    _tfPaymentSystem.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    switch (self.accountType) {
        case AccTypeCardCredit:
        _tfPaymentSystem.placeholder=NSLocalizedString(@"AccountEditPayTo", @"");
            break;
            
        default:
            _tfPaymentSystem.placeholder = NSLocalizedString(@"AccountEditPaymentSystem", @"");
            break;
    }
    
    
    _tfPaymentSystem.textColor = [UIColor colorWithHex:kColorHexBlack];
    
    frameTxt.size.width = 150;
    frameTxt.origin.x = 160;
    
    _tfNumber = [[UITextField alloc] initWithFrame:frameTxt];
    _tfNumber.font = [UIFont fontWithName:kFont1 size:12.0f];
    _tfNumber.delegate = self;
    _tfNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _tfNumber.textAlignment = NSTextAlignmentRight;
    _tfNumber.placeholder = NSLocalizedString(@"AccountEditLast4", @"");
    _tfNumber.textColor = [UIColor colorWithHex:kColorHexHeader];
    _tfNumber.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    _tfCard = [[UITextField alloc] initWithFrame:frameTxt];
    _tfCard.font = [UIFont fontWithName:kFont1 size:12.0f];
    _tfCard.delegate = self;
    _tfCard.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _tfCard.textAlignment = NSTextAlignmentRight;
    _tfCard.placeholder = NSLocalizedString(@"AccountEditLast4", @"");
    _tfCard.textColor = [UIColor colorWithHex:kColorHexHeader];
    _tfCard.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    // footer view
    if (self.account) {
        UIImage* img = [UIImage imageNamed:@"button-removePayment"];
        UIView *vFooter=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, img.size.height + 22)];
        UIButton *btnRemove=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
        btnRemove.center = CGPointMake(vFooter.frame.size.width/2,
                                       vFooter.frame.size.height/2);
        [btnRemove setBackgroundImage:img
                             forState:UIControlStateNormal];
        [btnRemove setBackgroundImage:[UIImage imageNamed:@"button-removePayment-pressed"]
                             forState:UIControlStateHighlighted];
        [btnRemove setTitleColor:[UIColor colorWithHex:kColorHexWhite]
                        forState:UIControlStateNormal];
        [btnRemove setTitle:NSLocalizedString(@"AccountEditRemoveButton", @"")
                   forState:UIControlStateNormal];
        [vFooter addSubview: btnRemove];
        [btnRemove addTarget:self
                      action:@selector(removeAccount)
            forControlEvents:UIControlEventTouchUpInside];
        btnRemove.titleLabel.font = [UIFont fontWithName:kFont1 size:16.0f];
        self.tvItems.tableFooterView = vFooter;
    }
}

-(void)viewWillAppear:(BOOL)animated{

    [_tvItems reloadData];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:kEventAGKeyboardWillHide
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:kEventAGKeyboardWillShow
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(systemKeyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(systemKeyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [_tvItems sizeReturn];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - buttons
- (void) back{
    [[AGDBWorker sharedWorker] rollback];
    [self navCtlPop];
}
- (void) navCtlPop{
    if (self.parentBack) {
        [self.navigationController popToViewController:self.parentBack
                                              animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) removeAccount{
    if (self.account) {
        [self.account markRemovedSave:YES];
        [self.navigationController popToViewController:[self.navigationController.viewControllers
                                                        objectAtIndex:self.navigationController.viewControllers.count-3]
                                              animated:YES];
    }
}

- (void) save{
    [self.view endEditing:YES];
    if(_titleAcc.length > 0){
        [[AGDBWorker sharedWorker] rollback];
        if(_account){
            _account.title = _titleAcc;
            _account.comment = _comment;
            _account.currency = _currency;
            _account.group = [NSNumber numberWithDouble: _group];
            _account.modifiedDate = [NSDate date];
            _account.creditLimit = [NSNumber numberWithDouble:self.creditLimit];
            _account.bank = self.bank;
            _account.card = self.card;
            _account.number = self.number;
            _account.paymentSystem = self.paymentSystem;
            [[AGDBWorker sharedWorker] saveManagedContext];
            double balanceOld = [_account balanceWithCurrency:_currency];
            double dBalance = _balance - balanceOld;
            if (abs(dBalance) >= 0.01) {
                double sumMain = dBalance * [_currency rateValueWithDate:_date mainCurrency:(kUser).currencyMain];
                [Payment insertPaymentWithUser:kUser
                                       account:_account
                                      category:nil
                             accountAsCategory:nil
                                      currency:_currency
                                           sum:dBalance
                                       sumMain:sumMain
                                     rateValue:0.0f
                                          date:[NSDate date]
                                       comment:_comment
                                     ptemplate:nil
                                      finished:YES
                                        hidden:YES
                                          save:YES];
            }
        }else{
            _account = [Account insertAccountWithUser:(kUser)
                                                title:_titleAcc
                                             currency:_currency
                                                 date:_date
                                                group:_group
                                                 type:_accountType
                                              comment:_comment
                                                 save:YES];
            _account.creditLimit = [NSNumber numberWithDouble:self.creditLimit];            
            _account.bank = self.bank;
            _account.card = self.card;
            _account.number = self.number;
            _account.paymentSystem = self.paymentSystem;
            [[AGDBWorker sharedWorker] saveManagedContext];
            double sumMain = _balance * [_currency rateValueWithDate:_date mainCurrency:(kUser).currencyMain];
            [Payment insertPaymentWithUser:kUser
                                   account:_account
                                  category:nil
                         accountAsCategory:nil
                                  currency:_currency
                                       sum:_balance
                                   sumMain:sumMain
                                 rateValue:0.0f
                                      date:[NSDate date]
                                   comment:_comment
                                 ptemplate:nil
                                  finished:YES
                                    hidden:YES
                                      save:YES];
            
        }
        [self navCtlPop];
    }else{
        [_tfTitle shake];
    }
}

- (void) toReport{
    AGPlotController* ctl = [[AGPlotController alloc]
                             initWithNibName:@"AGPlotView"
                             bundle:nil];
    ctl.account = _account;
    [self.navigationController pushViewController:ctl
                                         animated:YES];
}

- (void) dateSelected:(id)sender{
    UIDatePicker* dp = (UIDatePicker*)sender;
    _date = dp.date;
    [_tvItems reloadData];
}

#pragma mark - UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [AGTools cellStandardHeight];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int rows = 0;

    switch (self.accountType) {
        case AccTypeLoan:
        case AccTypeCash:
            rows = 6;
            break;
            
        case AccTypeCardCredit:
            rows = 11;
            break;
            
        case AccTypeBank:
            rows = 10;
            break;

        default:
            break;
    }

    return rows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* CellIdentifier = @"accountEditCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
    }else{
        for (UIView*v in cell.contentView.subviews) {
            if([v isKindOfClass:[UILabel class]] ||
               [v isKindOfClass:[UITextField class]]){
                [v removeFromSuperview];
            }
        }
    }

    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = @"";
    cell.detailTextLabel.text = @"";
    cell.userInteractionEnabled = YES;
    cell.textLabel.font = [UIFont fontWithName:kFont1 size:17.0];
    cell.textLabel.textColor = [UIColor colorWithHex:kColorHexBlack];
    cell.detailTextLabel.font = [UIFont fontWithName:kFont1 size:15.0];
    cell.detailTextLabel.textColor = [UIColor colorWithHex:kColorHexHeader];
    switch (indexPath.row) {
        case 0:
            [self configureCellBalance:cell];
            break;

        case 1:
            switch (self.accountType) {
                case AccTypeBank:
                case AccTypeCash:
                case AccTypeLoan:                    
                    [self configureCellTitle:cell];
                    break;
                    
                case AccTypeCardCredit:
                    [self configureCellCreditLimit:cell];
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 2:
            switch (self.accountType) {
                case AccTypeBank:
                case AccTypeCash:
                case AccTypeLoan:                    
                    [self configureCellCurrency:cell];
                    break;
                    
                case AccTypeCardCredit:
                    [self configureCellTitle:cell];                    
                    break;

                default:
                    break;
            }
            break;

        case 3:
            switch (self.accountType) {
                case AccTypeBank:
                case AccTypeCash:
                case AccTypeLoan:                    
                    [self configureCellDateOpen:cell];
                    break;
                    
                case AccTypeCardCredit:
                    [self configureCellCurrency:cell];                    
                    break;

                default:
                    break;
            }
            break;
            
        case 4:
            switch (self.accountType) {
                case AccTypeBank:
                    [self configureCellBank:cell];
                    break;
                    
                case AccTypeCash:
                case AccTypeLoan:                    
                    [self configureCellAccGroup:cell];
                    break;
                    
                case AccTypeCardCredit:
                    [self configureCellDateOpen:cell];
                    break;

                default:
                    break;
            }
            break;
            
        case 5:
            switch (self.accountType) {
                case AccTypeBank:
                    [self configureCellNumber:cell];
                    break;
                    
                case AccTypeCash:
                case AccTypeLoan:                    
                    [self configureCellComment:cell];
                    break;
                    
                case AccTypeCardCredit:
                    [self configureCellBank:cell];
                    break;

                default:
                    break;
            }
            break;

        case 6:
            switch (self.accountType) {
                case AccTypeBank:
                    [self configureCellCard:cell];
                    break;
                    
                case AccTypeCash:
                    break;
                    
                case AccTypeCardCredit:
                    [self configureCellNumber:cell];
                    break;
                    
                case AccTypeLoan:
                    break;
                    
                default:
                    break;
            }
            break;

        case 7:
            switch (self.accountType) {
                case AccTypeBank:
                    [self configureCellPaymentSystem:cell];
                    break;
                    
                case AccTypeCash:
                    break;
                    
                case AccTypeCardCredit:
                    [self configureCellCard:cell];
                    break;
                    
                case AccTypeLoan:
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 8:
            switch (self.accountType) {
                case AccTypeBank:
                    [self configureCellAccGroup:cell];
                    break;
                    
                case AccTypeCash:
                    break;
                    
                case AccTypeCardCredit:
                    [self configureCellPaymentSystem:cell];
                    break;
                    
                case AccTypeLoan:
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 9:
            switch (self.accountType) {
                case AccTypeBank:
                    [self configureCellComment:cell];
                    break;
                    
                case AccTypeCash:
                    break;
                    
                case AccTypeCardCredit:
                    [self configureCellAccGroup:cell];
                    break;
                    
                case AccTypeLoan:
                    break;
                    
                default:
                    break;
            }
            break;

        case 10:
            switch (self.accountType) {
                case AccTypeBank:
                    break;
                    
                case AccTypeCash:
                    break;
                    
                case AccTypeCardCredit:
                    [self configureCellComment:cell];
                    break;
                    
                case AccTypeLoan:
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    
    [AGTools tableViewPlain:_tvItems
              configureCell:cell
              withIndexPath:indexPath];
    return cell;
}

#pragma mark - PRIVATE configure cell
- (void) configureCellAccGroup:(UITableViewCell*)cell{
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = NSLocalizedString(@"AccountEditAccGroup", @"");
    cell.detailTextLabel.text = [AGTools accountGroupTitleWithGroup:_group];
}
- (void) configureCellComment:(UITableViewCell*)cell{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    _tfComment.text = _comment;
    [cell.contentView addSubview:_tfComment];
}
- (void) configureCellTitle:(UITableViewCell*)cell{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    _tfTitle.text = _titleAcc;
    [cell.contentView addSubview:_tfTitle];
}
- (void) configureCellBalance:(UITableViewCell*)cell{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.lbBalance setTextFromNumber:_balance
                        asInteger:NO
                        withColor:nil];
    if((self.account == nil) && (self.balance == 0)){
        self.lbBalance.textColor = [UIColor colorWithHex:kColorHexGray];
        switch (self.accountType) {
            case AccTypeLoan:
                self.lbBalance.text=NSLocalizedString(@"AccountEditBalanceLoan", @"");
                break;
                
            case AccTypeCardCredit:
                self.lbBalance.text=NSLocalizedString(@"AccountEditCreditBalance", @"");
                break;
            default:
                self.lbBalance.text=NSLocalizedString(@"AccountEditBalanceInit", @"");
        }
     }
    self.lbBalance.textAlignment = UITextAlignmentLeft;
    [cell.contentView addSubview:self.lbBalance];
}
- (void) configureCellCreditLimit:(UITableViewCell*)cell{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.lbCreditLimit setTextFromNumber:self.creditLimit
                                asInteger:NO
                                withColor:nil];
    if((self.account == nil) && (self.creditLimit == 0)){
        self.lbCreditLimit.textColor = [UIColor colorWithHex:kColorHexGray];
        self.lbCreditLimit.text = NSLocalizedString(@"AccountEditCreditLimit", @"");
    }
    self.lbCreditLimit.textAlignment = UITextAlignmentLeft;
    [cell.contentView addSubview:self.lbCreditLimit];
}
- (void) configureCellCurrency:(UITableViewCell*)cell{
    cell.textLabel.text = _currency.title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}
- (void) configureCellDateOpen:(UITableViewCell*)cell{
    cell.textLabel.text = [_date dateTitleFull];
    cell.detailTextLabel.text = NSLocalizedString(@"AccountEditDateOpened", @"");
    if(_account){
        cell.userInteractionEnabled = NO;
    }
}
- (void) configureCellBank:(UITableViewCell*)cell{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tfBank.text = self.bank;
    [cell.contentView addSubview:self.tfBank];
}
- (void) configureCellNumber:(UITableViewCell*)cell{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tfNumber.text = self.number;
    [cell.contentView addSubview:self.tfNumber];
    cell.textLabel.text = NSLocalizedString(@"AccountEditNumber", @"");
}
- (void) configureCellCard:(UITableViewCell*)cell{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tfCard.text = self.card;
   [cell.contentView addSubview:self.tfCard];
    cell.textLabel.text = NSLocalizedString(@"AccountEditCard", @"");
}
- (void) configureCellPaymentSystem:(UITableViewCell*)cell{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tfPaymentSystem.text = self.paymentSystem;
    [cell.contentView addSubview:self.tfPaymentSystem];
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            self.isEnteringBalance = YES;
            [(kRoot) showKeyboardWithState:AGKBStateFull
                                  delegate:self
                                  animated:YES];
            break;
            
        case 1:
            switch (self.accountType) {
                case AccTypeBank:
                case AccTypeCash:
                case AccTypeLoan:
                    break;
                    
                case AccTypeCardCredit:
                    self.isEnteringBalance = NO;
                    [(kRoot) showKeyboardWithState:AGKBStateFull
                                          delegate:self
                                          animated:YES];
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 2:
            switch (self.accountType) {
                case AccTypeBank:
                case AccTypeCash:
                case AccTypeLoan:
                    [self didSelectCurrency];
                    break;
                    
                case AccTypeCardCredit:
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 3:
            switch (self.accountType) {
                case AccTypeBank:
                case AccTypeCash:
                case AccTypeLoan:
                    [self didSelectDate];
                    break;
                    
                case AccTypeCardCredit:
                    [self didSelectCurrency];
                    break;
                    
                default:
                    break;
            }
            break;
        
        case 4:
            switch (self.accountType) {
                case AccTypeBank:
                    break;
                    
                case AccTypeCash:
                case AccTypeLoan:
                    [self didSelectAccGroup];
                    break;
                    
                case AccTypeCardCredit:
                    [self didSelectDate];
                    break;
                    
                default:
                    break;
            }
            break;
        
        case 8:
            switch (self.accountType) {
                case AccTypeBank:
                    [self didSelectAccGroup];
                    break;
                    
                case AccTypeCash:
                case AccTypeLoan:
                case AccTypeCardCredit:
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 9:
            switch (self.accountType) {
                case AccTypeBank:
                case AccTypeCash:
                case AccTypeLoan:
                    break;
                    
                case AccTypeCardCredit:
                    [self didSelectAccGroup];
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
}

- (void) didSelectCurrency{
    AGCurrencyListController* ctl = [[AGCurrencyListController alloc] initWithNibName:@"AGCurrencyListView" bundle:nil];
    ctl.delegate = self;
    User* usr = (kUser);
    ctl.currencies = [usr currenciesMainAdditionalSorted];
    ctl.currenciesDisabled = [NSArray arrayWithObject:_currency];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void) didSelectDate{
    [(kRoot) showDatePickerWithDate:[NSDate today]
                             target:self
                             action:@selector(dateSelected:)];
    [_tvItems reloadData];
}

- (void) didSelectAccGroup{
    AGAccountGroupController* ctl = [[AGAccountGroupController alloc] initWithNibName:@"AGAccountGroupView" bundle:nil];
    ctl.delegate = self;
    ctl.group = _group;
    [self.navigationController pushViewController:ctl
                                         animated:YES];
}

#pragma mark - UITextFieldDelegate

- (void) systemKeyboardWillShow{
    UITextField* textField = nil;
    if (_tfBank.isFirstResponder) {
        textField = _tfBank;
    }else if (_tfCard.isFirstResponder){
        textField = _tfCard;
    }else if (_tfComment.isFirstResponder){
        textField = _tfComment;
    }else if (_tfNumber.isFirstResponder){
        textField = _tfNumber;
    }else if (_tfPaymentSystem.isFirstResponder){
        textField = _tfPaymentSystem;
    }else if (_tfTitle.isFirstResponder){
        textField = _tfTitle;
    }

    int row = 0;
    if (textField == _tfComment) {
        switch (self.accountType) {
            case AccTypeCash:
            case AccTypeLoan:
                row = 5;
                break;
                
            case AccTypeBank:
                row = 9;
                break;
                
            case AccTypeCardCredit:
                row = 10;
                break;
                
            default:
                break;
        }
    }else if (textField == _tfBank){
        row = 4;
        if (self.accountType == AccTypeCardCredit) {
            row++;
        }
    }else if (textField == _tfCard){
        row = 5;
        if (self.accountType == AccTypeCardCredit) {
            row++;
        }
    }else if (textField == _tfNumber){
        row = 6;
        if (self.accountType == AccTypeCardCredit) {
            row++;
        }
    }else if (textField == _tfPaymentSystem){
        row = 7;
        if (self.accountType == AccTypeCardCredit) {
            row++;
        }
    }
    _tvItems.tag = 1;

    CGSize size = _tvItems.frame.size;
    size.height = 200;
    if (isIphoneRetina4) {
        size.height = 288;
    }
    [_tvItems sizeChangeAnimated:size];
    [self performSelector:@selector(scrollIn:)
               withObject:[NSNumber numberWithInt:row]
               afterDelay:kSlideAnimationTime];
}

- (void) systemKeyboardWillHide{
    [_tvItems sizeReturnAnimated];
    [_tvItems reloadData];
}

- (void) scrollIn:(NSNumber*)num{
    [_tvItems scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:num.intValue
                                                        inSection:0]
                    atScrollPosition:UITableViewScrollPositionMiddle
                            animated:YES];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _tfComment) {
        self.comment = _tfComment.text;
    }else if (textField == _tfBank){
        self.bank = _tfBank.text;
    }else if (textField == _tfCard){
        self.card = _tfCard.text;
    }else if (textField == _tfNumber){
        self.number = _tfNumber.text;
    }else if (textField == _tfPaymentSystem){
        self.paymentSystem = _tfPaymentSystem.text;
    }else if (textField == _tfTitle){
        self.titleAcc = _tfTitle.text;
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - AGCurrencyListDelegate
-(void)currencyListController:(AGCurrencyListController *)controller didFinishedSelectingCurrency:(Currency *)currency{
    if(_account){
        _balance = [_account balanceWithCurrency:currency];
    }else{
        _balance *= [_currency rateValueWithDate:[NSDate today] mainCurrency:currency];
    }
    _currency = currency;
    [_tvItems reloadData];
}

#pragma mark - AGAccountGroupController
-(void)accountGroupController:(AGAccountGroupController *)controller didFinishedSelectingGroup:(int)group{
    _group = group;
    [_tvItems reloadData];
}

#pragma mark - AGKeyboardDelegate
-(void)keyboardNumberPressed:(NSString *)number
             operationString:(NSString *)operationString
                      result:(double)result{
    UILabel* lb = self.lbBalance;
    if (self.isEnteringBalance) {
        lb = self.lbBalance;
        self.balance = result;
    }else{
        lb = self.lbCreditLimit;
        self.creditLimit = result;
    }
    [lb setTextFromNumber:result
                asInteger:NO
                withColor:nil];
    lb.textAlignment = NSTextAlignmentLeft;
    lb.text = operationString;
}

-(void)keyboardOperationPressed:(NSString *)operation
                operationString:(NSString *)operationString
                         result:(double)result{
    UILabel* lb = self.lbBalance;
    if (self.isEnteringBalance) {
        lb = self.lbBalance;
        self.balance = result;
    }else{
        lb = self.lbCreditLimit;
        self.creditLimit = result;
    }
    [lb setTextFromNumber:result
                asInteger:NO
                withColor:nil];
    lb.textAlignment = NSTextAlignmentLeft;
    lb.text = operationString;}

-(void)keyboardResultPressed:(double)result
             operationString:(NSString *)operationString{
    UILabel* lb = self.lbBalance;
    if (self.isEnteringBalance) {
        lb = self.lbBalance;
        self.balance = result;
    }else{
        lb = self.lbCreditLimit;
        self.creditLimit = result;
    }
    [lb setTextFromNumber:result
                asInteger:NO
                withColor:nil];
    lb.textAlignment = NSTextAlignmentLeft;
    lb.text = operationString;}

- (void) keyboardWillHide{
    if ((self.account) && (self.isEnteringBalance)){
        double balanceOld = [_account balanceWithCurrency:_currency];
        double dBalance = _balance - balanceOld;
        if (abs(dBalance) >= 0.01) {
            double sumMain = dBalance * [_currency rateValueWithDate:_date mainCurrency:(kUser).currencyMain];
            [Payment insertPaymentWithUser:kUser
                                   account:_account
                                  category:nil
                         accountAsCategory:nil
                                  currency:_currency
                                       sum:dBalance
                                   sumMain:sumMain
                                 rateValue:0.0f
                                      date:[NSDate date]
                                   comment:_comment
                                 ptemplate:nil
                                  finished:YES
                                    hidden:YES
                                      save:NO];
        }
    }
   
    
    [_tvItems reloadData];
}
- (void) keyboardWillShow{
    
}

@end
