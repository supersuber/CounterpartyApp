//
//  AboutController.h
//  Counterparty
//
//  Created by ouyang on 14-7-28.
//  Copyright (c) 2014年 ori. All rights reserved.
//

#import "BaseController.h"

@interface AboutController : BaseController

@property (retain, nonatomic) IBOutlet UILabel *couterpartyLabel;
@property (retain, nonatomic) IBOutlet UILabel *versionLabel;

@property (retain, nonatomic) IBOutlet UILabel *counterpartyDescLabel;

@property (retain, nonatomic) IBOutlet UILabel *contactUsLabel;

@end
