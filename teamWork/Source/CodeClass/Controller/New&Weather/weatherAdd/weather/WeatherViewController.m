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
@interface WeatherViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet UIView *myView;

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

//    AVUser * current = [AVUser currentUser];
//    if (current == nil) {
//        loginViewController * loginVC=[loginViewController new];
//        [self presentViewController:loginVC animated:NO completion:nil];
//    }else{
//    
//        entryyViewController * entryVC = [entryyViewController new];
//
//        entryVC.pasaaaa = ^(NSString * string){
//        
//            loginViewController * loginVC=[loginViewController new];
//            [self presentViewController:loginVC animated:YES completion:nil];
//        };
//        [self presentViewController:entryVC animated:YES completion:nil];
//    }
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
    
    //tableView
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.backgroundColor = [UIColor colorWithRed:50 green:50 blue:50 alpha:0.3];
    self.myTableView.separatorStyle = NO;
    self.myTableView.scrollEnabled = NO;
    
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
            [self.myTableView reloadData];
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
}

//tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return self.myTableView.bounds.size.height/6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    
    NSDate * today;
    NSDate * thirdDay;
    NSDate * fourthDay;
    NSDate * fifthDay;
    today = [NSDate date];
    thirdDay = [[NSDate alloc]initWithTimeInterval:24*60*60*3 sinceDate:today];
    fourthDay = [[NSDate alloc]initWithTimeInterval:24*60*60*4 sinceDate:today];
    fifthDay = [[NSDate alloc]initWithTimeInterval:24*60*60*5 sinceDate:today];
    if (indexPath.row == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"今天    %@ %@",self.otherDic[@"temp1"],self.otherDic[@"weather1"]];
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",self.otherDic[@"img1"]]];
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = [NSString stringWithFormat:@"明天    %@ %@",self.otherDic[@"temp2"],self.otherDic[@"weather2"]];
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",self.otherDic[@"img3"]]];
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = [NSString stringWithFormat:@"后天      %@ %@",self.otherDic[@"temp3"],self.otherDic[@"weather3"]];
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",self.otherDic[@"img5"]]];
    }
    if (indexPath.row == 3) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@    %@ %@",[self DealWithDate:thirdDay],self.otherDic[@"temp4"],self.otherDic[@"weather4"]];
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",self.otherDic[@"img7"]]];
    }
    if (indexPath.row == 4) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@    %@ %@",[self DealWithDate:fourthDay],self.otherDic[@"temp5"],self.otherDic[@"weather5"]];
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",self.otherDic[@"img9"]]];
    }
    if (indexPath.row == 5) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@    %@ %@",[self DealWithDate:fifthDay],self.otherDic[@"temp6"],self.otherDic[@"weather6"]];
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",self.otherDic[@"img11"]]];
    }
    return cell;
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
    gregorian =[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    date = [gregorian dateFromComponents:dateComponent];
    weekdayComponents =
    [gregorian components:NSWeekdayCalendarUnit fromDate:date];
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
