//
//  TabBarController.h
//  AiShang
//
//  Created by ouyang on 12-5-28.
//  Copyright (c) 2012年 onhand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarController : UITabBarController {

//button背景图片
UIImageView *backgroud_image;
//选中时的图片
UIImageView *select_image;
//背景图片
UIImageView *tab_bar_bg;
//button上的text	
//	NSMutableArray *tab_text;

NSMutableArray *tab_btn;
UIButton *btn;

UIImageView *barView;
    
}

- (void) init_tab;
- (void) when_tabbar_is_unselected;
- (void) add_custom_tabbar_elements;
- (void) when_tabbar_is_selected:(int)tabID;

- (void) hiddenTab:(BOOL)hidden;



@end
