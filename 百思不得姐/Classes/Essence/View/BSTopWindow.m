
//
//  BSTopWindow.m
//  百思不得姐
//
//  Created by mac on 2017/4/30.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSTopWindow.h"

@implementation BSTopWindow

static UIWindow *window_;

+ (void)initialize
{
    window_ = [[UIWindow alloc] init];
    window_.windowLevel = UIWindowLevelAlert;
    window_.frame = CGRectMake(0, 0, BSScreenW, 20);
    window_.backgroundColor = [UIColor clearColor];
    
    //xcode 7以后每个window必须有一个rootViewController；这是自定义的window设置方法
    UIViewController *vc = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    window_.rootViewController = vc;
    
    //添加点击手势，点击后返回scrollView滚动到顶部
    [window_ addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollToTop)]];
}

+ (void)scrollToTop
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self searchScrollViewInView:window];
}

+ (void)searchScrollViewInView:(UIView *)superView
{
    //递归搜索scrollView
    for (UIScrollView *subview in superView.subviews) {
        //CGRect rect = [subview.superview convertRect:subview.frame toView:nil];
        //CGRect rect01 = [[UIApplication sharedApplication].keyWindow convertRect:subview.frame fromView:subview.superview];

        BOOL isShowingOnWindow = [subview isShowingOnKeyWindow];
        if ([subview isKindOfClass:[UIScrollView class]] && isShowingOnWindow) {
           
                CGPoint contentOff = subview.contentOffset;
                contentOff.y = -subview.contentInset.top;
                [subview setContentOffset:contentOff animated:YES];
        }
        [self searchScrollViewInView:subview];
    }
}

+ (void)show
{
    window_.hidden = NO;
}

@end
