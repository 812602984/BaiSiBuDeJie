//
//  BSTopicCell.h
//  百思不得姐
//
//  Created by mac on 2017/4/13.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BSTopic;

@interface BSTopicCell : UITableViewCell

@property (nonatomic, strong) BSTopic *topic;

+ (instancetype)topicCell;

@end
