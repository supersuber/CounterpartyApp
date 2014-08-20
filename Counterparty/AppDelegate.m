//
//  AppDelegate.m
//  Counterparty
//
//  Created by ori on 14-7-24.
//  Copyright (c) 2014年 ori. All rights reserved.
//

#import "AppDelegate.h"
#import "MobClick.h"
#import "Config.h"
#import "TabBarController.h"
#import "MLNavigationController.h"
#import "HomeController.h"
#import "AssetController.h"
#import "BurnController.h"
#import "MoreController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [UIApplication sharedApplication].statusBarHidden = NO;    
    
    UIColor *barColor = [UIColor colorWithRed:0.510 green:0.498 blue:0.467 alpha:1.0];
//    barColor = [UIColor darkGrayColor];

    
    //Orders
    HomeController *go1 = [[[HomeController alloc] initWithNibName:@"HomeController" bundle:nil] autorelease];
    MLNavigationController *nav1 = [[[MLNavigationController alloc] initWithRootViewController:go1] autorelease];
    nav1.canDragBack = YES;
    nav1.navigationBar.tintColor = barColor;
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 6.0)) {
        nav1.navigationBar.tintColor = [UIColor darkGrayColor];
    }
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        nav1.navigationBar.barTintColor = [UIColor darkGrayColor];
        nav1.navigationBar.tintColor = [UIColor whiteColor];
        [nav1.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    }
    
    
    //Assets
    AssetController *go2 = [[[AssetController alloc] initWithNibName:@"AssetController" bundle:nil] autorelease];
    MLNavigationController *nav2 = [[[MLNavigationController alloc] initWithRootViewController:go2] autorelease];
    nav2.canDragBack = YES;
    nav2.navigationBar.tintColor = barColor;
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        nav2.navigationBar.barTintColor = barColor;
        nav2.navigationBar.tintColor = [UIColor whiteColor];
        [nav2.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    }
    nav2.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    

    //Burns
    BurnController *go3 = [[[BurnController alloc] initWithNibName:@"BurnController" bundle:nil] autorelease];
    MLNavigationController *nav3 = [[[MLNavigationController alloc] initWithRootViewController:go3] autorelease];
    nav3.canDragBack = YES;
    nav3.navigationBar.tintColor = barColor;
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        nav3.navigationBar.barTintColor = barColor;
        nav3.navigationBar.tintColor = [UIColor whiteColor];
        [nav3.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    }
    nav3.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    
    
    //More
    MoreController *go4 = [[[MoreController alloc] initWithNibName:@"MoreController" bundle:nil] autorelease];
    MLNavigationController *nav4 = [[[MLNavigationController alloc] initWithRootViewController:go4] autorelease];
    nav4.canDragBack = YES;
    nav4.navigationBar.tintColor = barColor;
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        nav4.navigationBar.barTintColor = barColor;
        nav4.navigationBar.tintColor = [UIColor whiteColor];
        [nav4.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    }
    nav4.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    
    
    TabBarController *tabController = [[[TabBarController alloc] init] autorelease];
    [tabController setViewControllers:[NSArray arrayWithObjects:nav1, nav2, nav3, nav4, nil]];
    [tabController when_tabbar_is_selected:0];
    
    self.window.rootViewController = tabController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [MobClick startWithAppkey:kUmengAppkey];
    [MobClick setAppVersion:kAppVersionCode];
    [MobClick checkUpdate];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
