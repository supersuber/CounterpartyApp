//
//  AboutController.m
//  Counterparty
//
//  Created by ouyang on 14-7-28.
//  Copyright (c) 2014年 ori. All rights reserved.
//

#import "AboutController.h"

@interface AboutController ()

@end

@implementation AboutController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"AboutUs", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showBackButton:YES];
    
    for (id subView in self.navigationController.navigationBar.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            [(UIButton *)subView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [(UIButton *)subView setTitleShadowColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        
    }
    
    
    self.couterpartyLabel.text = NSLocalizedString(@"Counterparty", nil);
    self.versionLabel.text = [NSString stringWithFormat:@"v%@", kAppVersionCode];
    self.counterpartyDescLabel.text = NSLocalizedString(@"CounterpartyDesc", nil);
    self.contactUsLabel.text = NSLocalizedString(@"ContactUs", nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_couterpartyLabel release];
    [_versionLabel release];
    [_counterpartyDescLabel release];
    [_contactUsLabel release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setCouterpartyLabel:nil];
    [self setVersionLabel:nil];
    [self setCounterpartyDescLabel:nil];
    [self setContactUsLabel:nil];
    [super viewDidUnload];
}
@end
