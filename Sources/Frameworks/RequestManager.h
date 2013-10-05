//
//  RequestManager.h
//  TestJSONVseMoe
//
//  Created by Alexandr Kolesnik on 27.06.13.
//  Copyright (c) 2013 Alexandr Kolesnik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface RequestManager : NSObject

@property(copy,nonatomic) NSString *token;


+ (RequestManager*) sharedRequest;

-(id)initWithToken:(NSString*)token;

- (void) synchronizeDataForUser:(User*)usr
                    withSuccess:(void(^)(void))success
                    withFailure:(void (^)(NSError *error))failure;


-(void)checkLoginWithUser:(User*)user
               withParams:(NSDictionary*)params
              withSuccess:(void(^)(BOOL isLoged))success
              withFailure:(void (^)(NSError *error))failure;


-(void) accountSumWithAccountID:(NSNumber*)accountID
                    withSuccess:(void(^)(NSNumber* result))success
                    withFailure:(void (^)(NSError *error))failure;


-(void)getTransactionListWithSuccess:(void(^)(id json))success
                         withFailure:(void (^)(NSError *error))failure;

-(void)getAccountListWithSuccess:(void(^)(id json))success
                     withFailure:(void (^)(NSError *error))failure;

-(void)getBankListWithSuccess:(void(^)(id json))success
                  withFailure:(void (^)(NSError *error))failure;

-(void)getCurrencyListWithSuccess:(void(^)(id json))success
                      withFailure:(void (^)(NSError *error))failure;

#pragma mark - sync


- (void) synchronizeDataForUser:(User*)usr;

-(void)synchTemplatesWithToken:(NSString*) token
                   withContext:(NSManagedObjectContext*)context
                      withUser:(User*)usr
                   withSuccess:(void(^)(void))success
                   withFailure:(void (^)(NSError *error))failure;

@end
