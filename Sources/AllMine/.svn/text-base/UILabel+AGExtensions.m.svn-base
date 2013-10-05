
//
//  UILabel+AGExtensions.m
//  AllMine
//
//  Created by Allgoritm LLC on 06.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "UILabel+AGExtensions.h"

#import "UIColor+AGExtensions.h"
#import "NSString+AGExtensions.h"

@implementation UILabel (AGExtensions)

- (void) setTextFromNumber:(double) number asInteger:(BOOL)integer withColor:(UIColor *)color{
    
    UIColor* clr1 = nil;
    if(color != nil){
        clr1 = color;
    }else if(number >= 0){
        clr1 = [UIColor colorWithHex:kColorHexGreen];
    }else{
        clr1 = [UIColor colorWithHex:kColorHexOrange];
        number *= (-1);
    }
//    UIColor* clr2 = [UIColor colorWithHex:kColorHexGray];
    
//    NSNumberFormatter* nf = [[NSNumberFormatter alloc] init];
//    [nf setNumberStyle:NSNumberFormatterDecimalStyle];
//    if(integer){
//        [nf setMaximumFractionDigits:0];
//        [nf setMinimumFractionDigits:0];
//    }else{
//        [nf setMaximumFractionDigits:2];
//        [nf setMinimumFractionDigits:2];
//    }
//    nf.usesGroupingSeparator = YES;
//    nf.groupingSize = 3;
//    nf.groupingSeparator = @" ";
    NSNumberFormatter* nf = [NSString numberFormatterInteger:integer];
    NSString* res = [nf stringFromNumber:[NSNumber numberWithDouble: number]];

    self.textAlignment = UITextAlignmentRight;
    
    if ((integer == NO) && ([[res substringFromIndex:[res length]-2] isEqualToString:@"00"])) {
        res = [res substringToIndex:[res length]-3];
    }
    
//    if (integer) {
        self.textColor = clr1;
        self.text = res;
//    }else{
//        NSMutableAttributedString* astr = [[NSMutableAttributedString alloc] initWithString:res];
//        [astr addAttribute:NSForegroundColorAttributeName value:clr1 range:NSMakeRange(0, res.length-2)];
//        [astr addAttribute:NSForegroundColorAttributeName value:clr2 range:NSMakeRange(res.length-2, 2)];
//        self.attributedText = astr;
        //        CGSize textSize = [self.text sizeWithFont:self.font];
        //        textSize.width -= textSize.width/12;
        //        CGRect analogRect = CGRectMake(0, 0, textSize.width, self.frame.size.height);
        //        CGPoint centrino = self.center;
        //
        //        self.frame = analogRect;
        //        self.center = centrino;
        //
        //        NSString *currency = [self.text substringWithRange:NSMakeRange(0, self.text.length - 3)];
        //        NSString *amount = [self.text substringWithRange:NSMakeRange(self.text.length - 3, 3)];
        //
        //        self.text = currency;
        //        self.textAlignment = UITextAlignmentLeft;
        //        self.font = [UIFont fontWithName:@"Helvetica-Bold" size:30.];
        //        self.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        //        [self drawTextInRect:analogRect];
        //
        //        self.text = amount;
        //        self.textAlignment = UITextAlignmentRight;
        //        self.font = [UIFont fontWithName:@"Helvetica-Bold" size:40.];
        //        [self drawTextInRect:analogRect];
//    }
}

@end
