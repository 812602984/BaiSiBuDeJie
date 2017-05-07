//
//  BSTopic.h
//  百思不得姐
//
//  Created by mac on 2017/4/13.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSTopic : NSObject

/** 名称 */
@property (nonatomic, copy) NSString *name;
/** 头像 */
@property (nonatomic, copy) NSString *profile_image;
/** 发帖时间 */
@property (nonatomic, copy) NSString *create_time;
/** 文字内容 */
@property (nonatomic, copy) NSString *text;
/** 顶的数量 */
@property (nonatomic, assign) NSInteger ding;
/** 踩的数量 */
@property (nonatomic, assign) NSInteger cai;
/** 转发数量 */
@property (nonatomic, assign) NSInteger repost;
/** 评论数量 */
@property (nonatomic, assign) NSInteger comment;
/** 是否新浪加V认证*/
@property (nonatomic, assign, getter=isSina_v) BOOL sina_v;
/** 小图片url */
@property (nonatomic, copy) NSString *small_image;
/** 中图片url */
@property (nonatomic, copy) NSString *middle_image;
/** 大图片url */
@property (nonatomic, copy) NSString *large_image;
/** 图片宽度 */
@property (nonatomic, assign) CGFloat width;
/** 图片高度 */
@property (nonatomic, assign) CGFloat height;
/** 播放次数 */
@property (nonatomic, assign) NSInteger playcount;
/** 音频时长 */
@property (nonatomic, assign) NSInteger voicetime;
/** 视频时长 */
@property (nonatomic, assign) NSInteger videotime;

/** 帖子lei xing */
@property (nonatomic, assign) BSTopicType type;

/** 添加额外的属性：每个topic模型对应的cell高度*/
@property (nonatomic, assign, readonly) CGFloat cellHeight;

/** 每个topic模型对应的中间图片frame*/
@property (nonatomic, assign, readonly) CGRect pictureFrame;

/** 每个topic模型对应的音频图片frame*/
@property (nonatomic, assign, readonly) CGRect voiceFrame;
/** 每个topic模型对应的视频图片frame*/
@property (nonatomic, assign, readonly) CGRect videoFrame;
/** 视频播放uri*/
@property (nonatomic, copy) NSString *videouri;
/** 音频播放uri*/
@property (nonatomic, copy) NSString *voiceuri;

@property (nonatomic, copy) NSString *topic_id;

/** 最热评论 */
@property (nonatomic, strong) NSArray *top_cmt;


/** 每个topic模型对应的中间图片是否被缩放*/
@property (nonatomic, assign) BOOL isZoom;

/** 每个topic模型对应的图片下载进度*/
@property (nonatomic, assign) CGFloat pictureProgress;

@end
