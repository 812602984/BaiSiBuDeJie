
//
//  BSTabBar.m
//  百思不得姐
//
//  Created by mac on 2017/4/8.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSTabBar.h"
//#import "BSPublishViewController.h"
#import "BSPublishView.h"

@interface BSTabBar()
@property (nonatomic, weak)UIButton *publishButton;
@end

@implementation BSTabBar

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        //设置tabBar的背景图片
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
        UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        publishButton.size = publishButton.currentBackgroundImage.size;
        [publishButton addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:publishButton];
        self.publishButton = publishButton;
    }
    return self;
}

UIWindow *window;

- (void)publishClick
{
    //1.用控制器的用法做
//    BSPublishViewController *publish = [[BSPublishViewController alloc] init];
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:publish animated:NO completion:nil];
    
    
    /**
     2.做一个背景透明的视图，可以看到后面的,可以用rootViewController里面加控制器的做法，但不适合这里，因为根部是tabbarcontroller，底部会多一个，所以用window
    
    BSPublishView *publishView = [BSPublishView publishView];
    publishView.frame = [UIScreen mainScreen].bounds;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:publishView];   //也可以    [window.rootViewController.view addSubview:publishView];
    */
    
     /**3.用window上加publishView实现，这样的话可以隔断点击事件,最后将window（publishView。superView）置为nil即可
    window = [[UIWindow alloc] init];
    
    window.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    window.frame = [UIScreen mainScreen].bounds;
    window.windowLevel = UIWindowLevelNormal;
    window.hidden = NO;

    BSPublishView *publishView = [BSPublishView publishView];
    publishView.myBlock = ^{
        window = nil;
    };
    publishView.frame = window.bounds;
    [window addSubview:publishView];
    */
    
    
    //4.
    [BSPublishView show];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.width;
    CGFloat height = self.height;
    
    //设置发布按钮的frame,UIImage继承自NSObject
    self.publishButton.center = CGPointMake(width*0.5, height*0.5);
    
    //设置其他UITabBarButton的frame
    CGFloat buttonY = 0;
    CGFloat buttonW = width / 5;
    CGFloat buttonH =  height;
    
    NSInteger index = 0;
    for (UIView *button in self.subviews) {
//        if (![button isKindOfClass:NSClassFromString(@"UITabBarButton")]) continue;
        if (![button isKindOfClass:[UIControl class]] || button == self.publishButton)  continue;
        
        //计算按钮的x
        CGFloat buttonX = buttonW * ((index>1)?(index+1):index);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        //增加索引
        index++;
    }
}

@end
