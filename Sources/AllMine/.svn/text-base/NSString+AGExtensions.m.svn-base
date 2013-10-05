//
//  NSString+AGExtensions.m
//  AllMine
//
//  Created by Allgoritm LLC on 26.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "NSString+AGExtensions.h"

@implementation NSString (AGExtensions)

+ (NSString*) encodeString:(NSString*) aString {
    NSString* encoded =
    (__bridge_transfer NSString*) CFURLCreateStringByAddingPercentEscapes(
                                                                          NULL, /* allocator */
                                                                          (__bridge CFStringRef)aString,
                                                                          NULL, /* charactersToLeaveUnescaped */
                                                                          (CFStringRef)@"!*'();:@&=+$,/?%#[]._",
                                                                          kCFStringEncodingUTF8);
    return encoded;
}

- (NSString*) encode {
    return [NSString encodeString:self];
}

+(NSNumberFormatter*)numberFormatterInteger:(BOOL)integer{
    NSNumberFormatter* nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle:NSNumberFormatterDecimalStyle];
    if(integer){
        [nf setMaximumFractionDigits:0];
        [nf setMinimumFractionDigits:0];
    }else{
        [nf setMaximumFractionDigits:2];
        [nf setMinimumFractionDigits:2];
    }
    nf.usesGroupingSeparator = YES;
    nf.groupingSize = 3;
    nf.groupingSeparator = @" ";
    
    return nf;
}

+ (NSString*) formattedStringFromNumber:(NSNumber*)number{
    NSString* numStr = [[NSString numberFormatterInteger:NO]
                        stringFromNumber:number];
    if ([[numStr substringFromIndex:numStr.length-3] isEqualToString:@".00"]) {
        numStr = [numStr substringToIndex:numStr.length-3];
    }
    return [self formattedStringFromNumber:number
                                    string:numStr];
}

+ (NSString*) formattedStringFromNumber:(NSNumber*)number
                                 string:(NSString*)numStr{
    
    NSString* formattedNumber = [[NSString numberFormatterInteger:YES]
                                 stringFromNumber:number];
    NSRange rangePoint = [numStr rangeOfString:@"."];
    if (rangePoint.location != NSNotFound) {
        formattedNumber = [formattedNumber stringByAppendingString:
                           [numStr substringFromIndex:rangePoint.location]];
    }
    return formattedNumber;
}


@end
