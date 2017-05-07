//
//  UIImageView+BSExtension.m
//  百思不得姐
//
//  Created by mac on 2017/5/1.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "UIImageView+BSExtension.h"
#import <UIImageView+WebCache.h>

@implementation UIImageView (BSExtension)

- (void)setHeader:(NSString *)url
{
    UIImage *placeholder = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = image?[image circleImage]:placeholder;
    }];
}

@end
