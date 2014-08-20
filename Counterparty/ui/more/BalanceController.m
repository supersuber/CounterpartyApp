//
//  BalanceController.m
//  Counterparty
//
//  Created by ouyang on 14-7-29.
//  Copyright (c) 2014年 ori. All rights reserved.
//

#import "BalanceController.h"
#import "AddressController.h"

@interface BalanceController ()

@end

@implementation BalanceController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"AddressBalance", nil);
        self.list = [NSMutableDictionary dictionary];
        self.tempList = [NSMutableArray array];
        self.beginPage = 0;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showBackButton:YES];
    
    CGRect bounds = self.view.bounds;
    bounds.size.height = [UIScreen mainScreen].bounds.size.height-44-20-49;
    
    _tableView = [[PullingRefreshTableView alloc] initWithFrame:bounds pullingDelegate:self style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [self request];
    
}


- (void)request {
    [self showLoading];
    [_tempList removeAllObjects];
    
    /*
     */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *url = [NSString stringWithFormat:@"http://www.blockscan.com/balance.aspx?q=&p=%d", self.beginPage];
        [HXLoger log:@"----%s, url=%@", __func__, url];
        NSData *data = [[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]] autorelease];
        TFHpple *hpple = [[[TFHpple alloc] initWithHTMLData:data] autorelease];
        NSArray *tables = [hpple searchWithXPathQuery:@"//table"];
        if (tables.count > 0) {
            TFHppleElement *table = [tables objectAtIndex:0];
            
            NSArray *trs = table.children;
            for (TFHppleElement *tr in trs) {
                NSArray *ths = tr.children;
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:10];
                for (int i = 0; i < ths.count; i++) {
                    TFHppleElement *th = [ths objectAtIndex:i];
                    if ([@"Rank" isEqualToString:th.content]) {
                        break;
                    }
                    
                    switch (i) {
                        case 0:
                        {
                            NSString *content = th.content;
                            if (content == nil) {
                                content = @"";
                            }
                            [dic setObject:content forKey:@"Rank"];
                        }
                            break;
                        case 1:
                        {
                            NSString *content = nil;
                            NSArray *as = th.children;
                            if (as.count > 0) {
                                TFHppleElement *a = as.firstObject;
                                content = a.content;
                            }
                            else {
                                content = th.content;
                            }
                            if (content == nil) {
                                content = @"";
                            }
                            [dic setObject:content forKey:@"Address"];
                        }
                            break;
                        case 2:
                        {
                            NSString *content = th.content;
                            if (content == nil) {
                                content = @"";
                            }
                            [dic setObject:content forKey:@"XCPBalance"];
                        }
                            break;
                        case 3:
                        {
                            NSString *content = th.content;
                            if (content == nil) {
                                content = @"";
                            }
                            [dic setObject:content forKey:@"Percentage"];
                        }
                            break;
                            
                        default:
                            break;
                    }
                }
                NSString *tx = [dic objectForKey:@"Address"];
                if (tx.length > 32) {
                    [_tempList addObject:dic];
                }
                
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hiddenLoading];
            
            if (self.refreshing) {
                [self.tableView tableViewDidFinishedLoading];
                self.tableView.reachedTheEnd = NO;
                self.refreshing = NO;
                [_list removeAllObjects];
            }
            
            if (_tempList.count < 1) {
                [self.tableView tableViewDidFinishedLoadingWithMessage:NSLocalizedString(@"AllLoaded", nil)];
                self.tableView.reachedTheEnd = YES;
            }
            else {
                [self.tableView tableViewDidFinishedLoading];
                self.tableView.reachedTheEnd = NO;
                
                for (NSDictionary *dic in _tempList) {
                    NSString *key = [NSString stringWithFormat:@"Top%d", _tempList.count * (self.beginPage + 1)];
                    NSMutableArray *arr = [_list objectForKey:key];
                    if (arr == nil) {
                        arr = [NSMutableArray array];
                    }
                    [arr addObject:dic];
                    [_list setObject:arr forKey:key];
                }
                [_tableView reloadData];
            }
            
        });
        
    });
}

