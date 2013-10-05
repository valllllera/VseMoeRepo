//
//  AGServerAccess.h
//  AllMine
//
//  Created by Allgoritm LLC on 26.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface AGServerAccess : NSObject

+ (AGServerAccess*) sharedAccess;

- (void) userSetNewPassword:(NSString*)passNew forUser:(User*)usr;
- (void) userRegisterLogin:(NSString*)login password:(NSString*)password;
- (void) userExistWithLogin:(NSString*)login password:(NSString*)password;
- (void) userRequestPasswordRecoveryForUser:(User*)usr;
- (NSString*) userToken:(User*)usr;

-(void) settingsSetFromServerForUser:(User*)usr;

- (void) synchronizeDataForUser:(User*)usr;

@end
