//
//  VPKCompositonManager.m
//  VideoProcessKitTest
//
//  Created by Peter Hu on 2018/7/2.
//  Copyright © 2018年 PeterHu. All rights reserved.
//

#import "VPKCompositonManager.h"
#import "VPKFileManager.h"
#import <UIKit/UIKit.h>



@interface VPKCompositonChannel()

@end


@implementation VPKCompositonChannel

-(instancetype)initWithChannelId:(NSInteger)channelId mediaType:(AVMediaType)type range:(CMTimeRange)range fileUrl:(NSURL *)fileUrl{
    self =  [super init];
    _channelId = channelId;
    _mediaType = type;
    _range = range;
    _fileUrl = fileUrl;
    return self;
}

@end


@interface VPKCompositonManager()


@property(nonatomic,strong)NSArray<NSArray< VPKCompositonChannel *> *> *mVideoChannels;
@property(nonatomic,strong)NSArray<NSArray< VPKCompositonChannel *> *> *mAudioChannels;

@property(nonatomic,assign) CMTimeRange  maxTimeRange;

@property(nonatomic,strong) AVMutableComposition  *composition;

/**
 标识是否为纯音频合成
 */
@property(nonatomic,assign) BOOL isPureAudioComposite;

@end


@implementation VPKCompositonManager



