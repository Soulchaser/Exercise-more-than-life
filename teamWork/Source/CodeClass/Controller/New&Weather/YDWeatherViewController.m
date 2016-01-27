//
//  YDWeatherViewController.m
//  teamWork
//
//  Created by lanou3g on 16/1/25.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "YDWeatherViewController.h"
#import "WeatherCollectionViewCell.h"
@interface YDWeatherViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(strong,nonatomic) UICollectionView * collectionView;

@property(strong,nonatomic) UIView * backView;
@end

//Cell重用标识符
static NSString * const WeatherCollectionViewCellID = @"WeatherCollectionViewCellReuseIdentifier";

@implementation YDWeatherViewController


-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication].delegate.window bringSubviewToFront:self.backView];
    [self.collectionView reloadData];
    NSLog(@"%lu",kGD.BasicArray.count);

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    //每个单元格的大小
    flowLayout.itemSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    
    //初始化collectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    //集合视图背景色
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.pagingEnabled = YES;
    
    //滑动方向(默认是竖向滑动)
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //添加到主视图
    [self.view addSubview:self.collectionView];
    
    //设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    //添加一个view(view上有两个按钮)
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 40)];
    self.backView.backgroundColor = [UIColor blackColor];
    
    //设置透明度
    self.backView.alpha = 0.5;
    // !!!:"添加"按钮
    UIButton * addButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-50-5, 5, 50, 30)];
    [addButton setTitle:@"添加" forState:UIControlStateNormal];
    [addButton setTitle:@"添加" forState:UIControlStateHighlighted];
    [addButton addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];

    // !!!:设置按钮
    UIButton * settingButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 50, 30)];
    [settingButton setTitle:@"设置" forState:UIControlStateNormal];
    [settingButton setTitle:@"设置" forState:UIControlStateHighlighted];
    [settingButton addTarget:self action:@selector(settingAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [[UIApplication sharedApplication].delegate.window addSubview:self.backView];
    //注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"WeatherCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:WeatherCollectionViewCellID];
    
    //添加视图
    [self.backView addSubview:addButton];
    [self.backView addSubview:settingButton];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [[UIApplication sharedApplication].delegate.window sendSubviewToBack:self.backView];
}

// !!!:添加按钮点击事件
-(void)addButtonAction
{
    AddTableViewController * addVC = [AddTableViewController new];
    UINavigationController * addNC = [[UINavigationController alloc] initWithRootViewController:addVC];
    [self presentViewController:addNC animated:YES completion:^{
        [self.collectionView reloadData];
    }];
}

-(void)settingAction
{
    SettingViewController * settingVC = [SettingViewController new];
    UINavigationController * settingNC = [[UINavigationController alloc] initWithRootViewController:settingVC];
    [self presentViewController:settingNC animated:YES completion:^{
        [self.collectionView reloadData];
    }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return kGD.BasicArray.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WeatherCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:WeatherCollectionViewCellID forIndexPath:indexPath];
    
//    cell.MainWeatherImgView.backgroundColor = [UIColor redColor];
    
    YDWeatherModel * model = kGD.BasicArray[indexPath.row];
    
    cell.AQILabel.text = [NSString stringWithFormat:@"%@~%@",model.aqi,model.qlty];
    cell.CurrentCityLabel.text = model.city;
    [cell.MainWeatherImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://files.heweather.com/cond_icon/%@.png",model.code]]];
    //温度
    cell.CurrentCityLabel.text = model.tmp;
    //未来三天的天气情况
    YDmodelForecast * Fmodel_1 = model.array[1];
    YDmodelForecast * Fmodel_2 = model.array[2];
    YDmodelForecast * Fmodel_3 = model.array[3];
    cell.TomorrowDateLabel.text = [kGD weekdayStringFromDate:Fmodel_1.date];
    [cell.TomorrowWeatherImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://files.heweather.com/cond_icon/%@.png",Fmodel_1.code_d]]];
    return cell;
    
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
