//
//  HomeController.h
//  Counterparty
//
//  Created by ouyang on 14-7-26.
//  Copyright (c) 2014年 ori. All rights reserved.
//

#import "BaseController.h"
#import "PullingRefreshTableView.h"

@interface HomeController : BaseController <PullingRefreshTableViewDelegate, UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, retain) NSString *totalBuy;
@property (nonatomic, retain) NSString *totalSell;

@property (nonatomic, retain) NSMutableArray *list;
@property (nonatomic, retain) NSMutableArray *list2;
@property (nonatomic, retain) NSMutableArray *tempList;
@property (nonatomic, retain) NSMutableArray *tempList2;
@property (retain, nonatomic) PullingRefreshTableView *tableView;
@property (nonatomic) BOOL refreshing;

@property (retain, nonatomic) IBOutlet UITableViewCell *cell;

@end
