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
#import "AGExtendSubscribeView.h"
#import "UIView+Additions.h"

@interface AGSettingsSubscribeController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *checkBox;
@property (strong, nonatomic) AGExtendSubscribeView *alertView;

@end

@implementation AGSettingsSubscribeController

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
    
    _scrollView.contentOffset = CGPointZero;
    
    [self showExtendSubscribeView];
}

- (IBAction)agreementButtonPressed:(id)sender
{
    AGSettingsAgreementController* ctl = [[AGSettingsAgreementController alloc] initWithNibName:@"AGSettingsAgreementController" bundle:nil];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)showExtendSubscribeView
{
    [self hideExtendSubscribeView];
    
    self.alertView = [[NSBundle mainBundle] loadNibNamed:@"AGExtendSubscribeView" owner:nil options:nil][0];
    __weak AGSettingsSubscribeController *selfWeak = self;
    [_alertView setSuccessBlock:^(NSUInteger index) {
        
        if(index == 0)
        {
            [selfWeak hideExtendSubscribeView];
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

@end
