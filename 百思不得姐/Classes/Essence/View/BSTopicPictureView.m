//
//  BSTopicPictureView.m
//  百思不得姐
//
//  Created by mac on 2017/4/14.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSTopicPictureView.h"
#import "BSTopic.h"
#import <UIImageView+WebCache.h>
#import "BSTopicShowPictureController.h"
#import "BSProgressView.h"

@interface BSTopicPictureView()

/** 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/** gif标识 */
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
/** 查看全部图片 */
@property (weak, nonatomic) IBOutlet UIButton *seeAllButton;
/** 图片下载进度 */
@property (weak, nonatomic) IBOutlet  BSProgressView *progressView;

@end

@implementation BSTopicPictureView

- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
    
    
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];
    
    [super awakeFromNib];
}

- (void)showPicture
{
    BSTopicShowPictureController *showPicture = [[BSTopicShowPictureController alloc] init];

    showPicture.topic = self.topic;
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPicture animated:YES completion:nil];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers[0] pushViewController:showPicture animated:YES];
    
}

+ (instancetype)pictureView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}

- (void)setTopic:(BSTopic *)topic
{
    _topic = topic;
    
    [self.progressView setProgress:topic.pictureProgress animated:NO];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.hidden = NO;
        topic.pictureProgress = 1.0 * receivedSize / expectedSize;
        [self.progressView setProgress:topic.pictureProgress animated:NO];    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.progressView.hidden = YES;
            
            //如果是大图片，才需要绘图
            if(topic.isZoom == NO) return;
            
            //开启图形上下文
            UIGraphicsBeginImageContextWithOptions(topic.pictureFrame.size, YES, 0.0);
            
            //将下载完的image对象绘制到图形上下文
            CGFloat width = topic.pictureFrame.size.width;
            CGFloat height = width / image.size.width * image.size.height;
            [image drawInRect:CGRectMake(0, 0, width, height)];
            
            //获得图片
            self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            
            //结束图形上下文
            UIGraphicsEndImageContext();

    }];

    NSString *extension = topic.large_image.pathExtension;
    BOOL isGif = [extension.lowercaseString isEqualToString:@"gif"];
    
    self.gifView.hidden = !isGif;
    
    if (topic.isZoom) {
        self.seeAllButton.hidden = NO;
//        self.imageView.contentMode = UIViewContentModeTop;
    }else {
        self.seeAllButton.hidden = YES;
//        self.imageView.contentMode = UIViewContentModeScaleToFill;
    }
}

@end
