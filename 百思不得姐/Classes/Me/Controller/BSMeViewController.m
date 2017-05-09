//
//  BSMeViewController.m
//  百思不得姐
//
//  Created by mac on 2017/4/8.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSMeViewController.h"
#import "BSMineCell.h"
#import "BSLoginRegisterViewController.h"
#import "BSSquareView.h"
#import "BSAccountTool.h"
#import "BSAccount.h"

@interface BSMeViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation BSMeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BSGlobalBg;
    
    [self setNav];
    
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([BSAccountTool getAccount]) {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)setupTableView
{
    [self.tableView registerClass:[BSMineCell class] forCellReuseIdentifier:@"mine"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.frame = CGRectMake(0, 0, BSScreenW, BSScreenH);
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = BSTopicCellMargin;
    self.tableView.bounces = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    //tableView为Group形式，默认上方有35的空间
    self.tableView.contentInset = UIEdgeInsetsMake(BSTopicCellMargin - 35, 0, 0, 0);
    
    BSSquareView *squareView = [[BSSquareView alloc] init];
    self.tableView.tableFooterView = squareView;
    squareView.height = 850;
}

- (void)setNav
{
    //设置导航栏标题
    self.navigationItem.title = @"我的";
    
    //设置导航栏右边图片按钮
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"mine-setting-icon" highImage:@"mine-setting-icon-click" target:self action:@selector(settingClick)];
    UIBarButtonItem *moonItem = [UIBarButtonItem itemWithImage:@"mine-moon-icon" highImage:@"mine-moon-icon-click" target:self action:@selector(nightModeClick)];
    
    self.navigationItem.rightBarButtonItems = @[settingItem,moonItem];
    
    self.view.backgroundColor = BSGlobalBg;
}

- (void)settingClick
{
    BSLogFunc
}

- (void)nightModeClick
{
    BSLogFunc
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSMineCell *cell = [[BSMineCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"mine"];
    if (indexPath.section == 0) {
        BSAccount *account = [BSAccountTool getAccount];
        if (account) {
            cell.textLabel.text = account.name?:[NSString stringWithFormat:@"uid:%@",account.uid];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.detailTextLabel.text = @"已登录";
            cell.userInteractionEnabled = NO;
        }else{
            cell.userInteractionEnabled = YES;
            cell.textLabel.text = @"登录／注册";
            cell.detailTextLabel.text = @"未登录";
        }
        cell.imageView.image = [UIImage imageNamed:@"mine_icon_nearby"];
    }else {
        cell.textLabel.text = @"离线下载";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSAccount *account = [BSAccountTool getAccount];

    if (indexPath.section == 0 && account == nil) {
        BSLoginRegisterViewController *loginVc = [[BSLoginRegisterViewController alloc] init];
        [self presentViewController:loginVc animated:YES completion:nil];
    }
}

@end
