//
//  CurrencyCellController.h
//  Всё моё
//
//  Created by Alexey Kalentiev on 27.06.13.
//  Copyright (c) 2013 Viacheslav Kaloshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrencyCellController : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *currencyName;
@property (weak, nonatomic) IBOutlet UILabel *currencyDetail;
@property (weak, nonatomic) IBOutlet UIImageView *checkmarkImage;

@end
