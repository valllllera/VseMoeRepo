//
//  AGSettingsSubscribeController.m
//  Всё моё
//
//  Created by Evgeniy Tka4enko on 15.10.13.
//  Copyright (c) 2013 Viacheslav Kaloshin. All rights reserved.
//

#import "AGSettingsSubscribeController.h"
#import "AGTools.h"
#import "AGSettingsAgreementController.h"
#import "AGConfirmSubscribeView.h"
#import "UIView+Additions.h"
#import "AGServerAccess.h"
#import "Tariff+EntityWorker.h"
#import "AGRootController.h"
#import "AGAppDelegate.h"
#import "User.h"
#import "MKStoreManager.h"

@interface AGSettingsSubscribeController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *checkBox;
@property (strong, nonatomic) AGConfirmSubscribeView *alertView;
@property (weak, nonatomic) IBOutlet UILabel *remainingLabel;

@property (weak, nonatomic) IBOutlet UIButton *tariff1Button;
@property (weak, nonatomic) IBOutlet UIButton *tariff2Button;
@property (weak, nonatomic) IBOutlet UIButton *tariff3Button;

@property (weak, nonatomic) IBOutlet UILabel *tariff1DescrLabel;
@property (weak, nonatomic) IBOutlet UILabel *tariff2DescrLabel;
@property (weak, nonatomic) IBOutlet UILabel *tariff3DescrLabel;

@property (strong, nonatomic) Tariff *tariff1;
@property (strong, nonatomic) Tariff *tariff2;
@property (strong, nonatomic) Tariff *tariff3;

@end

@implementation AGSettingsSubscribeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, 950);
    
    self.title = NSLocalizedString(@"SettingsSubscribe", nil);
    self.navigationItem.leftBarButtonItem = [AGTools navigationBarButtonItemWithImageNamed:@"button-back" target:self action:@selector(back)];
    
    int now = [[NSDate date] timeIntervalSince1970];
    
    NSNumber *remain = nil;
    if((kUser).payment.integerValue == UserPaymentPaid)
    {
        remain = @(((kUser).end.integerValue - now) / 1000 / 60 / 60 / 24);
    }
    else
    {
        remain = @(0);
    }
    
    _remainingLabel.text = [NSString stringWithFormat:NSLocalizedString(@"SettingsSubscribeRemaining", nil), remain];
    
    [[AGServerAccess sharedAccess] tariffUpdateWithSuccess:^{
        
        [self reloadTariffs];
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadTariffs
{
    self.tariff1 = [Tariff tariffWithId:1];
    self.tariff2 = [Tariff tariffWithId:2];
    self.tariff3 = [Tariff tariffWithId:3];
    
    [_tariff1Button setTitle:[_tariff1.amount stringValue] forState:UIControlStateNormal];
    [_tariff2Button setTitle:[_tariff2.amount stringValue] forState:UIControlStateNormal];
    [_tariff3Button setTitle:[_tariff3.amount stringValue] forState:UIControlStateNormal];
    
    _tariff1DescrLabel.text = _tariff1.descr;
    _tariff2DescrLabel.text = _tariff2.descr;
    _tariff3DescrLabel.text = _tariff3.descr;
}

- (void) back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)checkboxPressed:(id)sender
{
    _checkBox.selected = !_checkBox.selected;
}

- (IBAction)agreementButtonPressed:(id)sender
{
    AGSettingsAgreementController* ctl = [[AGSettingsAgreementController alloc] initWithNibName:@"AGSettingsAgreementController" bundle:nil];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)showExtendSubscribeViewWithPrice:(NSString *)price period:(NSString *)period
{    
    NSString *textTemplate = NSLocalizedString(@"SettingsSubscribeConfirm", nil);
    
    NSString *find = @"%@";
    
    int strCount = [textTemplate length] - [[textTemplate stringByReplacingOccurrencesOfString:find withString:@""] length];
    strCount /= [find length];
    
    if(strCount == 2)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Подтвердите подписку" message:[NSString stringWithFormat:textTemplate, period, price] delegate:nil cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:@"Согласиться", nil];
        alertView.delegate = self;
        [alertView show];
    }
    
    /*[self hideExtendSubscribeView];
    
    self.alertView = [[NSBundle mainBundle] loadNibNamed:@"AGConfirmSubscribeView" owner:nil options:nil][0];
    __weak AGSettingsSubscribeController *selfWeak = self;
    
    if(strCount == 2)
    {
        _alertView.textLabel.text = [NSString stringWithFormat:textTemplate, period, price];
    }    
    
    [_alertView setSuccessBlock:^(NSUInteger index) {
        
        if(index == 0)
        {
            [selfWeak hideExtendSubscribeView];
        }
        if(success && index == 1)
        {
            success();
        }
        
    }];
    
    _alertView.frame = CGRectMake((self.view.frame.size.width - _alertView.frame.size.width) / 2, (self.view.frame.size.height - _alertView.frame.size.height) / 2, _alertView.frame.size.width, _alertView.frame.size.height);
    
    [_alertView hide:NO];
    [self.view addSubview:_alertView];
    [_alertView show:YES];
    _scrollView.userInteractionEnabled = NO;*/
}

/*
- (void)hideExtendSubscribeView
{
    [_alertView hide:YES completion:^{
        
        [_alertView removeFromSuperview];
        _scrollView.userInteractionEnabled = YES;
        _alertView = nil;
        
    }];
}*/

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            [[MKStoreManager sharedManager] buyFeature:kInAppPurchaseProductId1 onComplete:^(NSString *purchasedFeature, NSData *purchasedReceipt, NSArray *availableDownloads) {
                
                
                
            } onCancelled:nil];
            break;
            
        case 1:
            [[MKStoreManager sharedManager] buyFeature:kInAppPurchaseProductId2 onComplete:^(NSString *purchasedFeature, NSData *purchasedReceipt, NSArray *availableDownloads) {
                
                
                
            } onCancelled:nil];
            break;
            
        case 2:
            [[MKStoreManager sharedManager] buyFeature:kInAppPurchaseProductId3 onComplete:^(NSString *purchasedFeature, NSData *purchasedReceipt, NSArray *availableDownloads) {
                
                
                
            } onCancelled:nil];
            break;
            
        default:
            break;
    }
}

- (IBAction)tariff1ButtonPressed:(id)sender
{
    if(_checkBox.selected)
    {
        [self showExtendSubscribeViewWithPrice:[NSString stringWithFormat:@"%@ P", _tariff1.amount] period:_tariff1.descr];
    }
}

- (IBAction)tariff2ButtonPressed:(id)sender
{
    if(_checkBox.selected)
    {
        [self showExtendSubscribeViewWithPrice:[NSString stringWithFormat:@"%@ P", _tariff2.amount] period:_tariff2.descr];
    }
}

- (IBAction)tariff3ButtonPressed:(id)sender
{
    if(_checkBox.selected)
    {
        [self showExtendSubscribeViewWithPrice:[NSString stringWithFormat:@"%@ P", _tariff3.amount] period:_tariff3.descr];
    }
}

@end
