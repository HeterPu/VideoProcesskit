//
//  VPKCompositonManager.h
//  VideoProcessKitTest
//
//  Created by Peter Hu on 2018/7/2.
//  Copyright © 2018年 PeterHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

/*
 Attention:
 利用支持的 AVAssetExportPresetAppleM4A 编码最后转换成mp3,然并卵！那么问题来了，事实上在Apple 框架支持中不支持mp3的编码，只有解码，在苹果官方ipod，itunes中是大力支持AAC格式编码的，当然为了推广却没有被人们所熟悉。
 M4A的全称为(MPEG AAC),也指代AAC AAC是目前世界上音质最好的有损音频格式,用最高品质Q10参数转出来的AAC,音质比MP3好很多,非常接近无损。
 */


/**
 合成成功的block
 @param fileUrl 合成后的地址
 */
typedef void(^VPK_CompositeSuccessBlcok)(NSURL *fileUrl);


/**
 合成的进度
 @param progress 进度百分比
 */
typedef void(^VPK_CompositionProgress)(CGFloat progress);


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



@property(nonatomic,copy) NSString  *presetName;

@property(nonatomic,copy) NSString  *outputFileType;


-(void)compositeWthVideoChannels:(NSArray<NSArray< VPKCompositonChannel *> *> *) videoChannels
                   audioChannels:(NSArray<NSArray< VPKCompositonChannel *> *> *)audioChannels
                      outPutParh:(NSString *)path
                   progressBlock:(VPK_CompositionProgress)progressBlock
                    successBlock:(VPK_CompositeSuccessBlcok)successBlock;


@end
