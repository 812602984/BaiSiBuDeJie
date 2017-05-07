//
//  BSRecommendViewController.m
//  百思不得姐
//
//  Created by mac on 2017/4/9.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSRecommendViewController.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import "BSRecommendCategoryCell.h"
#import "BSRecommendCategory.h"
#import <MJExtension.h>
#import "BSRecommendUserCell.h"
#import "BSRecommendUser.h"
#import <MJRefresh.h>

#define BSRecommendSelectedCategory self.categories[self.categoryTableView.indexPathForSelectedRow.row]

@interface BSRecommendViewController ()<UITableViewDelegate,UITableViewDataSource>

/** 左边的类别数据 */
@property (nonatomic, strong) NSArray *categories;
/** 左边的类别列表 */
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
/** 右边的用户列表 */
@property (weak, nonatomic) IBOutlet UITableView *userTableView;

@property (strong, nonatomic) NSDictionary *params;

@property (strong, nonatomic) AFHTTPSessionManager *manager;

@property (assign, nonatomic) BOOL alreayLoaded;

@end

@implementation BSRecommendViewController

static NSString *const BSCategoryCellId = @"category";
static NSString *const BSUserCellId = @"userCell";

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTableViews];
    
    [self setRefresh];
    
    //显示指示器
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    [self loadCategoryData];
    
    //接收网络状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:)  name:BSNetworkStateNotification object:nil];
    
}

- (void)loadCategoryData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
    params[@"a"] = @"category";
    params[@"c"] = @"subscribe";
    
    [self.manager GET:@"https://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //隐藏指示器
        [SVProgressHUD dismiss];
        
        self.categories = [BSRecommendCategory mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        //刷新表格
        [self.categoryTableView reloadData];
        [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        [self.userTableView.mj_header beginRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        [[BSNetState shareInstance] checkNetworkState];
        //显示失败信息
        [self setNoticeWord];

    }];
}

- (void)refreshData:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    if (![userInfo[@"netType"]  isEqual: @"NotReachable"] && ![BSNetState shareInstance].hasNet) {
        if (!self.categories.count) {
            [self loadCategoryData];
        }else {
            [self loadNewUsers];
        }
    }
}

/**
 * 控件初始化
 */
- (void)setupTableViews
{
    [self.categoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSRecommendCategoryCell class]) bundle:nil] forCellReuseIdentifier:BSCategoryCellId];
    [self.userTableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSRecommendUserCell class]) bundle:nil] forCellReuseIdentifier:BSUserCellId];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.categoryTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.userTableView.contentInset = self.categoryTableView.contentInset;
    self.userTableView.rowHeight = 70;
    
    self.title = @"推荐关注";
    
    //设置背景色
    self.view.backgroundColor = BSGlobalBg;
    
}

- (void)setRefresh
{
    self.userTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUsers)];
    self.userTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];
    self.userTableView.mj_footer.hidden = YES;
}

/**
 * 下拉刷新
 */
- (void)loadNewUsers
{
    BSRecommendCategory *category = BSRecommendSelectedCategory;
    category.currentPage = 1;
    //发送请求给服务器，请求数据
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = [NSNumber numberWithInteger:category.categoryId];
    params[@"page"] = @(category.currentPage);
    self.params = params;
    
    [self.manager GET:@"https://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //字典数组->模型数组
        NSArray *users = [BSRecommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [category.users removeAllObjects];
        //添加到当前类别对应的用户数组中
        category.total = [responseObject[@"total"] integerValue];

        category.currentPage = 1;
        [category.users addObjectsFromArray:users];
        
        if (self.params != params)  return;
        
        //刷新右边列表数据
        [self.userTableView reloadData];
        
        //结束刷新状态
        [self.userTableView.mj_header endRefreshing];
        
        [self checkFooterState];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.params != params)  return;
        
        [self setNoticeWord];
    }];

}

/**
 * 上拉加载更多
 */
- (void)loadMoreUsers
{
     BSRecommendCategory *category = BSRecommendSelectedCategory;
    //发送请求给服务器，请求数据
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(category.categoryId);
    params[@"page"] = @(++category.currentPage);
    self.params = params;
    
    [self.manager GET:@"https://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //字典数组->模型数组
        NSArray *users = [BSRecommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        //添加到当前类别对应的用户数组中
        [category.users addObjectsFromArray:users];
        
        //不是最后一次请求，不刷新数据
        if (self.params != params) return;
        
        //刷新右边列表数据
        [self.userTableView reloadData];
        
        [self checkFooterState];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //不是最后一次请求，不刷新数据
        if (self.params != params) return;
        
        [self setNoticeWord];
    }];
}

/**
 * 检查下拉刷新时footer的状态
 */
- (void)setNoticeWord
{
    if ([[BSNetState shareInstance].networkDescription isEqualToString:@"NotReachable"]) {
        [SVProgressHUD showErrorWithStatus:@"请检查您的网络"];
    }else {
        //提醒
        [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
    }
    //结束刷新状态
    [self.userTableView.mj_header endRefreshing];
    [self checkFooterState];

}

/**
 * 检查下拉刷新时footer的状态
 */
- (void)checkFooterState
{
    BSRecommendCategory *category = BSRecommendSelectedCategory;
    NSInteger count = category.users.count;
    self.userTableView.mj_footer.hidden = (count == 0);

    if (category.total == count) {
        [self.userTableView.mj_footer endRefreshingWithNoMoreData];
    }else {
        [self.userTableView.mj_footer endRefreshing];
    }
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.categoryTableView) {
        return self.categories.count;
    }else {
  
        [self checkFooterState];
        
        return [BSRecommendSelectedCategory users].count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.categoryTableView) {  //左边的类别列表
        BSRecommendCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:BSCategoryCellId] ;
        cell.category = self.categories[indexPath.row];
        return cell;
    }else {  //右边边的用户列表
        BSRecommendUserCell *cell = [tableView dequeueReusableCellWithIdentifier:BSUserCellId];
        BSRecommendCategory *category = BSRecommendSelectedCategory;
        cell.user = category.users[indexPath.row];

        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.categoryTableView) {
        [self.userTableView.mj_header endRefreshing];
        [self.userTableView.mj_footer endRefreshing];
        
        BSRecommendCategory *category = self.categories[indexPath.row];
        
        if (category.users.count) {
            [self.userTableView reloadData];
        }else {
            [self.userTableView reloadData];
            
            [self.userTableView.mj_header beginRefreshing];
        }
    }
}

/**
 * 控制器销毁后停掉所有网络请求，以防程序崩溃
 */
- (void)dealloc
{
    [self.manager.operationQueue cancelAllOperations];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
    [super viewWillDisappear:animated];

}

@end
