//
//  BSAccount.m
//  百思不得姐
//
//  Created by mac on 2017/5/8.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSAccount.h"

@implementation BSAccount

+(instancetype)accountWithDict:(NSDictionary *)dict
{
    BSAccount *account = [[self alloc] init];
    account.access_token = dict[@"access_token"];
    account.uid = dict[@"uid"];
    account.expires_in = dict[@"expires_in"];
    /**
     *  获得帐号存储的时间（access_token的产生时间）
     */
    account.created_time = [NSDate date];
    
    return account;
}

/**
 *  当一个对象要归档进沙盒时，就会调用这个方法
 *  目的在这个方法中说明这个对象的哪些属性要存进沙盒
 */
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.access_token forKey:@"access_token"];
    [coder encodeObject:self.uid forKey:@"uid"];
    [coder encodeObject:self.created_time forKey:@"created_time"];
    [coder encodeObject:self.expires_in forKey:@"expires_in"];
    [coder encodeObject:self.name forKey:@"name"];
}

/**
 *  当从沙盒中解档一个对象时（从沙盒中加载一个对象时），就会调用这个方法
 *  目的:在这个方法中说明沙河中的属性该怎么解析（需要去除哪些属性）
 */
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.access_token = [coder decodeObjectForKey:@"access_token"];
        self.uid = [coder decodeObjectForKey:@"uid"];
        self.created_time = [coder decodeObjectForKey:@"created_time"];
        self.expires_in = [coder decodeObjectForKey:@"expires_in"];
        self.name = [coder decodeObjectForKey:@"name"];
    }
    return self;
}

@end
