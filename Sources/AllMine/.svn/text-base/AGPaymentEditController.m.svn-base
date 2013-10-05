//
//  AGPaymentEditController.m
//  AllMine
//
//  Created by Allgoritm LLC on 12.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "AGPaymentEditController.h"
#import "AGAppDelegate.h"
#import "AGRootController.h"
#import "UILabel+AGExtensions.h"
#import "Currency+EntityWorker.h"
#import "Account+EntityWorker.h"
#import "Category+EntityWorker.h"
#import "AGTools.h"
#import "NSDate+AGExtensions.h"
#import "AGPaymentEditCurrencyController.h"
#import "User+EntityWorker.h"
#import "Payment+EntityWorker.h"
#import "AGDBWorker.h"
#import "UIColor+AGExtensions.h"
#import <QuartzCore/QuartzCore.h>

@interface AGPaymentEditController ()

@property(nonatomic, assign) double sum;
@property(nonatomic, assign) double rateValue;
@property(nonatomic, strong) Currency* currency;
@property(nonatomic, strong) Account* account;
@property(nonatomic, strong) Category* category;
@property(nonatomic, strong) Account* accountAsCategory;
@property(nonatomic, strong) NSDate* date;
@property(nonatomic, strong) NSString* comment;
@property(nonatomic, strong) NSMutableArray* subpayments;

@property(nonatomic, strong) IBOutlet UIView* vKeyboard;
@property(nonatomic, strong) AGKeyboardController* kbCtl;

@property(nonatomic,strong) IBOutlet UITextView* txtvComment;
@property(nonatomic,strong) IBOutlet UIImageView* ivCommentBackground;
@property(nonatomic,strong) IBOutlet UILabel* lbCommentTruncated;

@property(nonatomic, strong) NSArray* accounts;

@property(nonatomic, strong) IBOutlet UILabel* lbSumResult;
@property(nonatomic, strong) IBOutlet UILabel* lbOps;
@property(nonatomic, strong) IBOutlet UIButton* bnAccount;
@property(nonatomic, strong) IBOutlet UIButton* bnDate;
@property(nonatomic, strong) IBOutlet UIButton* bnRemove;
@property(nonatomic, strong) IBOutlet UIButton* bnCategory;
@property(nonatomic, strong) IBOutlet UIButton* bnCurrency;
@property(nonatomic, strong) IBOutlet UIButton* bnSplit;
@property(nonatomic, strong) IBOutlet UIImageView* ivTemplate;

@property(nonatomic, strong) UILabel* lbSumIncorrect;

@property(nonatomic, assign) BOOL firstAppear;

@property(nonatomic, assign) BOOL keyboardPrintToLbOps;

@end

