//
//  WeatherViewController.m
//  时时天气1
//
//  Created by zhouyong on 16/1/4.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "WeatherViewController.h"
#import "ViewController.h"
#import "GetDataTools.h"
#import "CBChartView.h"
@interface WeatherViewController ()


@property (weak, nonatomic) IBOutlet UIView *myView;

//图片
@property (weak, nonatomic) IBOutlet UIImageView *img_pic_1;

@property (weak, nonatomic) IBOutlet UIImageView *img_pic_2;

@property (weak, nonatomic) IBOutlet UIImageView *img_pic_3;

@property (weak, nonatomic) IBOutlet UIImageView *img_pic_4;

@property (weak, nonatomic) IBOutlet UIImageView *img_pic_5;

//日期

@property (weak, nonatomic) IBOutlet UILabel *date_1;

@property (weak, nonatomic) IBOutlet UILabel *date_2;

@property (weak, nonatomic) IBOutlet UILabel *date_3;

@property (weak, nonatomic) IBOutlet UILabel *date_4;

@property (weak, nonatomic) IBOutlet UILabel *date_5;

//温度

@property (weak, nonatomic) IBOutlet UILabel *tem_1;

@property (weak, nonatomic) IBOutlet UILabel *tem_2;

@property (weak, nonatomic) IBOutlet UILabel *tem_3;

@property (weak, nonatomic) IBOutlet UILabel *tem_4;

@property (weak, nonatomic) IBOutlet UILabel *tem_5;

//天气情况

@property (weak, nonatomic) IBOutlet UILabel *type_1;

@property (weak, nonatomic) IBOutlet UILabel *type_2;

@property (weak, nonatomic) IBOutlet UILabel *type_3;

@property (weak, nonatomic) IBOutlet UILabel *type_4;

@property (weak, nonatomic) IBOutlet UILabel *type_5;

//气温数组
@property(nonatomic,strong)NSArray * temArray;
//weatherView
@property (weak, nonatomic) IBOutlet UIView *weatherView;

//图表属性
@property(nonatomic,strong)CBChartView * chartView;
@end

@implementation WeatherViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{

    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        UIImage * image = [UIImage imageNamed:@"tianqi"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"天气" image:image selectedImage:nil];
        
    }
    return self;
}

- (IBAction)toCityListAction:(id)sender {
    ViewController * cityListVC = [ViewController new];
    
    [cityListVC returnText:^(NSString *cityname) {
        if ([cityname isEqualToString:@"北京市"]) {
            cityname = @"北京";
        }
        NSString                *path;
        NSDictionary            *dic;
        path = [[NSBundle mainBundle]pathForResource:@"CityId" ofType:@"plist"];
        dic = [NSDictionary dictionaryWithContentsOfFile:path];
        self.cityId = [dic objectForKey:cityname];
        [self getData];
    }];
    
    
    [self.navigationController pushViewController:cityListVC animated:YES];
}

//show图表
- (IBAction)chartShowAction:(id)sender {
    
    if (self.chartView) {
        [self.chartView removeFromSuperview];
        self.chartView = nil;
    }else{
    self.chartView = [[CBChartView alloc]initWithFrame:CGRectMake(20, 100, kScreenWidth/2, kScreenWidth/2)];
    self.chartView.shutDefaultAnimation = YES;
    self.chartView.xValues = @[@"0",@"1",@"2",@"3",@"4",@"5"];
    self.chartView.yValues = self.temArray;
    self.chartView.chartWidth = 2.0;
    self.chartView.chartColor = [UIColor orangeColor];
    self.chartView.center = self.weatherView.center;
    [self.weatherView addSubview:self.chartView];
    [UIView animateWithDuration:1 animations:^{
        self.chartView.frame = CGRectMake(10, 100, 310, 330);
        self.chartView.center = self.weatherView.center;
    }];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chartClose)];
    [self.chartView addGestureRecognizer:tap];
    }
}
//close图表
-(void)chartClose{

    [self.chartView removeFromSuperview];
    self.chartView = nil;
}

