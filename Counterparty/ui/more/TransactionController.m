//
//  TransactionController.m
//  Counterparty
//
//  Created by ouyang on 14-7-29.
//  Copyright (c) 2014年 ori. All rights reserved.
//

#import "TransactionController.h"
#import "UIImageView+WebCache.h"

@interface TransactionController ()

@end

@implementation TransactionController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Transactions", nil);
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
        NSString *url = [NSString stringWithFormat:@"http://www.blockscan.com/tx.aspx?p=%d", self.beginPage];
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
                    if ([@"Tx" isEqualToString:th.content]) {
                        break;
                    }
                    
                    switch (i) {
                        case 0:
                        {
                            NSString *content = th.content;
                            if (content == nil) {
                                content = @"";
                            }
                            [dic setObject:content forKey:@"Tx"];
                            break;
                        }
                            break;
                        case 1:
                        {
                            NSArray *as = th.children;
                            if (as.count > 0) {
                                TFHppleElement *a = as.firstObject;
                                NSString *content = a.content;
                                if (content == nil) {
                                    content = @"";
                                }
                                [dic setObject:content forKey:@"Block"];
                            }
                        }
                            break;
                        case 2:
                        {
                            NSString *content = th.content;
                            if (content == nil) {
                                content = @"";
                            }
                            [dic setObject:content forKey:@"BlockTime"];
                        }
                            break;
                        case 3:
                        {
                            NSArray *as = th.children;
                            if (as.count > 0) {
                                TFHppleElement *a = as.firstObject;
                                NSString *content = a.content;
                                if (content == nil) {
                                    content = @"";
                                }
                                [dic setObject:content forKey:@"Source"];
                            }
                            else {
                                NSString *content = th.content;
                                if (content == nil) {
                                    content = @"";
                                }
                                [dic setObject:content forKey:@"Source"];
                            }
                        }
                            break;
                        case 4:
                        {
                            
                            NSArray *imgs = th.children;
                            //                            NSLog(@"---imgs.count=%d", imgs.count);
                            if (imgs.count > 0) {
                                TFHppleElement *img = [imgs objectAtIndex:0];
                                NSDictionary *imgDic = img.attributes;
                                NSString *icon = [imgDic objectForKey:@"src"];
                                [dic setObject:[NSString stringWithFormat:@"%@%@", kDefaultApiUrl, icon] forKey:@"Icon"];
                                //                                [HXLoger log:@"----icon=%@", icon];
                            }
                            NSString *content = th.content;
//                            [HXLoger log:@"----dest=%@", content];
                            content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
                            if ([content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0) {
                                [dic setObject:content forKey:@"Destination"];
                            }
                        }
                            break;
                        case 5:
                        {
                            NSString *content = th.content;
                            if (content == nil) {
                                content = @"";
                            }
                            [dic setObject:content forKey:@"BTCAmount"];
                        }
                            break;
                        case 6:
                        {
                            NSString *content = th.content;
                            if (content == nil) {
                                content = @"";
                            }
                            [dic setObject:content forKey:@"Fee"];
                        }
                            break;
                            
                        default:
                            break;
                    }
                }
                NSString *tx = [dic objectForKey:@"Tx"];
                if (tx.length > 0) {
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
                    NSString *blockTime = [dic objectForKey:@"BlockTime"];
                    if (blockTime.length > 10) {
                        blockTime = [blockTime substringToIndex:10];
                    }
                    NSMutableArray *arr = [_list objectForKey:blockTime];
                    if (arr == nil) {
                        arr = [NSMutableArray array];
                    }
                    [arr addObject:dic];
                    [_list setObject:arr forKey:blockTime];
                }
                [_tableView reloadData];
            }
            
        });
        
    });
}



#pragma mark- UITableViewDataSource<NSObject>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _list.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *keys = [_list allKeys];
    NSArray* reversedArray = [[keys reverseObjectEnumerator] allObjects];
    NSString *key = [reversedArray objectAtIndex:section];
    NSArray *subs = [_list objectForKey:key];
    return subs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *keys = [_list allKeys];
    NSArray* reversedArray = [[keys reverseObjectEnumerator] allObjects];
    return [reversedArray objectAtIndex:section];
}

static NSString *CellId = @"CellId";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TransactionCell" owner:self options:nil];
        if (nib.count > 0) {
            cell = self.cell;
        }
        else {
            [HXLoger log:@"failed to load CustomCell nib file!"];
        }
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    //    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
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
    
    UILabel *txLabel = (UILabel *)[cell viewWithTag:11];
    UILabel *blockLabel = (UILabel *)[cell viewWithTag:12];
    UILabel *blockTimeLabel = (UILabel *)[cell viewWithTag:13];
    UILabel *sourceLabel = (UILabel *)[cell viewWithTag:21];
    UIImageView *iconIV = (UIImageView *)[cell viewWithTag:31];
    iconIV.opaque = YES;
    iconIV.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *destinationLabel = (UILabel *)[cell viewWithTag:32];
    UILabel *btcAmountLabel = (UILabel *)[cell viewWithTag:41];
    UILabel *feeLabel = (UILabel *)[cell viewWithTag:42];
    
    NSArray *keys = [_list allKeys];
    NSArray* reversedArray = [[keys reverseObjectEnumerator] allObjects];
    NSString *key = [reversedArray objectAtIndex:indexPath.section];
    NSArray *subs = [_list objectForKey:key];
    NSDictionary *dic = [subs objectAtIndex:indexPath.row];
    
    txLabel.text = [NSString stringWithFormat:@"Tx:%@", [dic objectForKey:@"Tx"]];
    blockLabel.text = [NSString stringWithFormat:@"Block:%@", [dic objectForKey:@"Block"]];
    blockTimeLabel.text = [dic objectForKey:@"BlockTime"];
    sourceLabel.text = [NSString stringWithFormat:@"Source:%@", [dic objectForKey:@"Source"]];
    [iconIV setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"Icon"]] placeholderImage:[UIImage imageNamed:@"Icon"]];
    destinationLabel.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"Destination"]];
    btcAmountLabel.text = [NSString stringWithFormat:@"BTC Amount:%@", [dic objectForKey:@"BTCAmount"]];
    feeLabel.text = [NSString stringWithFormat:@"Fee:%@", [dic objectForKey:@"Fee"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];    
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
