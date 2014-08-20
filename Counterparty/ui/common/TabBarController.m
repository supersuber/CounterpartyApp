//
//  TabBarController.m
//  AiShang
//
//  Created by ouyang on 12-5-28.
//  Copyright (c) 2012年 onhand. All rights reserved.
//

#import "TabBarController.h"
#import "BaseController.h"

@implementation TabBarController


- (void)viewDidLoad {
//    [HXLoger log:@"%s", __func__);
    [super viewDidLoad];
    
    self.tabBar.backgroundColor = [UIColor clearColor];
    self.tabBarController.tabBar.hidden = YES;
    
    for(UIView *view in self.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
//            [HXLoger log:@"-UITabBar--x=%f, y=%f, width=%f, height=%f", view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
            
//            [view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)];
            [view setFrame:CGRectMake(view.frame.origin.x, [UIScreen mainScreen].bounds.size.height, view.frame.size.width, view.frame.size.height)];
        }
        else
        {
//            [HXLoger log:@"---x=%f, y=%f, width=%f, height=%f", view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);

//            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
//            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, [UIScreen mainScreen].bounds.size.height)];
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
        }
    }
    
    self.view.backgroundColor = [UIColor clearColor];
	[self init_tab];
	[self when_tabbar_is_unselected];
	[self add_custom_tabbar_elements];
}



- (void)init_tab
{
    [HXLoger log:@"%s", __func__];
    
    if (barView == nil) {
//        barView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 431, 320, 49)];
        
//        barView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 431, 320, 49)];
        barView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-49, 320, 49)];
        
//        barView.image = [UIImage imageNamed:@"ditiao"];
        
        [barView setContentMode:UIViewContentModeScaleToFill];        
       barView.image = [UIImage imageNamed:@"tab_bg"];
//        barView.backgroundColor = [UIColor lightGrayColor];


//        [HXLoger log:@"-barView--x=%f, y=%f, width=%f, height=%f", barView.frame.origin.x, barView.frame.origin.y, barView.frame.size.width, barView.frame.size.height);

        
        barView.userInteractionEnabled = YES;
        [self.view addSubview:barView];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [HXLoger log:@"%s", __func__);    
}

- (void)when_tabbar_is_unselected
{
//    [HXLoger log:@"%s", __func__);
    
	for(UIView *view in self.view.subviews)
	{
		if([view isKindOfClass:[UITabBar class]])
		{
			view.hidden = YES;
			break;
		}
	}
}

-(void)add_custom_tabbar_elements
{
//    [HXLoger log:@"%s", __func__);    
    
	int tab_num = 4;//TABbar个数
    int button_width = 320 / tab_num;
	int i = 0;
	
	tab_btn = [[NSMutableArray alloc] initWithCapacity:0];
	for (; i < tab_num; i++)
	{
		btn = [UIButton buttonWithType:UIButtonTypeCustom];
		[btn setFrame:CGRectMake(i*button_width, 1, button_width, 48)];
//		[btn setFrame:CGRectMake(i*button_width, 2, button_width, 30)];
//        [btn setBackgroundImage:[UIImage imageNamed:@"tab_button_bg_on"] forState:UIControlStateSelected];
//        [btn setBackgroundImage:[UIImage imageNamed:@"tab_button_bg_on"] forState:UIControlStateHighlighted];
        
        switch (i) {
            case 0:
                [btn setTitle:NSLocalizedString(@"Orders", nil) forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"tab_orders_off"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"tab_orders"] forState:UIControlStateHighlighted];
                [btn setImage:[UIImage imageNamed:@"tab_orders"] forState:UIControlStateSelected];
                
                break;
            case 1:
                [btn setTitle:NSLocalizedString(@"Assets", nil) forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"tab_assets_off"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"tab_assets"] forState:UIControlStateHighlighted];
                [btn setImage:[UIImage imageNamed:@"tab_assets"] forState:UIControlStateSelected];
                break;
            case 2:
                [btn setTitle:NSLocalizedString(@"Burns", nil) forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"tab_burns_off"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"tab_burns"] forState:UIControlStateHighlighted];
                [btn setImage:[UIImage imageNamed:@"tab_burns"] forState:UIControlStateSelected];
                break;
            case 3:
                [btn setTitle:NSLocalizedString(@"More", nil) forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"tab_more_off"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"tab_more"] forState:UIControlStateHighlighted];
                [btn setImage:[UIImage imageNamed:@"tab_more"] forState:UIControlStateSelected];
                break;
                
            default:
                break;
        }
        [btn setBackgroundImage:[UIImage imageNamed:@"tab_item_bg"] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageNamed:@"tab_item_bg"] forState:UIControlStateSelected];
        
        [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        
        /*
        [btn setImageEdgeInsets: UIEdgeInsetsMake(5, (button_width-16)/2, 16, 0)];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(20.0, -10, 0.0, 0.0)];
        
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0.0,-btn.imageView.image.size.width, 0.0,0.0)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, -btn.titleLabel.bounds.size.width)];
         */
        
        
		if (i == 0)
		{
			[btn setSelected:YES];
		}


        [btn setTitleEdgeInsets:UIEdgeInsetsMake( 30.0,-btn.imageView.image.size.width, 0.0,0.0)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(-10.0, 0.0,0.0, -btn.titleLabel.bounds.size.width)];

		[btn setTag:i];
		[tab_btn addObject:btn];
		[barView addSubview:btn];
        
        
        
//        [HXLoger log:@"-barView--x=%f, y=%f, width=%f, height=%f", barView.frame.origin.x, barView.frame.origin.y, barView.frame.size.width, barView.frame.size.height);
//        [HXLoger log:@"-btn--x=%f, y=%f, width=%f, height=%f", btn.frame.origin.x, btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height);

        
        
		[btn addTarget:self action:@selector(button_clicked_tag:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(multipleTap:withEvent:) forControlEvents:UIControlEventTouchDownRepeat];
		[btn release];
	}
}

