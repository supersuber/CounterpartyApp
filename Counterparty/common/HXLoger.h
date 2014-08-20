//
//  HXLoger.h
//  OriTest
//
//  Created by yanghx on 13-10-16.
//  Copyright (c) 2013年 yanghx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXLoger : NSObject

//外部调试模式打印日志
+ (void)log:(NSString *)format, ...;

//内部调试打印日志
+ (void)show:(NSString *)format, ...;

@end
