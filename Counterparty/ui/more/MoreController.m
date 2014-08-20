//
//  MoreController.m
//  Counterparty
//
//  Created by ouyang on 14-7-26.
//  Copyright (c) 2014年 ori. All rights reserved.
//

#import "MoreController.h"
#import "MobClick.h"
#import "AboutController.h"
#import "TransactionController.h"
#import "BroadcastController.h"
#import "BalanceController.h"
#import "AgreementController.h"

@interface MoreController ()

@end

@implementation MoreController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"More", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark UITableViewDataSource<NSObject>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    if (section == 2) {
        return 2;
    }
    return 1;
}

static NSString *CellId = @"CellId";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId] autorelease];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    if (indexPath.section == 1) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    NSString *cellName = @"";
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cellName = NSLocalizedString(@"Transactions", nil);
                cell.imageView.image = [UIImage imageNamed:@"more_transaction"];
                break;
            case 1:
                cellName = NSLocalizedString(@"Broadcasts", nil);
                cell.imageView.image = [UIImage imageNamed:@"more_broadcast"];
                break;
            case 2:
                cellName = NSLocalizedString(@"AddressBalance", nil);
                cell.imageView.image = [UIImage imageNamed:@"more_balance"];
                break;
                
            default:
                break;
        }
    }
    else if (indexPath.section == 1) {
        cellName = NSLocalizedString(@"VersionUpdate", nil);
        cell.imageView.image = [UIImage imageNamed:@"more_update"];
    }
    else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cellName = NSLocalizedString(@"Agreement", nil);
            cell.imageView.image = [UIImage imageNamed:@"more_agreement"];
        }
        else {
            cellName = NSLocalizedString(@"AboutUs", nil);
            cell.imageView.image = [UIImage imageNamed:@"more_contact"];
        }
    }
    
    cell.textLabel.text = cellName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            TransactionController *go = [[[TransactionController alloc] initWithNibName:@"TransactionController" bundle:nil] autorelease];
            [self.navigationController pushViewController:go animated:YES];
        }
        else if (indexPath.row == 1) {
            BroadcastController *go = [[[BroadcastController alloc] initWithNibName:@"BroadcastController" bundle:nil] autorelease];
            [self.navigationController pushViewController:go animated:YES];
        }
        else {
            BalanceController *go = [[[BalanceController alloc] initWithNibName:@"BalanceController" bundle:nil] autorelease];
            [self.navigationController pushViewController:go animated:YES];
        }
    }
    
    else if (indexPath.section == 1) {
        [MobClick checkUpdateWithDelegate:self selector:@selector(callBackSelectorWithDictionary:)];
        [self showLoading];
    }
    else  {
        if (indexPath.row == 0) {
            AgreementController *go = [[[AgreementController alloc] initWithNibName:@"AgreementController" bundle:nil] autorelease];
            [self.navigationController pushViewController:go animated:YES];
        }
        else {
            AboutController *go = [[[AboutController alloc] initWithNibName:@"AboutController" bundle:nil] autorelease];
            [self.navigationController pushViewController:go animated:YES];
        }
    }
}


- (void)callBackSelectorWithDictionary:(NSDictionary *)appUpdateInfo{
    //    [HXLoger log:@"---%s, %@", __func__, appUpdateInfo);
    [self hiddenLoading];
    BOOL update = [[appUpdateInfo objectForKey:@"update"] boolValue];
    if (update) {
        NSString *version = [appUpdateInfo objectForKey:@"version"];
        NSString *update_log = [appUpdateInfo objectForKey:@"update_log"];
        NSString *path = [appUpdateInfo objectForKey:@"path"];
        self.updateUrl = path;
        NSString *alertTitle = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"LatestVersion", nil), version];
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:alertTitle message:update_log delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Update", nil), nil] autorelease];
        [alert show];
    }else{
        //您使用的已经是最新的版本!
        [self showCustomLoading:NSLocalizedString(@"NoUpdate", nil)];
    }
}


#pragma mark- UIAlertViewDelegate <NSObject>
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateUrl]];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
