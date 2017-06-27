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
#import "BSAccountTool.h"
#import "BSAccount.h"

@interface BSFriendTrendsViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation BSFriendTrendsViewController

- (UITableView *)tableView
{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor orangeColor];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏标题
    self.navigationItem.title = @"我的关注";

    //设置导航栏左边图片按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" highImage:@"friendsRecommentIcon-click" target:self action:@selector(friendsClick)];
    
    self.view.backgroundColor = BSGlobalBg;
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([BSAccountTool getAccount]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"recommend"];
        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        [self.tableView reloadData];
    }
}

- (void)friendsClick
{
    BSRecommendViewController *cm = [[BSRecommendViewController alloc] init];
    [self.navigationController pushViewController:cm animated:YES];
}

- (IBAction)loginRegisterClick:(id)sender
{
    BSLoginRegisterViewController *loginRegisterVc = [[BSLoginRegisterViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginRegisterVc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recommend"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"recommend"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld行",indexPath.row];
    
    return cell;
}

- (void)dealloc
{
    
}

@end
