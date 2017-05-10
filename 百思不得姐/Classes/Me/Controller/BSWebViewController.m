//
//  BSWebViewController.m
//  百思不得姐
//
//  Created by mac on 2017/5/2.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSWebViewController.h"
#import <WebKit/WebKit.h>
#import "BSWebviewProgressLine.h"

#define SystemUnderIos8 [[UIDevice currentDevice].systemVersion floatValue] < 8.0

@interface BSWebViewController ()<UIWebViewDelegate,WKUIDelegate,WKNavigationDelegate>

//webView在ios 9以上系统加载缓慢，ios 8有了WkWebview
@property (nonatomic, weak) UIWebView *webView;

@property (nonatomic, weak) WKWebView *wkWebview;

//返回按钮
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBackBtn;

//前进按钮
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goForwardBtn;

//网页进度条
@property (weak, nonatomic) BSWebviewProgressLine *progressLine;

@end

@implementation BSWebViewController

- (BSWebviewProgressLine *)progressLine
{
    if (_progressLine == nil) {
        CGRect rect = self.navigationController.navigationBar.bounds;
        CGFloat height = 2.f;
        BSWebviewProgressLine *progressLine = [[BSWebviewProgressLine alloc] initWithFrame:CGRectMake(0, rect.size.height - height, BSScreenW, height)];
        progressLine.lineColor = [UIColor blueColor];
        [self.navigationController.navigationBar addSubview:progressLine];
        _progressLine = progressLine;
    }
    return _progressLine;
}

- (UIWebView *)webView
{
    if (_webView == nil) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, BSScreenW, self.view.height-44)];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
        [self.view addSubview:webView];
        _webView = webView;
    }
    return _webView;
}

- (WKWebView *)wkWebview
{
    if (_wkWebview == nil) {
        WKWebView *wkWebview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, BSScreenW, self.view.height-44)];
        [wkWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
        [self.view addSubview:wkWebview];
        _wkWebview = wkWebview;
    }
    return _wkWebview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (SystemUnderIos8) {
        
        self.webView.delegate = self;
    }else {
        self.wkWebview.navigationDelegate = self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
//WebView开始加载
- (void)webViewDidStartLoad:(UIWebView *)webView;
{
    [self.progressLine startLoadingAnimation];
}

//WebView加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.progressLine endLoadingAnimation];
    self.goBackBtn.enabled = webView.canGoBack;
    self.goForwardBtn.enabled = webView.canGoForward;
}

//当error.code=-999时，请求被取消
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.progressLine endLoadingAnimation];
    if (error.code == -999) {
        return;
    }
}

#pragma mark - WKWebViewDelegate
//WKWebView加载完成
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [self.progressLine startLoadingAnimation];
}

//WKWebView加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self.progressLine endLoadingAnimation];
    self.goBackBtn.enabled = webView.canGoBack;
    self.goForwardBtn.enabled = webView.canGoForward;
}

//WKWebView加载失败
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [self.progressLine endLoadingAnimation];
}

#pragma UIToolBarItem
- (IBAction)backClick:(id)sender {
    if ([self.webView canGoBack] && SystemUnderIos8) {
        [self.webView goBack];
    }else {
        if (self.wkWebview && [self.wkWebview canGoBack]) {
            [self.wkWebview goBack];
        }
    }
}

- (IBAction)forwardClick:(id)sender {
    if ([self.webView canGoForward] && SystemUnderIos8) {
        [self.webView goForward];
    }else{
        if ( self.wkWebview && [self.wkWebview canGoForward]) {
            [self.wkWebview goForward];
        }
    }
}

- (IBAction)refreshClick:(id)sender {
    if (SystemUnderIos8) {
        [self.webView reload];
    }else{
        [self.wkWebview reload];
    }
}

@end
