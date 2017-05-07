//
//  BSRecommendTag.h
//  百思不得姐
//
//  Created by mac on 2017/4/10.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSRecommendTag : NSObject

/** 图片 */
@property (nonatomic, copy) NSString *image_list;

/** 订阅主题 */
@property (nonatomic, copy) NSString *theme_name;

/** 订阅人数 */
@property (nonatomic, assign) NSInteger sub_number;

@end
