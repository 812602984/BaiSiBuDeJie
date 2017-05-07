//
//  BSRecommendUser.m
//  百思不得姐
//
//  Created by mac on 2017/4/10.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSRecommendUser.h"

@implementation BSRecommendUser

- (NSString *)header
{
    return [_header stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
}

@end
