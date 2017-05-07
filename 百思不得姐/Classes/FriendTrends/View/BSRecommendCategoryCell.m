//
//  BSRecommendCategoryCell.m
//  百思不得姐
//
//  Created by mac on 2017/4/9.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSRecommendCategoryCell.h"
#import "BSRecommendCategory.h"

@interface BSRecommendCategoryCell()

@property (weak, nonatomic) IBOutlet UIView *selectedIndicator;


@end

@implementation BSRecommendCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = BSRGBColor(244, 244, 244);
    [self.textLabel setFont:[UIFont systemFontOfSize:13]];
    self.selectedIndicator.backgroundColor = BSRGBColor(219, 21, 26);
    
    //当cell的selection为None时，即使cell被选中，内部的子控件也不会进入高亮状态
//    self.textLabel.textColor = BSRGBColor(80, 80, 80);
//    self.textLabel.highlightedTextColor = BSRGBColor(219, 21, 26);
}

-(void)setCategory:(BSRecommendCategory *)category
{
    _category = category;
    self.textLabel.text = category.name;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //重新调整内部textLabel的frame，使白色分割线明显
    self.textLabel.y = 2;
    self.textLabel.height = self.contentView.height - 2*self.textLabel.y;
}

/**
 *可以在这里监听cell选中或者取消
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:YES];
    
    self.selectedIndicator.hidden = !selected;
    self.textLabel.textColor = selected?self.selectedIndicator.backgroundColor:BSRGBColor(80, 80, 80);
    BSLog(@"%d",selected);
}

@end
