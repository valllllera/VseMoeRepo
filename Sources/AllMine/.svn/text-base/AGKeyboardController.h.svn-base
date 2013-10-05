//
//  AGKeyboardController.h
//  AllMine
//
//  Created by Allgoritm LLC on 12.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    AGKBStateFull = 0,
    AGKBStateSplit = 1
}AGKBState;

@class AGKeyboardController;

@protocol AGKeyboardDelegate <NSObject>

- (void) keyboardNumberPressed:(NSString*)number
               operationString:(NSString*)operationString
                        result:(double)result;

- (void) keyboardOperationPressed:(NSString*)operation
                  operationString:(NSString*)operationString
                           result:(double)result;

- (void) keyboardResultPressed:(double)result
               operationString:(NSString*)operationString;

@optional - (void) keyboardSplitPressed:(double)result
                        operationString:(NSString*)operationString;

@end

@interface AGKeyboardController : UIViewController

@property(nonatomic, strong) id<AGKeyboardDelegate> delegate;
@property(nonatomic, assign) double left;
@property(nonatomic, assign) AGKBState state;


- (void) resetOperationString;
@end
