//
//  VPKVideoEditTool.h
//  VideoProcessKitTest
//
//  Created by Peter Hu on 2018/7/31.
//  Copyright © 2018 PeterHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


FOUNDATION_EXPORT NSString * const VPKVideoCompressKeyWidth;
FOUNDATION_EXPORT NSString * const VPKVideoCompressKeyHeight;

@interface VPKVideoEditTool : NSObject



/**
 获取视频文件的编码格式
 
 @param fileUrl 要查看的文件路径 file:/// 的url
 @return 文件编码格式, 如: vide/avc1
 */
+(NSString *)getVideoEncodeTypeWithFileUrl:(NSURL *)fileUrl;



/**
 获取视频信息(给服务器使用)
 
 @param fileUrl 视频路径 file:/// 的字符串
 @return 视频信息
 {
 @"duration" :   视频时长
 @"angle"    :   视频角度
 @"width"    :   视频原始宽
 @"height"   :   视频原始高
 }
 */
+ (NSDictionary *)getVideoInfoWithFileUrl:(NSURL *)fileUrl;


/**
 获取视频旋转方向
 
 @param fileUrl 输入文件路径 file:/// 的url
 @return 返回角度信息
 Portrait  90
 PortraitUpsideDown 270;
 LandscapeRight  0
 LandscapeLeft   180
 */
+(NSInteger)getVideoRotateAngleFileUrl:(NSURL *)fileUrl;





/**
 获取资源文件的读取器
 
 @param url 资源文件的 url, 可以为文件 url 或网络 url
 @param error 若读取失败则回传错误对象
 @return AVAssetReader
 
 注意: 此处仅创建读取器, 若使用需先调用 startReading 方法
 */
+ (AVAssetReader *)readerWithAssetUrl:(NSURL *)url
                                error:(NSError **)error;



/**
 初始化一个资源写入器
 
 @param outputPath 资源写入路径
 @param options 资源写入的选项, key value 待定
 @param error 若初始化失败则回传错误对象
 @return 资源写入器
 
 注意: 此处仅创建写入器, 若使用需先调用 startWriting 和 startSessionAtSourceTime 方法
 
 */


+ (AVAssetWriter *)writerWithOutputPath:(NSString *)outputPath
                                options:(NSDictionary *)options
                                  error:(NSError **)error;


@end
