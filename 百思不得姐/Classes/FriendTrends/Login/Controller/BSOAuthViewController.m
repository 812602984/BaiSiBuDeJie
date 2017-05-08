//
//  BSOAuthViewController.m
//  百思不得姐
//
//  Created by mac on 2017/5/8.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSOAuthViewController.h"
#import <AFNetworking.h>
#import "BSAccount.h"
#import "BSAccountTool.h"

@interface BSOAuthViewController ()<UIWebViewDelegate>

@end

@implementation BSOAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = self.view.bounds;
    webView.delegate = self;
    [self.view addSubview:webView];
    
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?client_id=1635164511&redirect_uri=https://www.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //1.获得url
    NSString *url = request.URL.absoluteString;
    
    //2.判断是否为回调地址
    NSRange range = [url rangeOfString:@"code="];
    if (range.length != 0) {
        NSInteger fromIndex = range.location + range.length;
        NSString *code = [url substringFromIndex:fromIndex];
        //利用code换取一个access_token
        [self accessTokenWithCode:code];
        return NO;
    }
    return YES;
}

-(void)accessTokenWithCode:(NSString *)code
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_id"] = @"1635164511";
    params[@"client_secret"] = @"3940602b5448cc8d8d9e5bd54bb0c59f";
    params[@"grant_type"] = @"authorization_code";
    params[@"redirect_uri"] = @"https://www.baidu.com";
    params[@"code"] = code;

    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    //发送请求
    [manager POST:@"https://api.weibo.com/oauth2/access_token" parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //将返回的账号字典数据转成模型，存进沙盒
        BSAccount *account = [BSAccount accountWithDict:responseObject];
        [BSAccountTool saveAccount:account];
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        BSLog(@"请求失败 -- %@",error);
        BSLog(@"任务 -- %@",task);
    }];
}

- (void)cancel
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
