//
//  WeatherViewController.h
//  时时天气1
//
//  Created by zhouyong on 16/1/4.
//  Copyright © 2016年 zy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherViewController : UIViewController

@property (assign,nonatomic)   NSString  * cityId;
@property(nonatomic,strong)NSMutableDictionary * weatherDic;
@property(nonatomic,strong)NSMutableDictionary * otherDic;

@property (weak, nonatomic) IBOutlet UIButton *cityListButton;

@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *duLabel;

@property (weak, nonatomic) IBOutlet UILabel *duringLabel;
@property (weak, nonatomic) IBOutlet UILabel *windowLabel;

@property (weak, nonatomic) IBOutlet UILabel *weekLabel;

@end
