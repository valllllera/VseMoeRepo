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

@interface AGSettingsSubscribeController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *checkBox;
@property (strong, nonatomic) AGConfirmSubscribeView *alertView;

@property (weak, nonatomic) IBOutlet UIButton *oneMonthButton;
@property (weak, nonatomic) IBOutlet UIButton *twoMonthButton;
@property (weak, nonatomic) IBOutlet UIButton *yearButton;

@property (strong, nonatomic) NSNumber *oneMonthPrice;
@property (strong, nonatomic) NSNumber *twoMonthPrice;
@property (strong, nonatomic) NSNumber *yearPrice;

@end

@implementation AGSettingsSubscribeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _oneMonthPrice = @(30);
        _twoMonthPrice = @(50);
        _yearPrice = @(150);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_oneMonthButton setTitle:[_oneMonthPrice stringValue] forState:UIControlStateNormal];
    [_twoMonthButton setTitle:[_twoMonthPrice stringValue] forState:UIControlStateNormal];
    [_yearButton setTitle:[_yearPrice stringValue] forState:UIControlStateNormal];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, 925);
    
    self.title = NSLocalizedString(@"SettingsSubscribe", nil);
    self.navigationItem.leftBarButtonItem = [AGTools navigationBarButtonItemWithImageNamed:@"button-back" target:self action:@selector(back)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)showExtendSubscribeViewWithPrice:(NSString *)price period:(NSString *)period success:(void (^)())success
{
    [self hideExtendSubscribeView];
    
    self.alertView = [[NSBundle mainBundle] loadNibNamed:@"AGConfirmSubscribeView" owner:nil options:nil][0];
    __weak AGSettingsSubscribeController *selfWeak = self;
    
    NSString *textTemplate = NSLocalizedString(@"SettingsSubscribeConfirm", nil);
    
    NSString *find = @"%@";
    
    int strCount = [textTemplate length] - [[textTemplate stringByReplacingOccurrencesOfString:find withString:@""] length];
    strCount /= [find length];
    
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
    _scrollView.userInteractionEnabled = NO;
}

- (void)hideExtendSubscribeView
{
    [_alertView hide:YES completion:^{
        
        [_alertView removeFromSuperview];
        _scrollView.userInteractionEnabled = YES;
        _alertView = nil;
        
    }];
}

- (IBAction)oneMonthButtonPressed:(id)sender
{
    if(_checkBox.selected)
    {
        [self showExtendSubscribeViewWithPrice:[NSString stringWithFormat:@"%@ P", _oneMonthPrice] period:NSLocalizedString(@"SettingsSubscribeConfirm1month", nil) success:nil];
    }
}

- (IBAction)twoMonthButtonPressed:(id)sender
{
    if(_checkBox.selected)
    {
        [self showExtendSubscribeViewWithPrice:[NSString stringWithFormat:@"%@ P", _twoMonthPrice] period:NSLocalizedString(@"SettingsSubscribeConfirm2month", nil) success:nil];
    }
}

- (IBAction)yearButtonPressed:(id)sender
{
    if(_checkBox.selected)
    {
        [self showExtendSubscribeViewWithPrice:[NSString stringWithFormat:@"%@ P", _yearPrice] period:NSLocalizedString(@"SettingsSubscribeConfirm1year", nil) success:nil];
    }
}

@end