- (NSArray *)sortKeys:(NSArray *)keys {
    NSArray *resultArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        int int1 = [[obj1 stringByReplacingOccurrencesOfString:@"Top" withString:@""] intValue];
        int int2 = [[obj2 stringByReplacingOccurrencesOfString:@"Top" withString:@""] intValue];
        NSNumber *number1 = [NSNumber numberWithInt:int1];
        NSNumber *number2 = [NSNumber numberWithInt:int2];
        NSComparisonResult result = [number1 compare:number2];
        
        return result == NSOrderedDescending; // 升序
//        return result == NSOrderedAscending;  // 降序
    }];
    return resultArray;
}



#pragma mark- UITableViewDataSource<NSObject>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *keys = [_list allKeys];
    NSArray* reversedArray = [self sortKeys:keys];
    NSString *key = [reversedArray objectAtIndex:section];

    NSArray *subs = [_list objectForKey:key];
    return subs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *keys = [_list allKeys];
    NSArray* reversedArray = [self sortKeys:keys];
    NSString *key = [reversedArray objectAtIndex:section];
    return key;
}

static NSString *CellId = @"CellId";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BalanceCell" owner:self options:nil];
        if (nib.count > 0) {
            cell = self.cell;
        }
        else {
            [HXLoger log:@"failed to load CustomCell nib file!"];
        }
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = cell.frame;
    if ( indexPath.row % 2 )
    {
        [bgView setBackgroundColor:[UIColor whiteColor]];
    }
    else
    {
        [bgView setBackgroundColor:[UIColor colorWithWhite:0.95f alpha:1.0f]];
    }
    
    cell.backgroundView=bgView;
    [bgView release];
    
    UILabel *rankLabel = (UILabel *)[cell viewWithTag:11];
    UILabel *addressLabel = (UILabel *)[cell viewWithTag:21];
    UILabel *xcpBalanceLabel = (UILabel *)[cell viewWithTag:31];
    UILabel *percentageLabel = (UILabel *)[cell viewWithTag:32];
    
    NSArray *keys = [_list allKeys];
    NSArray* reversedArray = [self sortKeys:keys];
    NSString *key = [reversedArray objectAtIndex:indexPath.section];
    NSArray *subs = [_list objectForKey:key];
    NSDictionary *dic = [subs objectAtIndex:indexPath.row];
    
    rankLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"Rank"]];
    addressLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"Address"]];
    xcpBalanceLabel.text = [NSString stringWithFormat:@"XCP:%@", [dic objectForKey:@"XCPBalance"]];
    percentageLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"Percentage"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AddressController *go = [[[AddressController alloc] initWithNibName:@"AddressController" bundle:nil] autorelease];
    NSArray *keys = [_list allKeys];
    NSArray* reversedArray = [self sortKeys:keys];
    NSString *key = [reversedArray objectAtIndex:indexPath.section];
    NSArray *subs = [_list objectForKey:key];
    NSDictionary *dic = [subs objectAtIndex:indexPath.row];
    go.address = [dic objectForKey:@"Address"];
    [self.navigationController pushViewController:go animated:YES];
    
}

#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    [self performSelector:@selector(loadingTop) withObject:nil afterDelay:1.f];
}

/*
 - (NSDate *)pullingTableViewRefreshingFinishedDate {
 NSDateFormatter *df = [[NSDateFormatter alloc] init ];
 df.dateFormat = @"yyyy-MM-dd HH:mm";
 NSDate *date = [df dateFromString:@"2012-05-03 10:10"];
 [df release];
 return date;
 }
 
 - (NSDate *)pullingTableViewLoadingFinishedDate {
 NSDateFormatter *df = [[NSDateFormatter alloc] init ];
 df.dateFormat = @"yyyy-MM-dd HH:mm";
 NSDate *date = [df dateFromString:@"2012-09-29 12:10"];
 [df release];
 return date;
 }
 */


- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(loadingBottom) withObject:nil afterDelay:1.f];
}

#pragma mark - Scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
}

#pragma mark - Your actions

-(void)loadingTop {
    self.beginPage = 0;
    [self request];
}

-(void)loadingBottom {
    self.beginPage = self.beginPage + 1;
    [self request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_cell release];
    [_list release];
    [_tempList release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setCell:nil];
    [super viewDidUnload];
}
@end
