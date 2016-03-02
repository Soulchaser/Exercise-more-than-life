//
//  TrackwayTableViewController.m
//  teamWork
//
//  Created by hanxiaolong on 16/2/24.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "TrackwayTableViewController.h"

@interface TrackwayTableViewController ()<UITabBarControllerDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *dataArray;
//数据库管理工具
@property(strong,nonatomic)XLCodeDataTools *cordDataTools;
@end


static NSString *const systemCellResuseIdentfier = @"systemCellResuseIdentfier";

@implementation TrackwayTableViewController

-(instancetype)init
{
    if (self = [super init])
    {
        [self getData];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonAction)];
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
        //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"shangchuan"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonAction)];
        
        UIBarButtonItem *uploadButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"shangchuan"] style:UIBarButtonItemStyleDone target:self action:@selector(uploadButtonAction)];
        uploadButton.tintColor = [UIColor blackColor];
        UIBarButtonItem *downloadButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"xiazai"] style:UIBarButtonItemStyleDone target:self action:@selector(downloadButtonAction)];
        downloadButton.tintColor = [UIColor blackColor];
        NSArray *arr = [[NSArray alloc]initWithObjects:uploadButton,downloadButton, nil];
        
        self.navigationItem.rightBarButtonItems = arr;
        
        
        
        self.navigationItem.title = @"运动记录";
        
    }
    return self;
}

-(void)leftBarButtonAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)uploadButtonAction
{
    

    
    AVUser *currentUser = [AVUser currentUser];

    if (currentUser == nil) {
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未登录，请先登录" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *trueAlert = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            UIStoryboard *userStoryboard = [UIStoryboard storyboardWithName:@"User" bundle:nil];
            LoginViewController *loginVC = [userStoryboard instantiateViewControllerWithIdentifier:@"login"];
            [self presentViewController:loginVC animated:YES completion:nil];
        }];
        [alertCon addAction:trueAlert];
        [self presentViewController:alertCon animated:YES completion:nil];

    }else {
        LoadingEvents *loadingEvent = [LoadingEvents shareLoadingEvents];
        [loadingEvent dataBeginLoading:self];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.dataArray];
       // AVUser *currentUser = [AVUser currentUser];//运动作为用户的一个属性,存储为AVFile类型
        //删除原运动记录
        AVFile *oldPoint = [currentUser objectForKey:@"all_point"];
        [oldPoint deleteInBackground];
        //添加新记录
        AVFile *pointFile = [AVFile fileWithData:data];//运动点记录在AVFile表中
        [currentUser setObject:pointFile forKey:@"all_point"];//该条记录所有的运动点
            [currentUser saveEventually:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    //储存成功执行
                    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:@"上传成功" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *alertAct = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                    [alertCon addAction:alertAct];
                    [self presentViewController:alertCon animated:YES completion:nil];
                    [loadingEvent dataLoadSucceed:self];
                }
                else
                {
                    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"警告" message:@"上传失败" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *alertAct = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                    [alertCon addAction:alertAct];
                    [self presentViewController:alertCon animated:YES completion:nil];
                    [loadingEvent dataLoadFailed:self];
                }
            }];
    }
}

-(void)downloadButtonAction
{
    AVUser *currentUser = [AVUser currentUser];
    
    if (currentUser == nil) {
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未登录，请先登录" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *trueAlert = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            UIStoryboard *userStoryboard = [UIStoryboard storyboardWithName:@"User" bundle:nil];
            LoginViewController *loginVC = [userStoryboard instantiateViewControllerWithIdentifier:@"login"];
            [self presentViewController:loginVC animated:YES completion:nil];
        }];
        [alertCon addAction:trueAlert];
        [self presentViewController:alertCon animated:YES completion:nil];
        
    }else {
        LoadingEvents *loadingEvent = [LoadingEvents shareLoadingEvents];
        [loadingEvent dataBeginLoading:self];
        
        
        AVFile *pointFile = [currentUser objectForKey:@"all_point"];
        
        NSData *allPoint = [pointFile getData];
        
        NSArray *allPointArr = [NSKeyedUnarchiver unarchiveObjectWithData:allPoint];

        for (CordDataInfo *cordData in allPointArr)
        {
            
            NSArray *arr = [self.cordDataTools getDataFromLibraryWithstartDate:cordData.startDate];
            if (arr.count == 0)
            {
                //存入数据库
                [self.cordDataTools insertData:cordData];
            }
            else
            {
                //更新数据
                [self.cordDataTools updata:cordData];
            }
        }
        
        [self.dataArray removeAllObjects];
        [self getData];
        [self.tableView reloadData];
        [loadingEvent dataLoadSucceed:self];
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:@"下载成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAct = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertCon addAction:alertAct];
        [self presentViewController:alertCon animated:YES completion:nil];
        

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TrackwayTableViewCell class]) bundle:nil] forCellReuseIdentifier:systemCellResuseIdentfier];
    [self.tableView reloadData];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1]];
   
}


