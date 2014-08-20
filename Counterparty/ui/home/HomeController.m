//
//  HomeController.m
//  Counterparty
//
//  Created by ouyang on 14-7-26.
//  Copyright (c) 2014年 ori. All rights reserved.
//

#import "HomeController.h"

@interface HomeController ()

@end

@implementation HomeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Counterparty", nil);
        self.list = [NSMutableArray array];
        self.list2 = [NSMutableArray array];
        self.tempList = [NSMutableArray array];
        self.tempList2 = [NSMutableArray array];
        self.totalBuy = @"Order Book";
        self.totalSell = @"Order Book";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *titleView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
    UIImageView *logoIV = [[[UIImageView alloc] initWithFrame:CGRectMake(70, 7, 30, 30)] autorelease];
    logoIV.image = [UIImage imageNamed:@"counterparty_logo"];
    [titleView addSubview:logoIV];
    UILabel *logoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(logoIV.frame.origin.x+logoIV.frame.size.width+10, logoIV.frame.origin.y, 150, 30)] autorelease];
    logoLabel.text = @"Counterparty";
    logoLabel.backgroundColor = [UIColor clearColor];
    logoLabel.textColor = [UIColor whiteColor];//[UIColor colorWithRed:0.000 green:0.620 blue:0.286 alpha:1.0];
    logoLabel.font = [UIFont boldSystemFontOfSize:20];
    [titleView addSubview:logoLabel];
    self.navigationItem.titleView = titleView;

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
    [_tempList2 removeAllObjects];
    
    /*
     <table class="table table-striped " id="Table2">
     <tr>
        <td align="left" colspan="4">
            <font color="gray">Total: 7.76360378 BTC</font>
        </td>
     </tr>
     <tr>
        <th>Tx</th>
        <th>Volume</th>
        <th>Price</th>
        <th class="hidden-xs">Total</th>
     </tr>
     <tr>
        <td><a href='order.aspx?q=1268119' rel='tooltip' data-placement='right' title='[Source]:<br>1KYXwXS2kaUVwaZReCJiumqyuXQyumb3AD&#013;<br>[Blocks Till Expire]: &#013;466 blocks (Approx 4655 mins)<br>[Fee_Required]: 0 BTC<br>[Fee_Provided]: 0.0001585 BTC'>1268119</a></td>
        <td>37.9154 XCP</td>
        <td>0.00418000 BTC/XCP</td>
        <td class="hidden-xs">0.15848637 BTC</td>
     </tr>
     
     <tr>
        <td><a href='order.aspx?q=1864752' rel='tooltip' data-placement='right' title='[Source]:<br>13zZnKip77TyySNrDwpmkeaAQwTKZvfWfG&#013;<br><br>[Blocks Till Expire]: &#013;954 blocks (Approx 9535 mins)<br>[Fee_Required]: 0.00179432 BTC<br>[Fee_Provided]: 0.0002 BTC'>1864752</a></td>
        <td><font color='brown'>21.6341175 XCP</font></td>
        <td>0.004 BTC/XCP</td>
        <td class="hidden-xs">0.08653647 BTC</td>
     </tr>
     

     */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *url = @"http://www.blockscan.com/order_book.aspx";
        [HXLoger log:@"----%s, url=%@", __func__, url];
        NSData *data = [[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]] autorelease];
        TFHpple *hpple = [[[TFHpple alloc] initWithHTMLData:data] autorelease];
        NSArray *tables = [hpple searchWithXPathQuery:@"//table"];
        
        //Buy Orders
        if (tables.count > 0) {
            TFHppleElement *table = tables.firstObject;
            NSArray *trs = table.children;
            for (int i = 0; i < trs.count; i++) {
                TFHppleElement *tr = [trs objectAtIndex:i];
                if (i == 0) {
                    NSArray *tds = tr.children;
                    if (tds.count > 0) {
                        TFHppleElement *td = tds.firstObject;
                        if (td.children.count > 0) {
                            TFHppleElement *font = td.children.firstObject;
                            NSString *content = font.content;
                            if (content == nil) {
                                content = @"";
                            }
                            self.totalBuy = content;
//                            [HXLoger log:@"-------%@", content];
                        }

                    }
                }
                
                NSArray *ths = tr.children;
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:3];
                for (int j = 0; j < ths.count; j++) {
                    TFHppleElement *th = [ths objectAtIndex:j];
                    
                    switch (j) {
                        case 1:
                        {
                            /*
                             <td><font color='brown'>21.6341175 XCP</font></td>
                             */
                            if (th.children.count > 0) {
                                TFHppleElement *font = th.children.firstObject;
                                NSString *content = font.content;
                                if (content == nil) {
                                    content = @"";
                                }
                                [dic setObject:content forKey:@"Volume"];
                            }
                            else {
                                NSString *content = th.content;
                                if (content == nil) {
                                    content = @"";
                                }
                                [dic setObject:content forKey:@"Volume"];
                            }
                        }
                            break;
                        case 2:
                        {
                            NSString *content = th.content;
                            if (content == nil) {
                                content = @"";
                            }
                            [dic setObject:content forKey:@"Price"];
                        }
                            break;
                        case 3:
                        {
                            NSString *content = th.content;
                            if (content == nil) {
                                content = @"";
                            }
                            [dic setObject:content forKey:@"Total"];
                        }
                            break;
                            
                        default:
                            break;
                    }
                }
                NSString *price = [[dic objectForKey:@"Price"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if (price.length > 0) {
                    [_tempList addObject:dic];
                }
            }
        }
        
        //Sell Orders
        if (tables.count > 1) {
            TFHppleElement *table = [tables objectAtIndex:1];
            NSArray *trs = table.children;
            for (int i = 0; i < trs.count; i++) {
                TFHppleElement *tr = [trs objectAtIndex:i];
                if (i == 0) {
                    NSArray *tds = tr.children;
                    if (tds.count > 0) {
                        TFHppleElement *td = tds.firstObject;
                        if (td.children.count > 0) {
                            TFHppleElement *font = td.children.firstObject;
                            NSString *content = font.content;
                            if (content == nil) {
                                content = @"";
                            }
                            self.totalSell = content;
//                            [HXLoger log:@"-------%@", content];
                        }
                        
                    }
                }
                
                NSArray *ths = tr.children;
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:3];
                for (int j = 0; j < ths.count; j++) {
                    TFHppleElement *th = [ths objectAtIndex:j];
                    
                    switch (j) {
                        case 1:
                        {
                            if (th.children.count > 0) {
                                TFHppleElement *font = th.children.firstObject;
                                NSString *content = font.content;
                                if (content == nil) {
                                    content = @"";
                                }
                                [dic setObject:content forKey:@"Volume"];
                            }
                            else {
                                NSString *content = th.content;
                                if (content == nil) {
                                    content = @"";
                                }
                                [dic setObject:content forKey:@"Volume"];
                            }
                        }
                            break;
                        case 2:
                        {
                            NSString *content = th.content;
                            if (content == nil) {
                                content = @"";
                            }
                            [dic setObject:content forKey:@"Price"];
                        }
                            break;
                        case 3:
                        {
                            NSString *content = th.content;
                            if (content == nil) {
                                content = @"";
                            }
                            [dic setObject:content forKey:@"Total"];
                        }
                            break;
                            
                        default:
                            break;
                    }
                }
                NSString *price = [[dic objectForKey:@"Price"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if (price.length > 0) {
                    [_tempList2 addObject:dic];
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
                [_list2 removeAllObjects];
            }
            self.tableView.reachedTheEnd = YES;
            [self.tableView tableViewDidFinishedLoading];
            
            [_list addObjectsFromArray:_tempList];
            [_list2 addObjectsFromArray:_tempList2];

            [_tableView reloadData];
            
        });
        
    });
    
}



