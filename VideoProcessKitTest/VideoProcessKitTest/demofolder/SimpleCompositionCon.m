//
//  SimpleCompositionCon.m
//  VideoProcessKitTest
//
//  Created by Peter Hu on 2018/6/29.
//  Copyright © 2018年 PeterHu. All rights reserved.
//

#import "SimpleCompositionCon.h"
#import "VPKFileManager.h"
#import "VPKCompositonManager.h"

@interface SimpleCompositionCon ()

@property(nonatomic,strong) VPKCompositonManager  *manager;

@end

@implementation SimpleCompositionCon

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [VPKFileManager getDocumentPath];
    NSString *path1 =  [path stringByAppendingPathComponent:@"MFwf6J.mp4"];
    NSString *path2 =  [path stringByAppendingPathComponent:@"XnzwQF.mp4"];
    
    
    path1 = [[NSBundle mainBundle] pathForResource:@"MFwf6J" ofType:@"mp4"];
    // 视频来源
    path2 = [[NSBundle mainBundle] pathForResource:@"XnzwQF" ofType:@"mp4"];
    NSString *path3  = [[NSBundle mainBundle] pathForResource:@"dVIlx3" ofType:@"mp4"];
    NSString *path4  = [[NSBundle mainBundle] pathForResource:@"123" ofType:@"mp3"];
    
    NSString *output =  [path stringByAppendingPathComponent:@"output.mp4"];
    
//    CMTimeMake(30, 1); 1s
    VPKCompositonChannel *channel1 = [[VPKCompositonChannel alloc]initWithChannelId:0 mediaType:AVMediaTypeVideo range:CMTimeRangeMake(kCMTimeZero, kCMTimeZero) fileUrl:[NSURL fileURLWithPath:path1]];
    VPKCompositonChannel *channel2 = [[VPKCompositonChannel alloc]initWithChannelId:0 mediaType:AVMediaTypeVideo range:CMTimeRangeMake(kCMTimeZero, kCMTimeZero) fileUrl:[NSURL fileURLWithPath:path2]];
    
      VPKCompositonChannel *channel3 = [[VPKCompositonChannel alloc]initWithChannelId:0 mediaType:AVMediaTypeVideo range:CMTimeRangeMake(kCMTimeZero, kCMTimeZero) fileUrl:[NSURL fileURLWithPath:path3]];
    
      VPKCompositonChannel *channel4 = [[VPKCompositonChannel alloc]initWithChannelId:0 mediaType:AVMediaTypeAudio range:CMTimeRangeMake(kCMTimeZero, CMTimeMake(30, 1)) fileUrl:[NSURL fileURLWithPath:path4]];
    
    
    _manager = [[VPKCompositonManager alloc]init];
    [_manager compositeWthVideoChannels:nil audioChannels:@[@[channel4,channel4]] outPutParh:output successBlock:^(NSURL *fileUrl) {
        NSLog(@"the out put file is",fileUrl.path);
    }];
    [_manager setProgressBlock:^(CGFloat progress) {
        
    }];
    NSLog(@"");
    // Do any additional setup after loading the view from its nib.
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
