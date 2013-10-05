//
//  AGKeyboardController.m
//  AllMine
//
//  Created by Allgoritm LLC on 12.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "AGKeyboardController.h"

#import "NSString+AGExtensions.h"

#define kOpPlus @"+"
#define kOpMinus @"-"
#define kOpMult @"*"

@interface AGKeyboardController ()

@property(nonatomic, strong) NSString* operationString;

@property(nonatomic, strong) IBOutlet UIButton* bnPlus;
@property(nonatomic, strong) IBOutlet UIButton* bnMinus;
@property(nonatomic, strong) IBOutlet UIButton* bnMult;
@property(nonatomic, strong) IBOutlet UIButton* bnSplit;

- (IBAction) numberPressed:(id)sender;
- (IBAction) multPressed:(id)sender;
- (IBAction) plusPressed:(id)sender;
- (IBAction) minusPressed:(id)sender;
- (IBAction) backspacePressed:(id)sender;
- (IBAction) pointPressed:(id)sender;
- (IBAction) resultPressed:(id)sender;
- (IBAction) splitPressed:(id)sender;
@end

@implementation AGKeyboardController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _operationString = @"";
        _state = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    _operationString = @"2+3+5.0*2-4*5";
//    [self resultPressed:nil];
    if (_left == 0.0) {
        _operationString = @"";
    }
    _bnSplit.hidden = YES;
    
    switch (self.state) {
        case AGKBStateSplit:
            _bnSplit.hidden = NO;
            _bnMult.hidden = YES;
            break;
            
        default:
            break;
    }
}

-(void)setLeft:(double)left{
    _left = left;
    _operationString = [NSString stringWithFormat:@"%.2f", _left];
}

- (void) resetOperationString{
    self.operationString = @"";
}

#pragma mark - delegate
- (void) delegateKeyboardNumberPressed:(NSString*)number{
    if ([self.delegate respondsToSelector:@selector(keyboardNumberPressed:operationString:result:)]) {
        AGLog(@"============");
        [self.delegate keyboardNumberPressed:number
                             operationString:[self operationStringFormattedCopy]
                                      result:[self parseOperationString]];
    }
}

- (void) delegateKeyboardOperationPressed:(NSString*)operation{
    if ([self.delegate respondsToSelector:@selector(keyboardOperationPressed:operationString:result:)]) {
        AGLog(@"============");
        [self.delegate keyboardOperationPressed:operation
                             operationString:[self operationStringFormattedCopy]
                                      result:[self parseOperationString]];
    }
}

#pragma mark - buttons
-(IBAction)numberPressed:(id)sender{
    UIButton* btn = (UIButton*)sender;
    NSString* number = [NSString stringWithFormat:@"%d", btn.tag];
    self.operationString = [self.operationString stringByAppendingString:number];
    [self delegateKeyboardNumberPressed:number];
}

static int p = 0;
-(IBAction)pointPressed:(id)sender{
    if (p == 0){
        p = 1;
        NSString* number = @".";
        self.operationString = [self.operationString stringByAppendingString:number];
        [self delegateKeyboardNumberPressed:number];
    }
}

-(IBAction)backspacePressed:(id)sender{
    if([_operationString length] > 0){
        if([[_operationString substringFromIndex:[_operationString length]-1] isEqualToString:@"."]){
            p = 0;
        }
        self.operationString = [self.operationString substringToIndex:[_operationString length]-1];
        [self delegateKeyboardNumberPressed:@""];
    }
}

-(IBAction)splitPressed:(id)sender{
    if([self.delegate respondsToSelector:@selector(keyboardSplitPressed:operationString:)]){
        AGLog(@"============");
        [self.delegate keyboardSplitPressed:[self parseOperationString]
                            operationString:[self operationStringFormattedCopy]];
    }
}

-(IBAction)plusPressed:(id)sender{
    if(_operationString.length == 0) return;
    if(([[_operationString substringFromIndex:_operationString.length-1] isEqualToString:kOpPlus]) ||
       ([[_operationString substringFromIndex:_operationString.length-1] isEqualToString:kOpMult]) ||
       ([[_operationString substringFromIndex:_operationString.length-1] isEqualToString:kOpMinus])){
        return;
    }
    
    p = 0;
    _operationString = [_operationString stringByAppendingString:kOpPlus];
    [self delegateKeyboardOperationPressed:kOpPlus];
}
-(void)minusPressed:(id)sender{
    if(([_operationString length] > 0) &&
            (([[_operationString substringFromIndex:[_operationString length]-1] isEqualToString:kOpPlus]) ||
             ([[_operationString substringFromIndex:[_operationString length]-1] isEqualToString:kOpMult]) ||
             ([[_operationString substringFromIndex:[_operationString length]-1] isEqualToString:kOpMinus]))){
            return;
        }
    
    p = 0;
    _operationString = [_operationString stringByAppendingString:kOpMinus];
    [self delegateKeyboardOperationPressed:kOpMinus];
}
-(IBAction)multPressed:(id)sender{
    if(_operationString.length == 0) return;
    if(([[_operationString substringFromIndex:_operationString.length-1] isEqualToString:kOpPlus]) ||
        ([[_operationString substringFromIndex:_operationString.length-1] isEqualToString:kOpMult]) ||
       ([[_operationString substringFromIndex:_operationString.length-1] isEqualToString:kOpMinus])){
        return;
    }
    
    p = 0;
    _operationString = [_operationString stringByAppendingString:kOpMult];
    [self delegateKeyboardOperationPressed:kOpMult];
}

