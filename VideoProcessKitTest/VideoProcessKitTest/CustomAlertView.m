  //
//  CustomAlertView.h
//  AlertView
//
//  Created by PeterHu on 16/4/12.
//  Copyright © 2016年 PeterHu. All rights reserved.
//

#import "CustomAlertView.h"

#define WeakObject(obj)     autoreleasepool{} __weak    typeof(obj) Weak##obj   = obj;
// 屏幕高度
#define ScreenHeight ([[UIScreen mainScreen] bounds].size.height)
// 屏幕宽度
#define ScreenWidth ([[UIScreen mainScreen] bounds].size.width)


#define kRGBA(R, G, B, A)   [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define kRGB(R, G, B)       kRGBA(R, G, B, 1)
//#import "UILabel+ChangeLineSpaceAndWordSpace.h"


// Global Setting
#define _K_SCREEN_WIDTH ([[UIScreen mainScreen ] bounds ].size.width)
#define _K_SCREEN_HEIGHT ([[UIScreen mainScreen ] bounds ].size.height)

#define kAlertWidth (70  * _K_SCREEN_WIDTH/100)
#define kTitleWidth (kAlertWidth-16-32)
#define kContentWidth (kAlertWidth + 10)

#define kContentMaxHeight 400.0f
#define kContentMinHeight 40.0f

#define kTitleTopMargin 5.0f
#define kHeaderHeight 40.0f

#define kSingleButtonWidth (160.0f * _K_SCREEN_WIDTH/320)
#define kCoupleButtonWidth (107.0f * _K_SCREEN_WIDTH/320)

#define kButtonHeight 30.0f
#define kButtonBottomMargin 0.0f

#define kContentBottomMargin 0.0f
#define kContentTopMargin 0.0f

#define KCoupleButtonPadding 0.0f
#define color(r,g,b,a)   [UIColor colorWithRed: ( r / 255.0) green:( g / 255.0) blue:( b / 255.0) alpha:( a / 1.0)]

#define KkeyBoard_show_offset -50.0f


#define KAlertView_Back_Color [UIColor whiteColor]


// Alert Title Style
#define Ktitle_Font   [UIFont systemFontOfSize:20.0];
#define ktitle_color  color(38,38,38,1)


// Alert Tips Setting

#define Ktips_Content_Left_Padding  15
#define Ktips_Content_height  (kAlertWidth * 14 / 24  - 80.0f)
#define KTips_Font   [UIFont systemFontOfSize:14.0];
#define Ktips_textColor color(66,66,66,1);
#define Ktips_offset  -16.0f


// Alert TextFeild setting
#define Kinput_Content_Left_Padding  15.0f
#define Kinput_Content_height  90.0f
#define Kinput_offset  20.0f

// AlertBtn Style
#define kalert_leftBtn_BackGroundColor [UIColor whiteColor]
#define kalert_rightBtn_BackGroundColor color(41,201,202,1)
#define kalert_singleBTN_BackGroundColor [UIColor whiteColor]
#define kalert_btn_left_tintColor color(41,201,202,1)
#define kalert_btn_right_tintColor [UIColor whiteColor]
#define kalert_btn_right_single_tintColor color(41,201,202,1)
#define kalert_btn_font  [UIFont systemFontOfSize:14];

//presented view configure

#define kPresented_section_padding 5.0
#define kPresented_row_height 60.0
#define kPresented_title_height 60.0

#define kAnimationInDuration 0.5
#define kAnimationOutDuration 0.25


// 修正
#define KcouplePadding 15

@interface CustomAlertView ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) BOOL leftLeave;
@property (nonatomic, strong) UIView *lbTitle;
@property (nonatomic, strong) UIView *tvContent;
@property (nonatomic, strong) UIView *tvBottom;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *backImageView;
@property (nonatomic, copy) NSString * inputStr;

@property (nonatomic, copy) dispatch_block_t leftBlock;
@property (nonatomic, copy) dispatch_block_t rightBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock;

@property (nonatomic,copy) presented_block presen_Block;

@property(nonatomic,assign) BOOL isLeftBTNExist;
@property(nonatomic,assign)TapBlankDismissType dismissType;

@property(nonatomic,strong)NSNumber *backGroundAlpha;
@property(nonatomic,strong)NSNumber *aniamationDuration;
@property(nonatomic,strong)UIColor *mengBanColor;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSArray *tableDataArra;
@property(nonatomic,strong)NSNumber *preSelectedIndex;

@property(nonatomic,copy) selfview_block keyBoardShow;
@property(nonatomic,copy) selfview_block keyBoardHide;


@property (nonatomic, copy) dispatch_block_String leftBlock_S;
@property (nonatomic, copy) dispatch_block_String rightBlock_S;
@property (nonatomic, copy) dispatch_block_String dismissBlock_S;


//输入的TextView
@property(nonatomic,strong) UITextField *inputTextField;

@end


@implementation CustomAlertView{
}

