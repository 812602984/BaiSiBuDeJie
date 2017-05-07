//
//  BSCommentViewController.m
//  百思不得姐
//
//  Created by mac on 2017/4/21.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSCommentViewController.h"
#import "BSTopicCell.h"
#import "BSTopic.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "BSComment.h"
#import "BSHeaderView.h"
#import "BSCommentHeaderView.h"
#import "BSCommentCell.h"
#import <MJRefresh.h>

@interface BSCommentViewController ()<UITableViewDelegate,UITableViewDataSource>
//底部评论条距离屏幕下方距离的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//最热评论
@property (nonatomic, strong) NSArray *hotComments;

//最新评论
@property (nonatomic, strong) NSMutableArray *latestComments;

@property (nonatomic, strong) NSArray *saved_top_cmt;

//当前页码
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

static NSString *BSCommentCellId = @"commentCell";

@implementation BSCommentViewController

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [[AFHTTPSessionManager alloc] init];
    }
    return _manager;
}

- (NSMutableArray *)latestComments
{
    if (!_latestComments) {
        _latestComments = [[NSMutableArray alloc] init];
    }
    return _latestComments;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setConfig];
    
    [self setupHeader];
    
    [self setRefresh];

}

- (void)setRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
    self.tableView.mj_footer.hidden = YES;
}

- (void)setConfig
{
    self.title = @"评论";
    
    //设置cell的高度自动计算（ios 8以后可用）
    self.tableView.estimatedRowHeight = 44;
    self.tableView.autoresizingMask = UITableViewAutomaticDimension;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"comment_nav_item_share_icon" highImage:@"comment_nav_item_share_icon_click" target:self action:nil];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSCommentCell class]) bundle:nil] forCellReuseIdentifier:BSCommentCellId];
    
    //去掉tableview自带的分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, BSTopicCellMargin, 0);
}

