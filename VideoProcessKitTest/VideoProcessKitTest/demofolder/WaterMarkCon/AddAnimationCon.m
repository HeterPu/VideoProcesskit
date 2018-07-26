//
//  AddAnimationCon.m
//  VideoProcessKitTest
//
//  Created by Peter Hu on 2018/7/26.
//  Copyright © 2018 PeterHu. All rights reserved.
//

#import "AddAnimationCon.h"

@interface AddAnimationCon ()

@end

@implementation AddAnimationCon

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
    // 1
    UIImage *animationImage = [UIImage imageNamed:@"stone"];;
    CALayer *overlayLayer1 = [CALayer layer];
    [overlayLayer1 setContents:(id)[animationImage CGImage]];
    overlayLayer1.frame = CGRectMake(size.width/2-64, size.height/2 + 200, 128, 128);
    [overlayLayer1 setMasksToBounds:YES];
    
    
    
    CALayer *overlayLayer2 = [CALayer layer];
    [overlayLayer2 setContents:(id)[animationImage CGImage]];
    overlayLayer2.frame = CGRectMake(size.width/2-64, size.height/2 - 200, 128, 128);
    [overlayLayer2 setMasksToBounds:YES];
    
    // 2 - Rotate
//    if (_animationSelectSegment.selectedSegmentIndex == 0) {
        CABasicAnimation *animation =
        [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        animation.duration=2.0;
        animation.repeatCount=5;
        animation.autoreverses=YES;
        // rotate from 0 to 360
        animation.fromValue=[NSNumber numberWithFloat:0.0];
        animation.toValue=[NSNumber numberWithFloat:(2.0 * M_PI)];
        animation.beginTime = AVCoreAnimationBeginTimeAtZero;
        [overlayLayer1 addAnimation:animation forKey:@"rotation"];
        
        animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        animation.duration=2.0;
        animation.repeatCount=5;
        animation.autoreverses=YES;
        // rotate from 0 to 360
        animation.fromValue=[NSNumber numberWithFloat:0.0];
        animation.toValue=[NSNumber numberWithFloat:(2.0 * M_PI)];
        animation.beginTime = AVCoreAnimationBeginTimeAtZero;
        [overlayLayer2 addAnimation:animation forKey:@"rotation"];
    
//        // 3 - Fade
//    } else if(_animationSelectSegment.selectedSegmentIndex == 1) {
//        CABasicAnimation *animation
//        =[CABasicAnimation animationWithKeyPath:@"opacity"];
//        animation.duration=3.0;
//        animation.repeatCount=5;
//        animation.autoreverses=YES;
//        // animate from fully visible to invisible
//        animation.fromValue=[NSNumber numberWithFloat:1.0];
//        animation.toValue=[NSNumber numberWithFloat:0.0];
//        animation.beginTime = AVCoreAnimationBeginTimeAtZero;
//        [overlayLayer1 addAnimation:animation forKey:@"animateOpacity"];
//
//        animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
//        animation.duration=3.0;
//        animation.repeatCount=5;
//        animation.autoreverses=YES;
//        // animate from invisible to fully visible
//        animation.fromValue=[NSNumber numberWithFloat:1.0];
//        animation.toValue=[NSNumber numberWithFloat:0.0];
//        animation.beginTime = AVCoreAnimationBeginTimeAtZero;
//        [overlayLayer2 addAnimation:animation forKey:@"animateOpacity"];
//
//        // 4 - Twinkle
//    } else if(_animationSelectSegment.selectedSegmentIndex == 2) {
//        CABasicAnimation *animation =
//        [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//        animation.duration=0.5;
//        animation.repeatCount=10;
//        animation.autoreverses=YES;
//        // animate from half size to full size
//        animation.fromValue=[NSNumber numberWithFloat:0.5];
//        animation.toValue=[NSNumber numberWithFloat:1.0];
//        animation.beginTime = AVCoreAnimationBeginTimeAtZero;
//        [overlayLayer1 addAnimation:animation forKey:@"scale"];
//
//        animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//        animation.duration=1.0;
//        animation.repeatCount=5;
//        animation.autoreverses=YES;
//        // animate from half size to full size
//        animation.fromValue=[NSNumber numberWithFloat:0.5];
//        animation.toValue=[NSNumber numberWithFloat:1.0];
//        animation.beginTime = AVCoreAnimationBeginTimeAtZero;
//        [overlayLayer2 addAnimation:animation forKey:@"scale"];
//    }
    
    // 5
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, size.width, size.height);
    videoLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:overlayLayer1];
    [parentLayer addSublayer:overlayLayer2];
    
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
