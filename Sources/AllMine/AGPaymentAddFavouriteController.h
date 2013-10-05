//
//  AGPaymentAddFavouriteController.h
//  AllMine
//
//  Created by Allgoritm LLC on 15.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGKeyboardController.h"
#import "AGPaymentEditCurrencyController.h"
#import "AGPaymentSplitController.h"

#import "AGTemplateEditController.h"

@interface AGPaymentAddFavouriteController : UIViewController<AGKeyboardDelegate, AGPaymentEditCurrencyDelegate, AGPaymentSplitDelegate, AGTemplateEditControllerDelegate>

@end
