//
//  BSComment.h
//  百思不得姐
//
//  Created by mac on 2017/4/19.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSUser.h"

@interface BSComment : NSObject

@property (nonatomic, copy) NSString *comment_id;
//评论内容
@property (nonatomic, copy) NSString *content;
//语音时长
@property (nonatomic, assign) NSInteger voicetime;
//点赞数
@property (nonatomic, assign) NSInteger like_count;

// voice-uri
@property (nonatomic, copy) NSString *voiceuri;

@property (nonatomic, strong) BSUser *user;

@end
