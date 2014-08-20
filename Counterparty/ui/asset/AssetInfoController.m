//
//  AssetInfoController.m
//  Counterparty
//
//  Created by ouyang on 14-7-28.
//  Copyright (c) 2014年 ori. All rights reserved.
//

#import "AssetInfoController.h"

@interface AssetInfoController ()

@end

@implementation AssetInfoController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"AssetInfo", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showBackButton:YES];    
    
    if (_asset.length > 3) {
        self.title = self.asset;
    }
    
//    self.asset = @"MEAT";
    
    self.assetIdLabel.text = self.assetId;
    self.divisibleLabel.text = self.divisible;
    self.issuerLabel.text = @"";
    self.totalAmountLabel.text = @"";
    self.callableLabel.text = @"";
    self.lockedLabel.text = @"";
    self.callDateLabel.text = @"";
    self.callPriceLabel.text = @"";
    self.descLabel.text = @"";
    self.contactsTV.text = @"";
    self.introductionTV.text = @"";
    
    
    UIScrollView *mainSV = (UIScrollView *)self.view;
    mainSV.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 100);

    [self request];
}

- (void)updateData {
    self.issuerLabel.text = self.issuer;
    self.totalAmountLabel.text = self.totalAmount;
    self.callableLabel.text = self.callable;
    self.lockedLabel.text = self.locked;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.callDate.longLongValue];
    self.callDateLabel.text = [date description];
    if (self.callDate.intValue == 0) {
        self.callDateLabel.text = self.callDate;
    }
    self.callPriceLabel.text = self.callPrice;
    self.descLabel.text = self.desc;
    
    if ([self.contacts isEqualToString:@"N/A"]) {
        self.contacts = NSLocalizedString(@"UserNotSet", nil);
    }
    self.contactsTV.text = self.contacts;
    
    if ([self.contacts stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length < 1) {
        self.contactsTV.text = @"[email protected]";
    }
    
    if ([self.introduction isEqualToString:@"N/A"]) {
        self.introduction = @"";
    }
    self.introductionTV.text = [NSString stringWithFormat:@"Description:%@\n%@", self.desc, self.introduction];
}

