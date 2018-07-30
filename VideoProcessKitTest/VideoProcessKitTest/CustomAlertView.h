//
//  CustomAlertView.h
//  AlertView
//
//  Created by PeterHu on 16/4/12.
//  Copyright © 2016年 PeterHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageTitleButton.h"


/**
 点击弹框灰色区域视图是否消失

 - TapBlankDismiss: 点击消失，默认为消失
 - TapBlankNoDismiss: 点击不消失
 */
typedef NS_ENUM(NSUInteger, TapBlankDismissType) {
    TapBlankDismiss = 1 ,
    TapBlankNoDismiss,
};


/**
 点击弹框灰色区域视图是否消失
 
 - TapBlankDismiss: 点击消失，默认为消失
 - TapBlankNoDismiss: 点击不消失
 */
typedef NS_ENUM(NSUInteger, Custom_SelectionType) {
    Custom_SelectionTypeSingle = 0,
    Custom_SelectionTypeMulti,
};


/**
 弹框样式

 - CustomAlertStyleTips: 提示弹框样式
 - CustomAlertStyleInput: 可以输入的弹框样式
 */
typedef NS_ENUM(NSUInteger, CustomAlertStyle) {
    CustomAlertStyleTips = 1 ,
    CustomAlertStyleInput,
};



/**
 传入参数为单个NSString 的block

 @param str 传入str
 */
typedef void (^dispatch_block_String)(NSString * str);
typedef void(^presented_block)(int section,int row);

typedef void(^selfview_block)(UIView * view,CGFloat height);


@interface CustomAlertView : UIView




/**
 可以改变蒙版的颜色，透明度，若要透明设置color 为clearcolor，不要设置alpha 为 0,因为alpha < 0.1 ,不响应点击。

 @param content 内容视图
 @param type 点击消失类型
 @param color 蒙版颜色
 @param alpha 蒙版透明度
 @param duration 蒙版出现的时间
 @param dismissBlock 取消的回调
 @return 返回的实例对象
 */
+(CustomAlertView *)popViewWith:(UIView *)content
                    disMissType:(TapBlankDismissType)type
                   mengBanColor:(UIColor *)color
                   mengbanAlpha:(NSNumber *)alpha
                   animationTime:(NSNumber *)duration
                   dismissBlock:(dispatch_block_t)dismissBlock;


/**
 自定义弹窗视图方法

 @param titleV 头部视图，最低高度为40
 @param content 内容视图，高度范围为40-300
 @param bottomView 底部视图，可为空
 @param type 弹出框类型，默认为点击空白可退出
 @param leftBTN 左侧按钮，为空为单向选择
 @param rightBTN 右侧按钮，最小高度为40
 @param leftBlock 左侧按钮点击Block
 @param rightBlock 右侧按钮点击Block
 @param dismissBlock 点击空白区域Block
 */
+(instancetype)popViewWithTitleView:(UIView *)titleV
             contentView:(UIView *)content
              bottomView:(UIView*)bottomView
             disMissType:(TapBlankDismissType)type
              leftButton:(UIButton *)leftBTN
             rightButton:(UIButton *)rightBTN
               leftBlock:(dispatch_block_t )leftBlock
              rightBlock:(dispatch_block_t)rightBlock
            dismissBlock:(dispatch_block_t)dismissBlock;




/**
 常用样式便利类方法

 @param style 输入样式或者提示样式
 @param title 标题
 @param placeHolder 如果提示样式的话就是提示内容，否则即为Text的PlaceHolder
 @param leftTitle 左侧按钮标题
 @param rightTitle 右侧按钮标题
 @param type 点击空白区域是否消失
 @param leftBlock 左侧按钮点击Block
 @param rightBlock 右侧按钮点击Block
 @param dismissBlock 点击空白Block
 */
+(instancetype)popWithStyle:(CustomAlertStyle)style
              title:(NSString *)title
contentOrPlaceHolder:(NSString *)placeHolder
          leftTitle:(NSString *)leftTitle
         rightTitle:(NSString *)rightTitle
        disMissType:(TapBlankDismissType)type
          leftBlock:(dispatch_block_String )leftBlock
         rightBlock:(dispatch_block_String)rightBlock
       dismissBlock:(dispatch_block_String)dismissBlock;



/**
 底部弹出视图

 @param str title 传 nil 没有标题
 @param arra 二维数组 传 MenuItem 对象
 @param click 点击的目录
 */
+(void)presentedWithTitle:(NSString *)str
                menuArray:(NSArray<NSArray<id<MenuAbleItem>> *>*)arra
               clickBlock:(presented_block)click;



+(CustomAlertView *)presentedWithTitle:(NSString *)str
                   scrollableMenuArray:(NSArray<NSString *> *)arra
                      preSeletionIndex:(NSNumber *)index
                            clickBlock:(presented_block)click;

/**
 显示成功信息

 @param str 信息
 @param delay 世界
 @param block 回调
 */
+(void)showSuccessMessage:(NSString *)str
                    delay:(NSTimeInterval)delay
                 complete:(void(^)(void))block;



/**
 显示失败信息
 
 @param str 信息
 @param delay 世界
 @param block 回调
 */
+(void)showFailMessage:(NSString *)str
                 delay:(NSTimeInterval)delay
              complete:(void(^)(void))block;





/**
 自动消失提示信息

 @param str 提示内容
 @param color 提示标题颜色
 @param iconName 图标名称
 @param delay 延迟时间
 @param block 提示结束回调
 */
+(void)showMessage:(NSString *)str
      messageColor:(UIColor *)color
          iconName:(NSString *)iconName
             delay:(NSTimeInterval)delay
          complete:(void(^)(void))block;




/**
 自动消失提示信息 
 @param str 提示内容
 @param color 提示标题颜色
 @param iconName 图标名称
 @param delay 延迟时间
 @param block 提示结束回调
 */
+(void)showMessage:(NSString *)str
      messageColor:(UIColor *)color
          iconName:(NSString *)iconName
             delay:(NSTimeInterval)delay
   backGroundColor:(UIColor *)backColor
          complete:(void(^)(void))block;


/**
 获取弹框的宽度值

 @return 返回弹框的高度
 */
+ (CGFloat)getCustomAlertViewWidth;



-(void)setKeyBoardShow:(selfview_block)show;

-(void)setKeyBoardHide:(selfview_block)hide;

/**
 人工取消弹窗
 */
- (void)dismissAlert;


/**
 获取输入框的textField
 @return textField
 */
-(UITextField *)getInputTextField;

@end
