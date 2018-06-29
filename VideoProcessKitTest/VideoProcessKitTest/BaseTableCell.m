//
//  BaseTableCell.m
//  OTS
//
//  Created by pidi on 2017/11/23.
//  Copyright © 2017年 Peter Hu. All rights reserved.
//

#import "BaseTableCell.h"

@interface BaseTableCell ()

@property(nonatomic,strong) UIColor *normalBackColor;
@property(nonatomic,assign) BOOL selectionColorFlag;

@end

@implementation BaseTableCell



-(void)setHightlightedStateEnable:(BOOL)isEnable{
    _selectionColorFlag = !isEnable;
}


-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if ([self isRemoveSelectionColor])return;
    if (_selectionColorFlag)return;
    if (highlighted) {
        _normalBackColor = self.backgroundColor;
        self.backgroundColor = [self getHightedColor];
    }
    else
    {
        if (_normalBackColor) {
            self.backgroundColor = _normalBackColor;
        }
    }
}


-(UIColor *)getHightedColor {
    return  [UIColor colorWithRed:0.7 green:0.9 blue:0.9 alpha:1.0];
}

-(BOOL)isRemoveSelectionColor{
    return false;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
