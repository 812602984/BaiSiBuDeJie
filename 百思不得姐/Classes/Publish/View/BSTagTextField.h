//
//  BSTagTextField.h
//  百思不得姐
//
//  Created by mac on 2017/5/14.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  BSTagTextField;

@protocol BSTagTextFieldDelegate <NSObject>

@optional

- (void)textFieldDidClickDelete:(BSTagTextField *)textField;

@end

@interface BSTagTextField : UITextField

@property (nonatomic, weak) id <BSTagTextFieldDelegate> delegate;

@end


