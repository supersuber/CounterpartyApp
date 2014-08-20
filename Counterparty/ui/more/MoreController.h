//
//  MoreController.h
//  Counterparty
//
//  Created by ouyang on 14-7-26.
//  Copyright (c) 2014年 ori. All rights reserved.
//

#import "BaseController.h"

@interface MoreController : BaseController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (retain, nonatomic) NSString *updateUrl;
@property (retain, nonatomic) IBOutlet UITableView *tableView;


@end
