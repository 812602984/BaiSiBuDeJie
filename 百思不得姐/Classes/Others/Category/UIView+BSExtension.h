//
//  UIView+BSExtension.h
//  百思不得姐
//
//  Created by mac on 2017/4/8.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BSExtension)

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGSize size;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

/*在分类中声明@property，只会生成方法声明，不会生成方法的实现和带有_下划线的成员变量*/

//判断一个控件是否真正显示在主窗口上
- (BOOL)isShowingOnKeyWindow;

@end
