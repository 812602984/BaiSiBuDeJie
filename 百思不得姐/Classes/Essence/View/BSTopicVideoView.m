//
//  BSTopicVideoView.m
//  百思不得姐
//
//  Created by mac on 2017/4/16.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSTopicVideoView.h"
#import <UIImageView+WebCache.h>
#import "BSTopic.h"
#import <MediaPlayer/MediaPlayer.h>

@interface BSTopicVideoView ()
{
    MPMoviePlayerViewController *_mp;
}

@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;

@property (weak, nonatomic) IBOutlet UILabel *videotimeLabel;

@end

@implementation BSTopicVideoView

- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
    [super awakeFromNib];
}

+ (instancetype)videoView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)setTopic:(BSTopic *)topic
{
    _topic = topic;
    
    [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image] placeholderImage:nil];
    self.playcountLabel.text = [NSString stringWithFormat:@"%zd次播放",topic.playcount];
    NSInteger minute = topic.videotime / 60;
    NSInteger second = topic.videotime % 60;
    self.videotimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",minute,second];
}

//视频播放按钮点击事件
- (IBAction)playClick:(id)sender {
    _mp = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:self.topic.videouri]];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.frame = [UIScreen mainScreen].bounds;
    _mp.view.frame = window.bounds;
    [window addSubview:_mp.view];
    [_mp.moviePlayer play];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playBack:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

- (void)playBack:(NSNotification *)notification{
    NSDictionary *dict = notification.userInfo;
    
    //获取播放返回的原因
    NSInteger type = [dict[MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue];
    //type 的值 1.自动播放完毕 2.点击Done 按钮  3.播放有异常
    switch (type) {
        case 1:
        {
            NSLog(@"自动播放完毕");
        }
            break;
        case 2:
        {
            //点击Done
            [_mp.moviePlayer stop];
            //界面跳转
            [_mp.view removeFromSuperview];
            
        }
            break;
        case 3:
        {
            NSLog(@"播放有异常");
        }
            break;
            
        default:
            break;
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
