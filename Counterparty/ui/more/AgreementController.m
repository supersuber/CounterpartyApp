//
//  AgreementController.m
//  Counterparty
//
//  Created by ouyang on 14-7-29.
//  Copyright (c) 2014年 ori. All rights reserved.
//

#import "AgreementController.h"

@interface AgreementController ()

@end

@implementation AgreementController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Agreement", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showBackButton:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
