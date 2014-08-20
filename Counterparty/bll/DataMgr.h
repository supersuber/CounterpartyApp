//
//  DataMgr.h
//  AiShang
//
//  Created by ouyang on 12-5-28.
//  Copyright (c) 2012年 onhand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface DataMgr : NSObject


+ (AppDelegate *)getAppDelegate;

+ (void)saveCacheData:(NSString *)cacheKey stringForCache:(NSString *)cacheString;

+ (NSString *)readCacheData:(NSString *)cacheKey;



+ (void)saveIsRememberPassword:(BOOL)remember;

+ (BOOL)getIsRememberPassword;

+ (void)savePassword:(NSString *)password;

+ (NSString *)getPassword;

+ (void)saveCompanyPhone:(NSString *)phone;

+ (NSString *)getCompanyPhone;

+ (void)saveUserId:(NSString *)userId;

+ (NSString *)getUserId;

+ (void)saveUsername:(NSString *)username;

+ (NSString *)getUsername;

+ (void)saveQRCodeUrl:(NSString *)url;

+ (NSString *)getQRCodeUrl;


@end
