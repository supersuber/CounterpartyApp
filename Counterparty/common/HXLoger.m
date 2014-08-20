//
//  HXLoger.m
//  OriTest
//
//  Created by yanghx on 13-10-16.
//  Copyright (c) 2013年 yanghx. All rights reserved.
//

#import "HXLoger.h"
#import "Config.h"

@implementation HXLoger

+ (void)log:(NSString *)format, ... {
    if (kShowLog) {
        va_list args;
        va_start(args, format);
        NSString* str = [[NSString alloc] initWithFormat:format arguments:args];
        va_end( args );
        NSLog(@"%@", str);
        [str release];
    }
}


+ (void)show:(NSString *)format, ... {
    if (kShowLog) {
        va_list args;
        va_start(args, format);
        NSString* str = [[NSString alloc] initWithFormat:format arguments:args];
        va_end( args );
        NSLog(@"%@", str);
        [str release];
    }
}

@end
