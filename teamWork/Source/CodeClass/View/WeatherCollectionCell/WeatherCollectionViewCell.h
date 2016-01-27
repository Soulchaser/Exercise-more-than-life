//
//  WeatherCollectionViewCell.h
//  teamWork
//
//  Created by lanou3g on 16/1/25.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherCollectionViewCell : UICollectionViewCell
//页面的天气简图(上方)
@property (weak, nonatomic) IBOutlet UIImageView *MainWeatherImgView;
//空气质量(AQI)labe
@property (weak, nonatomic) IBOutlet UILabel *AQILabel;
//当前城市City
@property (weak, nonatomic) IBOutlet UILabel *CurrentCityLabel;
//今天的温度
@property (weak, nonatomic) IBOutlet UILabel *CurrentTemLabel;
//今天预报最高温T_today--H_high
@property (weak, nonatomic) IBOutlet UILabel *ForecastTHTemLabel;
//今天预报最低温
@property (weak, nonatomic) IBOutlet UILabel *ForecastTLLabel;
//明天的日期
@property (weak, nonatomic) IBOutlet UILabel *TomorrowDateLabel;
//明天的天气简图
@property (weak, nonatomic) IBOutlet UIImageView *TomorrowWeatherImgView;
//后天的日期TDAT_the day after tomorrow
@property (weak, nonatomic) IBOutlet UILabel *TDATDateLabel;
//后天的天气简图
@property (weak, nonatomic) IBOutlet UIImageView *TDATImgView;
//大后天的日期TDFN_three days from now
@property (weak, nonatomic) IBOutlet UILabel *TDFNDateLabel;
//大后天的天气简图
@property (weak, nonatomic) IBOutlet UIImageView *TDFNImgView;


//设置按钮
@property (weak, nonatomic) IBOutlet UIButton *settingButton;

//添加按钮
@property (weak, nonatomic) IBOutlet UIButton *addButton;



@end