+ (instancetype)popViewWithTitleView:(UIView *)titleV
             contentView:(UIView *)content
              bottomView:(UIView*)bottomView
             disMissType:(TapBlankDismissType)type
         leftButton:(UIButton *)leftBTN
        rightButton:(UIButton *)rightBTN
               leftBlock:(dispatch_block_t)leftBlock
              rightBlock:(dispatch_block_t)rightBlock
            dismissBlock:(dispatch_block_t)dismissBlock
{
    CustomAlertView* popView=[CustomAlertView new];
   
    popView.leftBlock=leftBlock;
    popView.rightBlock=rightBlock;
    popView.dismissBlock=dismissBlock;
    
    popView.backgroundColor = KAlertView_Back_Color;
    popView.lbTitle = titleV;

    CGFloat titleHeight = kHeaderHeight;
    if (titleV.frame.size.height > kHeaderHeight){
        titleHeight = titleV.frame.size.height;
    }
    titleV.frame = CGRectMake(0, 0, kAlertWidth, titleHeight);
    popView.dismissType = type;
    [popView addSubview:popView.lbTitle];

    
    CGFloat contentTopMargin = titleHeight + kContentTopMargin;
    if (!titleV) {
        contentTopMargin = 0;
    }
    
    if (!rightBTN) {
        popView.backgroundColor = content.backgroundColor;
        content.frame =CGRectMake(0,contentTopMargin, content.frame.size.width, content.frame.size.height);
    }
    else
    {
    content.frame =CGRectMake(0,contentTopMargin, kAlertWidth, content.frame.size.height);
    }
    CGRect frame= content.frame;
    frame.size.height=MAX(content.frame.size.height, kContentMinHeight);
    frame.size.height=MIN(content.frame.size.height, kContentMaxHeight);
    
    if (!rightBTN) {
        frame.size.height = content.frame.size.height;
    }
    content.frame=frame;
    popView.tvContent = content;
    [popView addSubview:content];
    
    CGRect leftBtnFrame;
    CGRect rightBtnFrame;
    
    CGFloat btnHeight = kButtonHeight;
    if (rightBTN.frame.size.height > kButtonHeight){btnHeight = rightBTN.frame.size.height;}
    if (!leftBTN) {
        popView.isLeftBTNExist = NO;
        rightBtnFrame = CGRectMake(0, CGRectGetMaxY(popView.tvContent.frame)+kContentBottomMargin, kAlertWidth, btnHeight);
        popView.rightBtn = rightBTN;
        popView.rightBtn.frame = rightBtnFrame;
        rightBTN.titleLabel.font = kalert_btn_font;
    }else {
        popView.isLeftBTNExist = YES;
        leftBtnFrame = CGRectMake(KcouplePadding, CGRectGetMaxY(popView.tvContent.frame)+kContentBottomMargin, (kAlertWidth - 3 * KcouplePadding - KCoupleButtonPadding) / 2, btnHeight);
        rightBtnFrame = CGRectMake(CGRectGetMaxX(leftBtnFrame) + KCoupleButtonPadding + KcouplePadding, CGRectGetMaxY(popView.tvContent.frame)+kContentBottomMargin, (kAlertWidth -  3 * KcouplePadding - KCoupleButtonPadding) / 2, btnHeight);
        popView.leftBtn = leftBTN;
        popView.rightBtn = rightBTN;
        popView.leftBtn.frame = leftBtnFrame;
        popView.rightBtn.frame = rightBtnFrame;
        leftBTN.titleLabel.font = kalert_btn_font;
        rightBTN.titleLabel.font = kalert_btn_font;
    }

    
    [popView.leftBtn addTarget:popView action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [popView.rightBtn addTarget:popView action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    popView.leftBtn.layer.masksToBounds = popView.rightBtn.layer.masksToBounds = YES;
    [popView addSubview:popView.leftBtn];
    [popView addSubview:popView.rightBtn];

    bottomView.frame =CGRectMake(0, CGRectGetMaxY(popView.rightBtn.frame)+kContentTopMargin, kAlertWidth, bottomView.frame.size.height);
    popView.tvBottom = bottomView;
    [popView addSubview:bottomView];
    [popView resetFrame];
    [popView show];
    return popView;
}




+(CustomAlertView *)popViewWith:(UIView *)content  disMissType:(TapBlankDismissType)type mengBanColor:(UIColor *)color mengbanAlpha:(NSNumber *)alpha animationTime:(NSNumber *)duration dismissBlock:(dispatch_block_t)dismissBlock {
    
    dispatch_block_t leftBlock;
    dispatch_block_t rightBlock;
    UIView *titleV;
    UIButton *rightBTN;
    UIButton *leftBTN;
    UIView *bottomView;
    
    CustomAlertView* popView=[CustomAlertView new];
    popView.aniamationDuration = duration;
    popView.mengBanColor = color;
    popView.backGroundAlpha = alpha;
    
    popView.leftBlock=leftBlock;
    popView.rightBlock=rightBlock;
    popView.dismissBlock=dismissBlock;
    
    popView.backgroundColor = KAlertView_Back_Color;
    popView.lbTitle = titleV;
    
    CGFloat titleHeight = kHeaderHeight;
    if (titleV.frame.size.height > kHeaderHeight){
        titleHeight = titleV.frame.size.height;
    }
    titleV.frame = CGRectMake(0, 0, kAlertWidth, titleHeight);
    popView.dismissType = type;
    [popView addSubview:popView.lbTitle];
    
    
    CGFloat contentTopMargin = titleHeight + kContentTopMargin;
    if (!titleV) {
        contentTopMargin = 0;
    }
    
    if (!rightBTN) {
        popView.backgroundColor = content.backgroundColor;
        content.frame =CGRectMake(0,contentTopMargin, content.frame.size.width, content.frame.size.height);
    }
    else
    {
        content.frame =CGRectMake(0,contentTopMargin, kAlertWidth, content.frame.size.height);
    }
    CGRect frame= content.frame;
    frame.size.height=MAX(content.frame.size.height, kContentMinHeight);
    frame.size.height=MIN(content.frame.size.height, kContentMaxHeight);
    
    if (!rightBTN) {
        frame.size.height = content.frame.size.height;
    }
    content.frame=frame;
    popView.tvContent = content;
    [popView addSubview:content];
    
    CGRect leftBtnFrame;
    CGRect rightBtnFrame;
    
    CGFloat btnHeight = kButtonHeight;
    if (rightBTN.frame.size.height > kButtonHeight){btnHeight = rightBTN.frame.size.height;}
    if (!leftBTN) {
        popView.isLeftBTNExist = NO;
        rightBtnFrame = CGRectMake(0, CGRectGetMaxY(popView.tvContent.frame)+kContentBottomMargin, kAlertWidth, btnHeight);
        popView.rightBtn = rightBTN;
        popView.rightBtn.frame = rightBtnFrame;
        
        rightBTN.titleLabel.font = kalert_btn_font;
        
    }else {
        popView.isLeftBTNExist = YES;
        leftBtnFrame = CGRectMake(0, CGRectGetMaxY(popView.tvContent.frame)+kContentBottomMargin, (kAlertWidth - KCoupleButtonPadding) / 2, btnHeight);
        rightBtnFrame = CGRectMake(CGRectGetMaxX(leftBtnFrame) + KCoupleButtonPadding, CGRectGetMaxY(popView.tvContent.frame)+kContentBottomMargin, (kAlertWidth - KCoupleButtonPadding) / 2, btnHeight);
        popView.leftBtn = leftBTN;
        popView.rightBtn = rightBTN;
        popView.leftBtn.frame = leftBtnFrame;
        popView.rightBtn.frame = rightBtnFrame;
         leftBTN.titleLabel.font = kalert_btn_font;
         rightBTN.titleLabel.font = kalert_btn_font;
    }
    
    
    [popView.leftBtn addTarget:popView action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [popView.rightBtn addTarget:popView action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    popView.leftBtn.layer.masksToBounds = popView.rightBtn.layer.masksToBounds = YES;
    [popView addSubview:popView.leftBtn];
    [popView addSubview:popView.rightBtn];
    
    bottomView.frame =CGRectMake(0, CGRectGetMaxY(popView.rightBtn.frame)+kContentTopMargin, kAlertWidth, bottomView.frame.size.height);
    popView.tvBottom = bottomView;
    [popView addSubview:bottomView];
    [popView resetFrame];
    [popView show];
    return popView;

}


+(instancetype)popWithStyle:(CustomAlertStyle)style
              title:(NSString *)title
contentOrPlaceHolder:(NSString *)placeHolder
          leftTitle:(NSString *)leftTitle
         rightTitle:(NSString *)rightTitle
        disMissType:(TapBlankDismissType)type
          leftBlock:(dispatch_block_String)leftBlock
         rightBlock:(dispatch_block_String)rightBlock
       dismissBlock:(dispatch_block_String)dismissBlock {

    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 50)];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = ktitle_color;
    titleLabel.font = Ktitle_Font;
    UIView *contentV = [[UIView alloc]init];
    UITextField *textF = [[UITextField  alloc]init];
    
    UIView *btnLine = [[UIView  alloc]init];
    if (style == CustomAlertStyleTips) {
        contentV.frame = CGRectMake(0, 0, 0, Ktips_Content_height);
        UILabel *contentL = [[UILabel alloc]initWithFrame:CGRectMake(Ktips_Content_Left_Padding, Ktips_offset,kAlertWidth - 2 * Ktips_Content_Left_Padding, Ktips_Content_height)];
        contentL.numberOfLines = 4;
        contentL.text = placeHolder;
        
        // 设置行间距和字间距
//        [UILabel changeLineSpaceForLabel:contentL WithSpace:3];
        
        contentL.font = KTips_Font;
        contentL.textColor = Ktips_textColor;
        contentL.textAlignment = NSTextAlignmentCenter;
        [contentV addSubview:contentL];
        [contentL setAdjustsFontSizeToFitWidth:true];
        btnLine.frame = CGRectMake(0, Ktips_Content_height - 0.5, kAlertWidth, 0.5);
        }
    else
    {
        contentV.frame = CGRectMake(0, 0, 0, Kinput_Content_height);
        UITextField *contentF = [[UITextField alloc]initWithFrame:CGRectMake(Kinput_Content_Left_Padding,Kinput_offset,kAlertWidth - Kinput_Content_Left_Padding * 2, 40)];
        contentF.placeholder =placeHolder;
        contentF.layer.borderColor = color(220, 220, 220, 1).CGColor;
        contentF.layer.borderWidth = 0.5f;
        contentF.layer.cornerRadius = 2;
        contentF.font = [UIFont systemFontOfSize:14.0f];
        contentF.clearButtonMode = UITextFieldViewModeAlways;
        
        UIView *leftView = [[UIView  alloc]init];
        leftView.bounds = CGRectMake(0, 0, 15, 40);
        contentF.leftView = leftView;
        contentF.leftViewMode = UITextFieldViewModeAlways;
        [contentV addSubview:contentF];
        textF = contentF;
        btnLine.frame = CGRectMake(0, Kinput_Content_height - 0.5, kAlertWidth, 0.5);
    }
    
    btnLine.hidden = true;
    
    textF.tintColor = kalert_rightBtn_BackGroundColor;
    btnLine.backgroundColor = color(220, 220, 220, 1);
    [contentV addSubview:btnLine];

    
    if (!title) {
        titleLabel.frame = CGRectMake(0, 0, 0, 0);
    }
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.tintColor = kalert_btn_left_tintColor;
    rightBtn.tintColor = kalert_btn_right_tintColor;
    
    leftBtn.layer.cornerRadius = kButtonHeight / 2;
    leftBtn.layer.borderWidth = 1;
    leftBtn.layer.borderColor = kalert_btn_left_tintColor.CGColor;
    rightBtn.layer.cornerRadius = kButtonHeight / 2;
    
    if (leftTitle) {
        [leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        [rightBtn setTitle:rightTitle forState:UIControlStateNormal];
        leftBtn.backgroundColor = kalert_leftBtn_BackGroundColor;
        rightBtn.backgroundColor = kalert_rightBtn_BackGroundColor;
    }
    else
    {
        [rightBtn setTitle:rightTitle forState:UIControlStateNormal];
        rightBtn.backgroundColor = kalert_singleBTN_BackGroundColor;
        rightBtn.tintColor = kalert_btn_right_single_tintColor;
    }
    CustomAlertView *popView = [CustomAlertView popViewWithTitleView:titleLabel contentView:contentV bottomView:nil disMissType:type leftButton:(leftTitle == nil ? nil : leftBtn) rightButton:rightBtn leftBlock:^{
       } rightBlock:^{
       } dismissBlock:^{
    }];
    
    popView.inputTextField = textF;
    popView.layer.cornerRadius = 5;
    popView.layer.masksToBounds = YES;
    popView.leftBlock_S = leftBlock;
    popView.rightBlock_S = rightBlock;
    popView.dismissBlock_S = dismissBlock;
    textF.delegate = popView;
    return popView;
}



+(void)showSuccessMessage:(NSString *)str
                    delay:(NSTimeInterval)delay
                 complete:(void(^)(void))block {
    
    CGFloat w = ScreenWidth * 0.66;
    CGFloat h = ScreenWidth * 0.4;
    CGRect rect = CGRectMake(0, 0, w, h);
    
    UIView *backV = [[UIView  alloc]init];
    backV.backgroundColor = [UIColor whiteColor];
    backV.frame = rect;
    ImageTitleButton *imageBTN = [ImageTitleButton buttonWithType:UIButtonTypeCustom];
    imageBTN.frame = CGRectMake(0, h * 0.22, w, h * 0.75);
    [imageBTN setImageSize:CGSizeMake(w * 0.20, w * 0.20)];
    [imageBTN setImage:[UIImage imageNamed:@"YHQ_isvalid"] forState:UIControlStateNormal];
    [imageBTN setTitle:str forState:UIControlStateNormal];
    [imageBTN setTitleColor:kRGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    imageBTN.titleLabel.textAlignment = NSTextAlignmentCenter;
    imageBTN.style = EImageTopTitleBottom;
    
    [backV addSubview:imageBTN];
    CustomAlertView *alertV = [CustomAlertView popViewWithTitleView:nil contentView:backV bottomView:nil disMissType:TapBlankNoDismiss leftButton:nil rightButton:nil leftBlock:^{
        
    } rightBlock:^{
        
    } dismissBlock:^{
        
    }];
    
    alertV.layer.cornerRadius = 5;
    alertV.layer.masksToBounds = YES;
    
    @WeakObject(alertV);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (block) block();
        [WeakalertV dismissAlert];
    });
}



+(void)showFailMessage:(NSString *)str
                    delay:(NSTimeInterval)delay
                 complete:(void(^)(void))block {
    
    CGFloat w = ScreenWidth * 0.66;
    CGFloat h = ScreenWidth * 0.4;
    CGRect rect = CGRectMake(0, 0, w, h);
    
    UIView *backV = [[UIView  alloc]init];
    backV.backgroundColor = [UIColor whiteColor];
    backV.frame = rect;
    ImageTitleButton *imageBTN = [ImageTitleButton buttonWithType:UIButtonTypeCustom];
    imageBTN.frame = CGRectMake(0, h * 0.22, w, h * 0.75);
    [imageBTN setImageSize:CGSizeMake(w * 0.20, w * 0.20)];
    [imageBTN setImage:[UIImage imageNamed:@"YHQ_isNovalid"] forState:UIControlStateNormal];
    [imageBTN setTitle:str forState:UIControlStateNormal];
    [imageBTN setTitleColor:kRGBA(224, 57, 61, 1) forState:UIControlStateNormal];
    imageBTN.titleLabel.textAlignment = NSTextAlignmentCenter;
    imageBTN.style = EImageTopTitleBottom;
    
    [backV addSubview:imageBTN];
    CustomAlertView *alertV = [CustomAlertView popViewWithTitleView:nil contentView:backV bottomView:nil disMissType:TapBlankNoDismiss leftButton:nil rightButton:nil leftBlock:^{
        
    } rightBlock:^{
        
    } dismissBlock:^{
        
    }];
    
    alertV.layer.cornerRadius = 5;
    alertV.layer.masksToBounds = YES;
    
    @WeakObject(alertV);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (block) block();
        [WeakalertV dismissAlert];
    });
}

