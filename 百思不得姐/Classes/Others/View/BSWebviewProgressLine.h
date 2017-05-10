//
//  BSWebviewProgressLine.h
//  百思不得姐
//
//  Created by mac on 2017/5/10.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSWebviewProgressLine : UIView

//进度条颜色
@property (nonatomic, strong) UIColor *lineColor;

//开始加载
- (void)startLoadingAnimation;

//加载完成
- (void)endLoadingAnimation;

@end
