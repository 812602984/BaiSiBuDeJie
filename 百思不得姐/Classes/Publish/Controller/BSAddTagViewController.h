//
//  BSAddTagViewController.h
//  百思不得姐
//
//  Created by mac on 2017/5/13.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSAddTagViewController : UIViewController

@property (nonatomic, copy) void (^tagsBlock) (NSArray *tags);

@property (nonatomic, strong) NSArray *textArr;

@end
