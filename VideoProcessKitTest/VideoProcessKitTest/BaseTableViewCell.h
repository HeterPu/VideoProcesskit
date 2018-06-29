//
//  BaseTableViewCell.h
//  YanHuangDLT
//
//  Created by Peter on 14/11/2016.
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableCell.h"

@interface BaseTableViewCell : BaseTableCell


+(instancetype)cellWithTableView:(UITableView *)tableview;




#pragma mark - 受保护的方法，交给子类重写


/**
 初始化工作
 */
-(void)initializationWork;

/**
 cell的重用标识符，默认返回的标识符为类名

 @return 字符串类型
 */
+(NSString *)reuserIdentifier;

/**
 是否NIB加载，默认选用NIB加载

 @return 返回的BOOL值
 */
+(BOOL)isLoadFromNIB;



@end
