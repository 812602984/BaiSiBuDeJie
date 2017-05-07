//
//  BSTextFile.m
//  百思不得姐
//
//  Created by mac on 2017/4/11.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSTextFile.h"
#import <objc/runtime.h>

@implementation BSTextFile

//- (void)drawPlaceholderInRect:(CGRect)rect
//{
//    [self.placeholder drawInRect:CGRectMake(0, 10, rect.size.width, 25) withAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor],
//                         NSFontAttributeName:self.font}];
//    
//}

+ (void)initialize
{
//    [self getIvars];
//    [self getPropertyList];
//    [self getMethods];
}

/**
 * 获取UITextFiled的成员变量，带下划线
 */
+ (void)getIvars
{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([UITextField class], &count);
    
    for (int i = 0; i < count; i++) {
        //取出成员变量名字
        Ivar ivar = *(ivars + i);
        
        //打印成员变量名字
        BSLog(@"%s   <---->   %s",ivar_getName(ivar),ivar_getTypeEncoding(ivar));
    }
    
    //释放指针
    free(ivars);
}

/**
 * 获取UITextFiled的属性,@property
 */
+ (void)getPropertyList
{
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([UITextField class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = *(properties + i);
        
        BSLog(@"%s   <----->  %s",property_getName(property),property_getAttributes(property));
    }
    free(properties);
}

/**
 * 获取UITextFiled的方法
 */
+ (void)getMethods
{
    unsigned int count = 0;
    Method *methods = class_copyMethodList([UITextField class], &count);
    
    for (int i = 0; i < count; i++) {
        Method method = * (methods + i);
        
        BSLog(@"%@",NSStringFromSelector(method_getName(method)));
    }
    
    free(methods);
}

- (void)awakeFromNib
{
    [super awakeFromNib];
//    UILabel *placeholderLabel = [self valueForKeyPath:@"_placeholderLabel"];
//    placeholderLabel.textColor = [UIColor redColor];
    
    //修改占位文字颜色
    [self setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    //设置光标颜色和文字颜色一致
    self.tintColor = self.textColor;
    
    [self resignFirstResponder];
}

- (BOOL)becomeFirstResponder
{
    //使用kvc修改属性
    [self setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    [self setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    return [super resignFirstResponder];
}



@end