-(IBAction)resultPressed:(id)sender{
    if((_operationString.length == 0) ||
       ([_operationString isEqualToString:@"-"])) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(keyboardResultPressed:operationString:)]) {
        AGLog(@"============");        
        [self.delegate keyboardResultPressed:[self parseOperationString]
                             operationString:[self operationStringFormattedCopy]];
    }
    self.operationString = @"";
}

#pragma mark - formatting
- (NSString*) operationStringFormattedCopy{
    NSString* localOpString = [NSString stringWithString:_operationString];
    
    NSError* error = nil;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"[0-9]*\\.?[0-9]*"
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];

    AGLog(@">>> formatting string: %@", localOpString);
    int first = 0;
    while (first < localOpString.length) {
        NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:localOpString
                                                             options:0
                                                               range:NSMakeRange(first,
                                                                                 localOpString.length-first)];
//        if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
        if (rangeOfFirstMatch.length != 0) {
            NSString *substringForFirstMatch = [localOpString substringWithRange:rangeOfFirstMatch];

            NSNumber * myNumber = [NSNumber numberWithDouble:
                                   [self parseDoubleString:substringForFirstMatch]];

            NSString* formattedNumber = [NSString formattedStringFromNumber:myNumber
                                                                     string:substringForFirstMatch];
            
            first += formattedNumber.length+1;
            localOpString = [localOpString stringByReplacingCharactersInRange:rangeOfFirstMatch
                                                                   withString:formattedNumber];
        }else{
            break;
        }
        AGLog(@">> %@", localOpString);
    }
    localOpString = [localOpString stringByReplacingOccurrencesOfString:@"-" withString:@" - "];
    localOpString = [localOpString stringByReplacingOccurrencesOfString:@"+" withString:@" + "];
    AGLog(@">> formatting result: %@", localOpString);
    return localOpString;
}

