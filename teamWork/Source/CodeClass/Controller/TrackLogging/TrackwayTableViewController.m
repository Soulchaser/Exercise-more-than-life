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

@end


static NSString *const systemCellResuseIdentfier = @"systemCellResuseIdentfier";

@implementation TrackwayTableViewController

-(instancetype)init
{
    if (self = [super init])
    {
        [self getData];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TrackwayTableViewCell class]) bundle:nil] forCellReuseIdentifier:systemCellResuseIdentfier];
    [self.tableView reloadData];
   
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    
    
    
    
   // DLog(@"%d",indexPath.section);
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
#warning Incomplete implementation, return the number of sections
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
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
