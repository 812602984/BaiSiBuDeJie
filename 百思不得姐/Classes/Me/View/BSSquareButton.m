
//
//  BSSquareButton.m
//  百思不得姐
//
//  Created by mac on 2017/5/1.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSSquareButton.h"
#import "BSSquare.h"
#import <UIButton+WebCache.h>

@implementation BSSquareButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

- (void)setup
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    [self setBackgroundImage:[UIImage imageNamed:@"mainCellBackground"] forState:UIControlStateNormal];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setSquare:(BSSquare *)square
{
    _square = square;
    [self setTitle:square.name forState:UIControlStateNormal];
    [self sd_setImageWithURL:[NSURL URLWithString:square.icon] forState:UIControlStateNormal];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //调整图片
    self.imageView.width = self.width * 0.5;
    self.imageView.height = self.imageView.width;
    self.imageView.y = self.height * 0.15;
    self.imageView.centerX = self.width * 0.5;
    
    //调整文字
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height + BSTopicCellMargin;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
    
}

@end
