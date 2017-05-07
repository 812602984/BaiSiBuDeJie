
//
//  BSTextView.m
//  百思不得姐
//
//  Created by mac on 2017/5/2.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSTextView.h"

@implementation BSTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //默认字体
        self.font = [UIFont systemFontOfSize:15];
        //默认占位文字颜色,防止外部不设置的话导致崩溃（向字典中插入空值）
        self.placeholderColor = [UIColor grayColor];
        
        //设置垂直方向上的弹簧效果
        self.alwaysBounceVertical = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    [self setNeedsDisplay];  //重新绘制
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self setNeedsDisplay];
}

- (void)textDidChange
{
    [self setNeedsDisplay]; //重新调用drawRect
}

//每次调用drawRect，会把之前的内容清除
- (void)drawRect:(CGRect)rect {
    //rect是从左上角（0，-64）开始的
    
    //    if (self.text.length || self.attributedText.length) {
    //        return;
    //    }
    
    
    //如果有文字，直接返回，不绘制占位文字
    if (self.hasText) return;

    rect.origin.x = 5;
    rect.origin.y = 7;
    rect.size.width = self.width - 2 * rect.origin.x;
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = self.font;
    attr[NSForegroundColorAttributeName] = self.placeholderColor;
    [self.placeholder drawInRect:rect withAttributes:attr];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
