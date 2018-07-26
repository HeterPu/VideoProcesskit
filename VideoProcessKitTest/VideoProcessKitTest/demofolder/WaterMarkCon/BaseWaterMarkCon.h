//
//  BaseWaterMarkCon.h
//  VideoProcessKitTest
//
//  Created by Peter Hu on 2018/7/26.
//  Copyright © 2018 PeterHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface BaseWaterMarkCon : UIViewController


@property(nonatomic,strong) AVAsset  *videoAsset;


- (BOOL)startMediaBrowserFromViewController:(UIViewController*)controller usingDelegate:(id)delegate ;

-(void)videoOutput;

-(void)applyVideoEffectsToComposition:(AVMutableVideoComposition *) composition size:(CGSize)size;

-(void)exportDidFinish:(AVAssetExportSession *)session;

@end
