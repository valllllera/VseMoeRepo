//
//  AGPaymentSplitCell.m
//  Всё моё
//
//  Created by Allgoritm LLC on 07.03.13.
//  Copyright (c) 2013 Allgoritm LLC. All rights reserved.
//

#import "AGPaymentSplitCell.h"

#import "UIColor+AGExtensions.h"

@interface AGPaymentSplitCell()

@property(nonatomic, strong) UIButton* buttonBalance;
@property(nonatomic, strong) UIButton* buttonCategory;

@property(nonatomic, assign) id<AGPaymentSplitCellDelegate> delegate;

@end

@implementation AGPaymentSplitCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
           delegate:(id<AGPaymentSplitCellDelegate>)delegate
         cellHeight:(float)cellHeight{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.delegate = delegate;
        
        self.buttonCategory = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 140, cellHeight)];
        self.buttonCategory.titleLabel.font = [UIFont fontWithName:kFont1 size:17.0f];
        [self.buttonCategory setTitleColor:[UIColor colorWithHex:kColorHexGray]
                                  forState:UIControlStateNormal];
        [self.buttonCategory addTarget:self
                                action:@selector(categoryPressed)
                      forControlEvents:UIControlEventTouchUpInside];
        self.buttonCategory.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.buttonCategory.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:self.buttonCategory];

        //
        self.buttonBalance = [[UIButton alloc] initWithFrame:CGRectMake(150, 0, 140, cellHeight)];
        self.buttonBalance.titleLabel.font = [UIFont fontWithName:kFont1
                                                size:17.0f];
        [self.buttonBalance setTitleColor:[UIColor colorWithHex:kColorHexGray]
                                 forState:UIControlStateNormal];
        [self.buttonBalance addTarget:self
                               action:@selector(balancePressed)
                     forControlEvents:UIControlEventTouchUpInside];
        self.buttonBalance.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.buttonBalance.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:self.buttonBalance];
        
        UIImageView* ivArrow = [[UIImageView alloc] initWithImage:
                                [UIImage imageNamed:@"accessory-arrow"]];
        CGRect frame = ivArrow.frame;
        frame.origin.y = self.buttonCategory.frame.size.height/2 - frame.size.height/2;
        frame.origin.x = self.buttonCategory.frame.size.width + self.buttonCategory.frame.origin.x;
        ivArrow.frame = frame;
        [self.contentView addSubview:ivArrow];
    }
    return self;
}

- (void) setTitleCategory:(NSString*)value{
    [self.buttonCategory setTitle:value
                         forState:UIControlStateNormal];
}

- (void) setTitleBalance:(NSString*)value{
    [self.buttonBalance setTitle:value
                        forState:UIControlStateNormal];
}

- (void) setColorCategory:(UIColor*)value{
    [self.buttonCategory setTitleColor:value
                              forState:UIControlStateNormal];
}

- (void) setColorBalance:(UIColor*)value{
    [self.buttonBalance setTitleColor:value
                             forState:UIControlStateNormal];
}

- (void) balancePressed{
    if ([self.delegate respondsToSelector:@selector(paymentSplitCellBalancePressed:)]) {
        [self.delegate paymentSplitCellBalancePressed:self];
    }
}

- (void) categoryPressed{
    if ([self.delegate respondsToSelector:@selector(paymentSplitCellCategoryPressed:)]) {
        [self.delegate paymentSplitCellCategoryPressed:self];
    }
}

@end
