//
//  ImageTitleButton.h
//  CommonLibrary
//
//  Created by Alexi on 3/21/14.
//  Copyright (c) 2014 Alexi. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 图片标题按钮协议
 */
@protocol MenuAbleItem;

typedef void (^MenuAction)(id<MenuAbleItem> menu);
typedef void (^MenuHighlightedAction)(id<MenuAbleItem> menu,BOOL isHighted);

@protocol MenuAbleItem <NSObject>


- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon action:(MenuAction)action;

@optional
- (NSString *)title;
- (UIImage *)icon;
- (void)menuAction;
- (NSInteger)tag;
- (void)setTag:(NSInteger)tag;

@optional
- (UIColor *)foreColor;

@end



/**
 按钮的数据模型
 */
@interface MenuItem : NSObject<MenuAbleItem>
{
@protected
    NSString    *_title;
    UIImage     *_icon;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, copy) MenuAction action;

@end



/**
 带有block的普通菜单按钮
 */
@interface MenuButton : UIButton<MenuAbleItem>

@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, copy) NSString *title;

- (instancetype)initWithTitle:(NSString *)title action:(MenuAction)action;

- (instancetype)initWithBackground:(UIImage *)icon action:(MenuAction)action;

- (instancetype)initWithMenu:(MenuItem *)item;

- (void)setClickAction:(MenuAction)action;

- (void)setHighlightedPressAction:(MenuHighlightedAction)action;

// protected
- (void)onClick:(id)sender;

@end




typedef enum
{
    EImageTopTitleBottom,
    ETitleTopImageBottom,
    EImageLeftTitleRight,
    ETitleLeftImageRight,
    
    EImageLeftTitleRightLeft,
    EImageLeftTitleRightCenter,
    
    ETitleLeftImageRightCenter,
    ETitleLeftImageRightLeft,
    
    EFitTitleLeftImageRight, // 根据内容调整

    
}ImageTitleButtonStyle;




/**
 图片文字菜单
 */
@interface ImageTitleButton : MenuButton
{
@protected
    UIEdgeInsets _margin;
    CGSize _padding;
    CGSize _imageSize;
    ImageTitleButtonStyle _style;
}

@property (nonatomic, assign) UIEdgeInsets margin;
@property (nonatomic, assign) CGSize padding;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, assign) ImageTitleButtonStyle style;

- (instancetype)initWithStyle:(ImageTitleButtonStyle)style;

- (instancetype)initWithStyle:(ImageTitleButtonStyle)style maggin:(UIEdgeInsets)margin;

- (instancetype)initWithStyle:(ImageTitleButtonStyle)style maggin:(UIEdgeInsets)margin padding:(CGSize)padding;

- (void)setMyTintColor:(UIColor *)color;

- (void)setDisableHighted:(BOOL)isDisabled;

@end


@interface UIImage (ImageBtnTintColor)

// tint只对里面的图案作更改颜色操作
- (UIImage *)imageWithTintColor:(UIColor *)tintColor;
- (UIImage *)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;
- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor;

@end


@interface UILabel (ImageTitleCommon)


+ (instancetype)label;

+ (instancetype)labelWithTitle:(NSString *)title;

// 已知区域重新调整
- (CGSize)contentSize;

// 不知区域，通过其设置区域
- (CGSize)textSizeIn:(CGSize)size;

//- (void)layoutInContent;

@end


@interface InsetLabel : UILabel

@property (nonatomic, assign) UIEdgeInsets contentInset;

@end
