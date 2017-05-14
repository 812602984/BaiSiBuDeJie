
//
//  BSTagTextField.m
//  百思不得姐
//
//  Created by mac on 2017/5/14.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSTagTextField.h"

@implementation BSTagTextField

- (void)deleteBackward
{
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(BSTagTextFieldDelegate)]) {
        [self.delegate textFieldDidClickDelete:self];
    }
    
    [super deleteBackward];
}

@end
