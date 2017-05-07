//
//  BSRecommendTagsCell.m
//  百思不得姐
//
//  Created by mac on 2017/4/10.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSRecommendTagsCell.h"
#import "BSRecommendTag.h"
#import <UIImageView+WebCache.h>

@interface BSRecommendTagsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageListView;
@property (weak, nonatomic) IBOutlet UILabel *themeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subNumberLabel;


@end

@implementation BSRecommendTagsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setRecommendTag:(BSRecommendTag *)recommendTag
{
    _recommendTag = recommendTag;
    
     [self.imageListView sd_setImageWithURL:[NSURL URLWithString:recommendTag.image_list] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //jpg图片，SDWeb加载不出来。首先得拿到照片的路径，也就是下边的string参数，转换为NSData型。
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:recommendTag.image_list]];
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageListView.image = image;
//            self.imageListView.contentMode = UIViewContentModeScaleAspectFill;
//            [self setNeedsLayout];
        });
    });

    self.themeNameLabel.text = recommendTag.theme_name;
    if (recommendTag.sub_number < 10000) {
        self.subNumberLabel.text = [NSString stringWithFormat:@"%zd人订阅",recommendTag.sub_number];
    }else {
        self.subNumberLabel.text = [NSString stringWithFormat:@"%.1f万人订阅",recommendTag.sub_number/10000.0];
    }
}

//拦截cell的setFrame方法
- (void)setFrame:(CGRect)frame
{
    //修改cell的x和width，使左边和右边留出间隙
    frame.origin.x = 5;
    frame.size.width -= 2*frame.origin.x;
    
    //修改cell高度，使cell之间留出间隙
    frame.size.height -= 1;
    
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
