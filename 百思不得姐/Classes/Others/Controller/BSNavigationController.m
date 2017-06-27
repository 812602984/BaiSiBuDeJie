//
//  BSNavigationController.m
//  百思不得姐
//
//  Created by mac on 2017/4/9.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSNavigationController.h"

@interface BSNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation BSNavigationController

/**
 * 当第一次调用这个类的时候会调用一次
 */
+ (void)initialize
{
    //当导航栏用在BSNavigationController中，appearance才会生效
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:[self class], nil];
    [navBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    
    //可以对UIBarButtonItem做一些一次性设置
//    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加一个全屏滑动返回的功能
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    [self.view addGestureRecognizer:pan];
    //设置delegate，控制只有非根控制器才需要滑动返回
    pan.delegate = self;
    //禁止之前的UIEdgePanGestureRecognizer
    self.interactivePopGestureRecognizer.enabled = NO;
     
    /*解决重写返回按钮，滑动返回实效，一行代码搞定
    self.interactivePopGestureRecognizer.delegate = (id <UIGestureRecognizerDelegate>) self;
    */
    
    /*滑动返回手势失效：1.手势被清空 2.手势冲突 3.手势的代理做了一些事情（这里属于此种情况）*/
//    self.interactivePopGestureRecognizer.delegate = self;
    
    //写在这里每次push都会调用，程序启动会调用四次
//    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) { //如果push进来的不是第一个控制器
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        button.size = CGSizeMake(60, 30);
        //让按钮中所有的内容左对齐
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        [button sizeToFit];
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    //这句super的push要放在后面，让viewController可以覆盖上面设置的leftBarButtonItem，push控制器时会加载控制器的view
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

#pragma mark - UIGestureRecognizerDelegate
//决定是否出发手势
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return self.childViewControllers.count > 1;
}

- (void)dealloc
{
    
}

@end
