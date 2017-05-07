//
//  BSTopicVoiceView.h
//  百思不得姐
//
//  Created by mac on 2017/4/16.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BSTopic;

@interface BSTopicVoiceView : UIView

+ (instancetype)voiceView;

@property (nonatomic, strong) BSTopic *topic;

@end
