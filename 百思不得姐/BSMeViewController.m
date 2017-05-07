//
//  BSMeViewController.m
//  百思不得姐
//
//  Created by mac on 2017/4/8.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSMeViewController.h"

@interface BSMeViewController ()

@end

@implementation BSMeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置导航栏标题
    self.navigationItem.title = @"我的";
    
    //设置导航栏右边图片按钮
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"mine-setting-icon" highImage:@"mine-setting-icon-click" target:self action:@selector(settingClick)];
    UIBarButtonItem *moonItem = [UIBarButtonItem itemWithImage:@"mine-moon-icon" highImage:@"mine-moon-icon-click" target:self action:@selector(nightModeClick)];
    
    self.navigationItem.rightBarButtonItems = @[settingItem,moonItem];
}

- (void)settingClick
{
    BSLogFunc
}

- (void)nightModeClick
{
    BSLogFunc
}

@end
