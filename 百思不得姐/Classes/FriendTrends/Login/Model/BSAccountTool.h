//
//  BSAccountTool.h
//  百思不得姐
//
//  Created by mac on 2017/5/8.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BSAccount;

@interface BSAccountTool : NSObject

/**
 *  存储账户信息
 *
 *  @param account 账户
 */
+ (void)saveAccount:(BSAccount *)account;


/**
 *  获取账户信息
 *
 *  @return 账户模型
 */
+ (BSAccount *)getAccount;


@end
