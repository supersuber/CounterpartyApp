//
//  AssetInfoController.h
//  Counterparty
//
//  Created by ouyang on 14-7-28.
//  Copyright (c) 2014年 ori. All rights reserved.
//

#import "BaseController.h"

@interface AssetInfoController : BaseController

@property (nonatomic, retain) NSString *asset;
@property (retain, nonatomic) NSString *assetId;
@property (retain, nonatomic) NSString *issuer;
@property (retain, nonatomic) NSString *divisible;
@property (retain, nonatomic) NSString *totalAmount;
@property (retain, nonatomic) NSString *callable;
@property (retain, nonatomic) NSString *locked;
@property (retain, nonatomic) NSString *callDate;
@property (retain, nonatomic) NSString *callPrice;
@property (retain, nonatomic) NSString *desc;
@property (retain, nonatomic) NSString *contacts;
@property (retain, nonatomic) NSString *introduction;

@property (retain, nonatomic) IBOutlet UILabel *issuerLabel;
@property (retain, nonatomic) IBOutlet UILabel *assetIdLabel;
@property (retain, nonatomic) IBOutlet UILabel *divisibleLabel;
@property (retain, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (retain, nonatomic) IBOutlet UILabel *callableLabel;
@property (retain, nonatomic) IBOutlet UILabel *lockedLabel;
@property (retain, nonatomic) IBOutlet UILabel *callDateLabel;
@property (retain, nonatomic) IBOutlet UILabel *callPriceLabel;
@property (retain, nonatomic) IBOutlet UILabel *descLabel;

@property (retain, nonatomic) IBOutlet UITextView *contactsTV;
@property (retain, nonatomic) IBOutlet UITextView *introductionTV;




@end
