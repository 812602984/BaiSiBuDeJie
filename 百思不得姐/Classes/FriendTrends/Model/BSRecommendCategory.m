//
//  BSRecommendCategory.m
//  百思不得姐
//
//  Created by mac on 2017/4/9.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSRecommendCategory.h"

@implementation BSRecommendCategory

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"categoryId":@"id"};
}

- (NSMutableArray *)users
{
    if (!_users) {
        _users = [NSMutableArray array];
    }
    return _users;
}

@end
