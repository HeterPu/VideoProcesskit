//
//  VPKVideoEditTool.m
//  VideoProcessKitTest
//
//  Created by Peter Hu on 2018/7/31.
//  Copyright © 2018 PeterHu. All rights reserved.
//

#import "VPKVideoEditTool.h"


NSString *const VPKVideoCompressKeyWidth = @"VPKVideoCompressKeyWidth";
NSString *const VPKVideoCompressKeyHeight = @"VPKVideoCompressKeyHeight";


@implementation VPKVideoEditTool



// FourCharCode 转 NSString
static NSString * FourCCString(FourCharCode code) {
    NSString *result = [NSString stringWithFormat:@"%c%c%c%c",
                        (code >> 24) & 0xff,
                        (code >> 16) & 0xff,
                        (code >> 8) & 0xff,
                        code & 0xff];
    NSCharacterSet *characterSet = [NSCharacterSet whitespaceCharacterSet];
    return [result stringByTrimmingCharactersInSet:characterSet];
}


+(NSString *)getVideoEncodeTypeWithFileUrl:(NSURL *)fileUrl{
    // 文件不存在
    if(!fileUrl) {
        return nil;
    }
    // 获取资源
    AVAsset *videoAsset = [AVAsset assetWithURL:fileUrl];
    // 提取视频轨
    AVAssetTrack *track = [videoAsset tracksWithMediaType:AVMediaTypeVideo].firstObject;
    if (!track) return nil;
    // 拼凑格式, 参考: https://developer.apple.com/documentation/avfoundation/avassettrack/1386694-formatdescriptions?language=objc
    NSMutableString *format = [[NSMutableString alloc] init];
    for (int i = 0; i < track.formatDescriptions.count; i++) {
        CMFormatDescriptionRef desc =
        (__bridge CMFormatDescriptionRef)track.formatDescriptions[i];
        // Get String representation of media type (vide, soun, sbtl, etc.)
        NSString *type = FourCCString(CMFormatDescriptionGetMediaType(desc));
        // Get String representation media subtype (avc1, aac, tx3g, etc.)
        NSString *subType = FourCCString(CMFormatDescriptionGetMediaSubType(desc));
        // Format string as type/subType
        [format appendFormat:@"%@/%@", type, subType];
        // Comma separate if more than one format description
        if (i < track.formatDescriptions.count - 1) {
            [format appendString:@","];
        }
    }
    return format;
}



+(NSDictionary *)getVideoInfoWithFileUrl:(NSURL *)fileUrl{
    // 文件不存在
    if(!fileUrl) {
        return nil;
    }
    // 获取资源
    AVAsset *videoAsset = [AVAsset assetWithURL:fileUrl];
    AVAssetTrack *track = [videoAsset tracksWithMediaType:AVMediaTypeVideo].firstObject;
    if(!track) return nil;
    
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithCapacity:4];
    NSString *durationKey = @"duration";
    NSString *wKey = @"width";
    NSString *hKey = @"height";
    NSString *anKey = @"angle";
    // 获取时长
    CGFloat second = CMTimeGetSeconds(videoAsset.duration);
    if (isnan(second)) second =0;
    NSNumber *duration = @(second);
    [info setObject:duration forKey:durationKey];
    // 获取原始尺寸(后台需要)
    [info setObject:@(track.naturalSize.width) forKey:wKey];
    [info setObject:@(track.naturalSize.height) forKey:hKey];
    // 计算角度
    CGAffineTransform txf = track.preferredTransform;
    CGFloat an  = (atan2(txf.b, txf.a)) * (180.0/M_PI);
    CGFloat min = 0.001;
    // 90 转 -90, 转完即返回
    if((ABS(an-90)) <= min) {
        an = -90;
        [info setObject:@(an) forKey:anKey];
        return info;
    }
    // -90 转 90, 转完即返回
    if((ABS(an-(-90))) <= min) {
        an = 90;
        [info setObject:@(an) forKey:anKey];
        return info;
    }
    // 0 与 180 无需转换, 直接返回
    [info setObject:@(an) forKey:anKey];
    return info;
}


+(NSInteger)getVideoRotateAngleFileUrl:(NSURL *)fileUrl{
    NSUInteger degress = 0;
    AVAsset *asset = [AVAsset assetWithURL:fileUrl];
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;
        
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
            // Portrait
            degress = 90;
        }else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
            // PortraitUpsideDown
            degress = 270;
        }else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
            // LandscapeRight
            degress = 0;
        }else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
            // LandscapeLeft
            degress = 180;
        }
    }
    return degress;
}


