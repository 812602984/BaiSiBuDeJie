//
//  BSRecommendCategory.h
//  百思不得姐
//
//  Created by mac on 2017/4/9.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSRecommendCategory : NSObject

/** id */
@property (nonatomic, assign) NSInteger categoryId;

/** count */
@property (nonatomic, assign) NSInteger count;

/** name */
@property (nonatomic, copy) NSString *name;

/** 总页数 */
@property (nonatomic, assign) NSInteger currentPage;

/** 总数 */
@property (nonatomic, assign) NSInteger total;

@property (nonatomic, strong) NSMutableArray *users;

@end