#pragma mark- UITableViewDataSource<NSObject>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _list.count;
    }
    return _list2.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *head = @"";
    if (section == 0) {
        head = [NSString stringWithFormat:@"Buy %@", self.totalBuy];
    }
    else {
        head = [NSString stringWithFormat:@"Sell %@", self.totalSell];
    }
    return head;
}

static NSString *CellId = @"CellId";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeCell" owner:self options:nil];
        if (nib.count > 0) {
            cell = self.cell;
        }
        else {
            [HXLoger log:@"failed to load CustomCell nib file!"];
        }
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
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

    
    UILabel *volumeLabel = (UILabel *)[cell viewWithTag:11];
    UILabel *priceLabel = (UILabel *)[cell viewWithTag:12];
    UILabel *totalLabel = (UILabel *)[cell viewWithTag:13];
    
    if (indexPath.row == 0) {
        [bgView setBackgroundColor:[UIColor colorWithRed:1.000 green:0.839 blue:0.608 alpha:1.0]];
        [bgView setBackgroundColor:[UIColor colorWithRed:0.969 green:0.910 blue:0.667 alpha:1.0]];
        volumeLabel.textColor = [UIColor blackColor];
        priceLabel.textColor = [UIColor blackColor];
        totalLabel.textColor = [UIColor blackColor];
        volumeLabel.font = [UIFont boldSystemFontOfSize:17];
        priceLabel.font = [UIFont boldSystemFontOfSize:17];
        totalLabel.font = [UIFont boldSystemFontOfSize:17];
    }
    else {
        priceLabel.textColor = [UIColor blackColor];
        volumeLabel.font = [UIFont systemFontOfSize:11];
        priceLabel.font = [UIFont systemFontOfSize:11];
        totalLabel.font = [UIFont systemFontOfSize:11];
        if (indexPath.section == 0) {
            volumeLabel.textColor = [UIColor redColor];
            totalLabel.textColor = [UIColor colorWithRed:0.000 green:0.620 blue:0.286 alpha:1.0];
        }
        else {
            volumeLabel.textColor = [UIColor colorWithRed:0.000 green:0.620 blue:0.286 alpha:1.0];
            totalLabel.textColor = [UIColor redColor];
        }
    }
    

    NSDictionary *dic = nil;
    if (indexPath.section == 0) {
        dic = [_list objectAtIndex:indexPath.row];
    }
    else {
        dic = [_list2 objectAtIndex:indexPath.row];
    }
    
    volumeLabel.text = [dic objectForKey:@"Volume"];
    priceLabel.text = [dic objectForKey:@"Price"];
    totalLabel.text = [dic objectForKey:@"Total"];
    
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
    [_list2 release];
    [_tempList release];
    [_tempList2 release];
    [_totalBuy release];
    [_totalSell release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setCell:nil];
    [super viewDidUnload];
}
@end