/**
 自动消失提示信息
 
 @param str 提示内容
 @param iconName 图标名称
 @param delay 延迟时间
 @param block 提示结束回调
 */
+(void)showMessage:(NSString *)str
      messageColor:(UIColor *)color
          iconName:(NSString *)iconName
             delay:(NSTimeInterval)delay
          complete:(void (^)(void))block
{
    [CustomAlertView showMessage:str messageColor:color iconName:iconName delay:delay backGroundColor:[UIColor whiteColor] complete:block];
}



+(void)showMessage:(NSString *)str messageColor:(UIColor *)color iconName:(NSString *)iconName delay:(NSTimeInterval)delay backGroundColor:(UIColor *)backColor complete:(void (^)(void))block {
    if(!color) color = [UIColor blackColor];
    if (!backColor)backColor = [UIColor whiteColor];
    CGFloat w = ScreenWidth * 0.66;
    CGFloat h = ScreenWidth * 0.4;
    CGRect rect = CGRectMake(0, 0, w, h);
    
    UIView *backV = [[UIView  alloc]init];
    backV.backgroundColor = backColor;
    backV.frame = rect;
    ImageTitleButton *imageBTN = [ImageTitleButton buttonWithType:UIButtonTypeCustom];
    imageBTN.frame = CGRectMake(0, h * 0.22, w, h * 0.75);
    [imageBTN setImageSize:CGSizeMake(w * 0.20, w * 0.20)];
    [imageBTN setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
    [imageBTN setTitle:str forState:UIControlStateNormal];
    [imageBTN setTitleColor:color forState:UIControlStateNormal];
    imageBTN.titleLabel.textAlignment = NSTextAlignmentCenter;
    imageBTN.style = EImageTopTitleBottom;
    
    [backV addSubview:imageBTN];
    CustomAlertView *alertV = [CustomAlertView popViewWithTitleView:nil contentView:backV bottomView:nil disMissType:TapBlankNoDismiss leftButton:nil rightButton:nil leftBlock:^{
        
    } rightBlock:^{
        
    } dismissBlock:^{
        
    }];
    
    alertV.layer.cornerRadius = 5;
    alertV.layer.masksToBounds = YES;
    
    @WeakObject(alertV);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (block) block();
        [WeakalertV dismissAlert];
    });
}



