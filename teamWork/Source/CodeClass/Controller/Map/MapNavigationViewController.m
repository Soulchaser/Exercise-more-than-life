//
//  MapNavigationViewController.m
//  teamWork
//
//  Created by hanxiaolong on 16/1/20.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "MapNavigationViewController.h"

@interface MapNavigationViewController ()

@end

@implementation MapNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self shouldAutorotate];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置是否支持横屏，no是不支持
- (BOOL)shouldAutorotate
{
    return NO;
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