-(void)viewWillAppear:(BOOL)animated{

    [self.chartView removeFromSuperview];
    self.chartView = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.cityId = @"101010100";
    self.weatherDic = [NSMutableDictionary dictionary];
    self.otherDic = [NSMutableDictionary dictionary];
    
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    self.navigationItem.title = @"天气预报";
    
    self.view.backgroundColor = [UIColor redColor];
    //scrollVeiw从navigetionBar下边开始计算
    if ([self performSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    
    //今天周几
    NSDate * today = [NSDate date];
    self.weekLabel.text = [self DealWithDate:today];
    
    //获取数据
    [self getData];
    
    
}

//剪切字符串
-(NSString *)cutString:(NSString *)string{

    NSString * str1 = [[string componentsSeparatedByString:@"~"]lastObject];
    NSString * str = [str1 substringToIndex:1];
    return str;
}
//获取数据
-(void)getData{
    //数据
    [[GetDataTools shareGetData]getDataWithCityID:self.cityId andZero:^(NSMutableDictionary *dict) {
        self.otherDic = dict;
        self.temArray = @[[self cutString:dict[@"temp1"]],[self cutString:dict[@"temp2"]],[self cutString:dict[@"temp3"]],[self cutString:dict[@"temp4"]],[self cutString:dict[@"temp5"]],[self cutString:dict[@"temp6"]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.duringLabel.text = self.otherDic[@"temp1"];
            self.weatherImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",self.otherDic[@"img1"]]];
            self.weatherLabel.text = self.otherDic[@"weather1"];
        });
    }];
    [[GetDataTools shareGetData]getDataWithCityID:self.cityId andOne:^(NSMutableDictionary *dict) {
        self.weatherDic = dict;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self drawView];
        });
    }];

}


-(void)drawView{

    [self.cityListButton setTitle:self.weatherDic[@"city"] forState:(UIControlStateNormal)];
    self.duLabel.text = self.weatherDic[@"temp"];
    self.windowLabel.text = [NSString stringWithFormat:@"%@%@",self.weatherDic[@"WD"],self.weatherDic[@"WS"]];
    
    NSDate * today;
    NSDate * thirdDay;
    NSDate * fourthDay;
    NSDate * fifthDay;
    today = [NSDate date];
    thirdDay = [[NSDate alloc]initWithTimeInterval:24*60*60*3 sinceDate:today];
    fourthDay = [[NSDate alloc]initWithTimeInterval:24*60*60*4 sinceDate:today];
    fifthDay = [[NSDate alloc]initWithTimeInterval:24*60*60*5 sinceDate:today];
    
    
    //+1
    self.img_pic_1.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",self.otherDic[@"img3"]]];
    self.date_1.text = 
    self.tem_1.text = [NSString stringWithFormat:@"%@",self.otherDic[@"temp2"]];
    self.type_1.text = [NSString stringWithFormat:@"%@",self.otherDic[@"weather2"]];
    
    
    //+2
    self.img_pic_2.image =[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",self.otherDic[@"img5"]]];
    self.tem_2.text = [NSString stringWithFormat:@"%@",self.otherDic[@"temp3"]];
    self.type_2.text = [NSString stringWithFormat:@"%@",self.otherDic[@"weather3"]];
    
    
    //+3
    
    self.img_pic_3.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",self.otherDic[@"img7"]]];
    self.tem_3.text = [NSString stringWithFormat:@"%@",self.otherDic[@"temp4"]];
    self.type_3.text = [NSString stringWithFormat:@"%@",self.otherDic[@"weather4"]];
    self.date_3.text = [self DealWithDate:thirdDay];
    
    
    //+4
    self.img_pic_4.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",self.otherDic[@"img9"]]];
    self.tem_4.text = [NSString stringWithFormat:@"%@",self.otherDic[@"temp5"]];
    self.type_4.text = [NSString stringWithFormat:@"%@",self.otherDic[@"weather5"]];
    self.date_4.text = [self DealWithDate:fourthDay];
    
    
    //+5
    self.img_pic_5.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",self.otherDic[@"img11"]]];
    self.tem_5.text = [NSString stringWithFormat:@"%@",self.otherDic[@"temp6"]];
    self.type_5.text = [NSString stringWithFormat:@"%@",self.otherDic[@"weather6"]];
    self.date_5.text = [self DealWithDate:fifthDay];

    
}

-(NSString *)DealWithDate:(NSDate *)date
{
    NSString            *str;
    NSDateComponents    *dateComponent;
    NSCalendar          *gregorian;
    NSDateComponents    *weekdayComponents;
    
    str = [date description];
    dateComponent = [[NSDateComponents alloc]init ];
    [dateComponent setYear:[[str substringWithRange:NSMakeRange(0, 4)] floatValue]];
    [dateComponent setMonth:[[str substringWithRange:NSMakeRange(5, 2)] floatValue]];
    [dateComponent setDay:[[str substringWithRange:NSMakeRange(8, 2)] floatValue]];
    gregorian =[[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    date = [gregorian dateFromComponents:dateComponent];
    weekdayComponents =
    [gregorian components:NSCalendarUnitWeekday fromDate:date];
    return [self WeekDay:[weekdayComponents weekday]];
}
-(NSString *)WeekDay:(NSInteger)weekDay
{
    switch (weekDay) {
        case 1:
            return @"周日";
            break;
        case 2:
            return @"周一";
            break;
        case 3:
            return @"周二";
            break;
        case 4:
            return @"周三";
            break;
        case 5:
            return @"周四";
            break;
        case 6:
            return @"周五";
            break;
        case 7:
            return @"周六";
            break;
            
        default:
            break;
    }
    return nil;
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
