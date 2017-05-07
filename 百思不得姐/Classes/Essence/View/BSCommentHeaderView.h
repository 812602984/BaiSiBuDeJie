//
//  BSCommentHeaderView.h
//  百思不得姐
//
//  Created by mac on 2017/4/27.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSCommentHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) NSString *title;

+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

@end
