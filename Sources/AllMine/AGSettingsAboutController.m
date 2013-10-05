//
//  AGSettingsAboutController.m
//  AllMine
//
//  Created by Allgoritm LLC on 08.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "AGSettingsAboutController.h"
#import "AGTools.h"

@interface AGSettingsAboutController ()

@property (nonatomic,strong) IBOutlet UIImageView *ivBackground;

@end

@implementation AGSettingsAboutController

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
    self.navigationItem.title = NSLocalizedString(@"SettingsAbout", @"");
    
    
    if (isIphoneRetina4) {
     
        self.ivBackground.image = [UIImage imageNamed:@"about-568h"];
    }
    
    self.navigationItem.leftBarButtonItem = [AGTools navigationBarButtonItemWithImageNamed:@"button-back" target:self action:@selector(back)];
}

#pragma mark - buttons
- (void) back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)referenceLinkButtonPressed:(id)sender {
    NSString *link =  @"http://www.vsemoe.ru";
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: [link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

- (IBAction)supportLinkButtonPressed:(id)sender {
    NSString *mailString = [NSString stringWithFormat:@"mailto:?to=%@&subject=%@",
                            [@"support@vsemoe.ru" stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
                            NSLocalizedString(@"SettingsSupport", @"")];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: [mailString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
 
}


@end
