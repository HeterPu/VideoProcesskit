//
//  BaseTableCell.h
//  OTS
//
//  Created by pidi on 2017/11/23.
//  Copyright © 2017年 Peter Hu. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface BaseTableCell : UITableViewCell



/**
 设置是否开启禁用高亮

 @param isEnable 开启
 */
-(void)setHightlightedStateEnable:(BOOL)isEnable;


#pragma mark -- private

/**
 获取高亮的颜色
 @return 颜色
 */
-(UIColor *)getHightedColor;


/**
 是否隐藏高亮状态

 @return 默认不隐藏
 */
-(BOOL)isRemoveSelectionColor;

@end
