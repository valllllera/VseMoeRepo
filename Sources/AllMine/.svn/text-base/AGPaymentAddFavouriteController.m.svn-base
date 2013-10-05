//
//  AGPaymentAddFavouriteController.m
//  AllMine
//
//  Created by Allgoritm LLC on 15.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "AGPaymentAddFavouriteController.h"
#import "AGTools.h"
#import "Currency+EntityWorker.h"
#import "User+EntityWorker.h"
#import "AGAppDelegate.h"
#import "AGRootController.h"
#import "Currency+EntityWorker.h"
#import "UILabel+AGExtensions.h"
#import "Template+EntityWorker.h"
#import "Category+EntityWorker.h"

#import "AGTemplateEditController.h"

#import "Payment+EntityWorker.h"
#import "Template+EntityWorker.h"

#import "NSDate+AGExtensions.h"
#import "UIColor+AGExtensions.h"

#import "AGDBWorker.h"

#import "AGPaymentEditController.h"

#define kViewResetDelay 2.0f

@interface AGPaymentAddFavouriteController ()

@property(nonatomic, strong) IBOutlet UILabel* lbSum;
@property(nonatomic, strong) IBOutlet UIButton* bnCurrency;
@property(nonatomic, strong) IBOutlet UIView* vKeyboard;
@property(nonatomic, strong) IBOutlet UIScrollView* svRibbon;
@property(nonatomic, strong) AGKeyboardController* kbCtl;

@property(nonatomic, strong) NSMutableArray* subpayments;
@property(nonatomic, strong) NSMutableArray* bnsTemplate;

@property(nonatomic, strong) Currency* currency;
@property(nonatomic, assign) double rateValue;
@property(nonatomic, assign) double sum;

@property(nonatomic, strong) IBOutlet UILabel* lbResult;

@property(nonatomic, strong) UILabel* lbSumIncorrect;

@property(nonatomic, strong) NSArray* templates;

@end

@implementation AGPaymentAddFavouriteController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _rateValue = 0.0f;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.hidesBackButton = YES;
    UIView *title_view=[[UIView alloc] initWithFrame:self.navigationController.navigationBar.frame];
     UILabel *lb_title=[[UILabel alloc] initWithFrame:self.navigationController.navigationBar.frame];
    lb_title.text=NSLocalizedString(@"PaymentAddFavourite", @"");
    lb_title.textColor=[UIColor colorWithHex:kColorHexBlue];
    lb_title.font=[UIFont fontWithName:kFont1 size:15.0];
    lb_title.textAlignment=UITextAlignmentCenter;
    title_view=lb_title;
    title_view.backgroundColor=[UIColor clearColor];
    self.navigationItem.titleView=title_view;
    self.navigationItem.leftBarButtonItem = [AGTools navigationBarButtonItemWithImageNamed:@"button-back" target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [AGTools navigationBarButtonItemWithTitle:NSLocalizedString(@"PaymentTemplateToPaymentAddCommon", @"") imageNamed:@"button-save" target:self action:@selector(toPaymentCommon)];
    
    _subpayments = [NSMutableArray array];    
    
    _kbCtl = [[AGKeyboardController alloc] initWithNibName:@"AGKeyboardView" bundle:nil];
    _kbCtl.delegate = self;
    _kbCtl.state = AGKBStateSplit;
    _kbCtl.view.frame = CGRectMake(0, 0, 320, 216);
    [_vKeyboard addSubview:_kbCtl.view];
    
    [_bnCurrency setTitleColor:[UIColor colorWithHex:kColorHexDarkGray] forState:UIControlStateNormal];
    _bnCurrency.titleLabel.font = [UIFont fontWithName:kFont1 size:16.0f];
    self.currency = (kUser).currencyMain;
    
    _lbSum.font = [UIFont fontWithName:kFont2 size:40.0f];
    
   self.lbResult.textColor = [UIColor orangeColor];
    self.lbResult.font = [UIFont fontWithName:kFont1 size:12.0f];
    self.lbResult.textColor = [UIColor colorWithHex:kColorHexPaymentResult];
    self.lbResult.text = @"";

    self.sum = 0;
    
    _bnsTemplate = [NSMutableArray array];
    
    // sum incorrect
    self.lbSumIncorrect = [[UILabel alloc] initWithFrame:self.lbSum.frame];
    self.lbSumIncorrect.font = [UIFont fontWithName:kFont2 size:20.0f];
    self.lbSumIncorrect.backgroundColor = [UIColor clearColor];
    self.lbSumIncorrect.textAlignment = UITextAlignmentRight;
    self.lbSumIncorrect.text = [NSLocalizedString(@"PaymentEditSumIncorrect", @"") uppercaseString];
    self.lbSumIncorrect.textColor = [UIColor colorWithHex:kColorHexOrange];
    [self.lbSum.superview addSubview:self.lbSumIncorrect];
    
    [self hideLabelSumIncorrect];
}

