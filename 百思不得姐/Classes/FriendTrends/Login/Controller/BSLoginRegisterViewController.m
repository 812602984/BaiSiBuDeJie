//
//  BSLoginRegisterViewController.m
//  百思不得姐
//
//  Created by mac on 2017/4/11.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSLoginRegisterViewController.h"
#import "BSOAuthViewController.h"

@interface BSLoginRegisterViewController ()<UITextFieldDelegate>

//登录框距离控制器view左边的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewLeftmargin;

//账号
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;

//密码
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation BSLoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
 
    [self.navigationController setNavigationBarHidden:YES];
    
    self.accountTextField.delegate = self.passwordTextField.delegate = self;
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    
    [self.passwordTextField addTarget:self action:@selector(editBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [self.passwordTextField addTarget:self action:@selector(editEnd:) forControlEvents:UIControlEventEditingDidEnd];
}

- (void)editBegin:(UITextField *)textField
{
    [textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)editEnd:(UITextField *)textField
{
    [textField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

//关闭按钮
- (IBAction)closeButtonClick:(UIButton *)sender {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
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

//第三方QQ登录
- (IBAction)tencentLogin
{
    
}

//第三方新浪微博登录
- (IBAction)sinaLogin
{
    BSOAuthViewController *OAuthVc = [[BSOAuthViewController alloc] init];
//    UITabBarController *rootVc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//    [rootVc.selectedViewController pushViewController:OAuthVc animated:YES];
    
    OAuthVc.title = @"新浪授权";
    [self.navigationController pushViewController:OAuthVc animated:YES];
    
}

////第三方微信登录
- (IBAction)weixinLogin
{
    
}

#pragma mark - textField delegate
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self resignFirstResponder];
    return NO;
}

@end
