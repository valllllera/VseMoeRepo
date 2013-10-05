//
//  NSArray+Additions.m
//  Всё моё
//
//  Created by Alexandr Kolesnik on 04.07.13.
//  Copyright (c) 2013 Viacheslav Kaloshin. All rights reserved.
//

#import "NSArray+Additions.h"

@implementation NSArray (Additions)

- (NSArray *)arrayByInsertingObjectsFromArray:(NSArray *)otherArray fromIndex:(NSInteger)index
{
    NSMutableArray *newArray = [NSMutableArray array];
    
    for (int i = 0; i < index; i++)
    {
        [newArray addObject:self[i]];
    }
    
    for (int i = 0; i < [otherArray count];i++)
    {
        [newArray addObject:otherArray[i]];
    }
    
    for (int i = index; i < [self count] - index + 1; i++)
    {
        [newArray addObject:self[i]];
    }
    
    return newArray;
}

- (NSArray *)arrayByRemovingObjectsFromArray:(NSArray *)removingArray
{
    NSMutableArray *newArray =[NSMutableArray arrayWithArray:self];
    
    [newArray removeObjectsInArray:removingArray];
    return newArray;
}

- (NSArray *)arrayByRemovingObjectsWithClass:(Class)klass
{
    NSMutableArray *array = [NSMutableArray array];
    
    for(NSObject *object in self)
    {
        if([object isKindOfClass:klass])
        {
            [array addObject:object];
        }
    }
    
    NSMutableArray *newArray = [NSMutableArray arrayWithArray:self];
    [newArray removeObjectsInArray:array];

    return newArray;
}

@end