+(void)presentedWithTitle:(NSString *)str
                menuArray:(NSArray<NSArray<id<MenuAbleItem>> *>*)arra
               clickBlock:(presented_block)click {
    NSArray *array = arra;
    UIView *contentV = [[UIView  alloc]init];
    NSInteger sectionCount = arra.count;
    CGFloat lastRowHeight = 0;
    for (int i = 0; i < sectionCount; i++) {
        if(i > 0){
            UIView *paddingV = [[UIView alloc]init];
            paddingV.bounds = CGRectMake(0, 0, ScreenWidth, kPresented_section_padding);
            paddingV.center = CGPointMake( ScreenWidth/2, kPresented_section_padding / 2 + lastRowHeight);
            paddingV.backgroundColor = kRGBA(15, 16, 17, 1);
            [contentV addSubview:paddingV];
            lastRowHeight = paddingV.center.y + kPresented_section_padding / 2;
        }
        NSArray *rowArra = array[i];
        for (int j = 0; j < rowArra.count; j++) {
            MenuItem *menu = array[i][j];
            
            ImageTitleButton *btn = [[ImageTitleButton  alloc]initWithMenu:menu];
            

            if(!menu.icon){
                btn.style = ETitleLeftImageRightCenter;
//                btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            }else{
            btn.style = EImageLeftTitleRightCenter;
            btn.padding = CGSizeMake(20, 0);
            }
            btn.bounds = CGRectMake(0, 0, ScreenWidth, kPresented_row_height);
            btn.center = CGPointMake(ScreenWidth / 2,lastRowHeight + kPresented_row_height / 2);
            [btn setTitle:menu.title forState:UIControlStateNormal];
            [btn setImage:menu.icon forState:UIControlStateNormal];
            [btn setAdjustsImageWhenHighlighted:false];
//            [btn setAdjustsImageWhenDisabled:false];
            [btn setImageSize:CGSizeMake(30, 30)];
         
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithWhite:0.5 alpha:1.0] forState:UIControlStateHighlighted];
            btn.titleLabel.font = [UIFont systemFontOfSize:18.0];
            lastRowHeight = btn.center.y + kPresented_row_height / 2;
            UIView *padding = [[UIView  alloc]init];
            padding.bounds = CGRectMake(0, 0, ScreenWidth, 0.5);
            padding.center = CGPointMake((ScreenWidth)/ 2,lastRowHeight + 1);
            padding.backgroundColor = kRGBA(22, 21, 26, 1);
            [contentV addSubview:btn];
            [contentV addSubview:padding];
            btn.tag = i * 10 + j;
        }
    }
    contentV.bounds = CGRectMake(0, 0, ScreenWidth, lastRowHeight);

    
    ImageTitleButton *backGroundV = [[ImageTitleButton  alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
    UIView *contentV_Title = [[UIView  alloc]init];
    contentV_Title.backgroundColor = kRGB(22, 24, 30);
    UILabel *titleL = [[UILabel  alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, kPresented_title_height)];
    titleL.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.font = [UIFont systemFontOfSize:15.0];
    
    UIView *padding = [[UIView  alloc]init];
    padding.bounds = CGRectMake(0, 0, ScreenWidth, 0.5);
    padding.center = CGPointMake((ScreenWidth)/ 2,kPresented_title_height - 1);
    padding.backgroundColor = kRGB(22, 24, 30);
    [titleL addSubview:padding];
    
    
    contentV.center = CGPointMake(ScreenWidth / 2,contentV.bounds.size.height /  2);
    contentV_Title.frame = CGRectMake(0, ScreenHeight - contentV.bounds.size.height, ScreenWidth, contentV.bounds.size.height);
    if (str) {
        titleL.text = str;
        [contentV_Title addSubview:titleL];
        contentV.center = CGPointMake(ScreenWidth / 2, contentV.bounds.size.height / 2 + kPresented_title_height);
        contentV_Title.frame = CGRectMake(0, ScreenHeight - contentV.bounds.size.height - kPresented_title_height, ScreenWidth, contentV.bounds.size.height + kPresented_title_height);
    }
    
    
    CGPoint center_B = contentV_Title.center;
    center_B.y += contentV_Title.bounds.size.height;
    contentV_Title.center = center_B;
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint center_B = contentV_Title.center;
        center_B.y -= contentV_Title.bounds.size.height;
        contentV_Title.center = center_B;
    }];
    
    [contentV_Title addSubview:contentV];
    [backGroundV addSubview:contentV_Title];
    contentV.backgroundColor = kRGB(22, 24, 30);
    
   CustomAlertView *alertV = [CustomAlertView popViewWithTitleView:nil contentView:backGroundV bottomView:nil disMissType:TapBlankDismiss leftButton:nil rightButton:nil leftBlock:nil rightBlock:nil dismissBlock:^{
       click((int)-1,(int)-1);
   }];
    alertV.presen_Block = click;
    
    @WeakObject(alertV);
    for (UIView *view in contentV.subviews) {
        if ([view isKindOfClass:[ImageTitleButton class]]) {
            NSInteger i = view.tag / 10;
            NSInteger j = view.tag % 10;
            ImageTitleButton *dismiss = (ImageTitleButton *) view;

            [dismiss setClickAction:^(id<MenuAbleItem> menu) {
                [UIView animateWithDuration:0.3 animations:^{
                    CGPoint center_B = contentV_Title.center;
                    center_B.y += contentV_Title.bounds.size.height;
                    contentV_Title.center = center_B;
                } completion:^(BOOL finished) {
                    [WeakalertV dismissAlert];
                    click((int)i,(int)j);
                }];
            }];

        }
    }
       [backGroundV setClickAction:^(id<MenuAbleItem> menu) {
        
       [UIView animateWithDuration:0.3 animations:^{
           CGPoint center_B = contentV_Title.center;
           center_B.y += contentV_Title.bounds.size.height;
           contentV_Title.center = center_B;
       } completion:^(BOOL finished) {
            [WeakalertV dismissAlert];
       }];
    }];
}



