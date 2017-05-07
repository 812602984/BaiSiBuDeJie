//
//  BSTopicVoiceView.m
//  百思不得姐
//
//  Created by mac on 2017/4/16.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSTopicVoiceView.h"
#import "BSTopic.h"
#import <UIImageView+WebCache.h>
#import <AVFoundation/AVFoundation.h>

@interface BSTopicVoiceView ()
{
    AVAudioPlayer *_player;
}

@property (weak, nonatomic) IBOutlet UIImageView *voiceImageView;

@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;

@property (weak, nonatomic) IBOutlet UILabel *voicetimeLabel;

@end

@implementation BSTopicVoiceView

-(void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
    [super awakeFromNib];
}

+ (instancetype)voiceView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)setTopic:(BSTopic *)topic
{
    _topic = topic;
    
    [self.voiceImageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image] placeholderImage:nil];
    self.playcountLabel.text = [NSString stringWithFormat:@"%zd次播放",topic.playcount];
    NSInteger minute = topic.voicetime / 60;
    NSInteger second = topic.playcount % 60;
    self.voicetimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",minute,second];
}

//音频播放
- (IBAction)playClick:(id)sender {
    NSURL *urlStr = [[NSURL alloc] initWithString:self.topic.voiceuri];
    AVURLAsset *assert = [[AVURLAsset alloc] initWithURL:urlStr options:nil];
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithAsset:assert];
    
    _player = (AVAudioPlayer *)[AVPlayer playerWithPlayerItem:item];
    [_player play];
}

@end
