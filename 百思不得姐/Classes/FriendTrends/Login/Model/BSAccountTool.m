//
//  BSAccountTool.m
//  百思不得姐
//
//  Created by mac on 2017/5/8.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSAccountTool.h"
#import "BSAccount.h"

#define AccountPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"account.archive"]


@implementation BSAccountTool
+(void)saveAccount:(BSAccount *)account
{
    //自定义对象的存储必须用NSKeyedArchiver,不再有writeToFile方法
    [NSKeyedArchiver archiveRootObject:account toFile:AccountPath];
}

+(BSAccount *)getAccount
{
    //加载模型
    BSAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:AccountPath];
    
    /* 验证帐号是否过期 */
    
    //过期的秒数
    long long expires_in = [account.expires_in longLongValue];
    //获得过期时间
    NSDate *expiresTime = [account.created_time dateByAddingTimeInterval:expires_in];
    //获得当前时间
    NSDate *now = [NSDate date];
    
    //如果expiresTime <= now,过期
    NSComparisonResult result = [expiresTime compare:now];
    
    if (result != NSOrderedDescending) {  //过期
        return nil;
    }
    return account;
}

@end
