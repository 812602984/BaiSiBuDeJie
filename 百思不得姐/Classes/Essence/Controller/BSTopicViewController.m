
//
//  BSTopicViewController.m
//  百思不得姐
//
//  Created by mac on 2017/4/12.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSTopicViewController.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import "BSTopic.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import "BSTopicCell.h"
#import <QuartzCore/QuartzCore.h>
#import "BSCommentViewController.h"
#import "BSNewViewController.h"

#define BSTopicCellId  @"topicCell"

@interface BSTopicViewController ()

/** 帖子数据 */
@property (nonatomic, strong) NSMutableArray *topics;

@property (nonatomic) NSInteger currentPage;

@property (nonatomic, copy) NSString *maxtime;

@property (nonatomic, strong) NSDictionary *params;

@property (nonatomic, copy) NSString *a;

/** 是否正在下拉刷新数据 */
@property (nonatomic,getter=isHeaderRefresh) BOOL headerRefresh;

/** 是否正在上拉加载数据 */
@property (nonatomic,getter=isFootererRefresh) BOOL footerRefresh;


//@property (nonatomic, strong) UIImageView *barImageView;

@end

@implementation BSTopicViewController

- (NSMutableArray *)topics
{
    if (!_topics) {
        _topics = [NSMutableArray array];
    }
    return _topics;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化表格
    [self setupTableView];
    
    [self setRefresh];
    
    //接收网络状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:)  name:BSNetworkStateNotification object:nil];
}

- (void)refreshData:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    if (![userInfo[@"netType"]  isEqual: @"NotReachable"] && ![BSNetState shareInstance].hasNet) {
        if (!self.topics.count) {
            [self setRefresh];
        }
    }
    if ([userInfo[@"netType"] isEqualToString:@"NotReachable"]) {
        [SVProgressHUD showErrorWithStatus:@"您的网络开小差了💔"];
    }
}

- (void)setupTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSTopicCell class]) bundle:nil] forCellReuseIdentifier:BSTopicCellId];

    CGFloat top = BSTitleViewY + BSTitleViewH;
    CGFloat bottom = self.tabBarController.tabBar.height;
    
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;  //设置滚动条的inset
    
    //去掉tableView自带的分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)setRefresh
{
    self.headerRefresh = self.footerRefresh = NO;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    //自动改变透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

//参数a，新帖的a为newlist
- (NSString *)a
{
    return [self.parentViewController isKindOfClass:[BSNewViewController class]]?@"newlist":@"list";
}

#pragma mark - 数据处理
/**
 * 上拉加载更多数据
 */
- (void)loadMoreData
{
    if (self.isHeaderRefresh)  return;
    
    self.footerRefresh = YES;
    
    //结束下拉
    [self.tableView.mj_header endRefreshing];
    
    self.currentPage++;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
    params[@"a"] = self.a;
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    params[@"page"] = @(self.currentPage);
    params[@"maxtime"] = self.maxtime;
    self.params = params;
    
    [[AFHTTPSessionManager manager] GET:@"https://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
        if (self.params != params) return;
        //存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        NSArray *newTopics = [BSTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.topics addObjectsFromArray:newTopics];
        [self.tableView reloadData];
        
        [self.tableView.mj_footer endRefreshing];
        self.footerRefresh = NO;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.params != params) return;
        
        [self.tableView.mj_footer endRefreshing];
        self.currentPage--;
        
        if(![BSNetState shareInstance].hasNet) {
            [SVProgressHUD showErrorWithStatus:@"您的网络开小差了💔"];
        }
        self.footerRefresh = NO;
    }];
}

/**
 * 下拉刷新数据
 */
- (void)loadNewTopics
{
    if (self.isFootererRefresh) return;
    
    self.headerRefresh = YES;
    
    //结束上拉
    [self.tableView.mj_footer endRefreshing];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
    params[@"a"] = self.a;
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    self.params = params;
    
    [[AFHTTPSessionManager manager] GET:@"https://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
        if (self.params != params) return;
        
        //存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        self.topics = [BSTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        //清空页码
        self.currentPage = 0;
        self.headerRefresh = NO;

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        BSLog(@"%@",error.description);
        if (self.params != params) return;
        [[BSNetState shareInstance] checkNetworkState];

        [self.tableView.mj_header endRefreshing];
        self.headerRefresh = NO;
    }];
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tableView.mj_footer.hidden = (self.topics.count == 0);
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BSTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:BSTopicCellId];
    BSTopic *topic = self.topics[indexPath.row];
    cell.topic = topic;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取出帖子模型
    BSTopic *topic = self.topics[indexPath.row];

    //返回模型对应的cell高度
    return topic.cellHeight;
}

//选中cell跳转至评论页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSTopic *topic = self.topics[indexPath.row];
    BSCommentViewController *commentVc = [[BSCommentViewController alloc] init];
    commentVc.topic = topic;
    [self.navigationController pushViewController:commentVc animated:YES];
}

//scrollView结束滚动时清除内存缓存，防止内存过高
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
