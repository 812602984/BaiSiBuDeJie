//
//  BSRecommendUserCell.m
//  百思不得姐
//
//  Created by mac on 2017/4/10.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSRecommendUserCell.h"
#import "BSRecommendUser.h"
#import <UIImageView+WebCache.h>

@interface BSRecommendUserCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;

@end

@implementation BSRecommendUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setUser:(BSRecommendUser *)user
{
    _user = user;

    self.nameLabel.text = user.screen_name;
    self.fansCountLabel.text = [NSString stringWithFormat:@"%ld人关注",user.fans_count];
    
    [self.headerView sd_setImageWithURL:[NSURL URLWithString:user.header] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
}

@end
