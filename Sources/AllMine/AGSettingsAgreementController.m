//
//  AGSettingsAgreementController.m
//  Всё моё
//
//  Created by Evgeniy Tka4enko on 17.10.13.
//  Copyright (c) 2013 Viacheslav Kaloshin. All rights reserved.
//

#import "AGSettingsAgreementController.h"
#import "AGTools.h"
#import "AGServerAccess.h"

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
    
    _agreementImageView.image = [_agreementImageView.image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 0, 5, 0)];
    
    [self resizeAllView];
    
    [[AGServerAccess sharedAccess] paymentLegalTextWithSuccess:^(NSString *legal) {
        
        _agreementLabel.text = legal;
        [self resizeAllView];
        
    }];
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
    CGSize sizeAgreementLabel = [_agreementLabel.text sizeWithFont:_agreementLabel.font
                                       constrainedToSize:CGSizeMake(_agreementLabel.frame.size.width, MAXFLOAT)
                                           lineBreakMode:_agreementLabel.lineBreakMode];
    
    _agreementLabel.frame = CGRectMake(_agreementLabel.frame.origin.x, _agreementLabel.frame.origin.y, _agreementLabel.frame.size.width, sizeAgreementLabel.height);
    
    CGSize size = _agreementLabel.frame.size;
    
    _agreementView.frame = CGRectMake(_agreementView.frame.origin.x, _agreementView.frame.origin.y, _agreementView.frame.size.width, size.height + 70);
    
    _checkBox.frame = CGRectMake(_checkBox.frame.origin.x, _agreementView.frame.origin.y + _agreementView.frame.size.height + 30, _checkBox.frame.size.width, _checkBox.frame.size.height);
    _checkBoxLabel.frame = CGRectMake(_checkBoxLabel.frame.origin.x, _agreementView.frame.origin.y + _agreementView.frame.size.height + 28, _checkBoxLabel.frame.size.width, _checkBoxLabel.frame.size.height);
    
    //_scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, _agreementView.frame.origin.y + _agreementView.frame.size.height + 100);
    _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, _agreementView.frame.origin.y + _agreementView.frame.size.height + 50);
    
}

- (IBAction)checkboxPressed:(id)sender
{
    _checkBox.selected = !_checkBox.selected;
}

@end
