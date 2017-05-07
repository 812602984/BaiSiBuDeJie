//
//  BSCommentCell.m
//  百思不得姐
//
//  Created by mac on 2017/4/27.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSCommentCell.h"
#import "BSComment.h"
#import <UIImageView+WebCache.h>

@interface BSCommentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;

@end

@implementation BSCommentCell

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return NO;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = bgView;
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.x = BSTopicCellMargin;
    frame.size.width = BSScreenW - 2 * BSTopicCellMargin;
    [super setFrame:frame];
}

- (void)setComment:(BSComment *)comment
{
    _comment = comment;
    
    [self.profileImageView setHeader:comment.user.profile_image];
    
    self.sexImageView.image = [comment.user.sex isEqualToString:BSUserMale]? [UIImage imageNamed:@"Profile_manIcon"]:[UIImage imageNamed:@"Profile_womanIcon"];
    self.nameLabel.text = comment.user.username;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%zd",comment.like_count];
    self.contentLabel.text = comment.content;
    
    if (comment.voiceuri.length) {
        self.voiceButton.hidden = NO;
        [self.voiceButton setTitle:[NSString stringWithFormat:@"%zd''",comment.voicetime] forState:UIControlStateNormal];
    }else{
        self.voiceButton.hidden = YES;
    }
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:self animated:YES];
}

@end
