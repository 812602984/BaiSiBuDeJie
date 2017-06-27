//
//  BSPublishViewController.m
//  百思不得姐
//
//  Created by mac on 2017/4/15.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSPublishViewController.h"
#import "BSVerticalButton.h"
#import <POP.h>

static CGFloat const BSAnimationDelay = 0.1;
static CGFloat const BSAnimationIntension = 7;

@interface BSPublishViewController ()

@end

@implementation BSPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.userInteractionEnabled = NO;

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
        [self.view addSubview:button];
        
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
    [self.view addSubview:sloganView];
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
        self.view.userInteractionEnabled = YES;
    }];
    [sloganView pop_addAnimation:animation forKey:@"sloganViewIn"];
    
}

- (IBAction)cancel
{
    [self cancelWithCompletionBlock:nil];
}

- (void)cancelWithCompletionBlock:(void (^)())completionBlock
{
    int beginIndex = 2;
    for (int i = 2; i < self.view.subviews.count; i++) {
        UIView *view = self.view.subviews[i];
        
        //基本动画
        POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        CGFloat centerY = view.centerY + BSScreenH;
        //动画的执行节奏，一开始很慢，后面快
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(view.centerX, centerY)];
        animation.beginTime = CACurrentMediaTime() + BSAnimationDelay * (i - beginIndex);
        [view pop_addAnimation:animation forKey:@"out"];
        
        //监听最后一个动画
        if (i == self.view.subviews.count - 1) {
            [animation setCompletionBlock:^(POPAnimation *anim, BOOL finished){
                [self dismissViewControllerAnimated:NO completion:nil];
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
    [self cancelWithCompletionBlock:^{ //发段子
        if (button.tag == 2) {
            BSLog(@"%@",button.currentTitle);
        }
    }];
}

//点击控制器其他部分的话执行动画后控制器也消失
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self cancelWithCompletionBlock:nil];
}

-(void)dealloc
{
    
}

@end
