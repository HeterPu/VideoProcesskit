//
//  VPKCompositonManager.m
//  VideoProcessKitTest
//
//  Created by Peter Hu on 2018/7/2.
//  Copyright © 2018年 PeterHu. All rights reserved.
//

#import "VPKCompositonManager.h"
#import "VPKFileManager.h"
#import "VPKVideoEditTool.h"
#import <UIKit/UIKit.h>



@interface VPKCompositonChannel()

@property(nonatomic,assign) NSInteger channelId;
@property(nonatomic,copy) AVMediaType mediaType;
@property(nonatomic,assign)CMTimeRange range;
@property(nonatomic,strong) NSURL *fileUrl;



@end


@implementation VPKCompositonChannel



-(instancetype)initWithChannelId:(NSInteger)channelId
                       mediaType:(AVMediaType)type range:(CMTimeRange)range
                         fileUrl:(NSURL *)fileUrl{
    self =  [super init];
    _channelId = channelId;
    _mediaType = type;
    _range = range;
    _fileUrl = fileUrl;
    _startTime = kCMTimeZero;
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


@property (strong, nonatomic) NSTimer *mixTimer;
@property(nonatomic,weak) AVAssetExportSession *mixExport;
@property(nonatomic,copy) VPK_Compos_Progress mixProgressBlock;


@property (strong, nonatomic) NSTimer *innerTimer;
@property(nonatomic,weak) AVAssetExportSession *innerExport;
@property(nonatomic,copy) VPK_Compos_Progress innerProgressBlock;

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
            VPKCompositonChannel *channel = pipeChannel[i];
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
                CMTime startTime = channel.compositeType == VPKCompositonChannelTypePipe ? kCMTimeInvalid :channel.startTime;
                [videoTrack insertTimeRange:fileTimeRange ofTrack:videoAssetTrack atTime:startTime error:nil];
                // 音频采集通道
                AVAssetTrack *audioAssetTrack = [[fileAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
                // 加入合成轨道之中
                [audioTrack insertTimeRange:fileTimeRange ofTrack:audioAssetTrack atTime:startTime error:nil];
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
                  VPKCompositonChannel *channel = pipeChannel[i];
                  if (channel.mediaType == AVMediaTypeAudio) {
                      AVURLAsset *fileAsset = [[AVURLAsset alloc] initWithURL:channel.fileUrl options:nil];
                      CMTimeRange  fileTimeRange = [self fitTimeRange:channel.range avUrlAsset:fileAsset];
                      AVAssetTrack *audioAssetTrack = [[fileAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
                      CMTime startTime = channel.compositeType == VPKCompositonChannelTypePipe ? kCMTimeInvalid :channel.startTime;
                      // 把采集轨道数据加入到可变轨道之中
                      [audioTrack insertTimeRange:fileTimeRange ofTrack:audioAssetTrack atTime:startTime error:nil];
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
            success:(VPK_Compos_Success)successBlock
{
    
    _mixProgressBlock = progressBlock;
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
    _mixExport  = assetExport;
    
     _mixTimer = [NSTimer  timerWithTimeInterval:0.20 target:self selector:@selector(mixCompositionTimerCall) userInfo:nil repeats:YES];
    
    __weak typeof(self) weakSelf = self;
    // 合成完毕
    [assetExport exportAsynchronouslyWithCompletionHandler:^{
        if (weakSelf.mixTimer) {
            [weakSelf.mixTimer invalidate];
            weakSelf.mixTimer = nil;
        }
        // 回到主线程
        switch (assetExport.status) {
            case AVAssetExportSessionStatusUnknown:
                NSLog(@"exporter Unknow");
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"exporter Canceled");
                 if(successBlock) successBlock(nil,@"exporter Canceled");
                break;
            case AVAssetExportSessionStatusFailed:
                 if(successBlock) successBlock(nil,@"exporter fail");
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
                    successBlock([NSURL fileURLWithPath:storePath],nil);
                });
                break;
        }
    }];
}




//得到合适的时间
- (CMTimeRange)fitTimeRange:(CMTimeRange)timeRange avUrlAsset:(AVURLAsset *)avUrlAsset
{
    CMTimeRange fitTimeRange = timeRange;
    if (CMTIME_COMPARE_INLINE(avUrlAsset.duration, <=, timeRange.duration))fitTimeRange.duration = avUrlAsset.duration;
    if (CMTIME_COMPARE_INLINE(timeRange.duration, <= ,kCMTimeZero))fitTimeRange.duration = avUrlAsset.duration;
    return fitTimeRange;
}


-(AVMutableComposition *)composition{
    if (!_composition) {
        _composition = [AVMutableComposition composition];
    }
    return _composition;
}




-(void)innerCompositeWithChannel:(VPKCompositonChannel *)singleChannel
                       outPutPath:(NSString *)path
                    configuration:(VPK_Inner_Compos_Config)configuration
                    progressBlock:(VPK_Compos_Progress)progressBlock
                         complete:(VPK_Compos_Success)successBlock
{
    
    
    AVAsset *videoAsset = [AVAsset assetWithURL:singleChannel.fileUrl];
    // 1 - Early exit if there's no video file selected
    if (!videoAsset) {
        NSLog(@"合成资源不存在");
        if(successBlock) successBlock(nil,@"合成资源不存在");
        return;
    }
    _innerProgressBlock = progressBlock;
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
    __weak typeof(self) weakSelf = self;
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
    _innerExport  = exporter;
    
    _innerTimer = [NSTimer  timerWithTimeInterval:0.20 target:self selector:@selector(innerCompositionTimerCall) userInfo:nil repeats:YES];
    
    // 合成完毕
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        if (weakSelf.innerTimer) {
            [weakSelf.innerTimer invalidate];
            weakSelf.innerTimer = nil;
        }
        // 回到主线程
        switch (exporter.status) {
                case AVAssetExportSessionStatusUnknown:
                NSLog(@"exporter Unknow");
                break;
                case AVAssetExportSessionStatusCancelled:
                NSLog(@"exporter Canceled");
                if(successBlock) successBlock(nil,@"exporter Canceled");
                break;
                case AVAssetExportSessionStatusFailed:
                if(successBlock) successBlock(nil,@"exporter fail");
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
                    if(successBlock)successBlock([NSURL fileURLWithPath:path],nil);
                });
                break;
        }
    }];
}



