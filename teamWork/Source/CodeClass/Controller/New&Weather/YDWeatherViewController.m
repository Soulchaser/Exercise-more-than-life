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



@end

//Cell重用标识符
static NSString * const WeatherCollectionViewCellID = @"WeatherCollectionViewCellReuseIdentifier";

@implementation YDWeatherViewController

+(instancetype)sharedViewController
{
    static YDWeatherViewController * YDWVC = nil;
    if (YDWVC == nil) {
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            YDWVC = [[YDWeatherViewController alloc] init];
        });
    }
    return YDWVC;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    if (kGD.BasicArray.count == 0) {
        AddTableViewController * addVC = [AddTableViewController new];
        UINavigationController * addNC = [[UINavigationController alloc] initWithRootViewController:addVC];
        [self.navigationController presentViewController:addNC animated:YES completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    //每个单元格的大小
    flowLayout.itemSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    
    //初始化collectionView
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    
    collectionView.backgroundColor = [UIColor magentaColor];
    collectionView.pagingEnabled = YES;
    
    //滑动方向(默认是竖向滑动)
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    [self.view addSubview:collectionView];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    //注册cell
    [collectionView registerNib:[UINib nibWithNibName:@"WeatherCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:WeatherCollectionViewCellID];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return kGD.BasicArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WeatherCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:WeatherCollectionViewCellID forIndexPath:indexPath];
    
    cell.MainWeatherImgView.backgroundColor = [UIColor redColor];
    
    YDWeatherModel * model = kGD.BasicArray[indexPath.row];
    
    cell.AQILabel.text = [NSString stringWithFormat:@"%@~%@",model.aqi,model.qlty];
    cell.CurrentCityLabel.text = model.city;
    
    
    
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
