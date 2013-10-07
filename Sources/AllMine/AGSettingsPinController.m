//
//  AGSettingsPinController.m
//  Всё моё
//
//  Created by Evgeniy Tka4enko on 06.10.13.
//  Copyright (c) 2013 Viacheslav Kaloshin. All rights reserved.
//

#import "AGSettingsPinController.h"
#import "AGTools.h"
#import "NSString+AGExtensions.h"
#import "UIView+AGExtensions.h"

#define kCountNumbersInPin 5

@interface AGSettingsPinController ()

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation AGSettingsPinController

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
    
    _navItem.leftBarButtonItem = [AGTools navigationBarButtonItemWithTitle:NSLocalizedString(@"Cancel", @"") imageNamed:@"button-save" target:self action:@selector(cancel)];
    _navItem.rightBarButtonItem = [AGTools navigationBarButtonItemWithTitle:NSLocalizedString(@"Save", @"") imageNamed:@"button-save" target:self action:@selector(save)];
    
    [self setPin:[[NSUserDefaults standardUserDefaults] objectForKey:@"pin"]];
    
    _titleLabel.font = [UIFont fontWithName:kFont1 size:18.0f];
    _titleLabel.text = NSLocalizedString(@"SettingsProtectionEnterPin", nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancel
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)save
{
    NSNumber *pin = [self currentPin];
    if(!pin)
    {
        for(UITextField *textField in self.view.subviews)
        {
            if([textField isKindOfClass:[UITextField class]])
            {
                if([textField.text length] == 0)
                {
                    [textField shake];
                }
            }
        }
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:pin forKey:@"pin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(![string isNumeric])
    {
        return NO;
    }
    
    if(range.length == 0)
    {
        if(range.location > 0)
        {
            if(textField.tag < kCountNumbersInPin)
            {
                textField = (UITextField *)[self.view viewWithTag:textField.tag + 1];
                textField.text = [string substringToIndex:1];
                [textField becomeFirstResponder];
            }
            return NO;
        }
    }
    return YES;
}

- (NSNumber *)currentPin
{
    NSUInteger pin = 0;
    for(int i = 0; i < kCountNumbersInPin; i++)
    {
        for(UITextField *textField in self.view.subviews)
        {
            if([textField isKindOfClass:[UITextField class]])
            {
                if(textField.tag == i)
                {
                    NSString *text = textField.text;
                    if(text.length == 1)
                    {
                        pin += pow(10, kCountNumbersInPin - i - 1) * [text integerValue];
                        break;
                    }
                    else
                    {
                        return nil;
                    }
                }
            }
        }
    }
    
    if(pin > 0)
    {
        return @(pin);
    }
    return nil;
}

- (void)setPin:(NSNumber *)pin
{
    if(!pin)
    {
        return;
    }
    
    NSInteger pinInt = [pin integerValue];
    
    for(int i = 0; i < kCountNumbersInPin; i++)
    {
        for(UITextField *textField in self.view.subviews)
        {
            if([textField isKindOfClass:[UITextField class]])
            {
                if(textField.tag == i)
                {
                    int powMult = pow(10, kCountNumbersInPin - i - 1);
                    int num = pinInt / powMult;
                    textField.text = [NSString stringWithFormat:@"%d", num];
                    pinInt -= num * powMult;
                    break;
                }
            }
        }
    }
}

@end
