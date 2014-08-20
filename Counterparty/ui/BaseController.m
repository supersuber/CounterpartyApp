//
//  BaseController.m
//  code4app
//
//  Created by ori on 12-8-23.
//  Copyright (c) 2012年 ori. All rights reserved.
//

#import "BaseController.h"
#import "TabBarController.h"

@implementation BaseController

@synthesize hud = _hud;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.beginPage = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout= UIRectEdgeNone;
    }
    [self showNavgationBarBg];
    CGRect bounds = self.view.bounds;
    bounds.size.height = [UIScreen mainScreen].bounds.size.height-44-20;
    self.view.frame = bounds;
//    [HXLoger log:@"base:screen.h=%f, view.h=%f", [UIScreen mainScreen].bounds.size.height, self.view.frame.size.height);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc {
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showNavgationBarBg {
    NSString *bgImageName = @"nav_bg";
    UINavigationBar *navBar = self.navigationController.navigationBar;
    static int kSCNavBarImageTag = 10;
    if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        //if iOS 5.0 and later
        [navBar setBackgroundImage:[UIImage imageNamed:bgImageName] forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        /*
         self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:219.0/255.0 green:219.0/255.0 blue:219.0/255.0 alpha:1.0];
         return;
         */
        
        UIImageView *imageView = (UIImageView *)[navBar viewWithTag:kSCNavBarImageTag];
        if (imageView == nil)
        {
            imageView = [[UIImageView alloc] initWithImage:
                         [UIImage imageNamed:bgImageName]];
            
            [imageView setTag:kSCNavBarImageTag];
            [navBar insertSubview:imageView atIndex:0];
            [imageView release];
        }
        imageView.image = [UIImage imageNamed:bgImageName];
        
    }
    
}


- (void)showBackButton:(BOOL)show {
    return;
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] < 7.0)) {
        return;
    }
    
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 50, 30);
    [backButton setImage:[UIImage imageNamed:@"com_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"com_back"] forState:UIControlStateHighlighted];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    backButton.hidden = !show;
    
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    [backButtonItem release];
    
}


- (void)hiddenTabBar:(BOOL)hidden {
    TabBarController *tabbar = (TabBarController *)self.tabBarController;
    if (tabbar && [tabbar respondsToSelector:@selector(hiddenTab:)]) {
        [tabbar hiddenTab:hidden];
    }
}


- (void)showLoading{
//    [self showLoadingInWindow];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}

- (void)hiddenLoading{
//    [self hiddenLoadingInWindow];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)showLoadingInWindow{
    if (_loadingView == nil) {
        UIWindow *theWindow = self.view.window;
        CGRect theFrame = theWindow.frame;
        _loadingView = [[MBProgressHUD alloc] initWithFrame:theFrame];
//        _loadingView.labelText = kLoadingText;
        _loadingView.labelText = NSLocalizedString(@"Loading", nil);
        [theWindow addSubview:_loadingView];
        [_loadingView show:YES];
    }
    else{
        [_loadingView show:YES];
    }
}

- (void)hiddenLoadingInWindow{
    [_loadingView hide:YES];
}

- (void)showCustomLoading:(NSString *)customText{
    if (_infoView == nil) {
        self.infoView = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
        _infoView.mode = MBProgressHUDModeCustomView;
        [self.view addSubview:_infoView];
    }
    [self.view bringSubviewToFront:_infoView];
    _infoView.labelText = customText;
    [_infoView show:NO];
    [_infoView hide:YES afterDelay:2.0];
}

- (void)showError:(NSInteger)errNo errorMessage:(NSString *)errMsg
{
    [self showCustomLoading:errMsg];    
}



@end
