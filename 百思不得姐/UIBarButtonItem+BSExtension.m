//
//  UIBarButtonItem+BSExtension.m
//  百思不得姐
//
//  Created by mac on 2017/4/8.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "UIBarButtonItem+BSExtension.h"

@implementation UIBarButtonItem (BSExtension)

+(instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage  target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    button.size = button.currentBackgroundImage.size;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}

@end
