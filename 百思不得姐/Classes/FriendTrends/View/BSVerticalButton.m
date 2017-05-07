//
//  BSVerticalButton.m
//  百思不得姐
//
//  Created by mac on 2017/4/11.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSVerticalButton.h"

@implementation BSVerticalButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //调整图片
    self.imageView.x = 0;
    self.imageView.y = 0;
    self.imageView.width = self.width;
    self.imageView.height = self.imageView.width;
    
    //调整文字
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
    
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}

@end
