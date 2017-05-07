//
//  BSPushGuideView.m
//  百思不得姐
//
//  Created by mac on 2017/4/11.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSPushGuideView.h"

@implementation BSPushGuideView

+ (instancetype)guideView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (IBAction)close
{
    [self removeFromSuperview];
}

+ (void)show
{
    NSString *key = @"CFBundleShortVersionString";
    
    //获得当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    //获得沙盒中存储的版本号，即上次的版本号
    NSString *sanboxVersion = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    
    if (![currentVersion isEqualToString:sanboxVersion]) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        BSPushGuideView *guideView = [BSPushGuideView guideView];
        guideView.frame = window.bounds;
        [window addSubview:guideView];
        
        //存储版本号
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
