//
//  WaterMarkWithVPKCon.m
//  VideoProcessKitTest
//
//  Created by Peter Hu on 2018/7/30.
//  Copyright © 2018 PeterHu. All rights reserved.
//

#import "WaterMarkWithVPKCon.h"
#import "VPKCompositonManager.h"

@interface WaterMarkWithVPKCon ()

@end

@implementation WaterMarkWithVPKCon

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // EXAMPLE
    NSString *inputFile = [[VPKFileManager getDocumentPath]stringByAppendingPathComponent:@"123.mp4"];
    NSString *outoutFile = [[VPKFileManager getDocumentPath]stringByAppendingPathComponent:@"234.mp4"];
    
    VPKCompositonChannel *channel = [[VPKCompositonChannel alloc]initWithChannelId:0 mediaType:AVMediaTypeVideo range:kCMTimeRangeZero fileUrl:[NSURL fileURLWithPath:inputFile]];
    VPKCompositonManager *compositeManager = [[VPKCompositonManager alloc]init];
    [compositeManager innnerCompositeWithChannel:channel outPutPath:outoutFile configuration:^(AVMutableVideoComposition *composition, CGSize videoSize) {
        
        // SET BORDER
        UIImage *borderImage = [self imageWithColor:[UIColor cyanColor] rectSize: CGRectMake(0, 0, videoSize.width, videoSize.height)];
        CALayer *backgroundLayer = [CALayer layer];
        [backgroundLayer setContents:(id)[borderImage CGImage]];
        backgroundLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
        [backgroundLayer setMasksToBounds:YES];
        
        CALayer *videoLayer = [CALayer layer];
        videoLayer.frame = CGRectMake(20, 20,
                                      videoSize.width-(40), videoSize.height-(40));
        CALayer *parentLayer = [CALayer layer];
        [parentLayer addSublayer:backgroundLayer];
        [parentLayer addSublayer:videoLayer];
        composition.animationTool = [AVVideoCompositionCoreAnimationTool
                                     videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
        
        // SET LAYER ...
    } progressBlock:^(CGFloat progress) {
        NSLog(@"current progress is %f",progress);
    } complete:^(NSURL *fileUrl, NSString *errMsg) {
        
    }];
    
    // Do any additional setup after loading the view from its nib.
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