-(void)mixCompositionTimerCall{
    if (_mixProgressBlock) {
        self.mixProgressBlock(_mixExport.progress);
    }
}


-(void)innerCompositionTimerCall{
    if (_innerProgressBlock) {
        self.innerProgressBlock(_innerExport.progress);
    }
}



-(void)cropVideoWithFillUrl:(NSURL *)inputUrl
                      begin:(NSTimeInterval)begin
                        end:(NSTimeInterval)end
                 outputPath:(NSString *)outputPath
              progressBlock:(VPK_Compos_Progress)progressBlock
                   complete:(VPK_Compos_Success)successBlock{
    
    if(end <= begin || !inputUrl) {
        NSLog(@"输入文件为空或者开始时间小于结束时间");
        if(successBlock) successBlock(nil,@"输入文件为空或者开始时间小于结束时间");
        return;
    }
    
    begin = begin <=0 ? 0 : begin;
    // 获取视频资源
    NSURL *videoURL  = inputUrl;
    AVAsset *videoAsset = [AVAsset assetWithURL:videoURL];
    // 视频总时长
    NSTimeInterval videoDuration = CMTimeGetSeconds(videoAsset.duration);
    end = end <= videoDuration ? end : videoDuration;
    // 准备裁剪时间
    NSTimeInterval duration = end-begin;
    CMTimeRange range = CMTimeRangeMake(CMTimeMakeWithSeconds(begin, videoAsset.duration.timescale),
                                        CMTimeMakeWithSeconds(duration, videoAsset.duration.timescale));
    // 准备存储位置
    if([[NSFileManager defaultManager] fileExistsAtPath:outputPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:outputPath error:nil];
    }
    
    // 设置导出参数
    NSArray *presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:videoAsset];
    NSString *presetName = AVAssetExportPresetHighestQuality;
    // 如果不支持高质量压缩, 就使用默认压缩的第一个
    if (![presets containsObject:presetName]) {
        presetName = presets.firstObject;
    }
    
    
    __block AVAssetExportSession *export = [[AVAssetExportSession alloc] initWithAsset:videoAsset
                                                                            presetName:presetName];
    // 获取导出格式
    NSArray *supportFiles = export.supportedFileTypes;
    AVFileType outputFileType = AVFileTypeMPEG4;
    if(![supportFiles containsObject:outputFileType]) {
        outputFileType = supportFiles.firstObject;
    }
    export.outputURL = [NSURL fileURLWithPath:outputPath];
    export.outputFileType = outputFileType;
    export.shouldOptimizeForNetworkUse = YES;
    export.timeRange = range;
    
    
    
    __block NSTimer *timer = nil;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.20 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@" 打印信息:%f",export.progress);
        if (progressBlock) {
            progressBlock(export.progress);
        }
    }];
    
    
    NSLog(@"outputURL: %@\noutputFileType: %@\nstart.value: %lld\nstart.timescale:%d\nduration.value: %lld\nduration.timescale: %d",
          export.outputURL,
          export.outputFileType,
          export.timeRange.start.value, export.timeRange.start.timescale,
          export.timeRange.duration.value, export.timeRange.duration.timescale);
    
    
    [export exportAsynchronouslyWithCompletionHandler:^{
        
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
        
        // 回到主线程
        switch (export.status) {
            case AVAssetExportSessionStatusUnknown:
                NSLog(@"exporter Unknow");
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"exporter Canceled");
                 if(successBlock) successBlock(nil,@"exporter Canceled");
                break;
            case AVAssetExportSessionStatusFailed:
                 if(successBlock) successBlock(nil,@"exporter fail");
                NSLog(@"%@", [NSString stringWithFormat:@"exporter Failed%@",export.error.description]);
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
                    if(successBlock) successBlock([NSURL fileURLWithPath:outputPath],nil);
                });
                break;
        }
    }];
}