-(void)compositeWthVideoChannels:(NSArray<NSArray< VPKCompositonChannel *> *> *) videoChannels
                   audioChannels:(NSArray<NSArray< VPKCompositonChannel *> *> *)audioChannels
                      outPutParh:(NSString *)path
                   progressBlock:(VPK_Compos_Progress)progressBlock
                    successBlock:(VPK_Compos_Success)successBlock{
    
    if([VPKFileManager isFileExistOfPath:path]){
        NSLog(@"输出路径已存在,不可用");
        return;
    }
    __weak typeof (self)  weak_self;
    
    // 移除现有通道
    [self.composition.tracks enumerateObjectsUsingBlock:^(AVMutableCompositionTrack * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weak_self.composition removeTrack:obj];
    }];
    
    _mVideoChannels = videoChannels;
    _mAudioChannels = audioChannels;
    
    // 不使用通道(视频或音频)就不要创建，否则会有问题。
    _maxTimeRange = CMTimeRangeMake(kCMTimeZero, kCMTimeZero);
    BOOL hasVideoChannel = false;
    BOOL hasAudioChannel = false;
    if(videoChannels&&videoChannels.count > 0)hasVideoChannel = true;
     if(audioChannels&&audioChannels.count > 0)hasAudioChannel = true;
    
    _isPureAudioComposite = !hasVideoChannel;
    
    if(hasVideoChannel){
        for (int i = 0; i < videoChannels.count;i++) {
        NSArray<VPKCompositonChannel *> *pipeChannel = videoChannels[i];
        AVMutableCompositionTrack  *videoTrack = [self.composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid + i];
        AVMutableCompositionTrack  *audioTrack = [self.composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid + i];
        for (int i = 0; i < pipeChannel.count; i++) {
            VPKCompositonChannel *channel = pipeChannel[pipeChannel.count - i - 1];
            AVURLAsset *fileAsset = [[AVURLAsset alloc] initWithURL:channel.fileUrl options:nil];
            CMTimeRange  fileTimeRange = [self fitTimeRange:channel.range avUrlAsset:fileAsset];
            if(CMTimeCompare(CMTimeAdd(fileTimeRange.start, fileTimeRange.duration),_maxTimeRange.duration)){
                _maxTimeRange.duration = CMTimeAdd(fileTimeRange.start, fileTimeRange.duration);
            }
            
            // 增加视频通道
            if (channel.mediaType == AVMediaTypeVideo) {
                // 视频采集通道
                AVAssetTrack *videoAssetTrack = [[fileAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
                // 把采集轨道数据加入到可变轨道之中
                [videoTrack insertTimeRange:fileTimeRange ofTrack:videoAssetTrack atTime:fileTimeRange.start error:nil];
                // 音频采集通道
                AVAssetTrack *audioAssetTrack = [[fileAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
                // 加入合成轨道之中
                [audioTrack insertTimeRange:fileTimeRange ofTrack:audioAssetTrack atTime:fileTimeRange.start error:nil];
            }
        }
     }
    }
    
    if(hasAudioChannel){
          for (int i = 0; i < audioChannels.count;i++) {
               NSArray<VPKCompositonChannel *> *pipeChannel = audioChannels[i];
                AVMutableCompositionTrack *audioTrack = [_composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid + 100 + i];
//              audioTrack.preferredVolume =  0.04;
              for (int i = 0; i < pipeChannel.count; i++) {
                  VPKCompositonChannel *channel = pipeChannel[pipeChannel.count - i - 1];
                  if (channel.mediaType == AVMediaTypeAudio) {
                      AVURLAsset *fileAsset = [[AVURLAsset alloc] initWithURL:channel.fileUrl options:nil];
                      CMTimeRange  fileTimeRange = [self fitTimeRange:channel.range avUrlAsset:fileAsset];
                      AVAssetTrack *audioAssetTrack = [[fileAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
                      // 把采集轨道数据加入到可变轨道之中
                      [audioTrack insertTimeRange:fileTimeRange ofTrack:audioAssetTrack atTime:fileTimeRange.start error:nil];
                  }
              }
          }
    }
    
    
    //增加音频通道
    if (hasAudioChannel||hasVideoChannel) {
        [self composition:_composition storePath:path progressBlock:progressBlock success:successBlock];
    }else{
         NSLog(@"无视频和音频轨道");
    }
}



//输出
- (void)composition:(AVMutableComposition *)avComposition
          storePath:(NSString *)storePath
      progressBlock:(VPK_Compos_Progress)progressBlock
            success:(VPK_Compos_Success)successBlcok
{
    
    // 如果为音频默认输出为m4a格式,视频默认为MP4格式
    NSString *exportType  = self.presetName;
    if(!exportType)exportType = _isPureAudioComposite ? AVAssetExportPresetAppleM4A : AVAssetExportPresetHighestQuality;
    
    NSString *outputType = self.outputFileType;
    if(!outputType)outputType = _isPureAudioComposite ? AVFileTypeAppleM4A : AVFileTypeMPEG4;
    
    // 创建一个输出
    AVAssetExportSession *assetExport = [[AVAssetExportSession alloc] initWithAsset:avComposition presetName:exportType];
    assetExport.outputFileType = outputType;
    // 输出地址
    assetExport.outputURL = [NSURL fileURLWithPath:storePath];
    // 优化
    assetExport.shouldOptimizeForNetworkUse = YES;
    
    __block NSTimer *timer = nil;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.20 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@" 打印信息:%f",assetExport.progress);
        if (progressBlock) {
            progressBlock(assetExport.progress);
        }
    }];
    
    
    // 合成完毕
    [assetExport exportAsynchronouslyWithCompletionHandler:^{
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
        // 回到主线程
        switch (assetExport.status) {
            case AVAssetExportSessionStatusUnknown:
                NSLog(@"exporter Unknow");
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"exporter Canceled");
                break;
            case AVAssetExportSessionStatusFailed:
                NSLog(@"%@", [NSString stringWithFormat:@"exporter Failed%@",assetExport.error.description]);
                break;
            case AVAssetExportSessionStatusWaiting:
                NSLog(@"exporter Waiting");
                break;
            case AVAssetExportSessionStatusExporting:
                NSLog(@"exporter Exporting");
                break;
            case AVAssetExportSessionStatusCompleted:
                NSLog(@"exporter Completed");
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 调用播放方法
                    successBlcok([NSURL fileURLWithPath:storePath]);
                });
                break;
        }
    }];
}




