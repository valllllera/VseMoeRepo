//
//  AGAccountSelectController.m
//  Все мое
//
//  Created by Allgoritm LLC on 14.02.13.
//  Copyright (c) 2013 Allgoritm LLC. All rights reserved.
//

#import "AGAccountSelectController.h"
#import "Account+EntityWorker.h"
#import "AGAccountEditController.h"

#import "AGTools.h"
#import "UIColor+AGExtensions.h"

@interface AGAccountSelectController ()

@property(nonatomic, strong) IBOutlet UILabel* lb1;
@property(nonatomic, strong) IBOutlet UILabel* lb2;
@property(nonatomic, strong) IBOutlet UILabel* lb3;
@property(nonatomic, strong) IBOutlet UILabel* lb4;
@property(nonatomic, strong) IBOutlet UILabel* lb5;
@property(nonatomic, strong) IBOutlet UILabel* lb6;
@property(nonatomic, strong) IBOutlet UILabel* lb7;
@property(nonatomic, strong) IBOutlet UILabel* lb8;

@end

@implementation AGAccountSelectController

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
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = NSLocalizedString(@"AccountEditNew", @"");
    
    self.navigationItem.leftBarButtonItem = [AGTools navigationBarButtonItemWithImageNamed:@"button-back" target:self action:@selector(back)];
    
    UIFont* font = [UIFont fontWithName:kFont1
                                   size:12.0f];
    UIColor* clr = [UIColor colorWithHex:kColorHexBrown];

    self.lb1.font = font;
    self.lb1.textColor = clr;
    self.lb2.font = font;
    self.lb2.textColor = clr;
    self.lb3.font = font;
    self.lb3.textColor = clr;
    self.lb4.font = font;
    self.lb4.textColor = clr;
    self.lb5.font = font;
    self.lb5.textColor = clr;
    self.lb6.font = font;
    self.lb6.textColor = clr;
    self.lb7.font = font;
    self.lb7.textColor = clr;
    self.lb8.font = font;
    self.lb8.textColor = clr;
    
    self.lb1.text = NSLocalizedString(@"Cash", @"");
    self.lb2.text = NSLocalizedString(@"Cash2", @"");
    self.lb3.text = NSLocalizedString(@"Loan", @"");
    self.lb4.text = NSLocalizedString(@"Card", @"");
    self.lb5.text = NSLocalizedString(@"Credit", @"");
    self.lb6.text = NSLocalizedString(@"Bank", @"");
    self.lb7.text = NSLocalizedString(@"Electron", @"");
    self.lb8.text = NSLocalizedString(@"Other", @"");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - buttons
- (IBAction) selectedType:(id)sender{
    int tag = ((UIButton*)sender).tag;
    AccType type = AccTypeLoan;
    switch (tag) {
        case 1:
            type = AccTypeCash;
            break;
            
        case 2:
            type = AccTypeCardCredit;
            break;
            
        case 3:
            type = AccTypeBank;
            break;
            
        default:
            type = AccTypeLoan;
            break;
    }
    AGAccountEditController* ctl = [[AGAccountEditController alloc] initWithNibName:@"AGAccountEditView" bundle:nil];
    ctl.parentBack = self.parentBack;
    ctl.accountType = type;
    [self.navigationController pushViewController:ctl
                                         animated:YES];
}

@end
