//
//  AddTiltCon.m
//  VideoProcessKitTest
//
//  Created by Peter Hu on 2018/7/26.
//  Copyright © 2018 PeterHu. All rights reserved.
//

#import "AddTiltCon.h"

@interface AddTiltCon ()

@end

@implementation AddTiltCon

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


- (void)applyVideoEffectsToComposition:(AVMutableVideoComposition *)composition size:(CGSize)size
{
    
    
    CATextLayer *subtitle1Text = [[CATextLayer alloc] init];
    [subtitle1Text setFont:@"Helvetica-Bold"];
    [subtitle1Text setFontSize:36];
    
    // y 轴坐标系是反的
    [subtitle1Text setFrame:CGRectMake(0, size.height - 40, size.width / 2, 40)];
    //    [subtitle1Text setBounds:CGRectMake(0, 0, size.width / 2, 40)];
    //    [subtitle1Text setPosition:CGPointMake(size.width / 2, 0)];
    [subtitle1Text setString:@"i am peter"];
    [subtitle1Text setAlignmentMode:kCAAlignmentCenter];
    [subtitle1Text setForegroundColor:[[UIColor whiteColor] CGColor]];
    subtitle1Text.opacity = 0.0;
    
    //*********** For A Special Time
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [animation setDuration:1];
    [animation setFromValue:[NSNumber numberWithFloat:0]];
    [animation setToValue:[NSNumber numberWithFloat:1.0]];
    [animation setBeginTime:3];
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeForwards];
    [subtitle1Text addAnimation:animation forKey:@"animateOpacity1"];
    
    //*********** For A Special Time
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [animation2 setDuration:1];
    [animation2 setFromValue:[NSNumber numberWithFloat:1.0]];
    [animation2 setToValue:[NSNumber numberWithFloat:0.0]];
    [animation2 setBeginTime:8];
    [animation2 setRemovedOnCompletion:NO];
    [animation2 setFillMode:kCAFillModeForwards];
    [subtitle1Text addAnimation:animation2 forKey:@"animateOpacity2"];
    
    
    // 2 - The usual overlay
    CALayer *overlayLayer = [CALayer layer];
    [overlayLayer addSublayer:subtitle1Text];
    overlayLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [overlayLayer setMasksToBounds:YES];
    
    
    // 1 - Layer setup
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    
    parentLayer.frame = CGRectMake(0, 0, size.width, size.height);
    videoLayer.frame = CGRectMake(0, 0, size.width, size.height);
    
    
    [parentLayer addSublayer:overlayLayer];
    [parentLayer addSublayer:videoLayer];
    
    // 2 - Set up the transform
    CATransform3D identityTransform = CATransform3DIdentity;
    
    // 3 - Pick the direction
    identityTransform.m34 = 2.0 / 1000; // greater the denominator lesser will be the transformation
    
    // 4 - Rotate
    videoLayer.transform = CATransform3DRotate(identityTransform,  M_PI/4.0 ,1.0f, 0.0f, 0.0f);
    
    // 5 - Composition
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
