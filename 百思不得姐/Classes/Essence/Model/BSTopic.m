//
//  BSTopic.m
//  百思不得姐
//
//  Created by mac on 2017/4/13.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSTopic.h"
#import <MJExtension.h>
#import "BSComment.h"

@implementation BSTopic
{
    CGFloat _cellHeight;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"small_image":@"image0",@"middle_image":@"image1",@"large_image":@"image2",@"topic_id":@"id"};
    
    //如果把top_cmt当成一个BSComment对象的话，可以用@{@"top_cmt":@"top_cmt[0]"},其中可以使用点语法代替字典的key
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"top_cmt":@"BSComment"};
}

- (NSString *)create_time
{
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置日期格式(y:年,M:月,d:日,H:时,m:分,s:秒)
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 帖子的创建时间
    NSDate *create = [fmt dateFromString:_create_time];
    
    if (create.isThisYear) { // 今年
        if (create.isToday) { // 今天
            NSDateComponents *cmps = [[NSDate date] deltaFrom:create];
            
            if (cmps.hour >= 1) { // 时间差距 >= 1小时
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            } else if (cmps.minute >= 1) { // 1小时 > 时间差距 >= 1分钟
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            } else { // 1分钟 > 时间差距
                return @"刚刚";
            }
        } else if (create.isYesterday) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:create];
        } else { // 其他
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:create];
        }
    } else { // 非今年
        return _create_time;
    }
}

-(CGFloat)cellHeight
{
    if (!_cellHeight) {
        //文字的最大尺寸
        CGSize maxSize = CGSizeMake(BSScreenW - 40, MAXFLOAT);
        CGFloat textH = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
        
        //cell的高度
        _cellHeight = BSTopicCellTextY +textH + BSTopicCellMargin;
        
        //根据帖子的模型计算cell高度
        if (self.type == BSTopicTypePicture) {  //图片
            CGFloat pictureX = BSTopicCellMargin;
            CGFloat pictureY = BSTopicCellTextY + textH + BSTopicCellMargin;
            CGFloat pictureW = maxSize.width;
            CGFloat pictureH = self.height*pictureW/self.width;
            if (pictureH >= BSPictureMaxH) { //如果图片过长
                pictureH = BSPictureZoomH;
                self.isZoom = YES;
            }
            _pictureFrame = CGRectMake(pictureX, pictureY, pictureW, pictureH);
            
            _cellHeight += pictureH + BSTopicCellMargin;
        }else if (self.type == BSTopicTypeVoice) {//音频
            CGFloat voiceX = BSTopicCellMargin;
            CGFloat voiceY = BSTopicCellTextY + textH + BSTopicCellMargin;
            CGFloat voiceW = maxSize.width;
            CGFloat voiceH = self.height*voiceW/self.width;
            _voiceFrame = CGRectMake(voiceX, voiceY, voiceW, voiceH);
            _cellHeight += voiceH + BSTopicCellMargin;
        }else if (self.type == BSTopicTypeVideo) {//视频
            CGFloat videoX = BSTopicCellMargin;
            CGFloat videoY = BSTopicCellTextY + textH + BSTopicCellMargin;
            CGFloat videoW = maxSize.width;
            CGFloat videoH = self.height*videoW/self.width;
            _videoFrame = CGRectMake(videoX, videoY, videoW, videoH);
            _cellHeight += videoH + BSTopicCellMargin;
        }

        BSComment *comment = [self.top_cmt firstObject];
        if (comment) {
            CGSize commentLabelSize = CGSizeMake(BSScreenW - 40, MAXFLOAT);
            NSString *text = [NSString stringWithFormat:@"%@: %@",comment.user.username,comment.content];
            CGFloat commentH = [text boundingRectWithSize:commentLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height;
            _cellHeight += BSCommentTitleH + commentH + BSTopicCellMargin;
        }

        _cellHeight += BSTopicCellBottomBarH + BSTopicCellMargin;
    }
    
    return _cellHeight;
}

@end
