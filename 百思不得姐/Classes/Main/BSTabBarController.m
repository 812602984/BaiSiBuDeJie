//
//  BSTabBarController.m
//  百思不得姐
//
//  Created by mac on 2017/4/7.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSTabBarController.h"
#import "BSEssenceViewController.h"
#import "BSNewViewController.h"
#import "BSFriendTrendsViewController.h"
#import "BSMeViewController.h"
#import "BSTabBar.h"
#import "BSNavigationController.h"
#import <MJRefresh.h>

@interface BSTabBarController ()

@property (nonatomic, assign) NSInteger lastSelectedIndex;

@end

@implementation BSTabBarController

+ (void)initialize
{
    NSMutableDictionary *textArrs = [NSMutableDictionary dictionaryWithCapacity:2];
    textArrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    textArrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedTextArrs = [NSMutableDictionary dictionaryWithCapacity:2];
    selectedTextArrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    
    /***
     *某个类的方法后面有 UI_APPEARANCE_SELECTOR 这个宏的话，可以获取类对象的appearance来统一设置
     *通过appearance统一设置所以UITabBarItem的文字属性
     */
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:textArrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedTextArrs forState:UIControlStateSelected];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didClickTabBar:) name:@"BSDidSelectedTabBarNotification" object:nil];
    
    [self addChildVc:[[BSEssenceViewController alloc] init] title:@"精华" image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon"];
    
    //ios 7和之前会将tabBarItem选中的图片渲染成蓝色，处理如下：
    //     vc01.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabBar_essence_click_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [self addChildVc:[[BSNewViewController alloc] init] title:@"新帖" image:@"tabBar_new_icon" selectedImage:@"tabBar_new_click_icon"];
    
    [self addChildVc:[[BSFriendTrendsViewController alloc] init] title:@"关注" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];
    
    [self addChildVc:[[BSMeViewController alloc] initWithStyle:UITableViewStyleGrouped] title:@"我" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];
    
//    self.tabBar = [[BSTabBar alloc] init];   //tabBar为只读属性，可以kvc赋值
    
    [self setValue:[[BSTabBar alloc] init] forKey:@"tabBar"];
//    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
}

- (void)didClickTabBar:(NSNotification *)notification
{
    NSArray *vcArr = [self.childViewControllers[self.selectedIndex].childViewControllers firstObject].childViewControllers;
    if (self.selectedIndex == self.lastSelectedIndex) {
        for (UIViewController *vc in vcArr) {
            if ([vc.view isShowingOnKeyWindow] && [vc isKindOfClass:[UITableViewController class]]) {
                UITableViewController *tab = (UITableViewController *)vc;
                [tab.tableView.mj_header beginRefreshing];
            }
        }
    }
    self.lastSelectedIndex = self.selectedIndex;
}

/**
  * 初始化子控制器
 */
-(void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    childVc.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    BSNavigationController *nav = [[BSNavigationController alloc] initWithRootViewController:childVc];
    
    [self addChildViewController:nav];
}

@end
