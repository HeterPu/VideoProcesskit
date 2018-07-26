//
//  videoWatermarksCon.m
//  VideoProcessKitTest
//
//  Created by Peter Hu on 2018/7/25.
//  Copyright © 2018 PeterHu. All rights reserved.
//

#import "videoWatermarksCon.h"
#import "AddBorderCon.h"
#import "AddOverLayerCon.h"
#import "AddSubtitleCon.h"
#import "AddTiltCon.h"
#import "AddAnimationCon.h"
#import "AddLottieViewCon.h"

@interface videoWatermarksCon ()

@end

@implementation videoWatermarksCon


- (IBAction)addborderClick:(id)sender {
    AddBorderCon *con = [[AddBorderCon alloc]init];
    [self.navigationController pushViewController:con animated:true];
}


- (IBAction)addOverlayer:(id)sender {
    AddOverLayerCon *con = [[AddOverLayerCon alloc]init];
    [self.navigationController pushViewController:con animated:true];
}


- (IBAction)addSubtitle:(id)sender {
    AddSubtitleCon *con = [[AddSubtitleCon alloc]init];
    [self.navigationController pushViewController:con animated:true];
}
- (IBAction)addTile:(id)sender {
    AddTiltCon *con = [[AddTiltCon alloc]init];
    [self.navigationController pushViewController:con animated:true];
    
}


- (IBAction)addAnimation:(id)sender {
    AddAnimationCon *con = [[AddAnimationCon alloc]init];
    [self.navigationController pushViewController:con animated:true];
}


- (IBAction)lottieClick:(id)sender {
    AddLottieViewCon *con = [[AddLottieViewCon alloc]init];
    [self.navigationController pushViewController:con animated:true];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
