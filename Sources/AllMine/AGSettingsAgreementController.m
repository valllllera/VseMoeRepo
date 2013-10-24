//
//  AGSettingsAgreementController.m
//  Всё моё
//
//  Created by Evgeniy Tka4enko on 17.10.13.
//  Copyright (c) 2013 Viacheslav Kaloshin. All rights reserved.
//

#import "AGSettingsAgreementController.h"
#import "AGTools.h"

@interface AGSettingsAgreementController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *agreementView;
@property (weak, nonatomic) IBOutlet UIImageView *agreementImageView;
@property (weak, nonatomic) IBOutlet UILabel *agreementLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkBox;
@property (weak, nonatomic) IBOutlet UILabel *checkBoxLabel;

@end

@implementation AGSettingsAgreementController

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
    
    self.title = NSLocalizedString(@"SettingsAgreement", nil);
    self.navigationItem.leftBarButtonItem = [AGTools navigationBarButtonItemWithImageNamed:@"button-back" target:self action:@selector(back)];
    
    _agreementImageView.image = [_agreementImageView.image resizableImageWithCapInsets:UIEdgeInsetsMake(30, 0, 20, 0)];
    
    [self resizeAllView];
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

- (void)resizeAllView
{    
    [_agreementLabel sizeToFit];
    
    CGSize size = _agreementLabel.frame.size;
    
    _agreementView.frame = CGRectMake(_agreementView.frame.origin.x, _agreementView.frame.origin.y, _agreementView.frame.size.width, size.height + 70);
    
    _checkBox.frame = CGRectMake(_checkBox.frame.origin.x, _agreementView.frame.origin.y + _agreementView.frame.size.height + 30, _checkBox.frame.size.width, _checkBox.frame.size.height);
    _checkBoxLabel.frame = CGRectMake(_checkBoxLabel.frame.origin.x, _agreementView.frame.origin.y + _agreementView.frame.size.height + 28, _checkBoxLabel.frame.size.width, _checkBoxLabel.frame.size.height);
    
    _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, _agreementView.frame.origin.y + _agreementView.frame.size.height + 100);
    
}

- (IBAction)checkboxPressed:(id)sender
{
    _checkBox.selected = !_checkBox.selected;
}

@end
