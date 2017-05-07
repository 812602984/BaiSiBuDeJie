//
//  BSMineCell.m
//  百思不得姐
//
//  Created by mac on 2017/5/1.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSMineCell.h"

@implementation BSMineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView *bgView = [[UIImageView alloc] init];
        bgView.image = [UIImage imageNamed:@"mainCellBackground"];
        self.backgroundView = bgView;
        
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.textLabel.font = [UIFont systemFontOfSize:14];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.imageView.image == nil)  return;
    self.imageView.width = 30;
    self.imageView.height = 30;
    self.imageView.centerY = self.contentView.height * 0.5;
    self.textLabel.x = CGRectGetMaxX(self.imageView.frame) + BSTopicCellMargin;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
