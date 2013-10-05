//
//  NSString+ReplacePointWithComma.m
//  Всё моё
//
//  Created by Alexandr Kolesnik on 20.06.13.
//  Copyright (c) 2013 Viacheslav Kaloshin. All rights reserved.
//

#import "NSString+ReplacePointWithComma.h"

@implementation NSString (ReplacePointWithComma)

-(NSString*)replacePointWithComma
{    
    return [self stringByReplacingOccurrencesOfString:@","
                                          withString:@"."];
}

@end
