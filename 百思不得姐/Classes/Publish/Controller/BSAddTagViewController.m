

//
//  BSAddTagViewController.m
//  百思不得姐
//
//  Created by mac on 2017/margin/13.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSAddTagViewController.h"
#import <SVProgressHUD.h>
#import "BSTagTextField.h"

@interface BSAddTagViewController () <UITextFieldDelegate,BSTagTextFieldDelegate>

@property (nonatomic, weak) BSTagTextField *textField;

@property (nonatomic, strong) NSMutableArray *tagBtns;

@property (nonatomic, weak) UIButton *addTagButton;

@end

static const CGFloat margin = 5.0f;

@implementation BSAddTagViewController

- (NSMutableArray *)tagBtns
{
    if (!_tagBtns) {
        _tagBtns = [NSMutableArray array];
    }
    return _tagBtns;
}

- (void)setTextArr:(NSArray *)textArr
{
    _textArr = textArr;
    for (int i = 0; i < textArr.count; i++) {
        self.textField.text = textArr[i];
        [self addTagClick];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"添加标签";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    
    
    [self addTagBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
}

- (void)done
{
    //KVC
    NSArray *tags = [self.tagBtns valueForKeyPath:@"currentTitle"];
    !self.tagsBlock?:self.tagsBlock(tags);
    [self.navigationController popViewControllerAnimated:YES];
}

- (BSTagTextField *)textField
{
    if (_textField == nil) {
        BSTagTextField *textField = [[BSTagTextField alloc] init];
        textField.delegate = self;
        textField.width = BSScreenW;
        textField.x = margin;
        textField.y = 64;
        textField.height = 30;
        textField.font = [UIFont systemFontOfSize:14];
        textField.placeholder = @"输入逗号或回车键也可以添加标签哦";
        [textField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:textField];
        _textField = textField;
    }
    return _textField;
}

- (void)textDidChange:(UITextField *)textField
{
    if (textField.hasText) {
        self.addTagButton.hidden = NO;
        NSString *text = textField.text;
        NSString *lasttext = [text substringFromIndex:text.length-1];
        
        if ([lasttext isEqualToString:@","] || [lasttext isEqualToString:@"，"]) {
            textField.text = [text substringToIndex:text.length-1];
            [self addTagClick];
        }
        
        [self.addTagButton setTitle:[NSString stringWithFormat:@"标签：%@",textField.text] forState:UIControlStateNormal];
        
        if (self.tagBtns.count) {
            UIButton *btn = self.tagBtns.lastObject;
            CGFloat width = BSScreenW - CGRectGetMaxX(btn.frame) - margin;
            if (width < [self textFieldWidth]) {
                textField.x = margin;
                textField.y = CGRectGetMaxY(btn.frame) + margin;
            }else {
                textField.x = CGRectGetMaxX(btn.frame) + margin;
                textField.y = btn.y;
            }
            self.addTagButton.x = margin;
            self.addTagButton.y = CGRectGetMaxY(textField.frame) + margin;
        }
    }else {
        self.addTagButton.hidden = YES;
    }
}

- (void)addTagBtn
{
    UIButton *addTagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addTagBtn.height = 30;
    addTagBtn.x = margin;
    addTagBtn.y = CGRectGetMaxY(self.textField.frame) + margin;
    addTagBtn.width = BSScreenW - 2*addTagBtn.x;
    addTagBtn.backgroundColor = [UIColor blueColor];
    addTagBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    addTagBtn.titleEdgeInsets = UIEdgeInsetsMake(0, margin, 0, -margin);
    addTagBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [addTagBtn addTarget:self action:@selector(addTagClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addTagBtn];
    self.addTagButton = addTagBtn;
}

- (void)addTagClick
{
    if (self.tagBtns.count >= 5) {
        [SVProgressHUD showErrorWithStatus:@"最多只能创建5个标签哦！"];
        return;
    }
    
    if (self.textField.hasText) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor blueColor];
        [btn setTitle:self.textField.text forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        
        [btn addTarget:self action:@selector(removeTagBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        
        CGFloat width = [btn currentImage].size.width;
        CGFloat textW = btn.width - width;

        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, textW, 0, 0)];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -width, 0,0)];

        [self.view addSubview:btn];
        [self.tagBtns addObject:btn];
        self.textField.text = nil;
        self.addTagButton.hidden = YES;
        [self.addTagButton setTitle:nil forState:UIControlStateNormal];
        [UIView animateWithDuration:0.25 animations:^{
            [self updateBtnFrame];
        }];
    }
}

//排布标签按钮的frame
- (void)updateBtnFrame
{
    if (!self.tagBtns.count) {
        self.textField.x = margin;
        self.textField.y = 64;
        self.addTagButton.y = CGRectGetMaxY(self.textField.frame) + margin;
        return;
    }
    for (int i = 0; i < self.tagBtns.count; i++) {
        if (i == 0) {
            UIButton *btn = self.tagBtns.firstObject;
            btn.x = margin;
            btn.y = 64 + margin;
        }else {
            UIButton *lastBtn = self.tagBtns[i - 1];
            UIButton *btn = self.tagBtns[i];
            btn.x = CGRectGetMaxX(lastBtn.frame) + margin;
            btn.y = lastBtn.y;
            CGFloat width = BSScreenW - CGRectGetMaxX(lastBtn.frame) - margin;
            if (width < btn.width) {
                btn.x = margin;
                btn.y = CGRectGetMaxY(lastBtn.frame) + margin;
            }
        }
    }
    
    UIButton *btn = self.tagBtns.lastObject;
    CGFloat width = BSScreenW - CGRectGetMaxX(btn.frame) - margin;
    if (width < [self textFieldWidth]) {
        self.textField.x = margin;
        self.textField.y = CGRectGetMaxY(btn.frame) + margin;
    }else {
        self.textField.x = CGRectGetMaxX(btn.frame) + margin;
        self.textField.y = btn.y;
    }
    self.addTagButton.x = margin;
    self.addTagButton.y = CGRectGetMaxY(self.textField.frame) + margin;

}

- (void)removeTagBtn:(UIButton *)button
{
    [button removeFromSuperview];
    [self.tagBtns removeObject:button];
    [UIView animateWithDuration:0.25 animations:^{
        [self updateBtnFrame];
    }];
}

- (CGFloat)textFieldWidth
{
    CGFloat width = [self.textField.text sizeWithAttributes:@{NSForegroundColorAttributeName:self.textField.font}].width;
    return MAX(width, 220);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self addTagClick];
    return YES;
}

- (void)textFieldDidClickDelete:(BSTagTextField *)textField
{
    if (!textField.hasText) {
        [self removeTagBtn:self.tagBtns.lastObject];
    }
}

@end
