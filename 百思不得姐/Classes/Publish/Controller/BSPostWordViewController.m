
//
//  BSPostWordViewController.m
//  百思不得姐
//
//  Created by mac on 2017/5/2.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSPostWordViewController.h"
#import "BSTextView.h"
#import "BSAddTagToolBar.h"

@interface BSPostWordViewController ()<UITextViewDelegate>

@property (nonatomic, weak) BSTextView *textView;

@property (nonatomic, weak) BSAddTagToolBar *toolbar;

@end

@implementation BSPostWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    
    [self setupTextView];
    
    [self setupToolBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardwillchangeframe:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)setupToolBar
{
    BSAddTagToolBar *toolbar = [BSAddTagToolBar toolBar];
    toolbar.width = self.view.width;
    toolbar.y = self.view.height - toolbar.height;
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardwillchangeframe:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardwillchangeframe:(NSNotification *)noti
{
    //键盘最终的frame
    CGRect keyboardF = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //动画时间
    NSTimeInterval duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.toolbar.transform = CGAffineTransformMakeTranslation(0, keyboardF.origin.y - self.view.height);
    }];
}

- (void)setupTextView
{
    BSTextView *textView = [[BSTextView alloc] initWithFrame:self.view.bounds];
    textView.delegate = self;
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
        
}

- (void)finish
{
    [self.view endEditing:YES];
}

#pragma mark - textview delegate
- (void)textViewDidChange:(UITextView *)textView
{
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)dealloc
{
    
}

@end
