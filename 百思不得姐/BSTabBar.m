
//
//  BSTabBar.m
//  百思不得姐
//
//  Created by mac on 2017/4/8.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSTabBar.h"

@interface BSTabBar()
@property (nonatomic, weak)UIButton *publishButton;
@end

@implementation BSTabBar

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        publishButton.size = publishButton.currentBackgroundImage.size;
        [self addSubview:publishButton];
        self.publishButton = publishButton;
    }
    return self;
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
