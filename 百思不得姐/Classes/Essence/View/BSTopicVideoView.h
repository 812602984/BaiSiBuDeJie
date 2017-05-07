//
//  BSTopicVideoView.h
//  百思不得姐
//
//  Created by mac on 2017/4/16.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BSTopic;

@interface BSTopicVideoView : UIView

+ (instancetype)videoView;

@property (strong, nonatomic) BSTopic *topic;

@end
