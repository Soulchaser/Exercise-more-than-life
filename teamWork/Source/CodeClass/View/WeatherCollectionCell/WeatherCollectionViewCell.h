//
//  WeatherCollectionViewCell.h
//  teamWork
//
//  Created by lanou3g on 16/1/25.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherCollectionViewCell : UICollectionViewCell
//今天的温度
@property (weak, nonatomic) IBOutlet UILabel *currentTmpLabel;

//今天的天气情况
@property (weak, nonatomic) IBOutlet UILabel *currentCondTxtLabel;

//空气质量(AQI)labe
@property (weak, nonatomic) IBOutlet UILabel *AQILabel;
//当前城市City
@property (weak, nonatomic) IBOutlet UILabel *CurrentCityLabel;
//今天的天气情况
@property (weak, nonatomic) IBOutlet UILabel *currentCondtxtForeLabel;

//今天预报最高温T_today--H_high
@property (weak, nonatomic) IBOutlet UILabel *ForecastTHTemLabel;
//今天预报最低温
@property (weak, nonatomic) IBOutlet UILabel *ForecastTLLabel;
//明天的日期
@property (weak, nonatomic) IBOutlet UILabel *TomorrowDateLabel;

//明天的天气情况
@property (weak, nonatomic) IBOutlet UILabel *TomorrowCondTxtForeLabel;

//明天的预报最高
@property (weak, nonatomic) IBOutlet UILabel *TomorrowForecastHTmpLabel;

//明天预报最低
@property (weak, nonatomic) IBOutlet UILabel *TomorrowForecastLTmpLabel;

//后天的日期TDAT_the day after tomorrow
@property (weak, nonatomic) IBOutlet UILabel *TDATDateLabel;
//后天天气情况
@property (weak, nonatomic) IBOutlet UILabel *TDATCondTxtLabel;

//后天预报温度高
@property (weak, nonatomic) IBOutlet UILabel *TDATForecastHLabel;

//后天预报温度低
@property (weak, nonatomic) IBOutlet UILabel *TDATForecastLLabel;

//大后天的日期TDFN_three days from now
@property (weak, nonatomic) IBOutlet UILabel *TDFNDateLabel;
//大后天的天气情况
@property (weak, nonatomic) IBOutlet UILabel *TDFNCondTxtLabel;

//大后天预报温度高
@property (weak, nonatomic) IBOutlet UILabel *TDFNForecastHLabel;
//大后天预报温度低
@property (weak, nonatomic) IBOutlet UILabel *TDFNForecastLLabel;

//大大后天的日期
@property (weak, nonatomic) IBOutlet UILabel *FDFNForecastDateLabel;
//大大后天的天气情况
@property (weak, nonatomic) IBOutlet UILabel *FDFNForecastCondTxtLabel;

//大大后天预报温度高
@property (weak, nonatomic) IBOutlet UILabel *FDFNForecastHLabel;

//大大后天预报温度低
@property (weak, nonatomic) IBOutlet UILabel *FDFNForecastLLabel;

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UIView *backView2;//未来几天的


@end
