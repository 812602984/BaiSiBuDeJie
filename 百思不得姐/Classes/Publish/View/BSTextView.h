//
//  BSTextView.h
//  百思不得姐
//
//  Created by mac on 2017/5/2.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSTextView : UITextView

//占位文字
@property (nonatomic, copy) NSString *placeholder;

//占位文字的颜色
@property (nonatomic, strong) UIColor *placeholderColor;

@end
