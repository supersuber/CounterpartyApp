
#import "DataCache.h"
#import "DataMgr.h"
#import "CipherUtil.h"

#define kCacheFileName @"jiayuandatacache"


@implementation DataCache

+ (void)saveCacheData:(NSString *)cacheKey stringForCache:(NSString *)cacheString{
    NSString *todayString = [[[NSDate date] description] substringToIndex:10];
    todayString = @"";
    NSString *documentDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *cachesPath =[documentDirectory stringByAppendingPathComponent:kCacheFileName];
     NSString *personalCachesPath = [cachesPath stringByAppendingPathComponent:[DataMgr getUserId]];
    NSString *todayCachesPath =[personalCachesPath stringByAppendingPathComponent:todayString];
   
    //创建目录
    if(![[NSFileManager defaultManager] fileExistsAtPath:todayCachesPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@",todayCachesPath] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *cacheDataPath=[todayCachesPath stringByAppendingPathComponent:[CipherUtil md5:cacheKey]];
    NSData *cacheData = [cacheString dataUsingEncoding:NSUTF8StringEncoding];
    [cacheData writeToFile:cacheDataPath atomically:YES]; 
    
}

+ (NSString *)readCacheData:(NSString *)cacheKey{
    NSString *todayString = [[[NSDate date] description] substringToIndex:10];
    todayString = @"";
    NSString *documentDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *cachesPath =[documentDirectory stringByAppendingPathComponent:kCacheFileName];
    NSString *personalCachesPath = [cachesPath stringByAppendingPathComponent:[DataMgr getUserId]];
    NSString *todayCachesPath =[personalCachesPath stringByAppendingPathComponent:todayString];
    

    if(![[NSFileManager defaultManager] fileExistsAtPath:todayCachesPath])
    {
        return @"";
    }
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *cacheDataPath=[todayCachesPath stringByAppendingPathComponent:[CipherUtil md5:cacheKey]];
    if(![[NSFileManager defaultManager] fileExistsAtPath:personalCachesPath]){
        return @"";
    }
    NSData *cacheData = [fileManage contentsAtPath:cacheDataPath];//myFilePath是包含完整路径的文件名
    if (cacheData == nil || [cacheData length]==0) {
        return @"";
    }
    else{
        NSString* cacheString;
        cacheString = [[NSString alloc] initWithData:cacheData encoding:NSUTF8StringEncoding];
        [cacheString autorelease];
        return cacheString;
    }
}


+ (int)saveImage:(NSString *)name url:(NSString *)url image:(UIImage *)image {
    NSString *userid = [DataMgr getUserId];
    if (userid == nil || userid.length < 1) {
        return -1;
    }
    
    NSArray *keys = [DataCache getAllImageKey];
    for (NSString *key in keys) {
        if ([key isEqual:url]) {
            return 0;
        }
    }
    [DataCache saveImageKey:url];
    NSString *cacheString = [NSString stringWithFormat:@"%@|%@", name, url];
    [DataCache saveCacheData:url stringForCache:cacheString];
    return 1;
}

+ (NSArray *)getAllImage {
    NSMutableArray *all = [NSMutableArray array];
    NSArray *keys = [DataCache getAllImageKey];
    for (NSString *key in keys) {
        NSString *cacheString = [DataCache readCacheData:key];
        NSArray *imageStrings = [cacheString componentsSeparatedByString:@"|"];
        NSString *name = [imageStrings objectAtIndex:0];
        NSString *url = [imageStrings objectAtIndex:1];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", url, @"url", nil];
        [all addObject:dic];
    }
    return all;
}

+ (void)saveImageKey:(NSString *)key {
    NSString *keyName = [NSString stringWithFormat:@"allImageKeys_%@", [DataMgr getUserId]];
    NSString *savedImageKeys = [DataCache readCacheData:keyName];
    
    NSString *toSave = [NSString stringWithFormat:@"%@|%@", savedImageKeys, key];
    if (savedImageKeys.length < 1) {
        toSave = key;
    }

    [DataCache saveCacheData:keyName stringForCache:toSave];
}

+ (NSArray *)getAllImageKey {
    NSString *keyName = [NSString stringWithFormat:@"allImageKeys_%@", [DataMgr getUserId]];
    NSString *savedImageKeys = [DataCache readCacheData:keyName];
    if (savedImageKeys.length < 1) {
        return nil;
    }
    NSArray *keys = [savedImageKeys componentsSeparatedByString:@"|"];
    return keys;
}

+ (void)deleteAllImage {
    NSString *keyName = [NSString stringWithFormat:@"allImageKeys_%@", [DataMgr getUserId]];
    [DataCache saveCacheData:keyName stringForCache:@""];
}


+ (int)saveArticle:(NSString *)name infoid:(NSString *)infoid icon:(NSString *)icon time:(NSString *)time link:(NSString *)link {
    NSString *userid = [DataMgr getUserId];
    if (userid == nil || userid.length < 1) {
        return -1;
    }
    NSString *articleKey = [NSString stringWithFormat:@"%@%@%@%@", name, infoid, icon, link];
    articleKey = [articleKey stringByReplacingOccurrencesOfString:@"|" withString:@" "];
    NSArray *keys = [DataCache getAllArticleKey];
    for (NSString *key in keys) {
        if ([key isEqual:articleKey]) {
            return 0;
        }
    }
    [DataCache saveArticleKey:articleKey];
    NSString *cacheString = [NSString stringWithFormat:@"%@|%@|%@|%@|%@", name, infoid, icon, time, link];
    [DataCache saveCacheData:articleKey stringForCache:cacheString];
    return 1;    
}

+ (NSArray *)getAllArticle {
    NSMutableArray *all = [NSMutableArray array];
    NSArray *keys = [DataCache getAllArticleKey];
    for (NSString *key in keys) {
        NSString *cacheString = [DataCache readCacheData:key];
        NSArray *articleStrings = [cacheString componentsSeparatedByString:@"|"];
        NSString *name = [articleStrings objectAtIndex:0];
        NSString *infoid = [articleStrings objectAtIndex:1];
        NSString *icon = [articleStrings objectAtIndex:2];
        NSString *time = [articleStrings objectAtIndex:3];
        NSString *link = [articleStrings objectAtIndex:4];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", infoid, @"infoid", icon, @"icon", time, @"time", link, @"link", nil];
        [all addObject:dic];
    }
    return all;
}

+ (void)saveArticleKey:(NSString *)key {
    NSString *keyName = [NSString stringWithFormat:@"allArticleKeys_%@", [DataMgr getUserId]];
    NSString *savedKeys = [DataCache readCacheData:keyName];
    
    NSString *toSave = [NSString stringWithFormat:@"%@|%@", savedKeys, key];
    if (savedKeys.length < 1) {
        toSave = key;
    }
    
    [DataCache saveCacheData:keyName stringForCache:toSave];
}

+ (NSArray *)getAllArticleKey {
    NSString *keyName = [NSString stringWithFormat:@"allArticleKeys_%@", [DataMgr getUserId]];
    NSString *savedImageKeys = [DataCache readCacheData:keyName];
    if (savedImageKeys.length < 1) {
        return nil;
    }
    NSArray *keys = [savedImageKeys componentsSeparatedByString:@"|"];
    return keys;
}

+ (void)deleteAllArticle {
    NSString *keyName = [NSString stringWithFormat:@"allArticleKeys_%@", [DataMgr getUserId]];
    [DataCache saveCacheData:keyName stringForCache:@""];
}

+ (BOOL)isFirstLauched {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL lauched = [ud boolForKey:@"isFirstLauched"];
    return lauched;
}

+ (void)setFirstLauched {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:YES forKey:@"isFirstLauched"];
    [ud synchronize];
}

 
@end
