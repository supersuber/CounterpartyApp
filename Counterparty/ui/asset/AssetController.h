//
//  AssetController.h
//  Counterparty
//
//  Created by ouyang on 14-7-26.
//  Copyright (c) 2014年 ori. All rights reserved.
//

#import "BaseController.h"
#import "PullingRefreshTableView.h"

@interface AssetController : BaseController <PullingRefreshTableViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableDictionary *list;
@property (nonatomic, retain) NSMutableArray *tempList;
@property (retain, nonatomic) PullingRefreshTableView *tableView;
@property (nonatomic) BOOL refreshing;

@property (retain, nonatomic) IBOutlet UITableViewCell *cell;


@end
