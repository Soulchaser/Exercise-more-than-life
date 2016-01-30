//
//  WeatherCollectionViewCell.m
//  teamWork
//
//  Created by lanou3g on 16/1/25.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "WeatherCollectionViewCell.h"

@implementation WeatherCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

// !!!:设置按钮点击事件
- (IBAction)SettingAction:(id)sender {
    
    SettingViewController * SetVC = [SettingViewController new];
    UINavigationController * SetNC = [[UINavigationController alloc] initWithRootViewController:SetVC];
    [[YDWeatherViewController sharedViewController] presentViewController:SetNC animated:YES completion:nil];
    
    
    
}
// !!!:添加按钮点击事件
- (IBAction)AddAction:(id)sender {
   
    AddTableViewController * addVC = [AddTableViewController new];
    UINavigationController * addNC = [[UINavigationController alloc] initWithRootViewController:addVC];
    [[YDWeatherViewController sharedViewController] presentViewController:addNC animated:YES completion:nil];
    
    
}

@end
