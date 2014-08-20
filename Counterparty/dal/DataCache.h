
#import <Foundation/Foundation.h>


@interface DataCache : NSObject {
    
}


+ (void)saveCacheData:(NSString *)cacheKey stringForCache:(NSString *)cacheString;

+ (NSString *)readCacheData:(NSString *)cacheKey;

+ (int)saveImage:(NSString *)name url:(NSString *)url image:(UIImage *)image;//-1失败 1成功 0已存在

+ (NSArray *)getAllImage;

+ (void)saveImageKey:(NSString *)key;

+ (NSArray *)getAllImageKey;

+ (void)deleteAllImage;

+ (int)saveArticle:(NSString *)name infoid:(NSString *)infoid icon:(NSString *)icon time:(NSString *)time link:(NSString *)link;

+ (NSArray *)getAllArticle;

+ (void)saveArticleKey:(NSString *)key;

+ (NSArray *)getAllArticleKey;

+ (void)deleteAllArticle;

+ (BOOL)isFirstLauched;

+ (void)setFirstLauched;
 
@end
