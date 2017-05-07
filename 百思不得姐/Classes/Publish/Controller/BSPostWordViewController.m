
//
//  BSPostWordViewController.m
//  百思不得姐
//
//  Created by mac on 2017/5/2.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSPostWordViewController.h"
#import "BSTextView.h"

@interface BSPostWordViewController ()

@property (nonatomic, weak) BSTextView *textView;

@end

@implementation BSPostWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    
    //textView
    BSTextView *textView = [[BSTextView alloc] initWithFrame:self.view.bounds];
    textView.placeholder = @"请输入您想要发表的内容 急哦红腹锦鸡斤斤计较斤斤计较斤斤计较斤斤计较斤斤计较斤斤计较斤斤计较斤斤计较斤斤计较斤斤计较斤斤计较会发觉会见阿富汗放假啊喝酒啊发哈哈机会";
    textView.placeholderColor = [UIColor grayColor];
    [self.view addSubview:textView];
    self.textView = textView;
}

- (void)setNav
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finish)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateDisabled];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    //利用appearance设置UIBarButtonItem的话，可能生效时间在didAppear时，可以强制刷新
    //    [self.navigationController.navigationBar layoutIfNeeded];
    
    //    dispatch_after(5, dispatch_get_main_queue(), ^{
    //        self.navigationItem.rightBarButtonItem.enabled = YES;
    //    });

}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
//    self.textView.placeholderColor = [UIColor redColor];
//    self.textView.placeholder = @"hahhahhhahau 胡椒粉的骨灰盒 ";
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.textView.text = @"你好你还会减肥的后果和分身乏术恢复宁静空间";
//    });
    
}

- (void)finish
{
    BSLog(@"%s",__func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