- (void)request {
    [self showLoading];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *url = [NSString stringWithFormat:@"http://www.blockscan.com/assetInfo.aspx?q=%@", self.asset];
        [HXLoger log:@"----%s, url=%@", __func__, url];
        NSData *data = [[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]] autorelease];
        TFHpple *hpple = [[[TFHpple alloc] initWithHTMLData:data] autorelease];
        NSArray *tables = [hpple searchWithXPathQuery:@"//table"];
        if (tables.count > 0) {
            TFHppleElement *table = tables.firstObject;
            NSArray *trs = table.children;
            for (int i = 0; i < trs.count; i++) {
                TFHppleElement *tr = [trs objectAtIndex:i];
                NSArray *ths = tr.children;

                switch (i) {
                    case 1://Issuer
                    {
                        if (ths.count > 1) {
                            TFHppleElement *td = [ths objectAtIndex:1];
                            NSArray *as = td.children;
                            if (as.count > 0) {
                                TFHppleElement *a = as.firstObject;
                                NSString *content = a.content;
                                if (content == nil) {
                                    content = @"";
                                }
                                self.issuer = content;
//                                [HXLoger log:@"---issuer=%@", content];
                            }
                        }
                    }
                        break;
                    case 5://Total Amount
                    {
                        if (ths.count > 1) {
                            TFHppleElement *td = [ths objectAtIndex:1];

                            NSArray *as = td.children;
                            if (as.count > 0) {
                                TFHppleElement *b = as.lastObject;
                                NSString *content = b.content;
                                if (content == nil) {
                                    content = @"";
                                }
                                self.totalAmount = content;
//                                [HXLoger log:@"---total2=%@", content];
                            }
                            else {
                                NSString *content = td.content;
                                if (content == nil) {
                                    content = @"";
                                }
//                                [HXLoger log:@"---total=%@", content];
                                if ([content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0) {
                                    int from = [content rangeOfString:@"]"].location + [content rangeOfString:@"]"].length;
//                                    [HXLoger log:@"---from=%d", from];
                                    @try {
                                        content = [content substringFromIndex:from];
                                    }
                                    @catch (NSException *exception) {
                                        content = @"0";
                                    }
                                    @finally {
                                        //
                                    }

                                    self.totalAmount = content;
                                    break;
                                }
                            }
                        }
                    }
                        break;
                    case 7://Callable
                    {
                        if (ths.count > 1) {
                            TFHppleElement *td = [ths objectAtIndex:1];
                            NSString *content = td.content;
                            if (content == nil) {
                                content = @"";
                            }
                            self.callable = content;
                        }
                    }
                        break;
                    case 8://Call Date
                    {
                        if (ths.count > 1) {
                            TFHppleElement *td = [ths objectAtIndex:1];
                            NSString *content = td.content;
                            if (content == nil) {
                                content = @"0";
                            }
                            self.callDate = content;
                        }
                    }
                        break;
                    case 9://Call Price
                    {
                        if (ths.count > 1) {
                            TFHppleElement *td = [ths objectAtIndex:1];
                            NSString *content = td.content;
                            if (content == nil) {
                                content = @"";
                            }
                            self.callPrice = content;
                        }
                    }
                        break;
                    case 10://Locked
                    {
                        if (ths.count > 1) {
                            TFHppleElement *td = [ths objectAtIndex:1];
                            NSString *content = td.content;
                            if (content == nil) {
                                content = @"";
                            }
                            self.locked = content;
                        }
                    }
                        break;
                    case 11://desc
                    {
                        if (ths.count > 1) {
                            TFHppleElement *td = [ths objectAtIndex:1];
                            NSString *content = td.content;
                            if (content == nil) {
                                content = @"";
                            }
                            self.desc = content;
                        }
                    }
                        break;

                        
                    default:
                        break;
                }
                
            }
        }
        
        NSArray *divs = [hpple searchWithXPathQuery:@"//div"];
//        [HXLoger log:@"------divs.count=%d", divs.count];
        int panelBody = 0;
        for (TFHppleElement *div in divs) {
            NSDictionary *att = div.attributes;
//            [HXLoger log:@"--------att=%@", att];
            if (att == nil || [att objectForKey:@"class"] == nil || ![@"panel-body" isEqualToString:[att objectForKey:@"class"]]) {
                continue;
            }
            if (panelBody == 0) {
                NSArray *subs = div.children;
                if (subs.count > 0) {
                    TFHppleElement *sub = subs.firstObject;
                    NSString *content = sub.content;
                    if (content == nil) {
                        content = @"";
                    }
                    self.introduction = content;
                }
                else {
                    NSString *content = div.content;
                    if (content == nil) {
                        content = @"";
                    }
                    self.introduction = content;
                }
//                [HXLoger log:@"--------introduction=%@", self.introduction];
            }
            else if (panelBody == 4) {
                NSArray *subs = div.children;
                if (subs.count > 0) {
                    TFHppleElement *sub = subs.firstObject;
                    if (sub.children.count > 0) {
                        TFHppleElement *p = sub.children.firstObject;
                        NSString *content = p.content;
                        if (content == nil) {
                            content = @"";
                        }
                        self.contacts = content;
                    }
                    else {
                        NSString *content = sub.content;
                        if (content == nil) {
                            content = @"";
                        }
                        self.contacts = content;
                    }
                }
                else {
                    NSString *content = div.content;
                    if (content == nil) {
                        content = @"";
                    }
                    self.contacts = content;
                }
//                [HXLoger log:@"--------contacts=%@", self.contacts];
            }
            panelBody++;
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hiddenLoading];
            
            [self updateData];
        });
        
    });
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_issuerLabel release];
    [_assetIdLabel release];
    [_divisibleLabel release];
    [_totalAmountLabel release];
    [_callableLabel release];
    [_lockedLabel release];
    [_callDateLabel release];
    [_callPriceLabel release];
    [_descLabel release];
    [_contactsTV release];
    [_introductionTV release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setIssuerLabel:nil];
    [self setAssetIdLabel:nil];
    [self setDivisibleLabel:nil];
    [self setTotalAmountLabel:nil];
    [self setCallableLabel:nil];
    [self setLockedLabel:nil];
    [self setCallDateLabel:nil];
    [self setCallPriceLabel:nil];
    [self setDescLabel:nil];
    [self setContactsTV:nil];
    [self setIntroductionTV:nil];
    [super viewDidUnload];
}
@end
