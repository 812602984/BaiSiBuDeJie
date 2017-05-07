//
//  BSHeaderView.m
//  百思不得姐
//
//  Created by mac on 2017/4/27.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSHeaderView.h"

@implementation BSHeaderView

+(instancetype)headerView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (IBAction)click:(id)sender {
    NSLog(@"%zd",self.tag);
}

@end
