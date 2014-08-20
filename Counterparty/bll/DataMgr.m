//
//  DataMgr.m
//  AiShang
//
//  Created by ouyang on 12-5-28.
//  Copyright (c) 2012年 onhand. All rights reserved.
//

#import "DataMgr.h"

@implementation DataMgr

+ (AppDelegate *)getAppDelegate {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate;
}


+ (void)saveCacheData:(NSString *)cacheKey stringForCache:(NSString *)cacheString {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:cacheString forKey:cacheKey];
    [ud synchronize];
}

+ (NSString *)readCacheData:(NSString *)cacheKey {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *str = [ud objectForKey:cacheKey];
    return str;
}


+ (void)saveIsRememberPassword:(BOOL)remember {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:remember forKey:@"IsRememberPassword"];
    [ud synchronize];
}

+ (BOOL)getIsRememberPassword {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL remember = [ud boolForKey:@"IsRememberPassword"];
    return remember;
}

+ (void)savePassword:(NSString *)password {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:password forKey:@"password"];
    [ud synchronize];
}

+ (NSString *)getPassword {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *str = [ud objectForKey:@"password"];
    return str;
}


+ (void)saveCompanyPhone:(NSString *)phone {
    if (phone == nil || [phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < 1) {
        return;
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:phone forKey:@"CompanyPhone"];
    [ud synchronize];
}

+ (NSString *)getCompanyPhone {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *str = [ud objectForKey:@"CompanyPhone"];
    return str;
}

+ (void)saveUserId:(NSString *)userId {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:userId forKey:@"UserId"];
    [ud synchronize];
}

+ (NSString *)getUserId {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *str = [ud objectForKey:@"UserId"];
    return str;
}

+ (void)saveUsername:(NSString *)username {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:username forKey:@"Username"];
    [ud synchronize];
}

+ (NSString *)getUsername {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *str = [ud objectForKey:@"Username"];
    if (str == nil) {
        str = @"";
    }
    return str;
}

+ (void)saveQRCodeUrl:(NSString *)url {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:url forKey:@"QRCodeUrl"];
    [ud synchronize];
}

+ (NSString *)getQRCodeUrl {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *str = [ud objectForKey:@"QRCodeUrl"];
    if (str == nil) {
        str = @"";
    }
    return str;
}


@end