+(CustomAlertView *)presentedWithTitle:(NSString *)str
                   scrollableMenuArray:(NSArray<NSString *> *)arra
                      preSeletionIndex:(NSNumber *)index
                            clickBlock:(presented_block)click{
    UIView *contentV = [[UIView  alloc]init];
    contentV.bounds = CGRectMake(0, 0, ScreenWidth, ScreenWidth * 3 / 4);
    
    UITableView *tableV =[[UITableView alloc]initWithFrame:contentV.bounds style:UITableViewStylePlain];
    tableV.backgroundColor = kRGBA(230, 230, 230, 1);
    [contentV addSubview:tableV];
    
    ImageTitleButton *backGroundV = [[ImageTitleButton  alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
    UIView *contentV_Title = [[UIView  alloc]init];
    contentV_Title.backgroundColor = [UIColor whiteColor];
    UILabel *titleL = [[UILabel  alloc]initWithFrame:CGRectMake(15, 0, ScreenWidth - 15, kPresented_title_height)];
    titleL.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
    titleL.font = [UIFont systemFontOfSize:18.0];
    
    contentV.center = CGPointMake(ScreenWidth / 2,contentV.bounds.size.height /  2);
    contentV_Title.frame = CGRectMake(0, ScreenHeight - contentV.bounds.size.height, ScreenWidth, contentV.bounds.size.height);
    if (str) {
        titleL.text = str;
        [contentV_Title addSubview:titleL];
        contentV.center = CGPointMake(ScreenWidth / 2, contentV.bounds.size.height / 2 + kPresented_title_height);
        contentV_Title.frame = CGRectMake(0, ScreenHeight - contentV.bounds.size.height - kPresented_title_height, ScreenWidth, contentV.bounds.size.height + kPresented_title_height);
    }

    CGPoint center_B = contentV_Title.center;
    center_B.y += contentV_Title.bounds.size.height;
    contentV_Title.center = center_B;
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint center_B = contentV_Title.center;
        center_B.y -= contentV_Title.bounds.size.height;
        contentV_Title.center = center_B;
    }];
    
    [contentV_Title addSubview:contentV];
    [backGroundV addSubview:contentV_Title];
    contentV.backgroundColor = [UIColor whiteColor];
    
    CustomAlertView *alertV = [CustomAlertView popViewWithTitleView:nil contentView:backGroundV bottomView:nil disMissType:TapBlankDismiss leftButton:nil rightButton:nil leftBlock:nil rightBlock:nil dismissBlock:^{
        click((int)-1,(int)-1);
    }];
    alertV.presen_Block = click;
    
    @WeakObject(alertV);
    
    alertV.tableView = tableV;
    tableV.dataSource = alertV;
    tableV.delegate = alertV;
    alertV.tableDataArra = arra;
    alertV.preSelectedIndex = index;
    tableV.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.01)];
     tableV.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.01)];
    [backGroundV setClickAction:^(id<MenuAbleItem> menu) {
        
        [UIView animateWithDuration:0.3 animations:^{
            CGPoint center_B = contentV_Title.center;
            center_B.y += contentV_Title.bounds.size.height;
            contentV_Title.center = center_B;
        } completion:^(BOOL finished) {
            [WeakalertV dismissAlert];
        }];
    }];
    [tableV reloadData];
    return alertV;
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableDataArra ?_tableDataArra.count:0;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"csmcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:18.0];
    }
    cell.textLabel.text = _tableDataArra[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    if (_preSelectedIndex) {
        if (indexPath.row == _preSelectedIndex.integerValue) {
            cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        }
    }
   return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (self.presen_Block)self.presen_Block(0, (int)indexPath.row);
    
    
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint center_B = tableView.superview.superview.center;
        center_B.y += tableView.superview.superview.bounds.size.height;
        tableView.superview.superview.center = center_B;
    } completion:^(BOOL finished) {
        [self dismissAlert];
    }];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

