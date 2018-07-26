//
//  AddSubtitleCon.m
//  VideoProcessKitTest
//
//  Created by Peter Hu on 2018/7/26.
//  Copyright © 2018 PeterHu. All rights reserved.
//

#import "AddSubtitleCon.h"

@interface AddSubtitleCon ()
@property (weak, nonatomic) IBOutlet UITextField *textF;

@end

@implementation AddSubtitleCon

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)openAlbum:(id)sender {
    [self startMediaBrowserFromViewController:self usingDelegate:self];
}


- (IBAction)compose:(id)sender {
    [self videoOutput];
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_textF resignFirstResponder];
}


- (void)applyVideoEffectsToComposition:(AVMutableVideoComposition *)composition size:(CGSize)size
{
    // 1 - Set up the text layer
    CATextLayer *subtitle1Text = [[CATextLayer alloc] init];
    [subtitle1Text setFont:@"Helvetica-Bold"];
    [subtitle1Text setFontSize:36];
    
    // y 轴坐标系是反的
    [subtitle1Text setFrame:CGRectMake(0, size.height - 40, size.width / 2, 40)];
//    [subtitle1Text setBounds:CGRectMake(0, 0, size.width / 2, 40)];
//    [subtitle1Text setPosition:CGPointMake(size.width / 2, 0)];
    [subtitle1Text setString:_textF.text];
    [subtitle1Text setAlignmentMode:kCAAlignmentCenter];
    [subtitle1Text setForegroundColor:[[UIColor whiteColor] CGColor]];
    

    // 2 - The usual overlay
    CALayer *overlayLayer = [CALayer layer];
    [overlayLayer addSublayer:subtitle1Text];
    overlayLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [overlayLayer setMasksToBounds:YES];
    
//    overlayLayer.geometryFlipped      影响子视图 ，对自己无效
    
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, size.width, size.height);
    videoLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:overlayLayer];
    
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
