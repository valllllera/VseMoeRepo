//
//  AGStack.h
//  AllMine
//
//  Created by Allgoritm LLC on 20.12.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGStack : NSObject

-(id)init;

-(void)pushObject:(id)object;
-(id)popObject;

-(void)pushDouble:(double)value;
-(double)popDouble;

-(void)clear;

@end