-(void)viewWillAppear:(BOOL)animated{
//    self.sum = _sum;
//    self.currency = _currency;
    self.lbSum.textColor = [UIColor colorWithHex:kColorHexPaymentResult];
    [AGTools navigationBarSetOffsetZero:self.navigationController.navigationBar];
    
    //  ribbon
    for (UIView* b in _svRibbon.subviews) {
        if([b isKindOfClass:[UIView class]]){
            [b removeFromSuperview];
        }
    }
    _templates = [(kUser) templateSortedList];
    [_bnsTemplate removeAllObjects];
    _svRibbon.pagingEnabled = YES;
    double width = 80;
    double height = _svRibbon.frame.size.height / 2;
    int num = [_templates count]+1;
    for (int i = 0; i < num; i++) {
        double origX = width * (i - 1) / 2;
        double origY = height;
        if(i%2 == 0){
            origX = width * i / 2;
            origY = 0;
        }
        origY += (height - 42)/2;
        
        UIView* v = [[UIView alloc] initWithFrame:CGRectMake(origX,
                                                            origY,
                                                            width,
                                                             height)];
        
        UIButton* bn = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  width,
                                                                  height-21)];
        bn.tag = i;
        [v addSubview:bn];
        
        UILabel* lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 21, width, 21)];
        if (isIphoneRetina4) {
            CGRect rect=CGRectMake(0, 50, width, 21);
            lb.frame=rect;
        }
        lb.textAlignment = UITextAlignmentCenter;
        lb.font = [UIFont fontWithName:kFont1 size:12.0];
        lb.textColor = [UIColor colorWithHex:kColorHexBlack];
        lb.backgroundColor = [UIColor clearColor];
        [v addSubview:lb];
        
        if(i < [_templates count]){
            [bn setImage:[UIImage imageNamed:@"star-black"] forState:UIControlStateNormal];
            [bn setImage:[UIImage imageNamed:@"star-black-pressed"] forState:UIControlStateHighlighted];
            Template* tmplt = (Template*)[_templates objectAtIndex:i];
            lb.text = tmplt.title;
            [bn addTarget:self action:@selector(selectTemplate:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [bn setImage:[UIImage imageNamed:@"star-green"] forState:UIControlStateNormal];
            [bn setImage:[UIImage imageNamed:@"star-green-pressed"] forState:UIControlStateHighlighted];
            lb.text = NSLocalizedString(@"PaymentAddFavouriteNew", @"");
            [bn addTarget:self action:@selector(createTemplate) forControlEvents:UIControlEventTouchUpInside];
        }
        [_svRibbon addSubview:v];
        [_bnsTemplate addObject:bn];
    }
    _svRibbon.contentSize = CGSizeMake(width/2 * (num + num%2),
                                       height * 2);    
}

-(void)viewWillDisappear:(BOOL)animated{
    [AGTools navigationBarSetOffsetStandart:self.navigationController.navigationBar];
}

#pragma mark - buttons
- (void) back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) toPaymentCommon{
    AGPaymentEditController* ctl = [[AGPaymentEditController alloc] initWithNibName:@"AGPaymentEditView" bundle:nil];
    ctl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctl
                                         animated:YES];
}

- (IBAction) changeCurrency:(id)sender{
    AGPaymentEditCurrencyController* ctl = [[AGPaymentEditCurrencyController alloc] initWithNibName:@"AGPaymentEditCurrencyView" bundle:nil];
    ctl.currency = _currency;
    ctl.sum = _sum;
    ctl.date = [NSDate date];
    ctl.rateValue = _rateValue;
    ctl.delegate = self;
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)selectTemplate:(id)sender{
    UIButton* bn = (UIButton*)sender;
    Template* tmpl = [_templates objectAtIndex:bn.tag];
    
    if ([self isSumCorrect]) {
        if ((tmpl.category) && (tmpl.category.type.intValue == CatTypeExpense)) {
            _sum *= (-1);
        }
        User* usr = (kUser);
        double sumMain = _sum * [_currency rateValueWithDate:[NSDate today] mainCurrency:usr.currencyMain];
        Payment* payment = [Payment insertPaymentWithUser:(kUser) account:tmpl.account category:tmpl.category accountAsCategory:tmpl.accountAsCategory currency:_currency sum:_sum sumMain:sumMain rateValue:_rateValue date:[NSDate today] comment:tmpl.comment ptemplate:tmpl finished:YES hidden:NO save:YES];
        for (NSDictionary* d in _subpayments) {
            [Payment insertSubPaymentWithCategory:[d objectForKey:kCategory] sum:[[d objectForKey:kSum] doubleValue] superpayment:payment save:YES];
        }
        [[AGDBWorker sharedWorker] saveManagedContext];
        
    //    [self.navigationController popToRootViewControllerAnimated:YES];
        [self paymentDidAdd:payment];
    }
}

- (BOOL) isSumCorrect{
    BOOL correct = YES;
    if (self.sum < 0) {
        correct = NO;
        self.lbSum.text = @"";
        self.lbSumIncorrect.hidden = NO;
        [self performSelector:@selector(hideLabelSumIncorrect)
                   withObject:nil
                   afterDelay:0.3f];
    }
    return correct;
}

