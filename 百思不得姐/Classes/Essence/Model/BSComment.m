
//
//  BSComment.m
//  百思不得姐
//
//  Created by mac on 2017/4/19.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSComment.h"
#import <MJExtension.h>

@implementation BSComment

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
     return @{@"comment_id":@"id"};
}

@end
