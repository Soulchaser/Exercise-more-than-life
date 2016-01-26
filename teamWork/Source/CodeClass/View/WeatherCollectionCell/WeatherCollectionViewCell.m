//
//  WeatherCollectionViewCell.m
//  teamWork
//
//  Created by lanou3g on 16/1/25.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "WeatherCollectionViewCell.h"
#import "AddTableViewController.h"
#import "SettingViewController.h"
#import "YDWeatherViewController.h"
@implementation WeatherCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

// !!!:设置按钮点击事件
- (IBAction)SettingAction:(id)sender {
    
    SettingViewController * SetVC = [SettingViewController new];
    
    [[YDWeatherViewController sharedViewController] presentViewController:SetVC animated:YES completion:nil];
    
    
    
}
// !!!:添加按钮点击事件
- (IBAction)AddAction:(id)sender {
   
    AddTableViewController * addVC = [AddTableViewController new];
    
    [[YDWeatherViewController sharedViewController] presentViewController:addVC animated:YES completion:nil];
    
    
}

@end