- (void)button_clicked_tag:(id)sender
{
//    [HXLoger log:@"%s", __func__);
    
	int tagNum = [(UIButton *)sender tag];
	[self when_tabbar_is_selected:tagNum];
}

- (void)multipleTap:(id)sender withEvent:(UIEvent*)event {
//    [HXLoger log:@"%s", __func__);    
    
    UITouch* touch = [[event allTouches] anyObject];
	int tagNum = [(UIButton *)sender tag];    
    if (touch.tapCount == 2) {
        if (self.selectedIndex == tagNum) {
            UIViewController *aViewController = [self.viewControllers objectAtIndex:tagNum];
            if([aViewController isKindOfClass:[UINavigationController class]])
            {
                UINavigationController *navController = (UINavigationController*)aViewController;
                [navController popToRootViewControllerAnimated:NO];
                
            }

        }
    }
    
}

- (void)when_tabbar_is_selected:(int)tabID
{	
//    [HXLoger log:@"--------------------%s, beforeId=%d, tabId=%d", __func__, self.selectedIndex, tabID);
    
    if (self.selectedIndex != tabID) {
        switch(tabID)
        {
            case 0:
                [[tab_btn objectAtIndex:0] setSelected:true];
                [[tab_btn objectAtIndex:1] setSelected:false];
                [[tab_btn objectAtIndex:2] setSelected:false];
                [[tab_btn objectAtIndex:3] setSelected:false];
                break;
            case 1:
                [[tab_btn objectAtIndex:0] setSelected:false];
                [[tab_btn objectAtIndex:1] setSelected:true];
                [[tab_btn objectAtIndex:2] setSelected:false];
                [[tab_btn objectAtIndex:3] setSelected:false];
                break;
            case 2:
                [[tab_btn objectAtIndex:0] setSelected:false];
                [[tab_btn objectAtIndex:1] setSelected:false];
                [[tab_btn objectAtIndex:2] setSelected:true];
                [[tab_btn objectAtIndex:3] setSelected:false];
                break;
            case 3:
                [[tab_btn objectAtIndex:0] setSelected:false];
                [[tab_btn objectAtIndex:1] setSelected:false];
                [[tab_btn objectAtIndex:2] setSelected:false];
                [[tab_btn objectAtIndex:3] setSelected:true];
                break;
            default:
                break;
        }	
        self.selectedIndex = tabID;
    }
    else{
        UIViewController *aViewController = [self.viewControllers objectAtIndex:tabID];
        if([aViewController isKindOfClass:[UINavigationController class]])
        {
            UINavigationController *navController = (UINavigationController*)aViewController;
            [navController popToRootViewControllerAnimated:NO];
        }
    }
	
    
    
}

- (void) hiddenTab:(BOOL)hidden
{
//    [HXLoger log:@"-----------------------%s", __func__);    
    
    for(UIView *view in self.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            barView.hidden = hidden;
            if (hidden) {
                float hei = [UIScreen mainScreen].bounds.size.height;
//                [view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)];
                [view setFrame:CGRectMake(view.frame.origin.x, hei, view.frame.size.width, view.frame.size.height)];
                
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, 458, view.frame.size.width, view.frame.size.height)];
            }
        }
        else
        {
            if ([view isKindOfClass:[UIImageView class]]) {
                //                [HXLoger log:@"height:%f",view.frame.size.height);
                if (hidden) {
//                    [view setFrame:CGRectMake(view.frame.origin.x, 418, view.frame.size.width, 0)];
                    
//                    [view setFrame:CGRectMake(view.frame.origin.x, 431, view.frame.size.width, 0)];
                    [view setFrame:CGRectMake(view.frame.origin.x, [UIScreen mainScreen].bounds.size.height-49, view.frame.size.width, 0)];
                } else {
//                    [view setFrame:CGRectMake(view.frame.origin.x, 418, view.frame.size.width, 62)];
                    
//                    [view setFrame:CGRectMake(view.frame.origin.x, 431, view.frame.size.width, 49)];
                    [view setFrame:CGRectMake(view.frame.origin.x, [UIScreen mainScreen].bounds.size.height-49, view.frame.size.width, 49)];                                        
                }
            }
            else
            {
//                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, [UIScreen mainScreen].bounds.size.height)];
            }
        }
    }
}

- (void)dealloc {
	[backgroud_image release];
	[select_image release];
	[tab_bar_bg release];
    //	[tab_text release];
	[tab_btn release];
    [super dealloc];
}

@end