#pragma mark - parsing
- (double) parseOperationString{
    NSString* localOpString = [NSString stringWithString:_operationString];
    if (localOpString.length == 0) {
        return 0;
    }
    
    AGLog(@"==== parsing string: %@", localOpString);
    //  prepare
    localOpString = [localOpString stringByReplacingOccurrencesOfString:@" " withString:@""];
    localOpString = [localOpString stringByReplacingOccurrencesOfString:@"+." withString:@"+0."];
    localOpString = [localOpString stringByReplacingOccurrencesOfString:@".+" withString:@".0+"];
    localOpString = [localOpString stringByReplacingOccurrencesOfString:@"-." withString:@"-0."];
    localOpString = [localOpString stringByReplacingOccurrencesOfString:@".-" withString:@".0-"];
    localOpString = [localOpString stringByReplacingOccurrencesOfString:@"*." withString:@"*0."];
    localOpString = [localOpString stringByReplacingOccurrencesOfString:@".*" withString:@".0*"];
    if([[localOpString substringToIndex:1] isEqualToString:@"."]){
        localOpString = [NSString stringWithFormat:@"0%@", localOpString];
    }
    if([[localOpString substringToIndex:1] isEqualToString:@"-"]){
        localOpString = [NSString stringWithFormat:@"0%@", localOpString];
    }
    if([[localOpString substringFromIndex:[localOpString length]-1] isEqualToString:@"."]){
        localOpString = [NSString stringWithFormat:@"%@0", localOpString];
    }
    if([[localOpString substringFromIndex:[localOpString length]-1] isEqualToString:@"-"]
       || [[localOpString substringFromIndex:[localOpString length]-1] isEqualToString:@"+"]
       || [[localOpString substringFromIndex:[localOpString length]-1] isEqualToString:@"*"]){
        
        localOpString = [localOpString stringByReplacingCharactersInRange:NSMakeRange([localOpString length]-1, 1) withString:@""];
        
    }
    
    // parse
    AGLog(@"== prepared string: %@", localOpString);
    NSError *error = nil;
    
    //  *
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9]+\\.?[0-9]*\\*[0-9]+\\.?[0-9]*"
                                                                           options:NSRegularExpressionCaseInsensitive                                                           error:&error];
    while (true) {
        NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:localOpString options:0 range:NSMakeRange(0, [localOpString length])];
        if (rangeOfFirstMatch.length != 0) {
//        if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
            NSString *substringForFirstMatch = [localOpString substringWithRange:rangeOfFirstMatch];
            NSRange mulInd = [substringForFirstMatch rangeOfString:@"*"];
            NSString* strLeft = [substringForFirstMatch substringToIndex:mulInd.location];
            NSString* strRight = [substringForFirstMatch substringFromIndex:mulInd.location+1];
            double res = [self parseDoubleString:strLeft]*[self parseDoubleString:strRight];
            localOpString = [localOpString stringByReplacingCharactersInRange:rangeOfFirstMatch withString:[NSString stringWithFormat:@"%f", res]];
        }else{
            break;
        }
        AGLog(@"= %@", localOpString);
    }
    
    //  -
    regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9]+\\.?[0-9]*\\--?[0-9]+\\.?[0-9]*"
                                                      options:NSRegularExpressionCaseInsensitive
                                                        error:&error];
    while (true) {
        NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:localOpString options:0 range:NSMakeRange(0, [localOpString length])];
        if (rangeOfFirstMatch.length != 0) {
//        if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
            NSString *substringForFirstMatch = [localOpString substringWithRange:rangeOfFirstMatch];
            NSRange mulInd = [substringForFirstMatch rangeOfString:@"-"];
            NSString* strLeft = [substringForFirstMatch substringToIndex:mulInd.location];
            NSString* strRight = [substringForFirstMatch substringFromIndex:mulInd.location+1];
            if ((rangeOfFirstMatch.location == 1) && ([[localOpString substringToIndex:1] isEqualToString:kOpMinus])) {
                strLeft = [NSString stringWithFormat:@"-%@", strLeft];
                rangeOfFirstMatch.location -= 1;
                rangeOfFirstMatch.length += 1;
            }
            double res = [self parseDoubleString:strLeft]-[self parseDoubleString:strRight];
            localOpString = [localOpString stringByReplacingCharactersInRange:rangeOfFirstMatch withString:[NSString stringWithFormat:@"%f", res]];
        }else{
            break;
        }
        AGLog(@"= %@", localOpString);
    }
    
    //  +
    regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9]+\\.?[0-9]*\\+-?[0-9]+\\.?[0-9]*"
                                                      options:NSRegularExpressionCaseInsensitive
                                                        error:&error];
    while (true) {
        NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:localOpString options:0 range:NSMakeRange(0, [localOpString length])];
        if (rangeOfFirstMatch.length != 0) {
//        if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
            NSString *substringForFirstMatch = [localOpString substringWithRange:rangeOfFirstMatch];
            NSRange mulInd = [substringForFirstMatch rangeOfString:@"+"];
            NSString* strLeft = [substringForFirstMatch substringToIndex:mulInd.location];
            NSString* strRight = [substringForFirstMatch substringFromIndex:mulInd.location+1];
            if ((rangeOfFirstMatch.location == 1) && ([[localOpString substringToIndex:1] isEqualToString:kOpMinus])) {
                strLeft = [NSString stringWithFormat:@"-%@", strLeft];
                rangeOfFirstMatch.location -= 1;
                rangeOfFirstMatch.length += 1;
            }
            double res = [self parseDoubleString:strLeft]+[self parseDoubleString:strRight];
            localOpString = [localOpString stringByReplacingCharactersInRange:rangeOfFirstMatch withString:[NSString stringWithFormat:@"%f", res]];
        }else{
            break;
        }
        AGLog(@"= %@", localOpString);
    }
    double res = [self parseDoubleString:localOpString];
    AGLog(@"== parsing result: %f", res);
    return res;
}

- (double) parseDoubleString:(NSString*)str{
//    AGLog(@"%@", str);
    double res = 0;
    int p = 0;
    for (int i = 0; i<[str length]; i++) {
        NSString* digit = [str substringWithRange:NSMakeRange(i, 1)];
        if ([digit isEqualToString:@"."]) {
            p = 1;
            continue;
        }
        if(p == 0){
            res = res*10 + [digit intValue];
        }else{
            res += (double)[digit intValue] / pow(10, p++);
        }
    }
    if([[str substringToIndex:1] isEqualToString:@"-"]){
        res *= (-1);
    }
    return res;
}

@end