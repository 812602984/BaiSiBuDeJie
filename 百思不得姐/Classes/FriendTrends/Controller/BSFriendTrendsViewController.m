//
//  BSFriendTrendsViewController.m
//  百思不得姐
//
//  Created by mac on 2017/4/8.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSFriendTrendsViewController.h"
#import "BSRecommendViewController.h"
#import "BSLoginRegisterViewController.h"

@interface BSFriendTrendsViewController ()

@end

@implementation BSFriendTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏标题
    self.navigationItem.title = @"我的关注";
    
    //设置导航栏左边图片按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" highImage:@"friendsRecommentIcon-click" target:self action:@selector(friendsClick)];
    
    self.view.backgroundColor = BSGlobalBg;
}

- (void)friendsClick
{
    BSRecommendViewController *cm = [[BSRecommendViewController alloc] init];
    [self.navigationController pushViewController:cm animated:YES];
}

- (IBAction)loginRegisterClick:(id)sender
{
    BSLoginRegisterViewController *loginRegisterVc = [[BSLoginRegisterViewController alloc] init];
    [self presentViewController:loginRegisterVc animated:YES completion:nil];
}

@end
