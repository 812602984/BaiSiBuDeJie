//
//  AdView.h
//  百思不得姐
//
//  Created by mac on 2017/6/25.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdView : UIView

- (void) show;

+ (instancetype)adView;

@property (nonatomic, copy) NSString *filePath;

@end
