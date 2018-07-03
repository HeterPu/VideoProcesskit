//
//  VPKFileManager.h
//  VideoProcessKitTest
//
//  Created by Peter Hu on 2018/6/29.
//  Copyright © 2018年 PeterHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPKFileManager : NSObject


#pragma mark - GetFilePath


/**
 获取文件位置路径
 @return 返回文件路径字符串
 */
+(NSString *)getDocumentPath;


/**
 获取Libarary路径
 @return 获取Libarary路径字符串
 */
+(NSString *)getLibararyPath;


/**
 获取Cache路径
 @return 获取Cache路径字符串
 */
+(NSString *)getCachePath;


/**
 获取Temp的路径

 @return 获取Temp的路径字符串
 */
+(NSString *)getTempPath;


/**
 获取应用Application
 @return 获取应用的路径
 */
+(NSString *)getApplicationPath;


#pragma mark - File Manupulation


/**
  文件在某个路径是否存在
 @param filepath 文件路径
 */
+(BOOL)isFileExistOfPath:(NSString *)filepath;



/**
 从某个路径移除文件
 @param filepath 文件路径
 @return 是否移除成功
 */
+(BOOL)removeFileOfPath:(NSString *)filepath;



/**
 创建路径
 @param dirPath 具体路径
 @return 是否创建成功
 */
+(BOOL)creatDirectoryWithPath:(NSString *)dirPath;



/**
 按路径创建文件
 @param filePath 文件路径
 @return 是否创建成功
 */
+ (BOOL)creatFileWithPath:(NSString *)filePath;



/**
 移动文件
 @param fromPath 从某路径
 @param toPath 到某路径
 @return 是否成功
 */
+ (BOOL)moveFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath;


/**
 拷贝文件
 @param fromPath 从某路径
 @param toPath 到某路径
 @return 是否成功
 */
+(BOOL)copyFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath;




/**
 在某路径保存文件
 @param filePath 文件路径
 @param data 数据
 @return 是否保存成功
 */
+ (BOOL)saveFile:(NSString *)filePath withData:(NSData *)data;



/**
 给路径附加数据
 @param data 数据
 @param path 路径
 @return 是否附加成功
 */
+ (BOOL)appendData:(NSData *)data withPath:(NSString *)path;



/**
 在某路径获取数据
 @param filePath 文件路径
 @return 是否成功
 */
+ (NSData *)getFileData:(NSString *)filePath;



/**
 获取指定长度的数据
 @param filePath 文件路径
 @param startIndex 开始
 @param length 长度
 @return 是否成功
 */
+ (NSData *)getFileData:(NSString *)filePath startIndex:(long long)startIndex length:(NSInteger)length;



/**
 获取文件夹列表
 @param path 路径
 @return 是否成功
 */
+ (NSArray *)getFileListInFolderWithPath:(NSString *)path;


/**
 获取文件大小
 @param path 路径信息
 @return 是否成功
 */
+ (long long)getFileSizeWithPath:(NSString *)path;


/**
 获取文件创建日期
 @param path 路径信息
 @return 是否成功
 */
+ (NSString *)getFileCreatDateWithPath:(NSString *)path;


/**
 获取文件作者信息
 @param path 路径信息
 @return 是否成功
 */
+ (NSString *)getFileOwnerWithPath:(NSString *)path;


/**
 获取文件修改日期
 @param path 路径信息
 @return 是否成功
 */
+ (NSString *)getFileChangeDateWithPath:(NSString *)path;


@end
