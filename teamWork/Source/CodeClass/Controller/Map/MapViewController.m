//
//  MapViewController.m
//  teamWork
//
//  Created by hanxiaolong on 16/1/16.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()<MAMapViewDelegate>
@property(strong,nonatomic)MAMapView *mapView;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //设置高德地图的APIKEY
    [MAMapServices sharedServices].apiKey = KamapKey;
    
    self.mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    self.mapView.delegate = self;
    self.mapView.mapType = MAMapTypeStandard;
    [self.view addSubview:self.mapView];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(50, 50, 50, 50)];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    //[[UIApplication sharedApplication].delegate.window addSubview:button];
    //[[UIApplication sharedApplication].delegate.window bringSubviewToFront:button];
    
    [self.mapView addSubview:button];
}

-(void)buttonAction
{
    self.mapView.mapType = MAMapTypeSatellite;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

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