-(void)compressVideoAssetWithAssetUrl:(NSURL *)url outputPath:(NSString *)outputPath options:(NSDictionary *)options complete:(void (^)(NSError *))complete{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSError *error = nil;
        AVAssetReader *reader = [VPKVideoEditTool readerWithAssetUrl:url error:&error];
        AVAssetWriter *writer = [VPKVideoEditTool writerWithOutputPath:outputPath options:options error:&error];
        if(error || !reader || !writer) {
            NSLog(@"init reader or writer fail: %@", error);
            if(complete)complete(error);
            return ;
        }
        
        __block   BOOL audioFinished = NO;
        __block   BOOL videoFinished = NO;
        
        // 获取 input 和 output
        AVAssetReaderTrackOutput *videoOutput = nil;
        AVAssetReaderTrackOutput *audioOutput = nil;
        AVAssetWriterInput *videoInput = nil;
        AVAssetWriterInput *audioInput = nil;
        
        
        // Create the serialization queue to use for reading and writing the video data.
        
        NSLog(@"the count of outputs is %li",reader.outputs.count);
        for (AVAssetReaderTrackOutput *output in reader.outputs) {
            if([output.mediaType isEqualToString:AVMediaTypeVideo]) {
                videoOutput = output;
                continue;
            }
            if([output.mediaType isEqualToString:AVMediaTypeAudio]) {
                audioOutput = output;
                continue;
            }
        }
        
        NSLog(@"the count of inputs is %li",reader.outputs.count);
        
        for (AVAssetWriterInput *input in writer.inputs) {
            if ([input.mediaType isEqualToString:AVMediaTypeVideo]) {
                videoInput = input;
                continue;
            }
            if([input.mediaType isEqualToString:AVMediaTypeAudio]) {
                audioInput = input;
                continue;
            }
        }
        if(!videoOutput && !audioOutput) {
            NSLog(@"没有输出信息");
            if (complete) {
                error = [NSError errorWithDomain:@"ots.media.tool.err" code:1 userInfo:@{}];
                complete(error);
            }
            return ;
        }
        if(!videoInput && !audioInput) {
            NSLog(@"没有输入信息");
            if (complete) {
                error = [NSError errorWithDomain:@"ots.media.tool.err" code:1 userInfo:@{}];
                complete(error);
            }
            return ;
        }
        
        // 基础配置, 开始读取,开始写入
        videoInput.transform = videoOutput.track.preferredTransform;
        [reader startReading];
        [writer startWriting];
        [writer startSessionAtSourceTime:kCMTimeZero];
        
        dispatch_group_t dispatchGroup = dispatch_group_create();
        // 循环写入音频
        if (audioInput && audioOutput)
        {
            // 加入 Group, 循环写入音频
            dispatch_group_enter(dispatchGroup);
            [audioInput requestMediaDataWhenReadyOnQueue: dispatch_queue_create([@"audioDispatch" UTF8String], NULL) usingBlock:^{
                if (audioFinished)return;
                BOOL completedOrFailed = false;
                while ([audioInput isReadyForMoreMediaData] && !completedOrFailed)
                {
                    // Get the next audio sample buffer, and append it to the output file.
                    CMSampleBufferRef sampleBuffer = [audioOutput copyNextSampleBuffer];
                    if (!sampleBuffer){
                        completedOrFailed = YES;
                        break;
                    }
                    BOOL success = true;
                    success = [audioInput appendSampleBuffer:sampleBuffer];
                    CFRelease(sampleBuffer);
                    sampleBuffer = NULL;
                    completedOrFailed = !success;
                }
                
                
                if (completedOrFailed)
                {
                    
                    
                    BOOL oldFinished = audioFinished;
                    audioFinished = YES;
                    if (oldFinished == NO)
                    {
                        [audioInput markAsFinished];
                    }
                    dispatch_group_leave(dispatchGroup);
                }
            }];
        }
        // 循环写入视频
        if (videoInput && videoOutput)
        {
            
            dispatch_group_enter(dispatchGroup);
            [videoInput requestMediaDataWhenReadyOnQueue:dispatch_queue_create([@"videoDispatch" UTF8String], NULL)  usingBlock:^{
                if (videoFinished) return;
                BOOL completedOrFailed = NO;
                while ([videoInput isReadyForMoreMediaData] && !completedOrFailed)
                {
                    CMSampleBufferRef sampleBuffer = [videoOutput copyNextSampleBuffer];
                    if(!sampleBuffer) {
                        completedOrFailed = YES;
                        break;
                    }
                    BOOL success = true;
                    success = [videoInput appendSampleBuffer:sampleBuffer];
                    CFRelease(sampleBuffer);
                    sampleBuffer = nil;
                    completedOrFailed = !success;
                }
                if (completedOrFailed)
                {
                    
                    BOOL oldFinished = videoFinished;
                    videoFinished = YES;
                    if (oldFinished == NO)
                    {
                        [videoInput markAsFinished];
                    }
                    dispatch_group_leave(dispatchGroup);
                }
            }];
        }
        // 导出文件
        dispatch_group_notify(dispatchGroup, dispatch_queue_create([@"audioVideoMainDispatch" UTF8String], NULL), ^{
            if(reader.error && complete) {
                complete(reader.error);
                return;
            }
            [writer finishWritingWithCompletionHandler:^{
                if (complete) complete(writer.error);
            }];
        });
    });
}


@end
