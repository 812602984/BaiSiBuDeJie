//
//  BSTopicCell.m
//  百思不得姐
//
//  Created by mac on 2017/4/13.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSTopicCell.h"
#import "BSTopic.h"
#import <UIImageView+WebCache.h>
#import "NSDate+BSExtension.h"
#import "BSTopicPictureView.h"
#import "BSTopicVoiceView.h"
#import "BSTopicVideoView.h"
#import "BSComment.h"

@interface BSTopicCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *loveButton;
@property (weak, nonatomic) IBOutlet UIButton *hateButton;
@property (weak, nonatomic) IBOutlet UIButton *repostButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIImageView *SinaVView;
@property (weak, nonatomic) IBOutlet UILabel *text_label;

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIView *commentView;

//图片
@property (weak, nonatomic) BSTopicPictureView *pictureView;
//声音
@property (weak, nonatomic) BSTopicVoiceView *voiceView;
//视频
@property (weak, nonatomic) BSTopicVideoView *videoView;

@end

@implementation BSTopicCell

+ (instancetype)topicCell
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (BSTopicPictureView *)pictureView
{
    if (!_pictureView) {
         BSTopicPictureView *pictureView = [BSTopicPictureView pictureView];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}

- (BSTopicVoiceView *)voiceView
{
    if (!_voiceView) {
        BSTopicVoiceView *voiceView = [BSTopicVoiceView voiceView];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}

- (BSTopicVideoView *)videoView
{
    if (!_videoView) {
        BSTopicVideoView *videoView = [BSTopicVideoView videoView];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = bgView;
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.x = BSTopicCellMargin;
    frame.size.width -= 2 * BSTopicCellMargin;

    frame.size.height -= BSTopicCellMargin;
//    frame.size.height = self.topic.cellHeight - BSTopicCellMargin;
    frame.origin.y += BSTopicCellMargin;

    [super setFrame:frame];
    
}

- (void)setTopic:(BSTopic *)topic
{
    UIImage *placeholder = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:topic.profile_image] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.profileImageView.image = image?[image circleImage]:placeholder;
    }];
    self.nameLabel.text = topic.name;
    
    self.createTimeLabel.text = topic.create_time;
    self.SinaVView.hidden = !topic.sina_v;
    
    //设置按钮文字
    [self setupButton:self.loveButton count:topic.ding placeholder:@"顶"];
    [self setupButton:self.hateButton count:topic.cai placeholder:@"踩"];
    [self setupButton:self.repostButton count:topic.repost placeholder:@"转发"];
    [self setupButton:self.commentButton count:topic.comment placeholder:@"评论"];
    
    //设置帖子中间的内容
    self.text_label.text = topic.text;
    
    //根据帖子类型添加cell中间的内容
    if (topic.type == BSTopicTypePicture) { //图片
        self.pictureView.topic = topic;
        self.pictureView.frame = topic.pictureFrame;
        self.pictureView.hidden = NO;
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
    }else if(topic.type == BSTopicTypeVoice) { //音频
        self.voiceView.topic = topic;
        self.voiceView.frame = topic.voiceFrame;
        self.voiceView.hidden = NO;
        self.pictureView.hidden = YES;
        self.videoView.hidden = YES;
    }else if (topic.type == BSTopicTypeVideo) { //视频
        self.videoView.topic = topic;
        self.videoView.frame = topic.videoFrame;
        self.videoView.hidden = NO;
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
    }else if (topic.type == BSTopicTypeWord) { //段子
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
    }
    
    //最热评论区
    if (topic.top_cmt.count) {
        self.commentView.hidden = NO;
        BSComment *comment = [topic.top_cmt firstObject];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: %@",comment.user.username,comment.content]];
        
        [str setAttributes:@{NSForegroundColorAttributeName:[UIColor purpleColor]} range:NSMakeRange(0, comment.user.username.length)];
        self.commentLabel.attributedText = str;
    }else {
        self.commentView.hidden = YES;
    }
}

- (void)setupButton:(UIButton *)button count:(NSInteger)count placeholder:(NSString*)placeholder
{
    if (count > 10000) {
        placeholder = [NSString stringWithFormat:@"%.1f万",count/10000.0] ;
    }else if(count > 0){
        placeholder = [NSString stringWithFormat:@"%zd",count];

    }
    
    [button setTitle:placeholder forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
