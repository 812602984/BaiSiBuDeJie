//
//  BSCommentHeaderView.m
//  百思不得姐
//
//  Created by mac on 2017/4/27.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSCommentHeaderView.h"

@interface BSCommentHeaderView ()

@property (nonatomic, weak) UILabel *label;

@end


static NSString *headerId = @"header";

@implementation BSCommentHeaderView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView
{
    BSCommentHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];
    if (header == nil) { //缓存池没有的话，自己创建
        header = [[BSCommentHeaderView alloc] initWithReuseIdentifier:headerId];
    }
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = BSGlobalBg;
        UILabel *label = [[UILabel alloc] init];
        label.textColor = BSRGBColor(67, 67, 67);
        label.x = 10;
        label.width = 200;
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:label];

        self.label = label;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.x = BSTopicCellMargin;
    frame.size.width = BSScreenW - 2 * BSTopicCellMargin;
    [super setFrame:frame];
}

-(void)setTitle:(NSString *)title
{
    _title = [title copy];
    self.label.text = title;
}

@end
