//
//  BSUser.h
//  百思不得姐
//
//  Created by mac on 2017/4/19.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSUser : NSObject

//用户名
@property (nonatomic, copy) NSString *username;
//用户头像
@property (nonatomic, copy) NSString *profile_image;
//用户性别
@property (nonatomic, copy) NSString *sex;

@end
