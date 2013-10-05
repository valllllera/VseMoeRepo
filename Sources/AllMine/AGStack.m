//
//  AGStack.m
//  AllMine
//
//  Created by Allgoritm LLC on 20.12.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "AGStack.h"

@interface AGStack ()

@property(nonatomic, strong) NSMutableArray* stack;

@end

@implementation AGStack

-(id)init{
    self = [super init];
    if (self) {
        _stack = [NSMutableArray array];
    }
    return self;
}

-(void)pushObject:(id)object{
    [_stack addObject:object];
    AGLog(@"stack depth = %d", _stack.count);
}

-(id)popObject{
    id object = _stack.lastObject;
    [_stack removeLastObject];
    return object;
}

-(void)pushDouble:(double)value{
    [self pushObject:[NSNumber numberWithDouble:value]];
}
-(double)popDouble{
    NSNumber* number = self.popObject;
    return number.doubleValue;
}

-(void)clear{
    [_stack removeAllObjects];
}

@end