//-(UIView *)getPrestedviewWithArra:(NSArray *)arra {
//        return view;
//}

#pragma mark --TextFeildDelegate


-(void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"%@",textField.text);
    _inputStr = [NSString stringWithFormat:@"%@",textField.text];
}


#pragma mark --点击事件
-(void)cancellBtnClick:(UIButton *)sender {
    [self dismissAlert];
    
}


- (void)leftBtnClicked:(id)sender
{
    [self endEditing:true];
    _leftLeave = YES;
    [self dismissAlert];
    if (self.leftBlock) {
        self.leftBlock();
        if(self.leftBlock_S)
        {
        self.leftBlock_S(_inputStr);
        }
    }
}

- (void)rightBtnClicked:(id)sender
{
    _leftLeave = NO;
    [self dismissAlert];
    if (self.rightBlock) {
        self.rightBlock();
        if(self.rightBlock_S)
        {
        _inputStr = _inputTextField.text;
        self.rightBlock_S(_inputStr);
        }
    }
}



#pragma mark --显示与消失
- (void)show
{
    UIViewController *topVC = [self appRootViewController];
    
    
//改变进入动画样式
    
//    self.frame=CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5,
//                                       140,
//                                       self.frame.size.width,
//                                       self.frame.size.height);
    if (!self.rightBtn) {
        self.frame=CGRectMake((CGRectGetWidth(topVC.view.bounds) - self.frame.size.width) * 0.5,
                              (CGRectGetHeight(topVC.view.bounds) - self.frame.size.height) * 0.5,
                              self.frame.size.width,
                              self.frame.size.height);    }
    else
    {
    self.frame=CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5,
                          (CGRectGetHeight(topVC.view.bounds) - self.frame.size.height) * 0.5,
                          self.frame.size.width,
                          self.frame.size.height);
    }

   [ UIView animateWithDuration:kAnimationInDuration animations:^{
//       self.frame=CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5,
//                             -self.frame.origin.y-30,
//                             self.frame.size.width,
//                             self.frame.size.height);
//       NSLog(@"------------------------%f",self.frame.size.height);
       NSLog(@"------------------------%f",self.frame.origin.y);
       [topVC.view addSubview:self];
   }];

}

