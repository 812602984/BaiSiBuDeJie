//
//  BSAddTagToolBar.m
//  百思不得姐
//
//  Created by mac on 2017/5/12.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSAddTagToolBar.h"
#import "BSAddTagViewController.h"

@interface BSAddTagToolBar()

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) UIButton *addButton;

@property (strong, nonatomic) NSMutableArray *tagLabels;

@end

static const CGFloat margin = 5;
@implementation BSAddTagToolBar

- (NSMutableArray *)tagLabels
{
    if (_tagLabels == nil) {
        _tagLabels = [NSMutableArray array];
    }
    return _tagLabels;
}

+ (instancetype)toolBar
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    addButton.size = [addButton currentImage].size;
    addButton.x = BSTopicCellMargin;
    [self.topView addSubview:addButton];
    self.addButton = addButton;
}

- (void)addButtonClick
{
    BSAddTagViewController *tagVC = [[BSAddTagViewController alloc] init];
    __weak typeof(self) wself = self;
    [tagVC setTagsBlock:^(NSArray *tags){
        [wself createTagLabels:tags];
    }];
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [(UINavigationController *)(rootVC.presentedViewController) pushViewController:tagVC animated:YES];
}

- (void)createTagLabels:(NSArray *)tags
{
    for (int i = 0; i < tags.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor blueColor];
        label.font = [UIFont systemFontOfSize:14];
        label.text = tags[i];
        [label sizeToFit];
        label.height = 30;

        [self.tagLabels addObject:label];
        [self.topView addSubview:label];
    }
    [self updateTagLabelFrame];
}

- (void)updateTagLabelFrame
{
    for (int i = 0; i < self.tagLabels.count; i++) {
        if (i == 0) {
            UILabel *label = self.tagLabels.firstObject;
            label.x = margin;
            label.y = margin;
            
        }else {
            UILabel *lastLabel = self.tagLabels[i-1];
            UILabel *label = self.tagLabels[i];
            CGFloat width = self.topView.width - CGRectGetMaxX(lastLabel.frame) - margin;
            if (width < label.width) {
                label.x = margin;
                label.y = CGRectGetMaxY(lastLabel.frame) + margin;
            }else {
                label.x = CGRectGetMaxX(lastLabel.frame) + margin;
                label.y = lastLabel.y;
            }
        }

    }

    UILabel *label = self.tagLabels.lastObject;
    CGFloat width = self.topView.width - CGRectGetMaxX(label.frame) - margin;
    if(width < self.addButton.width) {
        self.addButton.x = margin;
        self.addButton.y = CGRectGetMaxY(label.frame) + margin;
    }else{
        self.addButton.x = CGRectGetMaxX(label.frame) + margin;
        self.addButton.y = label.y;
    }
}

@end
