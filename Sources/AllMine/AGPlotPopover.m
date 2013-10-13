//
//  AGPlotPopover.m
//  Всё моё
//
//  Created by Evgeniy Tka4enko on 13.10.13.
//  Copyright (c) 2013 Viacheslav Kaloshin. All rights reserved.
//

#import "AGPlotPopover.h"
#import "UIColor+AGExtensions.h"
#import "AGAllMineDefines.h"
#import "Currency.h"
#import "AGAppDelegate.h"
#import "AGRootController.h"
#import "User.h"

#define kColorHexPopoverBlue 0x42b1d9

@interface AGPlotPopover ()

@property (copy, nonatomic) NSString *dateString;
@property (copy, nonatomic) NSString *sum1String;
@property (copy, nonatomic) NSString *sum2String;
@property (copy, nonatomic) NSString *totalString;

@end

@implementation AGPlotPopover

- (id)initWithFrame:(CGRect)frame date:(NSString *)dateString sum:(NSString *)sumString
{
    frame.size.width = 114;
    frame.size.height = 73;
    
    self = [super initWithFrame:frame];
    if(self)
    {
        self.userInteractionEnabled = NO;
        
        self.dateString = dateString;
        self.sum1String = sumString;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"income_expenses_graf.png"]];
        imageView.frame = CGRectMake(0, 0, 114, 73);
        [self addSubview:imageView];
        
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(20, 25, 66, 1)];
        separatorView.backgroundColor = [UIColor colorWithHex:kColorHexPopoverBlue];
        [self addSubview:separatorView];
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 9, 85, 20)];
        dateLabel.text = _dateString;
        dateLabel.font = [UIFont fontWithName:kFont1 size:10.0f];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.textColor = [UIColor colorWithHex:kColorHexPopoverBlue];
        dateLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:dateLabel];
        
        Currency* mainCurrency = (kUser).currencyMain;
        
        UILabel *sumLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 27, 95, 20)];
        sumLabel.attributedText = [self sumAttributedStringWithSum:_sum1String currency:mainCurrency.title];
        sumLabel.textAlignment = NSTextAlignmentCenter;
        sumLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:sumLabel];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame date:(NSString *)dateString sum1:(NSString *)sum1String sum2:(NSString *)sum2String total:(NSString *)totalString
{
    frame.size.width = 116;
    frame.size.height = 110;
    
    self = [super initWithFrame:frame];
    if(self)
    {
        self.userInteractionEnabled = NO;
        
        self.dateString = dateString;
        self.sum1String = sum1String;
        self.sum2String = sum2String;
        self.totalString = totalString;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"kapital_graf.png"]];
        imageView.frame = CGRectMake(0, 0, 116, 110);
        [self addSubview:imageView];
        
        UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(20, 25, 66, 1)];
        separatorView.backgroundColor = [UIColor colorWithHex:kColorHexPopoverBlue];
        [self addSubview:separatorView];
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 9, 85, 20)];
        dateLabel.text = _dateString;
        dateLabel.font = [UIFont fontWithName:kFont1 size:10.0f];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.textColor = [UIColor colorWithHex:kColorHexPopoverBlue];
        dateLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:dateLabel];
        
        Currency* mainCurrency = (kUser).currencyMain;
        
        UILabel *sumLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 27, 95, 20)];
        sumLabel.attributedText = [self sumAttributedStringWithSum:_sum1String currency:mainCurrency.title];
        sumLabel.textAlignment = NSTextAlignmentCenter;
        sumLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:sumLabel];
        
        UILabel *sum2Label = [[UILabel alloc] initWithFrame:CGRectMake(5, 43, 95, 20)];
        sum2Label.attributedText = [self sumAttributedStringWithSum:_sum2String currency:mainCurrency.title];
        sum2Label.textAlignment = NSTextAlignmentCenter;
        sum2Label.backgroundColor = [UIColor clearColor];
        [self addSubview:sum2Label];
        
        UIView *separator2View = [[UIView alloc] initWithFrame:CGRectMake(20, 67, 66, 1)];
        separator2View.backgroundColor = [UIColor colorWithHex:kColorHexPopoverBlue];
        [self addSubview:separator2View];
        
        UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 69, 95, 20)];
        totalLabel.attributedText = [self sumAttributedStringWithSum:_totalString currency:mainCurrency.title];
        totalLabel.textAlignment = NSTextAlignmentCenter;
        totalLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:totalLabel];
    }
    return self;
}

- (NSAttributedString *)sumAttributedStringWithSum:(NSString *)sumString currency:(NSString *)currencyString
{
    NSMutableAttributedString *sumAttrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", sumString, currencyString]];
    
    NSRange sumRange = NSMakeRange(0, sumString.length);
    NSRange currencyRange = NSMakeRange(sumString.length + 1, [currencyString length]);
    
    [sumAttrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFont1 size:11.0f] range:sumRange];
    [sumAttrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFont1 size:9.0f] range:currencyRange];
    [sumAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:kColorHexDarkGray] range:currencyRange];
    
    return sumAttrString;
}

@end
