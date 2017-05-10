//
//  BSWebviewProgressLine.m
//  百思不得姐
//
//  Created by mac on 2017/5/10.
//  Copyright © 2017年 shaowu. All rights reserved.
//

/**
 *  webView的加载进度条，模拟webView加载进度
 */

#import "BSWebviewProgressLine.h"

@implementation BSWebviewProgressLine

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.hidden = YES;
        self.lineColor = [UIColor blueColor];
    }
    return self;
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    self.backgroundColor = lineColor;
}

- (void)startLoadingAnimation
{
    self.hidden = NO;
    self.width = 0;
    self.alpha = 0;
    __weak UIView *weakSelf = self;
    [UIView animateWithDuration:0.4 animations:^{
        weakSelf.alpha = 0.6;
        weakSelf.width = BSScreenW *0.6;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            weakSelf.alpha = 0.8;
            weakSelf.width = BSScreenW * 0.8;
        }];
    }];
}

- (void)endLoadingAnimation
{
    __weak UIView *weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.width = BSScreenW;
        weakSelf.alpha = 1;
    }completion:^(BOOL finished) {
        weakSelf.hidden = YES;
    }];
}

@end
