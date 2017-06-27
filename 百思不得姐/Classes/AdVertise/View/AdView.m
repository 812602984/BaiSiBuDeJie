//
//  AdView.m
//  百思不得姐
//
//  Created by mac on 2017/6/25.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "AdView.h"

//广告显示时间3s
static const int showtime = 5;

@interface AdView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *skipButton;

@end


@implementation AdView
{
    NSTimer *timer;
    int count;
}

- (void)setFilePath:(NSString *)filePath
{
    _filePath = filePath;
    _imageView.image = [UIImage imageWithContentsOfFile:filePath];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _skipButton.layer.cornerRadius = 4;
    self.imageView.userInteractionEnabled = YES;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self.imageView addGestureRecognizer:tap];

    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeCount) userInfo:nil repeats:YES];
}

- (void) startTimer
{
    count = showtime;
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void) timeCount
{
    [self.skipButton setTitle:[NSString stringWithFormat:@"%zds跳过",count] forState:UIControlStateNormal];
    count--;

    if (count == -1) {
        [self dismiss];
    }
}

//移除广告页面
- (void) dismiss
{
    [timer invalidate];
    timer = nil;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0.3f;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

+ (instancetype) adView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void) show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    self.frame = window.bounds;
    [window addSubview:self];
    
    [self startTimer];
}

- (void)tapClick:(UITapGestureRecognizer *)tap
{
    [self dismiss];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushToAdNotification" object:nil];
}

- (IBAction)skipClick:(id)sender
{
    BSLog(@"nihao");
    [self dismiss];
}



@end
