//
//  BSTopicPictureView.h
//  百思不得姐
//
//  Created by mac on 2017/4/14.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BSTopic;

@interface BSTopicPictureView : UIView

+ (instancetype)pictureView;

@property (nonatomic, strong) BSTopic *topic;

@end
