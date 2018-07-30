//
//  ViewController.m
//  VideoProcessKitTest
//
//  Created by Peter Hu on 2018/6/29.
//  Copyright © 2018年 PeterHu. All rights reserved.
//

#import "ViewController.h"
#import "MainTableViewCell.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 40)];
    self.title = @"VideoProcessKit Demo";
    // Do any additional setup after loading the view, typically from a nib.
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self getHeader].count;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self getSubTitleArray][section].count;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *titleArra = [self getSubTitleArray][indexPath.section];
    MainTableViewCell *cell = [MainTableViewCell cellWithTableView:tableView];
    cell.titleL.text = titleArra[indexPath.row];
    cell.titleL.textAlignment = NSTextAlignmentCenter;
    return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *view = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 40)];
    view.text = [self getHeader][section];
    view.textAlignment = NSTextAlignmentCenter;
    view.font = [UIFont  italicSystemFontOfSize:20.0];
    view.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0];
    return view;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *titleArra = [self selArra][indexPath.section];
    Class con =  NSClassFromString(titleArra[indexPath.row]);
    UIViewController *controller = [[con alloc]init];
    [self.navigationController pushViewController:controller animated:true];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSArray *)getHeader{
    return @[@"Video Composition",@"Audio Composition",@"Watermarks"];
}

-(NSArray <NSArray *>*)getSubTitleArray{
    return @[@[@"VideoSimpleComposition",@"VideoComplexComposition"],@[@"AudioSimpleComposition",@"AudioComplexComposition"],@[@"VideoWatermarkCon",@"VideoWatermarkConWithVPK"]];
}


-(NSArray *)selArra{
    return @[@[@"SimpleCompositionCon",@"SimpleCompositionCon"],@[@"SimpleCompositionCon",@"SimpleCompositionCon"],@[@"videoWatermarksCon",@"WaterMarkWithVPKCon"]];
}



@end
