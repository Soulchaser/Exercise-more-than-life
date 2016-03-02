//
//  YDWMViewController.m
//  teamWork
//
//  Created by lanou3g on 16/1/22.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "YDWMViewController.h"

@interface YDWMViewController ()

@property(strong,nonatomic) NYSegmentedControl * segmentedControl;

@property(strong,nonatomic) YDWeatherViewController * WeatherVC;

@property(strong,nonatomic) NSArray * exampleViews;

@property(strong,nonatomic) UIView * visibleExampleView;
@end

@implementation YDWMViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"健康资讯" image:[UIImage imageNamed:@"news"] selectedImage:[UIImage imageNamed:@"news_selected"]];

    }
    return self;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titles = @[@"减肥瘦身", @"男性健康", @"女性保养",@"私密生活"];
        self.viewControllerClasses = @[[JianfeiTableViewController class],
                                       [NanxingTableViewController class],
                                       [WomenTableViewController class],
                                       [SecretTableViewController class]
                                       ];
        self.titleSizeNormal = 15;
        self.titleColorSelected = [UIColor blackColor];
        self.titleColorNormal = [UIColor grayColor];
        self.menuItemWidth = 80;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"健康资讯";
    //字体颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1]];
    self.segmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"资讯", @"天气"]];
    [self.segmentedControl addTarget:self action:@selector(segmentSelected) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.titleFont = [UIFont fontWithName:@"AvenirNext-Medium" size:14.0f];
    self.segmentedControl.titleTextColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
    self.segmentedControl.selectedTitleFont = [UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0f];
    self.segmentedControl.selectedTitleTextColor = [UIColor whiteColor];
    self.segmentedControl.borderWidth = 1.0f;
    self.segmentedControl.borderColor = [UIColor colorWithWhite:0.15f alpha:1.0f];
    self.segmentedControl.drawsGradientBackground = YES;
    self.segmentedControl.segmentIndicatorInset = 2.0f;
    self.segmentedControl.segmentIndicatorGradientTopColor = [UIColor colorWithRed:0.30 green:0.50 blue:0.88f alpha:1.0f];
    self.segmentedControl.segmentIndicatorGradientBottomColor = [UIColor colorWithRed:0.20 green:0.35 blue:0.75f alpha:1.0f];
    self.segmentedControl.drawsSegmentIndicatorGradientBackground = YES;
    self.segmentedControl.segmentIndicatorBorderWidth = 0.0f;
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl sizeToFit];
    self.navigationItem.titleView = self.segmentedControl;

    //初始化天气视图控制器
    self.WeatherVC = [[YDWeatherViewController alloc] init];
    //添加为子控制器
    [self addChildViewController:self.WeatherVC];

}

-(void)segmentSelected
{

    if (self.segmentedControl.selectedSegmentIndex == 0) {
        [self.WeatherVC.view removeFromSuperview];
    }else
    {
        [self.view addSubview:self.WeatherVC.view];
    }
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
