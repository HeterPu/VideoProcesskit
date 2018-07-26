//
//  AddLottieViewCon.m
//  VideoProcessKitTest
//
//  Created by Peter Hu on 2018/7/26.
//  Copyright © 2018 PeterHu. All rights reserved.
//

#import "AddLottieViewCon.h"
#import <lottie/Lottie.h>

@interface AddLottieViewCon ()

@end

@implementation AddLottieViewCon

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)open:(id)sender {
    [self startMediaBrowserFromViewController:self usingDelegate:self];
}


- (IBAction)compose:(id)sender {
    [self videoOutput];
}


-(void)applyVideoEffectsToComposition:(AVMutableVideoComposition *)composition size:(CGSize)size{
    LOTAnimationView* animation = [LOTAnimationView animationNamed:@"Watermelon"];
    animation.frame = CGRectMake(0, -20, 100 , 100);
    animation.animationSpeed = 4.0;
    animation.loopAnimation = FALSE;
  
    
    // 否则视频倒置
    animation.layer.geometryFlipped = true;
    [animation play];
    
    
    
    
    //*********** For A Special Time
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [animation2 setDuration:1];
    [animation2 setFromValue:[NSNumber numberWithFloat:1.0]];
    [animation2 setToValue:[NSNumber numberWithFloat:0.0]];
    [animation2 setBeginTime:8];
    [animation2 setRemovedOnCompletion:NO];
    [animation2 setFillMode:kCAFillModeForwards];
    [animation.layer addAnimation:animation2 forKey:@"animateOpacity2"];
    
    
    
    CALayer *overlayLayer = [CALayer layer];
    UIImage *overlayImage = nil;
    
    overlayImage = [UIImage imageNamed:@"layer.png"];
    
    [overlayLayer setContents:(id)[overlayImage CGImage]];
    overlayLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [overlayLayer setMasksToBounds:YES];
    
    
    
    
    
    CATextLayer *subtitle1Text = [[CATextLayer alloc] init];
    [subtitle1Text setFont:@"Helvetica-Bold"];
    [subtitle1Text setFontSize:36];
    
    // y 轴坐标系是反的
    [subtitle1Text setFrame:CGRectMake(size.width / 2,20, size.width / 2, 40)];
    //    [subtitle1Text setBounds:CGRectMake(0, 0, size.width / 2, 40)];
    //    [subtitle1Text setPosition:CGPointMake(size.width / 2, 0)];
    [subtitle1Text setString:@"I am peter"];
    [subtitle1Text setAlignmentMode:kCAAlignmentCenter];
    [subtitle1Text setForegroundColor:[[UIColor whiteColor] CGColor]];
    subtitle1Text.opacity = 0.0;
    
    
    
    
    
    
    //*********** For A Special Time
    CABasicAnimation *animation3 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [animation3 setDuration:1];
    [animation3 setFromValue:[NSNumber numberWithFloat:0]];
    [animation3 setToValue:[NSNumber numberWithFloat:1.0]];
    [animation3 setBeginTime:3];
    [animation3 setRemovedOnCompletion:NO];
    [animation3 setFillMode:kCAFillModeForwards];
    [subtitle1Text addAnimation:animation3 forKey:@"animateOpacity3"];
    
    //*********** For A Special Time
    CABasicAnimation *animation4 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [animation4 setDuration:1];
    [animation4 setFromValue:[NSNumber numberWithFloat:1.0]];
    [animation4 setToValue:[NSNumber numberWithFloat:0.0]];
    [animation4 setBeginTime:8];
    [animation4 setRemovedOnCompletion:NO];
    [animation4 setFillMode:kCAFillModeForwards];
    [subtitle1Text addAnimation:animation4 forKey:@"animateOpacity4"];
    
    
    
    
    
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    videoLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:overlayLayer];
    [parentLayer addSublayer:animation.layer];
    [parentLayer addSublayer:subtitle1Text];
    
    
    
    composition.animationTool = [AVVideoCompositionCoreAnimationTool
                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
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
