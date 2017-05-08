//
//  BSAccount.h
//  百思不得姐
//
//  Created by mac on 2017/5/8.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  由于access_token不经常变，我们需要将拿到的access_token归档存起来，每次登陆的时候，先判断access_token是否有效（存在且不过期）
 *  归档使用模型，需要实现 NSCoding 协议
 */
@interface BSAccount : NSObject<NSCoding>

/**
 *  用于调用access_token,接口获取授权后的access_token
 */
@property (nonatomic, copy) NSString *access_token;

/**
 *  access_token的生命周期，单位是秒数
 */
@property (nonatomic, copy) NSNumber *expires_in;

/**
 *  当前授权用户的UID
 */
@property (nonatomic, copy) NSString *uid;

/**
 *  access_token的创建时间
 */
@property (nonatomic, strong) NSDate *created_time;

/**
 *  用户昵称
 */
@property (nonatomic, copy) NSString *name;

+ (instancetype)accountWithDict:(NSDictionary *)dict;

@end
