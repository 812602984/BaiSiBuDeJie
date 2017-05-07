//
//  BSRecommendTagsController.m
//  百思不得姐
//
//  Created by mac on 2017/4/10.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSRecommendTagsController.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import "BSRecommendTagsCell.h"
#import <MJExtension.h>
#import "BSRecommendTag.h"
#import "BSNetState.h"
#import <MJRefresh.h>

@interface BSRecommendTagsController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *tagsArr;

@end

@implementation BSRecommendTagsController

static NSString *const BSRecommendTagsCellId = @"tagCell";

- (NSMutableArray *)tagsArr
{
    if (!_tagsArr) {
        _tagsArr = [NSMutableArray array];
    }
    return _tagsArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"推荐标签";
    
    [[BSNetState shareInstance] checkNetworkState];
    //接收网络状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:)  name:BSNetworkStateNotification object:nil];
    
    [self setUpTableView];

    [self loadData];
}

- (void)refreshData:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    if (![userInfo[@"netType"]  isEqual: @"NotReachable"] && ![BSNetState shareInstance].hasNet) {
        [self.tableView.mj_header beginRefreshing];
    }
}

/**
 * 初始化tableView
 */
- (void)setUpTableView
{
    self.tableView.backgroundColor = BSGlobalBg;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSRecommendTagsCell class]) bundle:nil] forCellReuseIdentifier:BSRecommendTagsCellId];
    self.tableView.rowHeight = 70;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
//    [header setImages:idleImages forState:MJRefreshStateIdle];
//    [header setImages:pullingImages forState:MJRefreshStatePulling];
//    [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
//    self.tableView.mj_header = header;
}

/**
 * 加载数据
 */
- (void)loadData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:4];
    params[@"a"] = @"tag_recommend";
    params[@"c"] = @"topic";
    params[@"action"] = @"sub";
    
    [SVProgressHUD showInfoWithStatus:@"正在加载数据～"];
    [[AFHTTPSessionManager manager] GET:@"https://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        BSLog(@"%@",responseObject);
        NSArray *tagsArr = [BSRecommendTag mj_objectArrayWithKeyValuesArray:responseObject];
        [self.tagsArr removeAllObjects];
        [self.tagsArr addObjectsFromArray:tagsArr];
        
        //刷新表格数据
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载标签数据失败！"];
        [self.tableView.mj_header endRefreshing];
    }];

}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.tagsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSRecommendTagsCell *cell = [tableView dequeueReusableCellWithIdentifier:BSRecommendTagsCellId];
    cell.recommendTag = self.tagsArr[indexPath.row];
    return cell;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
