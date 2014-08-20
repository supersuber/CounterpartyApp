//
//  BaseController.h
//  code4app
//
//  Created by ori on 12-8-23.
//  Copyright (c) 2012年 ori. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Config.h"
#import "Constant.h"
#import "HXLoger.h"
#import "TFHpple.h"

@interface BaseController : UIViewController <MBProgressHUDDelegate>

@property (nonatomic, retain) MBProgressHUD *hud;
@property (nonatomic, retain) MBProgressHUD *loadingView;
@property (nonatomic, retain) MBProgressHUD *infoView;
@property (nonatomic, assign) int beginPage;


- (void)backAction;
- (void)showBackButton:(BOOL)show;
- (void)hiddenTabBar:(BOOL)hidden;
- (void)showNavgationBarBg;

- (void)showLoading;
- (void)hiddenLoading;
- (void)showLoadingInWindow;
- (void)hiddenLoadingInWindow;


- (void)showCustomLoading:(NSString *)customText;
- (void)showError:(NSInteger)errNo errorMessage:(NSString *)errMsg;


@end