- (void)dismissAlert
{
    [self endEditing:true];
    [self removeFromSuperview];
    if (self.dismissBlock) {
        self.dismissBlock();
        if (self.dismissBlock_S) {
            self.dismissBlock_S(_inputStr);
        }
    }
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


- (void)removeFromSuperview
{
    [UIView animateWithDuration:kAnimationOutDuration animations:^{
        self.alpha = 0;
        self.backImageView.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self.backImageView removeFromSuperview];
        self.backImageView = nil;
        UIViewController *topVC = [self appRootViewController];
        
        
        self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5,
                                CGRectGetHeight(topVC.view.bounds),
                                self.frame.size.width,
                                self.frame.size.height);
        if (_leftLeave) {
            self.transform = CGAffineTransformMakeRotation(-M_1_PI / 1.5);
        }else {
            self.transform = CGAffineTransformMakeRotation(M_1_PI / 1.5);
        }
        
        [super removeFromSuperview];
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];
    
    if (!self.backImageView) {
        self.backImageView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        self.backImageView.backgroundColor = self.mengBanColor;
        self.backImageView.alpha = 0.00f;
        
        [UIView animateWithDuration:self.aniamationDuration.floatValue delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.backImageView.alpha =  self.backGroundAlpha.floatValue;
        } completion:nil];
        
        self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapPress:)];
        tapGesture.numberOfTapsRequired=1;
        [self.backImageView addGestureRecognizer:tapGesture];
        
    }
    [topVC.view addSubview:self.backImageView];
    self.transform = CGAffineTransformMakeRotation(-M_1_PI / 2);
    
  
        self.transform = CGAffineTransformMakeRotation(0);
   
    if (!self.rightBtn) {
        self.frame =  self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - self.frame.size.width) * 0.5, (CGRectGetHeight(topVC.view.bounds) - self.frame.size.height) * 0.5,
                                              self.frame.size.width,
                                              self.frame.size.height);
    }
    else
    {
        self.frame =  self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, (CGRectGetHeight(topVC.view.bounds) - self.frame.size.height) * 0.5,
                                              self.frame.size.width,
                                              self.frame.size.height);
    }
    
    [super willMoveToSuperview:newSuperview];
}