@implementation AGPaymentEditController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _account = nil;
        _category = nil;
        _accountAsCategory = nil;
        _date = [NSDate today];
        _subpayments = [NSMutableArray array];
        _sum = 0.0f;
        _rateValue = 0.0f;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.firstAppear = YES;
       // Do any additional setup after loading the view from its nib.
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = NSLocalizedString(@"PaymentEditPayment", @"");
    self.navigationItem.leftBarButtonItem = [AGTools navigationBarButtonItemWithImageNamed:@"button-back" target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [AGTools navigationBarButtonItemWithTitle:NSLocalizedString(@"Save", @"") imageNamed:@"button-save" target:self action:@selector(save)];
        
    _accounts = [(kUser).accounts allObjects];

    _currency = (kUser).currencyMain;
    
    //--NEW Keyboard
    if (!_payment) {
    _kbCtl = [[AGKeyboardController alloc] initWithNibName:@"AGKeyboardView" bundle:nil];
    _kbCtl.delegate = self;
    _kbCtl.state = AGKBStateSplit;
    _kbCtl.view.frame = CGRectMake(0, 0, 320, 216);
    [_vKeyboard addSubview:_kbCtl.view];
    }
    //---END NEW Keyboard
    if (_payment) {
        _account = _payment.account;
        _category = _payment.category;
        _accountAsCategory = _payment.accountAsCategory;
        _currency = _payment.currency;
        self.sum = [_payment.sum doubleValue];
        if ((self.category) && (self.category.type.intValue == CatTypeExpense)) {
            self.sum *= (-1);
        }
        _rateValue = [_payment.rateValue doubleValue];
        _date = _payment.date;
        _comment = _payment.comment;
        
        [_subpayments removeAllObjects];
        for (Payment* p in _payment.subpayments) {
            if (p.category) {
                [_subpayments addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:p.category, p.sum, nil] forKeys:[NSArray arrayWithObjects:kCategory, kSum, nil]]];
            }else{
                [_subpayments addObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:p.sum, nil] forKeys:[NSArray arrayWithObjects:kSum, nil]]];
            }
        }
    }
    
    
    float fontSize = 14.0f;
    if (_account == nil) {
        [_bnAccount setTitle:NSLocalizedString(@"PaymentEditFrom", @"") forState:UIControlStateNormal];
    }else{
        [_bnAccount setTitle:_account.title forState:UIControlStateNormal];
    }
    _bnAccount.titleLabel.font = [UIFont fontWithName:kFont1 size:fontSize];
    [_bnAccount setTitleColor:[UIColor colorWithHex:kColorHexPaymentEditText]
                     forState:UIControlStateNormal];
    [_bnAccount setTitleColor:[UIColor colorWithHex:kColorHexPaymentEditTextHighlighted]
                     forState:UIControlStateHighlighted];
    
    _bnCategory.titleLabel.font = [UIFont fontWithName:kFont1 size:fontSize];
    [_bnCategory setTitleColor:[UIColor colorWithHex:kColorHexPaymentEditText]
                      forState:UIControlStateNormal];
    [_bnCategory setTitleColor:[UIColor colorWithHex:kColorHexPaymentEditTextHighlighted]
                      forState:UIControlStateHighlighted];
    
    _bnCurrency.titleLabel.font = [UIFont fontWithName:kFont1 size:fontSize];
    [_bnCurrency setTitleColor:[UIColor colorWithHex:kColorHexPaymentEditText]
                      forState:UIControlStateNormal];
//    [_bnCurrency setTitleColor:[UIColor colorWithHex:kColorHexPaymentEditText]
//                      forState:UIControlStateHighlighted];
    
    _bnDate.titleLabel.numberOfLines = 2;
    if(_date == nil){
        [_bnDate setTitle:NSLocalizedString(@"PaymentEditDate", @"") forState:UIControlStateNormal];
    }else{
        [_bnDate setTitle:[_date dateTitle2Lined] forState:UIControlStateNormal];
    }
    _bnDate.titleLabel.font = [UIFont fontWithName:kFont1 size:fontSize];
    [_bnDate setTitleColor:[UIColor colorWithHex:kColorHexPaymentEditText]
                  forState:UIControlStateNormal];
    [_bnDate setTitleColor:[UIColor colorWithHex:kColorHexPaymentEditTextHighlighted]
                  forState:UIControlStateHighlighted];
 //---TextView----
    self.ivCommentBackground.image = [UIImage imageNamed: @"pay-bn-back-comment"];
    self.txtvComment.font = [UIFont fontWithName:kFont1 size:fontSize - 2];
    self.txtvComment.textColor = [UIColor colorWithHex:kColorHexPaymentEditTextHighlighted];
    self.txtvComment.delegate = self;
    self.txtvComment.textAlignment = UITextAlignmentRight;
    self.txtvComment.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    self.txtvComment.text = @"";
    
    self.lbCommentTruncated.font = self.txtvComment.font;
    self.lbCommentTruncated.textAlignment = self.txtvComment.textAlignment;
    self.lbCommentTruncated.textColor = self.txtvComment.textColor;
    self.lbCommentTruncated.numberOfLines = 2;
    self.lbCommentTruncated.lineBreakMode = UILineBreakModeTailTruncation;
    if ((self.comment) && ([self.comment isEqualToString:@""] == NO)) {
        self.lbCommentTruncated.text = self.comment;
    } else {
        self.lbCommentTruncated.text = NSLocalizedString(@"PaymentEditComment", @"");
    }
 //---TextView---
      
    _lbOps.textAlignment = UITextAlignmentRight;
    _lbOps.text = @"";
    _lbOps.font = [UIFont fontWithName:kFont2 size:12.0f];
    _lbOps.textColor=[UIColor colorWithHex:kColorHexPaymentResult];
    _lbOps.adjustsFontSizeToFitWidth = YES;
    
    _lbSumResult.font = [UIFont fontWithName:kFont2 size:40.0f];
    _lbSumResult.userInteractionEnabled = YES;
    [_lbSumResult addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeSum:)]];
    _lbSumResult.adjustsFontSizeToFitWidth = YES;

    _bnRemove.titleLabel.font = [UIFont fontWithName:kFont1 size:16.0f];
