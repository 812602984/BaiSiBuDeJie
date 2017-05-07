//
//  BSRecommendUser.h
//  百思不得姐
//
//  Created by mac on 2017/4/10.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSRecommendUser : NSObject

/** 用户头像 */
@property (nonatomic, copy) NSString *header;

/** 用户昵称 */
@property (nonatomic, copy) NSString *screen_name;

/** 用户性别 */
@property (nonatomic, assign) NSInteger gender;

/** 粉丝数量 */
@property (nonatomic, assign) NSInteger fans_count;

@end
