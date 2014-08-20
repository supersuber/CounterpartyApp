//
//  AddressController.h
//  Counterparty
//
//  Created by ori on 14-7-27.
//  Copyright (c) 2014年 ori. All rights reserved.
//

#import "BaseController.h"
#import "PullingRefreshTableView.h"

@interface AddressController : BaseController <PullingRefreshTableViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *balance;
@property (nonatomic, retain) NSString *credits;
@property (nonatomic, retain) NSString *transaction;
@property (nonatomic, retain) NSMutableArray *list;
@property (nonatomic, retain) NSMutableArray *tempList;
@property (retain, nonatomic) PullingRefreshTableView *tableView;
@property (nonatomic) BOOL refreshing;


@property (retain, nonatomic) IBOutlet UIView *headView;
@property (retain, nonatomic) IBOutlet UILabel *addressLabel;
@property (retain, nonatomic) IBOutlet UILabel *balanceLabel;
@property (retain, nonatomic) IBOutlet UILabel *creditsLabel;
@property (retain, nonatomic) IBOutlet UILabel *transactionLabel;

@property (retain, nonatomic) IBOutlet UITableViewCell *cell;


@end
