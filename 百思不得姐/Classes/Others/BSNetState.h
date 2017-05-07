//
//  BSNetState.h
//  百思不得姐
//
//  Created by mac on 2017/4/12.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSNetState : NSObject

@property (nonatomic, assign) BOOL hasNet;

@property (nonatomic, copy) NSString *networkDescription;

+ (instancetype) shareInstance;

- (void)checkNetworkState;

@end