+(AVAssetReader *)readerWithAssetUrl:(NSURL *)url error:(NSError *__autoreleasing *)error{
    
    // 初始化 reader
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetReader *assetReader = [[AVAssetReader alloc] initWithAsset:asset error:error];
    if(!assetReader) return assetReader;
    
    // 添加 track output
    for (AVAssetTrack *track in asset.tracks) {
        NSDictionary *outputSetting = nil;
        if ([track.mediaType isEqualToString:AVMediaTypeAudio]) {
            outputSetting = @{ AVFormatIDKey : @(kAudioFormatLinearPCM)};
        }
        if([track.mediaType isEqualToString:AVMediaTypeVideo]) {
            outputSetting = @{
                              (id)kCVPixelBufferPixelFormatTypeKey     : @(kCVPixelFormatType_422YpCbCr8),
                              (id)kCVPixelBufferIOSurfacePropertiesKey : [NSDictionary dictionary]
                              };
        }
        if(!outputSetting) continue;
        AVAssetReaderTrackOutput *trackOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:track outputSettings:outputSetting];
        if([assetReader canAddOutput:trackOutput]) {
            [assetReader addOutput:trackOutput];
        }
    }
    return assetReader;
}



+(AVAssetWriter *)writerWithOutputPath:(NSString *)outputPath options:(NSDictionary *)options error:(NSError *__autoreleasing *)error{
    if([[NSFileManager defaultManager] fileExistsAtPath:outputPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:outputPath error:nil];
    }
    // 初始化资源写入器
    NSURL *outputUrl = [NSURL fileURLWithPath:outputPath];
    AVAssetWriter *assetWriter = [[AVAssetWriter alloc] initWithURL:outputUrl fileType:AVFileTypeMPEG4 error:error];
    if(!assetWriter) return assetWriter;
    
    // 添加音频输入
    AudioChannelLayout stereoChannelLayout = {
        .mChannelLayoutTag = kAudioChannelLayoutTag_Stereo,
        .mChannelBitmap = 0,
        .mNumberChannelDescriptions = 0
    };
    NSData *channelLayoutAsData = [NSData dataWithBytes:&stereoChannelLayout length:offsetof(AudioChannelLayout, mChannelDescriptions)];
    NSDictionary *compressionAudioSettings = @{
                                               AVFormatIDKey         : [NSNumber numberWithUnsignedInt:kAudioFormatMPEG4AAC],
                                               AVEncoderBitRateKey   : [NSNumber numberWithInteger:128000],
                                               AVSampleRateKey       : [NSNumber numberWithInteger:44100],
                                               AVChannelLayoutKey    : channelLayoutAsData,
                                               AVNumberOfChannelsKey : [NSNumber numberWithUnsignedInteger:2],
                                               };
    AVAssetWriterInput *assetWriterAudioInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:compressionAudioSettings];
    if([assetWriter canAddInput:assetWriterAudioInput]) {
        [assetWriter addInput:assetWriterAudioInput];
    }
    
    // 视频输入
    NSNumber *width = [options objectForKey:VPKVideoCompressKeyWidth];
    NSNumber *height = [options objectForKey:VPKVideoCompressKeyHeight];
    width = width ? width : @(960);
    height = height ? height : @(540);
    float bitrate = width.floatValue * height.floatValue *3;
    NSMutableDictionary *videoSettings = [@{
                                            AVVideoCodecKey  : AVVideoCodecTypeH264,
                                            AVVideoWidthKey  : width,
                                            AVVideoHeightKey : height,
                                            AVVideoCompressionPropertiesKey: @{
                                                    // 关键帧的间隔，1为所有帧都是关键帧，值越高，压缩率越高
                                                    AVVideoMaxKeyFrameIntervalKey: @150,
                                                    // 也可以使用track.estimatedDataRate,它直接决定了视频文件的大小
                                                    AVVideoAverageBitRateKey: @(bitrate),
                                                    }
                                            } mutableCopy];
    // Create the asset writer input and add it to the asset writer.
    AVAssetWriterInput *assetWriterVideoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    assetWriterVideoInput.expectsMediaDataInRealTime = YES;
    if([assetWriter canAddInput:assetWriterVideoInput]) {
        [assetWriter addInput:assetWriterVideoInput];
    }
    return assetWriter;
}


@end