//---
   
//----
    [_bnRemove setTitle:NSLocalizedString(@"PaymentEditRemove", @"") forState:UIControlStateNormal];
    [_bnRemove setTitleColor:[UIColor colorWithHex:kColorHexWhite] forState:UIControlStateNormal];
    if(_payment == nil){
        _bnRemove.hidden = YES;
    }
    _ivTemplate.hidden = YES;
//    if (_payment.template != nil) {
//        _ivTemplate.hidden = NO;
//    }
    
    double sum = _sum;
    double rateVal = _rateValue;
    self.currency = _currency;
    _rateValue = rateVal;
    self.sum = sum;

    // sum incorrect
    self.lbSumIncorrect = [[UILabel alloc] initWithFrame:self.lbSumResult.frame];
    self.lbSumIncorrect.font = [UIFont fontWithName:kFont2 size:20.0f];
    self.lbSumIncorrect.backgroundColor = [UIColor clearColor];
    self.lbSumIncorrect.textAlignment = UITextAlignmentRight;
    self.lbSumIncorrect.text = [NSLocalizedString(@"PaymentEditSumIncorrect", @"") uppercaseString];
    self.lbSumIncorrect.textColor = [UIColor colorWithHex:kColorHexOrange];
    [self.lbSumResult.superview addSubview:self.lbSumIncorrect];
}

- (void) viewWillAppear:(BOOL)animated{
    
    if ((_category == nil)&&(_accountAsCategory == nil)) {
        [_bnCategory setTitle:NSLocalizedString(@"PaymentEditTo", @"") forState:UIControlStateNormal];
    }else{
        if (_category != nil) {
            [_bnCategory setTitle:_category.title forState:UIControlStateNormal];
        }else{
            [_bnCategory setTitle:_accountAsCategory.title forState:UIControlStateNormal];
        }
    }
    self.sum = self.sum;
}

