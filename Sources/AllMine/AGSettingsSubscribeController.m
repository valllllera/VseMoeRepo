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

@interface AGSettingsSubscribeController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *checkBox;

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
}

- (IBAction)agreementButtonPressed:(id)sender
{
    AGSettingsAgreementController* ctl = [[AGSettingsAgreementController alloc] initWithNibName:@"AGSettingsAgreementController" bundle:nil];
    [self.navigationController pushViewController:ctl animated:YES];
}

@end
