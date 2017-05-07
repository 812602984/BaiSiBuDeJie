
//
//  UIImage+BSExtension.m
//  百思不得姐
//
//  Created by mac on 2017/5/1.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "UIImage+BSExtension.h"

@implementation UIImage (BSExtension)

- (UIImage *)circleImage
{
    //开启图形上下文,透明，否则裁剪的圆形图片四个角是黑色
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    //获取当前图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //在矩形中添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    
    //裁剪
    CGContextClip(ctx);
    
    //把圆形图片画上去
    [self drawInRect:rect];
    
    //获取矩形中圆形图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    //结束图形上下文
    UIGraphicsEndImageContext();
    
    return image;
}

@end