-(void)viewDidAppear:(BOOL)animated{
    if (_payment) {
       [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(agKeyboardWillShow)
                                                     name:kEventAGKeyboardWillShow
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(agKeyboardWillHide)
                                                     name:kEventAGKeyboardWillHide
                                                   object:nil];

        if (self.firstAppear) {
            self.firstAppear = NO;
            if (_payment == nil){
                [(kRoot) showKeyboardWithState:AGKBStateFull
                                      delegate:self
                                      animated:NO];
            }
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - buttons
- (void) back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) save{
    [self.txtvComment resignFirstResponder];
    BOOL finished = YES;
    if((_account == nil)||((_category == nil)&&(_accountAsCategory == nil))) {
        finished = NO;
    }
    if (self.sum >= 0) {
        if ((self.category) && (self.category.type.intValue == CatTypeExpense)) {
            _sum *= (-1);
        }
        
        User* usr = (kUser);
        double sumMain = 0;
        if (_rateValue > 0.0f) {
            sumMain = _sum * _rateValue / [usr.currencyMain rateValueWithDate:_date];
        }else{
            sumMain = _sum * [_currency rateValueWithDate:_payment.date mainCurrency:usr.currencyMain];
        }
        AGDBWorker* db = [AGDBWorker sharedWorker];    
        if(_payment){
            _payment.account = _account;
            _payment.category = _category;
            _payment.accountAsCategory = _accountAsCategory;
            _payment.currency = _currency;
            _payment.sum = [NSNumber numberWithDouble:_sum];
            _payment.sumMain = [NSNumber numberWithDouble:sumMain];
            _payment.rateValue = [NSNumber numberWithDouble:_rateValue];
            _payment.date = _date;
            _payment.comment = _comment;
            _payment.modifiedDate = [NSDate date];
            _payment.finished = [NSNumber numberWithBool:finished];       
            [db saveManagedContext];
        }else{
            _payment = [Payment insertPaymentWithUser:usr account:_account category:_category accountAsCategory:_accountAsCategory currency:_currency sum:_sum sumMain:sumMain rateValue:0.0f date:_date comment:_comment ptemplate:nil finished:finished hidden:NO save:YES];
        }
        for (Payment* p in _payment.subpayments) {
            [p markRemovedSave:YES];
        }
        for (NSDictionary* d in _subpayments) {
            [Payment insertSubPaymentWithCategory:[d objectForKey:kCategory] sum:[[d objectForKey:kSum] doubleValue] superpayment:_payment save:YES];
        }
        [db saveManagedContext];
        [self back];
    }
}

-(IBAction)changeAccount:(id)sender{
    AGAccountListController* ctl = [[AGAccountListController alloc] initWithNibName:@"AGAccountListView" bundle:nil];
    ctl.ctlState = AccountListStateSelect;
    ctl.delegateSelect = self;
    [self.navigationController pushViewController:ctl animated:YES];
}

-(IBAction)changeCategory:(id)sender{
    AGSettingsCategoriesController* ctl = [[AGSettingsCategoriesController alloc] initWithNibName:@"AGSettingsCategoriesView" bundle:nil];
    ctl.delegate = self;
    [self.navigationController pushViewController:ctl animated:YES];
}

-(IBAction)changeDate:(id)sender{
    [(kRoot) showDatePickerWithDate:_date
                             target:self
                             action:@selector(dateSelected:)];
}

-(void)dateSelected:(id)sender{
    UIDatePicker* dp = (UIDatePicker*)sender;
    _date = [dp.date dateWithoutTime];
    [_bnDate setTitle:[_date dateTitle2Lined]
             forState:UIControlStateNormal];
}

-(void)changeSum:(id)sender{
    if (_payment) {
        [(kRoot) showKeyboardWithState:AGKBStateFull
                              delegate:self
                              animated:YES];
    }
}

-(IBAction)changeCurrency:(id)sender{
    AGPaymentEditCurrencyController* ctl = [[AGPaymentEditCurrencyController alloc] initWithNibName:@"AGPaymentEditCurrencyView" bundle:nil];
    ctl.currency = _currency;
    ctl.sum = _sum;
    ctl.date = _date;
    ctl.rateValue = _rateValue;
    ctl.delegate = self;
    [self.navigationController pushViewController:ctl animated:YES];
}

-(IBAction)makeSplit:(id)sender{
    AGPaymentSplitController* ctl = [[AGPaymentSplitController alloc] initWithNibName:@"AGPaymentSplitView" bundle:nil];
    ctl.sum = _sum;
    ctl.category = _category;
    ctl.delegate = self;
    ctl.subpayments = _subpayments;
    [self.navigationController pushViewController:ctl animated:YES];
}

-(IBAction)remove:(id)sender{
    if(_payment){
        [_payment markRemovedSave:YES];
    }
    [self back];
}

#pragma mark - AGSettingsCategoriesDelegate
-(void)selectedCategory:(Category *)category{
    self.category = category;
    _accountAsCategory = nil;
    [self.navigationController popToViewController:self animated:YES];
}
-(void)selectedAccount:(Account *)account{
    self.category = nil;
    _accountAsCategory = account;
    [self.navigationController popToViewController:self animated:YES];
}

#pragma mark - AGKeyboardDelegate
- (void) agKeyboardWillShow{
    self.keyboardPrintToLbOps = NO;
}

- (void) agKeyboardWillHide{
    self.lbOps.text = @"";
}

-(void)keyboardNumberPressed:(NSString *)number
             operationString:(NSString *)operationString
                      result:(double)result{
    self.sum = result;
    if (self.keyboardPrintToLbOps) {
        self.lbOps.text = operationString;
    }
}

-(void)keyboardOperationPressed:(NSString *)operation
                operationString:(NSString *)operationString
                         result:(double)result{
    self.keyboardPrintToLbOps = YES;
    self.sum = result;
    self.lbOps.text = operationString;
}

-(void)keyboardResultPressed:(double)result
             operationString:(NSString *)operationString{
    self.sum = result;
    self.lbOps.text = @"";
    self.keyboardPrintToLbOps = NO;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.lbCommentTruncated.text = @"";
    textView.text = _comment;
    self.ivCommentBackground.image = [UIImage imageNamed:@"pay-bn-back-comment-pressed"];
    [self performSelector:@selector(textViewMoveCursor:)
               withObject:textView
               afterDelay:0.01];
}
- (void)textViewMoveCursor:(UITextView *)textView{
    textView.selectedRange = NSMakeRange(textView.text.length, 0);
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    _comment = textView.text;
    self.ivCommentBackground.image = [UIImage imageNamed:@"pay-bn-back-comment"];
    textView.text = @"";
    self.lbCommentTruncated.text = self.comment;
    
    if ((self.comment) && ([self.comment isEqualToString:@""] == NO)) {
        self.lbCommentTruncated.text = self.comment;
    } else {
        self.lbCommentTruncated.text = NSLocalizedString(@"PaymentEditComment", @"");
    }
}

#pragma mark - AGPaymentEditCurrencyDelegate
-(void)currencySelected:(Currency *)currency withRateValue:(double)rateValue{
    self.currency = currency;

    double rateOld = [_currency rateValueWithDate:_date];
    if(_rateValue > 0.0f){
        rateOld = _rateValue;
    }
    double rateNew = [_currency rateValueWithDate:_date];
    if(rateValue > 0.0f){
        rateNew = rateValue;
    }
    _sum *= rateOld;
    self.sum /= rateNew;
    for (NSMutableDictionary* d in _subpayments) {
        double ksumNew = [[d objectForKey:kSum] doubleValue] * rateOld;
        ksumNew /= rateNew;
        [d setValue:[NSNumber numberWithDouble:ksumNew] forKey:kSum];
    }
    _rateValue = rateValue;
}

#pragma mark - AGPaymentSplitDelegate
-(void)splitFinishedWithArray:(NSArray *)result{
    _subpayments = [NSMutableArray arrayWithArray: result];
}

#pragma mark - setters
-(void)setAccount:(Account *)account{
    if(account == nil) return;
    self.currency = account.currency;
    _account = account;
    [_bnAccount setTitle:_account.title forState:UIControlStateNormal];    
}

-(void)setCurrency:(Currency *)currency{
    double rateOld = [_currency rateValueWithDate:_date];
    if(_rateValue > 0.0f){
        rateOld = _rateValue;
//        if(_currency != currency){
            _rateValue = 0.0f;
//        }
    }
    double rateNew = [currency rateValueWithDate:_date];
    _sum *= rateOld;
    self.sum /= rateNew;
    for (NSMutableDictionary* d in _subpayments) {
        double ksumNew = [[d objectForKey:kSum] doubleValue] * rateOld;
        ksumNew /= rateNew;
        [d setValue:[NSNumber numberWithDouble:ksumNew] forKey:kSum];
    }
    _currency = currency;
    [_bnCurrency setTitle:_currency.title forState:UIControlStateNormal];
}

-(void)setSum:(double)sum{
    _sum = sum;
    [_lbSumResult setTextFromNumber:_sum asInteger:NO withColor:[UIColor colorWithHex:kColorHexPaymentResult]];
    if (self.sum < 0) {
        self.lbSumResult.text = @"";
        self.lbSumIncorrect.hidden = NO;
    }else{
        self.lbSumIncorrect.hidden = YES;
    }
}

#pragma mark - AGAccountListControllerSelectDelegate
-(void)accountListController:(AGAccountListController *)accountListCtl
            didSelectAccount:(Account *)account{
    self.account = account;
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Touch Delegate
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.txtvComment isFirstResponder] && [touch view] != self.txtvComment) {
        [self.txtvComment resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

@end
