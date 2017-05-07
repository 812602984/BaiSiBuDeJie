//
//  BSNetState.m
//  百思不得姐
//
//  Created by mac on 2017/4/12.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSNetState.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>


@implementation BSNetState

static BSNetState *_netState = nil;

+ (instancetype) shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _netState = [[self alloc] init];
    });
    return _netState;
}

- (void)checkNetworkState{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
//                NSLog(@"没有网络");
                [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:BSNetworkStateNotification object:nil userInfo:@{@"netType":@"NotReachable"}]];
                [BSNetState shareInstance].hasNet = NO;
                [BSNetState shareInstance].networkDescription = @"NotReachable";
                break;
            case AFNetworkReachabilityStatusUnknown:
//                NSLog(@"未知");
                if(! self.hasNet){
                    [SVProgressHUD dismiss];
                    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:BSNetworkStateNotification object:nil userInfo:@{@"netType":@"Unknown"}]];
                }
                [BSNetState shareInstance].hasNet = YES;
            case AFNetworkReachabilityStatusReachableViaWiFi:
//                NSLog(@"WiFi");
//                    [YJYYStatusHUD hildErrorMessage];
                if (!self.hasNet) {
                    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:BSNetworkStateNotification object:nil userInfo:@{@"netType":@"WiFi"}]];
                    [BSNetState shareInstance].hasNet = YES;
                }
               
            case AFNetworkReachabilityStatusReachableViaWWAN:
//                NSLog(@"3G|4G");
                if(!self.hasNet){
                    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:BSNetworkStateNotification object:nil userInfo:@{@"netType":@"WWAN"}]];
                }
                self.hasNet = YES;               
            default:
                self.hasNet= YES;
                if ([SVProgressHUD isVisible]) {
                    [SVProgressHUD dismiss];
                }
                break;
        }
    }];
    
}

@end
