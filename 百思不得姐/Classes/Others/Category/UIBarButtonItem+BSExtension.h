//
//  UIBarButtonItem+BSExtension.h
//  百思不得姐
//
//  Created by mac on 2017/4/8.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (BSExtension)

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

@end
