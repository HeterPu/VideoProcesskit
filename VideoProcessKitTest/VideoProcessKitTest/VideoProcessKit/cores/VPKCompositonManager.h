//
//  VPKCompositonManager.h
//  VideoProcessKitTest
//
//  Created by Peter Hu on 2018/7/2.
//  Copyright © 2018年 PeterHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


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


/**
 进度block
 */
@property (nonatomic,copy)VPK_CompositionProgress progressBlock;


-(void)compositeWthVideoChannels:(NSArray<NSArray< VPKCompositonChannel *> *> *) videoChannels
                   audioChannels:(NSArray<NSArray< VPKCompositonChannel *> *> *)audioChannels
                      outPutParh:(NSString *)path
                    successBlock:(VPK_CompositeSuccessBlcok)successBlock;


@end