- (void) hideLabelSumIncorrect{
    self.sum = self.sum;
    self.lbSumIncorrect.hidden = YES;
}

- (void) paymentDidAdd:(Payment*)payment{
    self.view.userInteractionEnabled = NO;
    [self.kbCtl resetOperationString];
    
    NSString* msg = @"";
    Template* tmpl = payment.template;
    if (tmpl.category != nil) {
        if (tmpl.category.type.intValue == CatTypeIncome) {
            msg = @"PaymentTemplateSelectedAlertIncome";
        }else{
            msg = @"PaymentTemplateSelectedAlertExpense";
        }
    }else{
        msg = @"PaymentTemplateSelectedAlertTransfer";
    }
//    msg = [NSString stringWithFormat:@"%@ %@ %.2f", NSLocalizedString(msg, @""), tmpl.title, payment.sumMain.doubleValue];
//    if ([[msg substringFromIndex:msg.length-3] isEqualToString:@".00"]) {
//        msg = [msg substringToIndex:msg.length-3];
//    }
    msg = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(msg, @""), tmpl.title];

    self.lbResult.text = msg;
    
    [self performSelector:@selector(resetView)
               withObject:self
               afterDelay:kViewResetDelay];
}

- (void) resetView{
    self.subpayments = [NSMutableArray array];
    self.currency = (kUser).currencyMain;
    self.sum = 0;
    self.lbResult.text = @"";
    [self viewWillAppear:NO];
    self.view.userInteractionEnabled = YES;
}

- (void)createTemplate{
    if ([self isSumCorrect]) {
        AGTemplateEditController* ctl = [[AGTemplateEditController alloc] initWithNibName:@"AGTemplateEditView" bundle:nil];
        ctl.currency = _currency;
        ctl.sum = _sum;
        ctl.subpayments = _subpayments;
        ctl.rateValue = _rateValue;
        ctl.addPayment = _sum != 0;
        ctl.delegate = self;
        [self.navigationController pushViewController:ctl animated:YES];
    }
}

#pragma mark - AGKeyboardDelegate
-(void)keyboardNumberPressed:(NSString *)number
             operationString:(NSString *)operationString
                      result:(double)result{
    self.sum = result;
    self.lbSum.textColor = [UIColor colorWithHex:kColorHexPaymentResult];
    self.lbSum.text = operationString;
}

-(void)keyboardOperationPressed:(NSString *)operation
                operationString:(NSString *)operationString
                         result:(double)result{
    self.sum = result;
    self.lbSum.textColor = [UIColor colorWithHex:kColorHexPaymentResult];
    self.lbSum.text = operationString;
}

-(void)keyboardResultPressed:(double)result
             operationString:(NSString *)operationString{
    self.lbSum.textColor = [UIColor colorWithHex:kColorHexPaymentResult];
    self.sum = result;
}

-(void)keyboardSplitPressed:(double)result
            operationString:(NSString *)operationString{
    AGPaymentSplitController* ctl = [[AGPaymentSplitController alloc]
                                     initWithNibName:@"AGPaymentSplitView"
                                     bundle:nil];
    ctl.sum = _sum;
    ctl.delegate = self;
    if([_subpayments count] > 0){
        ctl.subpayments = _subpayments;
    }
    [self.navigationController pushViewController:ctl animated:YES];
}

#pragma mark - setters
-(void)setCurrency:(Currency *)currency{
//    double rate = [_currency rateValueWithDate:[NSDate date] mainCurrency:currency];
//    self.sum = _sum * rate;
//    for (NSMutableDictionary* d in _subpayments) {
//        double ksumNew = [[d objectForKey:kSum] doubleValue] * rate;
//        [d setValue:[NSNumber numberWithDouble:ksumNew] forKey:kSum];
//    }
//    _currency = currency;
//    [_bnCurrency setTitle:_currency.title forState:UIControlStateNormal];
    double rateOld = [_currency rateValueWithDate:[NSDate date]];
    if(_rateValue > 0.0f){
        rateOld = _rateValue;
        //        if(_currency != currency){
        _rateValue = 0.0f;
        //        }
    }
    double rateNew = [currency rateValueWithDate:[NSDate date]];
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
    [_lbSum setTextFromNumber:_sum asInteger:NO withColor:[UIColor colorWithHex:kColorHexPaymentResult]];
}

#pragma mark - AGPaymentEditCurrencyDelegate
-(void)currencySelected:(Currency *)currency withRateValue:(double)rateValue{
    self.currency = currency;
    
    double rateOld = [_currency rateValueWithDate:[NSDate date]];
    if(_rateValue > 0.0f){
        rateOld = _rateValue;
    }
    double rateNew = [_currency rateValueWithDate:[NSDate date]];
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

#pragma mark - AGTemplateEditControllerDelegate
-(void)templateEditController:(AGTemplateEditController *)templateEditController
              didAddedPayment:(Payment *)payment{
    [self.navigationController popViewControllerAnimated:YES];    
    [self paymentDidAdd:payment];
}

@end
