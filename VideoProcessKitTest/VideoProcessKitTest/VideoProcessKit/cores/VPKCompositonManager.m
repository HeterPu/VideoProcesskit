//
//  VPKCompositonManager.m
//  VideoProcessKitTest
//
//  Created by Peter Hu on 2018/7/2.
//  Copyright © 2018年 PeterHu. All rights reserved.
//

#import "VPKCompositonManager.h"
#import "VPKFileManager.h"



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
 进度block
 */
@property (nonatomic,copy)VPK_CompositionProgress progressBlock;


/**
 标识是否为纯音频合成
 */
@property(nonatomic,assign) BOOL isPureAudioComposite;

@end


@implementation VPKCompositonManager



-(void)compositeWthVideoChannels:(NSArray<NSArray< VPKCompositonChannel *> *> *) videoChannels
                   audioChannels:(NSArray<NSArray< VPKCompositonChannel *> *> *)audioChannels
                      outPutParh:(NSString *)path
                   progressBlock:(VPK_CompositionProgress)progressBlock
                    successBlock:(VPK_CompositeSuccessBlcok)successBlock{
    
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
      progressBlock:(VPK_CompositionProgress)progressBlock
            success:(VPK_CompositeSuccessBlcok)successBlcok
{
    AVMutableVideoComposition
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





@end
