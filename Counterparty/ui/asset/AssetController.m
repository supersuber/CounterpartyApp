//
//  AssetController.m
//  Counterparty
//
//  Created by ouyang on 14-7-26.
//  Copyright (c) 2014年 ori. All rights reserved.
//

#import "AssetController.h"
#import "AssetInfoController.h"

@interface AssetController ()

@end

@implementation AssetController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Assets", nil);
        self.list = [NSMutableDictionary dictionary];
        self.tempList = [NSMutableArray array];
        self.beginPage = 0;        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
     <tr>
        <th>Asset</th>
        <th class="hidden-xs">Asset_ID</th>
        <th class="">Divisible</th>
     </tr>
     <tr>
        <td>
            <b><a href='assetInfo.aspx?q=BAAA'>BAAA</b></td>
        <td class="hidden-xs">17576</td>
        <td>True</td>
     </tr>
     */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *url = [NSString stringWithFormat:@"http://www.blockscan.com/asset.aspx?p=%d", self.beginPage];
        [HXLoger log:@"----%s, url=%@", __func__, url];
        NSData *data = [[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]] autorelease];
        TFHpple *hpple = [[[TFHpple alloc] initWithHTMLData:data] autorelease];
        NSArray *tables = [hpple searchWithXPathQuery:@"//table"];
        if (tables.count > 0) {
            TFHppleElement *table = tables.firstObject;
            NSArray *trs = table.children;
            for (TFHppleElement *tr in trs) {
                NSArray *ths = tr.children;
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:10];
                for (int i = 0; i < ths.count; i++) {
                    TFHppleElement *th = [ths objectAtIndex:i];
                    if ([@"Asset" isEqualToString:th.content]) {
                        break;
                    }
                    
                    switch (i) {
                        case 0:
                        {
                            /*
                             <td>
                                <b><a href='assetInfo.aspx?q=BAAA'>BAAA</b>
                             </td>
                             */
                            NSString *content = th.content;
                            if (content == nil) {
                                NSArray *bs = th.children;
                                if (bs.count > 0) {
                                    TFHppleElement *b = bs.firstObject;
                                    NSArray *as = b.children;
                                    if (as.count > 0) {
                                        TFHppleElement *a = as.firstObject;
                                        content = a.content;
                                        if (content == nil) {
                                            content = @"";
                                        }
                                        
                                    }
                                }
                            }
//                            [HXLoger log:@"asset=%@", content];
                            [dic setObject:content forKey:@"Asset"];
                        }
                            break;
                        case 1:
                        {
                            NSString *content = th.content;
//                            [HXLoger log:@"Asset_ID=%@", content];
                            if (content == nil) {
                                content = @"";
                            }
                            [dic setObject:content forKey:@"Asset_ID"];
                        }
                            break;
                        case 2:
                        {
                            NSString *content = th.content;
//                            [HXLoger log:@"Divisible=%@", content];
                            if (content == nil) {
                                content = @"";
                            }
                            [dic setObject:content forKey:@"Divisible"];
                        }
                            break;
                            
                        default:
                            break;
                    }
                }
                NSString *asset = [dic objectForKey:@"Asset"];
                if (asset.length > 0) {
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
                    NSString *asset = [dic objectForKey:@"Asset"];
                    NSString *prefix = [asset substringToIndex:1];
                    NSMutableArray *arr = [_list objectForKey:prefix];
                    if (arr == nil) {
                        arr = [NSMutableArray array];
                    }
                    [arr addObject:dic];
                    [_list setObject:arr forKey:prefix];
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
    NSString *key = [[_list allKeys] objectAtIndex:section];
    NSArray *subs = [_list objectForKey:key];
    return subs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[_list allKeys] objectAtIndex:section];
}

static NSString *CellId = @"CellId";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AssetCell" owner:self options:nil];
        if (nib.count > 0) {
            cell = self.cell;
        }
        else {
            [HXLoger log:@"failed to load CustomCell nib file!"];
        }
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

    UIView *bgView = [[[UIView alloc] init] autorelease];
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
    
    
    UILabel *assetNameLabel = (UILabel *)[cell viewWithTag:11];
    UILabel *assetIdLabel = (UILabel *)[cell viewWithTag:12];
    UILabel *divisibleLabel = (UILabel *)[cell viewWithTag:13];
    
    NSString *key = [[_list allKeys] objectAtIndex:indexPath.section];
    NSArray *subs = [_list objectForKey:key];
    NSDictionary *dic = [subs objectAtIndex:indexPath.row];
    
    assetNameLabel.text = [dic objectForKey:@"Asset"];
    assetIdLabel.text = [dic objectForKey:@"Asset_ID"];
    divisibleLabel.text = [dic objectForKey:@"Divisible"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AssetInfoController *go = [[[AssetInfoController alloc] initWithNibName:@"AssetInfoController" bundle:nil] autorelease];
    NSString *key = [[_list allKeys] objectAtIndex:indexPath.section];
    NSArray *subs = [_list objectForKey:key];
    NSDictionary *dic = [subs objectAtIndex:indexPath.row];
    go.asset = [dic objectForKey:@"Asset"];
    go.assetId = [dic objectForKey:@"Asset_ID"];
    go.divisible = [dic objectForKey:@"Divisible"];
    
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
    [super dealloc];
}
- (void)viewDidUnload {
    [self setCell:nil];
    [super viewDidUnload];
}
@end
