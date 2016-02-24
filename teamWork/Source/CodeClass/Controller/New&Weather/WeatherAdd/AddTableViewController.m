//
//  AddTableViewController.m
//  teamWork
//
//  Created by lanou3g on 16/1/25.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "AddTableViewController.h"

@interface AddTableViewController ()<UISearchBarDelegate>

@property(strong,nonatomic) NSMutableArray * resultArray;//结果数组

@property(strong,nonatomic) NSString * searchText;//全局-实时的搜索框文本

@property(assign,nonatomic) BOOL flag;

@end

@implementation AddTableViewController

-(NSMutableArray *)resultArray
{
    if (!_resultArray) {
        _resultArray = [NSMutableArray array];
    }
    return _resultArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"";
    
    self.flag = YES;
    
    UISearchBar * bar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-100, 64)];
    
    bar.backgroundColor = [UIColor redColor];
    
    bar.delegate = self;
    //显示cancel按钮
    bar.showsCancelButton = YES;
    //是否显示搜索结果按钮
//    bar.showsSearchResultsButton = YES;
    
    bar.keyboardType = UIKeyboardTypeDefault;
    bar.placeholder = @"请键入城市拼音如'beijing'";
    self.tableView.tableHeaderView = bar;
    
    //注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
}

#pragma mark ------------cancel按钮点击事件------------
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    DLog(@"点击开始搜索");
    self.resultArray = nil;
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    DLog(@"完成编辑");
    return YES;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    DLog(@"编辑结束调用");
}
// !!!:实时输出,显示键入的文本
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.searchText = searchText;
    //    DLog(@"%@",self.searchText);
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    [self makeData];
    
    DLog(@"点击搜索调用此方法");
}

-(void)makeData
{
    NSString * httpStr = @"http://apis.baidu.com/heweather/weather/free?city=";
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@%@",httpStr,self.searchText]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"2914a9e8c533799c98515dbba2834624" forHTTPHeaderField: @"apikey"];
    
    NSURLSessionDataTask * dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        NSMutableArray * dataArray = dict[@"HeWeather data service 3.0"];
        //写入文件
        //        [dict writeToFile:[NSString stringWithFormat:@"/Users/yuandongdong/Desktop/download/%@.plist",self.searchText] atomically:YES];
        
        DLog(@"%lu",(unsigned long)dataArray.count);
        
        for (NSDictionary * dict in dataArray) {
            //Basic部分
            YDWeatherModel * model = [[YDWeatherModel alloc] init];
            model.city = dict[@"basic"][@"city"];
            //"Now"部分
            model.tmp = dict[@"now"][@"tmp"];
            model.txt = dict[@"now"][@"cond"][@"txt"];
            
            //"aqi"部分
            model.aqi = dict[@"aqi"][@"city"][@"aqi"];
            model.qlty = dict[@"aqi"][@"city"][@"qlty"];

            //@"forecast"部分
            for (NSDictionary * forecastDic in dict[@"daily_forecast"]) {
                
                YDmodelForecast * modelF = [[YDmodelForecast alloc] init];

                modelF.date = forecastDic[@"date"];
                modelF.txt_d = forecastDic[@"cond"][@"txt_d"];
                modelF.max = forecastDic[@"tmp"][@"max"];
                modelF.min = forecastDic[@"tmp"][@"min"];
                [model.array addObject:modelF];
            }
            //添加到结果数组中
            [self.resultArray addObject:model];
            
        }
        DLog(@"%@",self.resultArray);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
        
    }];
    [dataTask resume];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.resultArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    YDWeatherModel * model = self.resultArray[indexPath.row];
    
    cell.textLabel.text =  model.city;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    YDWeatherModel * model = self.resultArray[indexPath.row];
    //如果数组为空直接添加,否则先判断
    if (kGD.BasicArray.count == 0) {
        [kGD.BasicArray addObject:model];
    }else
    {
        for (YDWeatherModel * Tmodel in kGD.BasicArray) {
            if ([Tmodel.city isEqualToString:model.city]) {
                //不做操作
                return;
            }
            //如果没有,添加到数组中
            [kGD.BasicArray addObject:model];
        }

    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        self.resultArray = nil;
    }];
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
