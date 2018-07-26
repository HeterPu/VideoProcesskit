//
//  AddBorderCon.m
//  VideoProcessKitTest
//
//  Created by Peter Hu on 2018/7/26.
//  Copyright © 2018 PeterHu. All rights reserved.
//

#import "AddBorderCon.h"

@interface AddBorderCon ()

@end

@implementation AddBorderCon

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)open:(id)sender {
     [self  startMediaBrowserFromViewController:self usingDelegate:self];
}


- (IBAction)compose:(id)sender {
    [self videoOutput];
}


- (UIImage *)imageWithColor:(UIColor *)color rectSize:(CGRect)imageSize {
    CGRect rect = imageSize;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


-(void)applyVideoEffectsToComposition:(AVMutableVideoComposition *)composition size:(CGSize)size{
     UIImage *borderImage = [self imageWithColor:[UIColor cyanColor] rectSize: CGRectMake(0, 0, size.width, size.height)];
    CALayer *backgroundLayer = [CALayer layer];
    [backgroundLayer setContents:(id)[borderImage CGImage]];
    backgroundLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [backgroundLayer setMasksToBounds:YES];
    
    CALayer *videoLayer = [CALayer layer];
    videoLayer.frame = CGRectMake(20, 20,
                                  size.width-(40), size.height-(40));
    CALayer *parentLayer = [CALayer layer];
    [parentLayer addSublayer:backgroundLayer];
    [parentLayer addSublayer:videoLayer];
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
