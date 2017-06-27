//
//  BSAdvertiseViewController.m
//  百思不得姐
//
//  Created by mac on 2017/6/25.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSAdvertiseViewController.h"

@interface BSAdvertiseViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation BSAdvertiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"点击进入广告链接";
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.backgroundColor = [UIColor whiteColor];
    if (!self.adUrl) {
        self.adUrl = @"http://www.jianshu.com";
    }
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.adUrl]];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
}

- (void)setAdUrl:(NSString *)adUrl
{
    _adUrl = adUrl;
}


@end