- (void)loadMoreComments
{
    //取消之前的请求任务，会走failure方法
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    NSInteger page = self.currentPage + 1;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.topic_id;
    BSComment *comment = [self.latestComments lastObject];
    params[@"lastcid"] = comment.comment_id;
    
    params[@"page"] = @(page);
    
    __weak typeof(self) weakSelf = self;
    [self.manager GET:@"https://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //BSLog(@"%@",[responseObject class]);
        
        //如果服务器返回的数据不是一个字典,直接返回(解决空评论导致的报错)
        //[weakSelf checkDataType:responseObject];

        if(![responseObject isKindOfClass:[NSDictionary class]]){
            self.tableView.mj_header.hidden = YES;
            self.tableView.mj_footer.hidden = YES;
            return;
        }

        //        [(NSArray *)responseObject[@"data"] writeToFile:@"/Users/mac/Desktop/data.plist" atomically:YES];
        //        [(NSArray *)responseObject[@"hot"] writeToFile:@"/Users/mac/Desktop/hot.plist" atomically:YES];
        weakSelf.hotComments = [BSComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        
        //最新评论
        NSArray *newComments = [BSComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [weakSelf.latestComments addObjectsFromArray:newComments];
        
        //成功了增加页码
        weakSelf.currentPage = page;
        
        [weakSelf.tableView reloadData];
        
        NSInteger total = [responseObject[@"total"] integerValue];
        if (weakSelf.latestComments.count >= total) {  //隐藏刷新
            weakSelf.tableView.mj_footer.hidden = YES;
        }else {   //结束刷新
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        
        //[weakSelf.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];

}

- (void)loadNewComments
{
    //取消之前的请求任务
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.topic_id;
    params[@"hot"] = @"1";
    
    __weak typeof(self) weakSelf = self;
    [self.manager GET:@"https://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //[weakSelf checkDataType:responseObject];
        
        if(![responseObject isKindOfClass:[NSDictionary class]] || !responseObject){
            if (self.tableView.mj_header.isRefreshing) {
                [self.tableView.mj_header endRefreshing];
            }
            self.tableView.mj_header.hidden = YES;
            self.tableView.mj_footer.hidden = YES;
            return;
        }
        
//        [(NSArray *)responseObject[@"data"] writeToFile:@"/Users/mac/Desktop/data.plist" atomically:YES];
//        [(NSArray *)responseObject[@"hot"] writeToFile:@"/Users/mac/Desktop/hot.plist" atomically:YES];
        weakSelf.hotComments = [BSComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        weakSelf.latestComments = [BSComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        weakSelf.currentPage = 1;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];

        NSInteger total = [responseObject[@"total"] integerValue];
        if (weakSelf.latestComments.count >= total) {  //隐藏刷新
            weakSelf.tableView.mj_footer.hidden = YES;
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

//检查数据类型，如果返回的为数组，直接返回
- (void)checkDataType:(id _Nullable)response
{
    if(![response isKindOfClass:[NSDictionary class]] && response != nil){
        self.tableView.mj_header.hidden = YES;
        self.tableView.mj_footer.hidden = YES;
        return;
    }
}

- (void)setupHeader
{
    UIView *headerView = [[UIView alloc] init];
    
    if (self.topic.top_cmt.count) {
        self.topic.top_cmt = nil;
        [self.topic setValue:@0 forKeyPath:@"_cellHeight"];
    }
    
    BSTopicCell *cell = [BSTopicCell topicCell];
    cell.topic = self.topic;

    CGFloat height = self.topic.cellHeight;
    cell.frame = CGRectMake(0, 0, BSScreenW, height);
    
     //让cell的宽度=headerView的宽度，并且以后cell的width也跟随headerView的宽度变化
//    cell.width = headerView.width;
//    cell.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [headerView addSubview:cell];
    headerView.frame = CGRectMake(0, 0, BSScreenW, height+5);
    
    self.tableView.tableHeaderView = headerView;
    
}

- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    //键盘显示／隐藏完毕的frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //修改底部约束
    self.bottomSpace.constant = BSScreenH - frame.origin.y;
    //动画时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey]  doubleValue];
    //动画,刚刚改了约束，马上强制布局一下
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}

#pragma mark - UITableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if (self.hotComments.count) {
//        return 2;
//    }
//    return 1;
    self.tableView.mj_footer.hidden = self.latestComments.count == 0;
    return self.hotComments.count?2:1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.hotComments.count? self.hotComments.count:self.latestComments.count;
    }
//    if (self.hotComments.count) {
//        if (section == 0) {
//            return self.hotComments.count;
//        }else {
//            return self.latestComments.count;
//        }
//    }
    return self.latestComments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:BSCommentCellId];
    
//    BSComment *comment = nil;
//    if(indexPath.section == 0){
//        if (self.hotComments.count) {
//            comment = self.hotComments[indexPath.row];
//        }else {
//            comment = self.latestComments[indexPath.row];
//        }
//    }else{
//        comment = self.latestComments[indexPath.row];
//    }
    
    BSComment *comment = [self commentAtIndexPath:indexPath];

    cell.comment = comment;
    return cell;
}

/*
 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
 {
 if (section == 0) {
 return self.hotComments.count? @"最热评论" : @"最新评论";
 }
 
 //    if (self.hotComments.count) {
 //        if (section == 0) {
 //            return @"最热评论";
 //        }else {
 //            return @"最新评论";
 //        }
 //    }
 
 return @"最新评论";
 }
 */


/* 不复用的headerView
 - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
 {
 //    BSHeaderView *view = [BSHeaderView headerView];
 
 UIView *header = [[UIView alloc] init];
 header.backgroundColor = BSGlobalBg;
 UILabel *label = [[UILabel alloc] init];
 label.textColor = BSRGBColor(67, 67, 67);
 label.width = 200;
 label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
 label.x = 10;
 [header addSubview:label];
 
 if (section == 0) {
 label.text = self.hotComments.count?@"最热评论" : @"最新评论";
 }else{
 label.text = @"最新评论";
 }
 return header;
 }
 */

/*复用的headerView--01
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerId = @"header";
    UIView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];
    UILabel *label = nil;
    if (header == nil) {
        
        header = [[UIView alloc] init];
        header.backgroundColor = BSGlobalBg;
        label = [[UILabel alloc] init];
        label.textColor = BSRGBColor(67, 67, 67);
        label.width = 200;
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        label.x = 10;
        label.tag = 110;
        [header addSubview:label];
    }
    label = [header viewWithTag:110];
    
    if (section == 0) {
        label.text = self.hotComments.count?@"最热评论" : @"最新评论";
    }else {
        label.text = @"最新评论";
    }
    
    return header;
}
*/

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    BSCommentHeaderView *header = [BSCommentHeaderView headerViewWithTableView:tableView];
   
    if (section == 0) {
        header.title = self.hotComments.count? @"最热评论" : @"最新评论";
    }else {
        header.title = @"最新评论";
    }
    
    return header;
}

//选中以后出现UIMenuController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
    }else{
        BSCommentCell *cell = (BSCommentCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell becomeFirstResponder];
        
        CGRect rect = CGRectMake(0, cell.height * 0.5, cell.width, cell.height*0.5);
        [menu setTargetRect:rect inView:cell];
        UIMenuItem *ding = [[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(ding:)];
        UIMenuItem *replay = [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(replay:)];
        UIMenuItem *cai = [[UIMenuItem alloc] initWithTitle:@"踩" action:@selector(cai:)];
        menu.menuItems = @[ding,replay,cai];
        [menu setMenuVisible:YES animated:YES];
    }
}

- (void)ding:(UIMenuController *)menu
{
    BSLogFunc;
    
    //获取选中行
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    BSComment *comment = [self commentAtIndexPath:indexPath];
    
    BSLog(@"%zd--%zd--%@",indexPath.section,indexPath.row,comment.content);
}

- (void)replay:(UIMenuController *)menu
{
    BSLogFunc;
    
}

- (void)cai:(UIMenuController *)menu
{
    BSLogFunc;
}

//此方法不写将不会调用上面的tableView:viewForHeaderInSection:方法
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.hotComments.count || self.latestComments.count) {
        return 30;
    }
    return 0;
}

//返回对应section的所有评论数组
- (NSArray *)commentsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.hotComments.count? self.hotComments:self.latestComments;
    }
    return self.latestComments;
}

- (BSComment *)commentAtIndexPath:(NSIndexPath *)indexPath
{
    return [self commentsInSection:indexPath.section][indexPath.row];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //恢复帖子的top_cmt
    if (self.saved_top_cmt.count) {
        self.topic.top_cmt = self.saved_top_cmt;
        [self.topic setValue:@0 forKeyPath:@"_cellHeight"];  //清0，让重新算一遍
    }
    
    //整个session无效
    [self.manager invalidateSessionCancelingTasks:YES];
}

@end
