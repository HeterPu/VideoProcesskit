//
//  VPKCompositonManager.h
//  VideoProcessKitTest
//
//  Created by Peter Hu on 2018/7/2.
//  Copyright © 2018年 PeterHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "VPKFileManager.h"

/*
 Attention:
 1.利用支持的 AVAssetExportPresetAppleM4A 编码最后转换成mp3,然并卵！那么问题来了，事实上在Apple 框架支持中不支持mp3的编码，只有解码，在苹果官方ipod，itunes中是大力支持AAC格式编码的，当然为了推广却没有被人们所熟悉。
 M4A的全称为(MPEG AAC),也指代AAC AAC是目前世界上音质最好的有损音频格式,用最高品质Q10参数转出来的AAC,音质比MP3好很多,非常接近无损。
 2.视频合成输出路径格式要对应音频 m4a,视频为 movie 或 mp4。
 */

#pragma mark - VPK BLOCKS

/**
 合成成功的block
 @param fileUrl 合成后的地址
 */
typedef void(^VPK_Compos_Success)(NSURL *fileUrl);

/**
 合成的进度
 @param progress 进度百分比
 */
typedef void(^VPK_Compos_Progress)(CGFloat progress);


/**
  Inner合成配置Block
 @param composition 合成的block
 @param videoSize 真实的视频尺寸
 */
typedef void(^VPK_Inner_Compos_Config)(AVMutableVideoComposition *composition,CGSize videoSize);


@interface VPKCompositonChannel:NSObject


/**
 现在未使用到 可以传0
 */
@property(nonatomic,assign) NSInteger channelId;
@property(nonatomic,copy) AVMediaType mediaType;
@property(nonatomic,assign)CMTimeRange range;
@property(nonatomic,strong) NSURL *fileUrl;


-(instancetype)initWithChannelId:(NSInteger)channelId
               mediaType:(AVMediaType) type
                   range:(CMTimeRange)range
                 fileUrl:(NSURL *)fileUrl;

@end



@interface VPKCompositonManager : NSObject



#pragma mark - Output setting

/**
 No set, Default Audio presetName is AVAssetExportPresetAppleM4A，default Video presetName is AVAssetExportPresetHighestQuality.
 */
@property(nonatomic,copy) NSString  *presetName;


/**
  No set, Default Audio outputFileType is AVFileTypeAppleM4A，default Video presetName is AVFileTypeMPEG4.
 */
@property(nonatomic,copy) NSString  *outputFileType;


#pragma mark - Composition

-(void)compositeWthVideoChannels:(NSArray<NSArray< VPKCompositonChannel *> *> *) videoChannels
                   audioChannels:(NSArray<NSArray< VPKCompositonChannel *> *> *)audioChannels
                      outPutParh:(NSString *)outputPath
                   progressBlock:(VPK_Compos_Progress)progressBlock
                    successBlock:(VPK_Compos_Success)successBlock;


-(void)innnerCompositeWithChannel:(VPKCompositonChannel *)singleChannel
                       outPutPath:(NSString *)outputPath
                    configuration:(VPK_Inner_Compos_Config)configration
                    progressBlock:(VPK_Compos_Progress)progressBlock
                         complete:(VPK_Compos_Success)successBlock;

@end