-(void)getData
{
   // self.dataArray = [[NSArray alloc]init];
    
    NSArray *arr = [[[XLCodeDataTools alloc]init]getDataFromLibrary];
    for (Entity *entity in arr)
    {
        //DLog(@"%@",entity.totleTime);
        CordDataInfo *cordData = [[CordDataInfo alloc]init];
        cordData.startDate = entity.startDate;
        cordData.movementTime = [entity.movementTime integerValue];
        
        cordData.totleTime = [entity.totleTime doubleValue];
        cordData.maxSpeed = [entity.maxSpeed floatValue];
        cordData.sportType = [entity.sportType integerValue];
        cordData.totleDistance = [entity.totleDistance floatValue];
        //DLog(@"%@",entity.totleTime);
        cordData.infoArray = [NSKeyedUnarchiver unarchiveObjectWithData:entity.infoData];
        [self.dataArray addObject:cordData];
    }
    //DLog(@"%@",self.dataArray);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ------选中cell------
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MapwayDetailsViewController *mapVC = [[MapwayDetailsViewController alloc]init];
    mapVC.cordData = self.dataArray[indexPath.section];
    [self.navigationController pushViewController:mapVC animated:YES];
}

#pragma mark ----cell的删除操作------
//选定删除范围
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//选定操作方法
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//进行cell的操作
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //从本地数据库中删除
    CordDataInfo *cordData = [[CordDataInfo alloc]init];
    cordData = self.dataArray[indexPath.section];
    
    [[XLCodeDataTools shareXLCoreDataTools]deleteDataFromLibraryWithstartDate:((MovementInfo *)cordData.infoArray.firstObject).timeDate];
    
    //从data中删除
    [self.dataArray removeObjectAtIndex:indexPath.section];
    
    //删除UI
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:indexPath.section];
    [tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


//区标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    CordDataInfo *cordData = [[CordDataInfo alloc]init];
    cordData = self.dataArray[section];

    NSString *dateStr = [self stringFromDate:((MovementInfo *)cordData.infoArray.firstObject).timeDate];
    //NSString *dateStr = [NSString stringWithFormat:@"%@",((MovementInfo *)cordData.infoArray.firstObject).timeDate];
    NSString *str = [[NSString alloc]init];
    switch (cordData.sportType)
    {
        case walkModel:
            str = @"步行";
            break;
        case runModel:
            str = @"跑步";
            break;
        case rideModel:
            str = @"骑行";
            break;
        default:
            break;
    }
    
    
    return [NSString stringWithFormat:@"%@ %@",str,dateStr];
}
//转化Date格式
- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: date];
    //转化过程中，会把当前时间当成0时区的时间来操作，所以先转成0时区的时间
    NSDate *localeDate = [date  dateByAddingTimeInterval: -interval];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *destDateString = [dateFormatter stringFromDate:localeDate];
    
    return destDateString;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TrackwayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:systemCellResuseIdentfier forIndexPath:indexPath];
    
    CordDataInfo *data = self.dataArray[indexPath.section];
    
    cell.DistanceLabel.text = [NSString stringWithFormat:@"%.2f",data.totleDistance/1000.0];
    
    if (data.totleTime/60 < 60)
    {
        cell.TimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",(int)(data.totleTime/60),(int)data.totleTime%60];
    }
    else
        cell.TimeLabel.text = [NSString stringWithFormat:@"%02d,%02d:%02d",(int)(data.totleTime/60)/60,(int)(data.totleTime/60),(int)data.totleTime%60];

    
    if (data.movementTime != 0)
    {
        cell.SpeedLabel.text = [NSString stringWithFormat:@"%.2fkm/h",(data.totleDistance/data.movementTime)*3.6];

    }
    else
        cell.SpeedLabel.text = @"0.00km/h";
    
    // Configure the cell...
    
    return cell;
}
#pragma mark ---------懒加载-----------
-(NSMutableArray *)dataArray
{
    if (_dataArray == nil)
    {
        _dataArray = [[NSMutableArray alloc]initWithCapacity:1];
    }
    return _dataArray;
}

-(XLCodeDataTools *)cordDataTools
{
    if (_cordDataTools == nil)
    {
        _cordDataTools = [[XLCodeDataTools alloc]init];
    }
    return _cordDataTools;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
