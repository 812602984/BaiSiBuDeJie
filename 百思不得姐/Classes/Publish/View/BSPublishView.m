//
//  BSPublishView.m
//  百思不得姐
//
//  Created by mac on 2017/4/16.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSPublishView.h"
#import "BSVerticalButton.h"
#import <POP.h>
#import "BSPostWordViewController.h"
#import "BSNavigationController.h"

static CGFloat const BSAnimationDelay = 0.1;
static CGFloat const BSAnimationIntension = 7;

#define BSRootView [UIApplication sharedApplication].keyWindow.rootViewController.view


@implementation BSPublishView

/***
    半透明视图不能点，点击事件会穿透到后面的控制器view
 */


+ (instancetype)publishView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

static UIWindow *window_;
+ (void)show
{
    window_ = [[UIWindow alloc] init];
    window_.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    window_.frame = [UIScreen mainScreen].bounds;
    window_.hidden = NO;
    
    BSPublishView *publishView = [BSPublishView publishView];
    publishView.frame = window_.bounds;
    [window_ addSubview:publishView];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //刚进来的时候有动画，动画过程中窗口不可点击,但是根窗口不能用户交互的话系统会发出警告。所以建议把后面的控制器的用户交互设置为No比较合理
//    BSRootView.userInteractionEnabled = NO;
    self.userInteractionEnabled = NO;    //自己也不可以点
    
    //中间6个按钮
    NSArray *titleArr = @[@"发视频",@"发图片",@"发段子",@"发声音",@"审帖",@"离线下载",];
    NSArray *imageArr = @[@"publish-video",@"publish-picture",@"publish-text",@"publish-audio",@"publish-review",@"publish-offline"];
    
    int maxCol = 3;
    CGFloat buttonW = 72;
    CGFloat buttonH = buttonW + 30;
    CGFloat buttonStartX = 20;
    CGFloat buttonStartY = (BSScreenH - 2 * buttonH) * 0.5;
    CGFloat xMargin = (BSScreenW - 2 * buttonStartX - maxCol * buttonW) / (maxCol - 1);
    
    for (int i = 0; i < 6; i++) {
        BSVerticalButton *button = [BSVerticalButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        button.tag = i;
        
        int row = i / maxCol;
        int col = i % maxCol;
        //        button.width = buttonW;
        //        button.height = buttonH;
        CGFloat buttonX = buttonStartX + col * (buttonW +  xMargin);
        CGFloat buttonEndY = buttonStartY + row * buttonH;
        CGFloat buttonBeginY = buttonEndY - BSScreenH;
        
        //按钮动画
        POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        animation.springBounciness = BSAnimationIntension;
        animation.springSpeed = BSAnimationIntension;
        animation.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonBeginY, buttonW, buttonH)];
        animation.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonEndY, buttonW, buttonH)];
        animation.beginTime = CACurrentMediaTime() + BSAnimationDelay * i;
        [button pop_addAnimation:animation forKey:@"buttonIn"];
    }
    
    //标语
    UIImageView *sloganView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    [self addSubview:sloganView];
    sloganView.y = -50;
    //标语动画
    CGFloat sloganViewEndY = BSScreenH * 0.2;
    CGFloat centerX = BSScreenW * 0.5;
    //    CGFloat sloganViewBeginY = sloganViewEndY - BSScreenH;
    
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(centerX, sloganView.y)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, sloganViewEndY)];
    animation.springBounciness = BSAnimationIntension;
    animation.springSpeed = BSAnimationIntension;
    animation.beginTime = CACurrentMediaTime() + BSAnimationDelay * imageArr.count;
    [animation setCompletionBlock:^(POPAnimation *anim, BOOL finished){
        //动画完成后窗口可点击
//        BSRootView.userInteractionEnabled = YES;
        self.userInteractionEnabled = YES;
    }];
    [sloganView pop_addAnimation:animation forKey:@"sloganViewIn"];
    
}

- (IBAction)cancel
{
    [self cancelWithCompletionBlock:nil];
}

- (void)cancelWithCompletionBlock:(void (^)())completionBlock
{
    //动画过程中窗口不可点击
//    BSRootView.userInteractionEnabled = NO;
    self.userInteractionEnabled = NO;
    
    int beginIndex = 1;
    for (int i = beginIndex; i < self.subviews.count; i++) {
        UIView *view = self.subviews[i];
        
        //基本动画
        POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        CGFloat centerY = view.centerY + BSScreenH;
        //动画的执行节奏，一开始很慢，后面快
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(view.centerX, centerY)];
        animation.beginTime = CACurrentMediaTime() + BSAnimationDelay * (i - beginIndex);
        [view pop_addAnimation:animation forKey:@"out"];
        
        //监听最后一个动画
        if (i == self.subviews.count - 1) {
            [animation setCompletionBlock:^(POPAnimation *anim, BOOL finished){
                //动画完成后窗口可点击
//                BSRootView.userInteractionEnabled = YES;
                self.userInteractionEnabled = YES;

//                [self removeFromSuperview];
                window_ = nil;
                
                /**方法3用到的
                if (self.myBlock) {
                    self.myBlock();
                }
                 */
                
                if (completionBlock) {
                    completionBlock();
                }
                
                //                !completionBlock?:completionBlock();
            }];
        }
    }
    
}

- (void)buttonClick:(BSVerticalButton *)button
{
    [self cancelWithCompletionBlock:^{
        if (button.tag == 2) {  //发段子
            UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
            BSPostWordViewController *post = [[BSPostWordViewController alloc] init];
            post.title = @"发表文字";
            BSNavigationController *nav = [[BSNavigationController alloc] initWithRootViewController:post];
            [root presentViewController:nav animated:YES completion:nil];
        }
    }];
}

//点击控制器其他部分的话执行动画后控制器也消失
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self cancelWithCompletionBlock:nil];
}

@end