#pragma mark UITapGestureRecognizer
-(void)handleTapPress:(UITapGestureRecognizer *)gestureRecognizer
{
    if (self.dismissType == TapBlankDismiss) {
        _leftLeave = YES;
        [self dismissAlert];
    }
    else{
        [self endEditing:true];
    }
}



#pragma mark - 设置视图尺寸
-(void)resetFrame{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDismiss:) name:UIKeyboardWillHideNotification object:nil];
    CGSize labelSize = [self.tvContent sizeThatFits:CGSizeMake(kContentWidth, 1000)];
    
    {
        CGRect frame=self.tvContent.frame;
        frame.size.height=MAX(labelSize.height, kContentMinHeight);
        frame.size.height=MIN(labelSize.height, kContentMaxHeight);
        if (!_rightBtn) {
            frame.size.height = self.tvContent.frame.size.height;
        }
        self.tvContent.frame=frame;
    }
    CGSize labelSize1 = [self.tvBottom sizeThatFits:CGSizeMake(kContentWidth, 1000)];
    
    {
        CGRect frame=self.tvBottom.frame;
        frame.size.height=MAX(labelSize1.height, kContentMinHeight);
        frame.size.height=MIN(labelSize1.height, kContentMaxHeight);
        self.tvBottom.frame=frame;
    }
    

    {

        if (!_isLeftBTNExist) {
          CGRect rightBtnFrame = CGRectMake((kAlertWidth)/4, CGRectGetMaxY(self.tvContent.frame)+kContentBottomMargin, kAlertWidth / 2, self.rightBtn.frame.size.height);
            self.rightBtn.frame = rightBtnFrame;
            self.rightBtn.layer.cornerRadius = kButtonHeight / 2;
            self.rightBtn.backgroundColor = [UIColor yellowColor];
            [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else
        {
        CGRect leftBtnFrame = CGRectMake(KcouplePadding, CGRectGetMaxY(self.tvContent.frame)+kContentBottomMargin, (kAlertWidth - 3 *KcouplePadding - KCoupleButtonPadding) / 2, self.rightBtn.frame.size.height);
        CGRect rightBtnFrame = CGRectMake(CGRectGetMaxX(leftBtnFrame) + KCoupleButtonPadding + KcouplePadding, CGRectGetMaxY(self.tvContent.frame)+kContentBottomMargin, (kAlertWidth - 3 *KcouplePadding -  KCoupleButtonPadding) / 2, self.rightBtn.frame.size.height);
        self.leftBtn.frame = leftBtnFrame;
        self.rightBtn.frame = rightBtnFrame;
        }
    }
    
    {
        
        // 针对ots 修正
        CGFloat btnxiuzheng = 0;
        if (_rightBtn) {
            btnxiuzheng = 13;
        }
        
        CGRect frame=self.frame;
        frame.size.height=self.lbTitle.frame.size.height+kContentTopMargin+kContentBottomMargin+self.rightBtn.frame.size.height+kButtonBottomMargin
        +self.tvContent.frame.size.height+self.tvBottom.frame.size.height + btnxiuzheng;
        NSLog(@"the frame is %f",self.tvContent.frame.size.height);
        frame.size.width=kAlertWidth;
        if (!_rightBtn) {
            CGFloat ssww = [UIScreen mainScreen].bounds.size.width;
            CGFloat sshh = [UIScreen mainScreen].bounds.size.height;
            frame.size.width = _tvContent.frame.size.width;
            self.frame = CGRectMake((ssww - frame.size.width) / 2 , (sshh - frame.size.height) / 2, frame.size.width, frame.size.height);
        }
        else
        {
          self.frame=frame;
        }
    }
}



-(void)keyBoardAppear:(NSNotification *)info{
    if (self.keyBoardShow) {
        NSDictionary *userInfo = [info userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        CGFloat height = keyboardRect.size.height;
        self.keyBoardShow(self,height);
    }
    else
    {
    CGPoint center = self.center;
    center.y = _K_SCREEN_HEIGHT * 0.5 + KkeyBoard_show_offset;
    [UIView animateWithDuration:kAnimationInDuration animations:^{
        self.center = center;
    }];
    }
 }


-(void)keyBoardDismiss:(NSNotification *)info{
    if (self.keyBoardHide) {
        self.keyBoardHide(self,0);
    }
    else
    {
    CGPoint center = self.center;
    center.y = _K_SCREEN_HEIGHT * 0.5;
    [UIView animateWithDuration:kAnimationInDuration animations:^{
        self.center = center;
    }];
    }
}


-(UITextField *)getInputTextField{
    return _inputTextField;
}


+ (CGFloat)getCustomAlertViewWidth {
    return kAlertWidth;
}


-(TapBlankDismissType)dismissType{
    if (!_dismissType) {
        _dismissType = TapBlankDismiss;
    }
    return _dismissType;
}



-(void)setKeyBoardShow:(selfview_block)show{
    _keyBoardShow = show;
}

-(void)setKeyBoardHide:(selfview_block)hide{
    _keyBoardHide = hide;
}



-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ already dealloc",[self class]);
}


-(NSNumber *)backGroundAlpha {
    if (!_backGroundAlpha) {
        _backGroundAlpha = @(0.34);
    }
    return _backGroundAlpha;
}



-(UIColor *)mengBanColor {
    if (!_mengBanColor) {
        _mengBanColor = [UIColor blackColor];
    }
    return _mengBanColor;
}


-(NSNumber *)aniamationDuration {
    if (!_aniamationDuration) {
        _aniamationDuration = @(kAnimationOutDuration);
    }
    return _aniamationDuration;
}


@end
