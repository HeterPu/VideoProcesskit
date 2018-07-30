//
//  ImageTitleButton.m
//  CommonLibrary
//
//  Created by Alexi on 3/21/14.
//  Copyright (c) 2014 Alexi. All rights reserved.
//

#import "ImageTitleButton.h"


@implementation MenuItem

- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon action:(MenuAction)action
{
    if (self = [super init]) {
        self.title = title;
        self.icon = icon;
        self.action = action;
    }
    return self;
}

- (void)menuAction
{
    if (_action)
    {
        _action(self);
    }
    
}

@end



@interface MenuButton ()

@property (nonatomic, copy) MenuAction action;
@property (nonatomic, copy) MenuHighlightedAction highlightedAction;

@end


@implementation MenuButton

- (instancetype)initWithMenu:(MenuItem *)item
{
    return [self initWithTitle:item.title icon:item.icon action:item.action];
}

- (instancetype)initWithTitle:(NSString *)title action:(MenuAction)action
{
    return [self initWithTitle:title icon:nil action:action];
}

- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon action:(MenuAction)action
{
    if (self = [super init])
    {
        self.title = title;
        self.icon = icon;
        self.action = action;
        [self setTitle:title forState:UIControlStateNormal];
        //        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self setImage:icon forState:UIControlStateNormal];
        [self addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (instancetype)initWithBackground:(UIImage *)icon action:(MenuAction)action
{
    if (self = [super init])
    {
        self.icon = icon;
        self.action = action;
        [self setBackgroundImage:icon forState:UIControlStateNormal];
        [self addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


- (void)setClickAction:(MenuAction)action
{
    self.action = action;
    [self addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onClick:(id)sender
{
    if (_action) {
        _action(self);
    }
    
}


-(void)setHighlightedPressAction:(MenuHighlightedAction)action {
    self.highlightedAction = action;
}


-(void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    if (self.highlightedAction) {
        self.highlightedAction(self, highlighted);
    }
}



@end



@interface ImageTitleButton()

@property(nonatomic,assign) BOOL isDisableHighted;

@end
@implementation ImageTitleButton

- (instancetype)init
{
    return [self initWithStyle:EImageLeftTitleRight];
}

- (instancetype)initWithStyle:(ImageTitleButtonStyle)style
{
    return [self initWithStyle:style maggin:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (instancetype)initWithStyle:(ImageTitleButtonStyle)style maggin:(UIEdgeInsets)margin
{
    return [self initWithStyle:style maggin:margin padding:CGSizeMake(2, 2)];
}

- (instancetype)initWithStyle:(ImageTitleButtonStyle)style maggin:(UIEdgeInsets)margin padding:(CGSize)padding
{
    if (self = [super initWithFrame:CGRectZero])
    {
        _style = style;
        _margin = margin;
        _padding = padding;
    }
    return self;
}

- (void)setImage:(nullable UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    if (image && CGSizeEqualToSize(_imageSize, CGSizeZero))
    {
        _imageSize = image.size;
    }
}


-(void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    if (enabled) {
        self.titleLabel.alpha = 1.0;
    }
    else
    {
        self.titleLabel.alpha = 0.5;
    }
}


-(void)setDisableHighted:(BOOL)isDisabled {
    _isDisableHighted = isDisabled;
}


- (void)setMargin:(UIEdgeInsets)margin
{
    _margin = margin;
    [self setNeedsDisplay];
}

- (void)setPadding:(CGSize)padding
{
    _padding = padding;
    [self setNeedsDisplay];
}

- (void)relayoutFrameOfSubViews
{
    CGRect rect = self.bounds;
    
    rect.origin.x += _margin.left;
    rect.size.width -= _margin.left + _margin.right;
    rect.origin.y += _margin.top;
    rect.size.height -= _margin.top + _margin.bottom;
    
    UIImage *img = [self imageForState:UIControlStateNormal];
    CGFloat scale = [[UIScreen mainScreen] scale];

    CGSize size = CGSizeZero;
    
    if (CGSizeEqualToSize(self.imageSize, CGSizeZero))
    {
        size = CGSizeMake(img.size.width/scale, img.size.height/scale);
    }
    else
    {
        size = self.imageSize;
    }
    
    switch (_style)
    {
        case EImageTopTitleBottom:
        {
            CGRect imgRect = rect;
            imgRect.size.height = size.height;
            imgRect.origin.x += (imgRect.size.width - size.width)/2;
            imgRect.size.width = size.width;
            self.imageView.frame = imgRect;
            
            CGRect titleRect = rect;
            titleRect.origin.y += imgRect.size.height + _padding.height;
            titleRect.size.height -= imgRect.size.height + _padding.height;
            self.titleLabel.frame = titleRect;
        }
            break;
        case ETitleTopImageBottom:
        {
            CGRect imgRect = rect;
            imgRect.origin.x += (imgRect.size.width - size.width)/2;
            imgRect.size.width = size.width;
            imgRect.size.height = size.height;
            imgRect.origin.y += rect.size.height - imgRect.size.height;
            self.imageView.frame = imgRect;
            
            CGRect titleRect = rect;
            titleRect.size.height -= imgRect.size.height + _padding.height;
            self.titleLabel.frame = titleRect;
        }
            break;
        case EImageLeftTitleRight:
        {
            CGRect imgRect = rect;
            imgRect.size.width = size.width;
            imgRect.size.height = size.height;
            imgRect.origin.y += (rect.size.height - size.height)/2;
            self.imageView.frame = imgRect;
            
            CGRect titleRect = rect;
            titleRect.origin.x += imgRect.size.width + _padding.width;
            titleRect.size.width -= imgRect.size.width + _padding.width;
            self.titleLabel.frame = titleRect;
        }
            break;
        case ETitleLeftImageRight:
        {
            CGRect imgRect = rect;
            imgRect.size.width = size.width;
            imgRect.origin.x += rect.size.width - imgRect.size.width;
            imgRect.size.height = size.height;
            imgRect.origin.y += (rect.size.height - size.height)/2;
            self.imageView.frame = imgRect;
            
            CGRect titleRect = rect;
            titleRect.size.width -= imgRect.size.width + _padding.width;
            self.titleLabel.frame = titleRect;
        }
            break;
        case EImageLeftTitleRightLeft:
        {
            CGRect imgRect = rect;
            imgRect.size = self.imageSize;
            imgRect.origin.y += (rect.size.height - imgRect.size.height)/2;
            self.imageView.frame = imgRect;
            
            rect.origin.x += imgRect.size.width + self.padding.width;
            rect.size.width -= imgRect.size.width + self.padding.width;
            self.titleLabel.textAlignment = NSTextAlignmentLeft;
            self.titleLabel.frame = rect;
        }
            break;
            
        case ETitleLeftImageRightLeft:
        {
            CGRect imgRect = rect;
            imgRect.size = self.imageSize;
            imgRect.origin.y += (rect.size.height - imgRect.size.height)/2;
            imgRect.origin.x += rect.size.width - (imgRect.size.width + self.padding.width);
            self.imageView.frame = imgRect;
            
            rect.size.width -= imgRect.size.width + self.padding.width;
            
            self.titleLabel.frame = rect;
        }
            break;
            
        case EImageLeftTitleRightCenter:
        {
            
            CGSize titleSize = [self.titleLabel textSizeIn:rect.size];
            
            CGRect middleRect = CGRectInset(rect, (rect.size.width - (titleSize.width + self.imageSize.width + self.padding.width))/2, 0);
            
            CGRect imgRect = middleRect;
            
            imgRect.size = self.imageSize;
            imgRect.origin.y += (middleRect.size.height - imgRect.size.height)/2;
            self.imageView.frame = imgRect;
            
            middleRect.origin.x += imgRect.size.width + self.padding.width;
            middleRect.size.width -= imgRect.size.width + self.padding.width;
            
            self.titleLabel.frame = middleRect;
    
            
        }
            break;
            
        case ETitleLeftImageRightCenter:
        {
            CGSize titleSize = [self.titleLabel textSizeIn:rect.size];
            
            CGRect middleRect = CGRectInset(rect, (rect.size.width - (titleSize.width + self.imageSize.width + self.padding.width))/2, 0);
            
            CGRect titlerect = middleRect;
            titlerect.size.width = titleSize.width;
            self.titleLabel.frame = titlerect;
            
            middleRect.origin.x += titlerect.size.width + self.padding.width;
            middleRect.size.width -= titlerect.size.width + self.padding.width;
            
            middleRect.origin.y += (middleRect.size.height - self.imageSize.height)/2;
            middleRect.size = self.imageSize;
            self.imageView.frame = middleRect;
        }
            break;
        case EFitTitleLeftImageRight:
        {
            CGSize titleSize = [self.titleLabel textSizeIn:rect.size];
            CGRect titleRect = rect;

            titleRect.origin.y = rect.origin.y + (rect.size.height - titleSize.height)/2;
            titleRect.size = titleSize;
            self.titleLabel.frame = titleRect;
            
            titleRect.origin.x += titleRect.size.width + self.padding.width;
            titleRect.size = self.imageSize;
            titleRect.origin.y = rect.origin.y + (rect.size.height - self.imageSize.height)/2;
            self.imageView.frame = titleRect;
            
            break;
        }
            break;
            
        default:
            break;
    }
}


/**
 当选中时取消高亮效果

 @param highlighted 是否高亮
 */
-(void)setHighlighted:(BOOL)highlighted {
    if (!_isDisableHighted) {
        [super setHighlighted:highlighted];
    }
}


- (void)layoutSubviews
{
    if (CGRectEqualToRect(self.bounds, CGRectZero))
    {
        return;
    }
    [super layoutSubviews];
    
//    // 单独设置title或image的时候只用
//    NSString *title = [self titleForState:UIControlStateNormal];
//    UIImage *image = [self imageForState:UIControlStateNormal];
//    if ([NSString isEmpty:title] && image)
//    {
        [self relayoutFrameOfSubViews];
//    }
}

- (void)setMyTintColor:(UIColor *)color
{
    if (color)
    {
        UIImage *img = [self imageForState:UIControlStateNormal];
        img = [img imageWithTintColor:color];
        [self setImage:img  forState:UIControlStateNormal];
        [self setTitleColor:color forState:UIControlStateNormal];
    }
}



@end



#pragma mark--UIImageTint implementation
@implementation UIImage (ImageBtnTintColor)

- (UIImage *)imageWithTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
{
    if (!tintColor) {
        return self;
    }
    
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn)
    {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

@end



@implementation UILabel (ImageTitleCommon)

+ (instancetype)label
{
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentLeft;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    return label;
}

+ (instancetype)labelWithTitle:(NSString *)title
{
    UILabel *label = [UILabel label];
    
    label.text = title;
    return label;
}

- (CGSize)contentSize
{
    return [self textSizeIn:self.bounds.size];
}

- (CGSize)textSizeIn:(CGSize)size
{
    NSLineBreakMode breakMode = self.lineBreakMode;
    UIFont *font = self.font;
    
    CGSize contentSize = CGSizeZero;
    //    if ([IOSDeviceConfig sharedConfig].isIOS7)
    //    {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = breakMode;
    paragraphStyle.alignment = self.textAlignment;
    
    NSDictionary* attributes = @{NSFontAttributeName:font,
                                 NSParagraphStyleAttributeName:paragraphStyle};
    contentSize = [self.text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributes context:nil].size;
    //    }
    //    else
    //    {
    //        contentSize = [self.text sizeWithFont:font constrainedToSize:size lineBreakMode:breakMode];
    //    }
    
    
    contentSize = CGSizeMake((int)contentSize.width + 1, (int)contentSize.height + 1);
    return contentSize;
}

//- (void)layoutInContent
//{
//    CGSize size = [self contentSize];
//    CGRect rect = self.frame;
//    rect.size = size;
//    self.frame = rect;
//}
//


@end


@implementation InsetLabel


- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _contentInset)];
}


- (CGSize)contentSize
{
    CGRect rect = UIEdgeInsetsInsetRect(self.bounds, _contentInset);
    CGSize size = [super textSizeIn:rect.size];
    return CGSizeMake(size.width + _contentInset.left + _contentInset.right, size.height + _contentInset.top + _contentInset.bottom);
}

- (CGSize)textSizeIn:(CGSize)size
{
    size.width -= _contentInset.left + _contentInset.right;
    size.height -= _contentInset.top + _contentInset.bottom;
    CGSize textSize = [super textSizeIn:size];
    return CGSizeMake(textSize.width + _contentInset.left + _contentInset.right, textSize.height + _contentInset.top + _contentInset.bottom);
}

@end