//得到合适的时间
- (CMTimeRange)fitTimeRange:(CMTimeRange)timeRange avUrlAsset:(AVURLAsset *)avUrlAsset
{
    CMTimeRange fitTimeRange = timeRange;
    
    if (CMTimeCompare(avUrlAsset.duration,timeRange.duration))
    {
        fitTimeRange.duration = avUrlAsset.duration;
    }
    if (CMTimeCompare(timeRange.duration,kCMTimeZero))
    {
        fitTimeRange.duration = avUrlAsset.duration;
    }
    return fitTimeRange;
}


-(AVMutableComposition *)composition{
    if (!_composition) {
        _composition = [AVMutableComposition composition];
    }
    return _composition;
}




-(void)innnerCompositeWithChannel:(VPKCompositonChannel *)singleChannel
                       outPutPath:(NSString *)path
                    configuration:(VPK_Inner_Compos_Config)configuration
                    progressBlock:(VPK_Compos_Progress)progressBlock
                         complete:(VPK_Compos_Success)successBlock
{
    
    
    AVAsset *videoAsset = [AVAsset assetWithURL:singleChannel.fileUrl];
    // 1 - Early exit if there's no video file selected
    if (!videoAsset) {
        NSLog(@"合成资源不存在");
        return;
    }
    
    // 2 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    // 3 - Video track
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    
    
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                        ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                         atTime:kCMTimeZero error:nil];
    
    
    if([videoAsset tracksWithMediaType:AVMediaTypeAudio].count != 0){
        
        // 没有音轨就不要创建，不然创建了不加会生成不出来
        AVMutableCompositionTrack  *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                            ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                             atTime:kCMTimeZero error:nil];
    }
    
    // 3.1 - Create AVMutableVideoCompositionInstruction
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    
    // 3.2 - Create an AVMutableVideoCompositionLayerInstruction for the video track and fix the orientation.
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    UIImageOrientation videoAssetOrientation_  = UIImageOrientationUp;
    BOOL isVideoAssetPortrait_  = NO;
    CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ = UIImageOrientationRight;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ =  UIImageOrientationLeft;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
        videoAssetOrientation_ =  UIImageOrientationUp;
    }
    if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
        videoAssetOrientation_ = UIImageOrientationDown;
    }
    [videolayerInstruction setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
    [videolayerInstruction setOpacity:0.0 atTime:videoAsset.duration];
    
    // 3.3 - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    
    CGSize naturalSize;
    if(isVideoAssetPortrait_){
        naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
    } else {
        naturalSize = videoAssetTrack.naturalSize;
    }
    
    float renderWidth, renderHeight;
    renderWidth = naturalSize.width;
    renderHeight = naturalSize.height;
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    
    // 设定帧率
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    
    
    __weak typeof(AVMutableVideoComposition) *weakComposition = mainCompositionInst;
    
    // 配置动画参数
    if(configuration){
        configuration(weakComposition,naturalSize);
    }
    
    // 4 - Get path
    NSURL *url = [NSURL fileURLWithPath:path];
    
    // 5 - Create exporter
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                      presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL=url;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = mainCompositionInst;
    

    __block NSTimer *timer = nil;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.20 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@" 打印信息:%f",exporter.progress);
        if (progressBlock) {
            progressBlock(exporter.progress);
        }
    }];
    
    // 合成完毕
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
        // 回到主线程
        switch (exporter.status) {
                case AVAssetExportSessionStatusUnknown:
                NSLog(@"exporter Unknow");
                break;
                case AVAssetExportSessionStatusCancelled:
                NSLog(@"exporter Canceled");
                break;
                case AVAssetExportSessionStatusFailed:
                NSLog(@"%@", [NSString stringWithFormat:@"exporter Failed%@",exporter.error.description]);
                break;
                case AVAssetExportSessionStatusWaiting:
                NSLog(@"exporter Waiting");
                break;
                case AVAssetExportSessionStatusExporting:
                NSLog(@"exporter Exporting");
                break;
                case AVAssetExportSessionStatusCompleted:
                NSLog(@"exporter Completed");
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 调用播放方法
                    if(successBlock)successBlock([NSURL fileURLWithPath:path]);
                });
                break;
        }
    }];
    
    
}





@end
