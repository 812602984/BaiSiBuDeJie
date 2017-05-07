//
//  BSLoginRegisterViewController.m
//  百思不得姐
//
//  Created by mac on 2017/4/11.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSLoginRegisterViewController.h"

@interface BSLoginRegisterViewController ()

//登录框距离控制器view左边的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewLeftmargin;


@end

@implementation BSLoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

//关闭按钮
- (IBAction)closeButtonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//注册按钮 & 已有账号 按钮
- (IBAction)loginOrRegisterButton:(UIButton *)sender {
    [self.view endEditing:YES];
    
    sender.selected = self.loginViewLeftmargin.constant == 0;
    if (sender.selected) {
        self.loginViewLeftmargin.constant =  - self.view.width;
        [UIView animateWithDuration:0.25 animations:^{
            [self.view setNeedsLayout];
        }];

//        sender.selected = YES;
    }else {
        self.loginViewLeftmargin.constant = 0;
        [UIView animateWithDuration:0.25 animations:^{
            [self.view setNeedsLayout];
        }];

//        sender.selected = NO;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  让当前控制器的状态栏颜色为白色
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
