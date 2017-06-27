
//
//  BSEssenceViewController.m
//  百思不得姐
//
//  Created by mac on 2017/4/8.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSEssenceViewController.h"
#import "BSRecommendTagsController.h"
#import "BSTopicViewController.h"
#import "BSAdvertiseViewController.h"

@interface BSEssenceViewController ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIView *inspectorView;

@property (nonatomic, strong) UIButton *selectedButton;

@property (nonatomic, weak) UIView *titleView;
/**中间内容*/
@property (nonatomic, weak) UIScrollView *contentView;

@end

@implementation BSEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = BSGlobalBg;
    
    [self registerNotifications];
    [self setupNav];
    [self setupClidVcs];
    [self setTitleView];
    [self setContentView];
}

- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToAd) name:@"pushToAdNotification" object:nil];
}

- (void) pushToAd
{
    BSAdvertiseViewController *adVc = [[BSAdvertiseViewController alloc] init];
    [self.navigationController pushViewController:adVc animated:YES];
}


- (void)setupClidVcs
{
    BSTopicViewController *all = [[BSTopicViewController alloc] init];
    all.title = @"全部";
    all.type = BSTopicTypeAll;
    [self addChildViewController:all];
    
    BSTopicViewController *video = [[BSTopicViewController alloc] init];
    video.title = @"视频";
    video.type = BSTopicTypeVideo;
    [self addChildViewController:video];
    
    BSTopicViewController *voice = [[BSTopicViewController alloc] init];
    voice.title = @"声音";
    voice.type = BSTopicTypeVoice;
    [self addChildViewController:voice];
    
    BSTopicViewController *pic = [[BSTopicViewController alloc] init];
    pic.title = @"图片";
    pic.type = BSTopicTypePicture;
    [self addChildViewController:pic];
    
    BSTopicViewController *word = [[BSTopicViewController alloc] init];
    word.title = @"段子";
    word.type = BSTopicTypeWord;
    [self addChildViewController:word];
}

/**
 * 设置顶部标签栏
 */
- (void)setTitleView
{
    //title标签
    UIView *titleView = [[UIView alloc] init];
    titleView.width = self.view.width;
    titleView.y = BSTitleViewY;
    titleView.height = BSTitleViewH;
    titleView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [self.view addSubview:titleView];
    self.titleView = titleView;
    
    //底部的指示器
    UIView *inspectorView = [[UIView alloc] init];
    inspectorView.height = 2;
    inspectorView.x = 0.f;
    inspectorView.y = titleView.height - inspectorView.height;
    inspectorView.backgroundColor = [UIColor redColor];
    self.inspectorView = inspectorView;
    
    //内部的子标签
//    NSArray *titleArr = @[@"全部",@"视频",@"声音", @"图片", @"段子"];
    CGFloat width = self.view.width/self.childViewControllers.count;
    CGFloat height = titleView.height;
    for (int i = 0; i < self.childViewControllers.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:self.childViewControllers[i].title forState:UIControlStateNormal];
//        [button layoutIfNeeded];   //强制布局（强制更新子控件的frame）
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.x = i*width;
        button.width = width;
        button.height = height;
        button.tag = i;
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:button];
        if (i == 0) {
            button.enabled = NO;
            self.selectedButton = button;

            [button.titleLabel sizeToFit];
            self.inspectorView.width = button.titleLabel.width;
//            self.inspectorView.width = [titleArr[i] sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}].width;
            self.inspectorView.centerX = button.centerX;

        }
    }
    
    [titleView addSubview:inspectorView];
}

//中间的控制器部分
- (void)setContentView
{
    //不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contenView = [[UIScrollView alloc] init];
    contenView.delegate = self;
    contenView.backgroundColor = BSGlobalBg;
    contenView.frame = self.view.bounds;
//    //设置内边距
//    CGFloat top = CGRectGetMaxY(self.titleView.frame);
//    CGFloat bottom = self.tabBarController.tabBar.height;
//    contenView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
//    contenView.delegate = self;
    
    [self.view insertSubview:contenView atIndex:0];
    //scrollView水平滚动，里面的tableView上下滚动
    contenView.contentSize = CGSizeMake(contenView.width * self.childViewControllers.count, 0);
    contenView.pagingEnabled = YES;   //分页
    self.contentView = contenView;
    
    //添加第一个控制器
    [self scrollViewDidEndScrollingAnimation:contenView];
}

- (void)titleClick:(UIButton *)button
{
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    
    //动画
    [UIView animateWithDuration:0.5 animations:^{
        self.inspectorView.width = button.titleLabel.width;
        self.inspectorView.centerX = button.centerX;
    }];
    
    //滚动
    CGPoint offset = self.contentView.contentOffset;
    offset.x = button.tag * self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
}

/**
 * 设置导航栏
 */
- (void)setupNav
{
    //设置导航栏标题
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    //设置导航栏左边图片按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
}

- (void)tagClick
{
    BSRecommendTagsController *tagsVc = [[BSRecommendTagsController alloc] init];
    [self.navigationController pushViewController:tagsVc animated:YES];
}

#pragma mark -<UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //动画完成后添加子控制器的view
    
    //当前索引
    NSInteger index = scrollView.contentOffset.x/scrollView.width;
    
    //取出子控制器
    UIViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0;   //控制器的默认y值是20
    //设置控制器view的height值为整个屏幕的高度（默认比屏幕高度少20）
    vc.view.height = scrollView.height;
    [scrollView addSubview:vc.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    NSInteger index = scrollView.contentOffset.x/scrollView.width;
    //点击按钮
    [self titleClick:self.titleView.subviews[index]];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
