//
//  BSSquareView.m
//  百思不得姐
//
//  Created by mac on 2017/5/1.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSSquareView.h"
#import <AFNetworking.h>
#import "BSSquare.h"
#import <MJExtension.h>
#import "BSSquareButton.h"
#import <UIButton+WebCache.h>
#import "BSWebViewController.h"
#import <SafariServices/SafariServices.h>

@interface BSSquareView ()

@property (nonatomic, strong) NSMutableArray *squareList;

@end

@implementation BSSquareView

- (NSMutableArray *)squareList
{
    if (!_squareList) {
        _squareList = [[NSMutableArray alloc] init];
    }
    return _squareList;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"a"] = @"square";
        dict[@"c"] = @"topic";
        
        [[AFHTTPSessionManager manager] GET:@"https://api.budejie.com/api/api_open.php" parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *arr = (NSArray *)responseObject[@"square_list"];
            if(arr.count) {
                self.squareList = [BSSquare mj_objectArrayWithKeyValuesArray:arr];
                [self createSquares:self.squareList];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    return self;
}

- (void)createSquares:(NSArray *)arr
{
    NSInteger maxCols = 4;
    CGFloat btnW = BSScreenW / maxCols;
    CGFloat btnH = btnW;
    for (int i = 0; i < arr.count; i++) {
        int row = i / maxCols;
        int col = i % maxCols;
        BSSquareButton *btn = [BSSquareButton buttonWithType:UIButtonTypeCustom];
        btn.square = self.squareList[i];
        btn.x = col * btnW;
        btn.y = row * btnH;
        btn.width = btnW;
        btn.height = btnH;
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    self.height = ((arr.count + maxCols - 1) / maxCols)*btnH;
    [self setNeedsDisplay];
    
}

- (void)btnClick:(BSSquareButton *)btn
{
    NSString *url = btn.square.url;
    if ([url hasPrefix:@"http"]) {
        UITabBarController *tabBar = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        UINavigationController *nav = tabBar.selectedViewController;
        if(SystemUnderVersion(9.0)){
        
            BSWebViewController *webView = [[BSWebViewController alloc] initWithNibName:@"BSWebViewController" bundle:nil];
            webView.url = url;
            webView.title = btn.square.name;
            
            
            [nav pushViewController:webView animated:YES];
        }else {
            //ios 9.0的新方法，跳转到safari网页，并且在应用内，建议用modal，模态跳转
            SFSafariViewController *safariVc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url]];
//            safariVc.
            [tabBar presentViewController:safariVc animated:YES completion:nil];
        }
    }
}

////控件第一次显示的时候调用
//- (void)drawRect:(CGRect)rect {
//    
//}

@end
