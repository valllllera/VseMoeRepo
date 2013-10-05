//
//  NSArray+Additions.h
//  Всё моё
//
//  Created by Alexandr Kolesnik on 04.07.13.
//  Copyright (c) 2013 Viacheslav Kaloshin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Additions)

- (NSArray *)arrayByInsertingObjectsFromArray:(NSArray *)otherArray fromIndex:(NSInteger)index;

- (NSArray *)arrayByRemovingObjectsFromArray:(NSArray *)removingArray;

@end
