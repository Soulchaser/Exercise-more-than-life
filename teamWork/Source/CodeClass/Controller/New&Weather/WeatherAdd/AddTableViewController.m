//
//  AddTableViewController.m
//  teamWork
//
//  Created by lanou3g on 16/1/25.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "AddTableViewController.h"

#import "YDWeatherModel.h"

@interface AddTableViewController ()<UISearchBarDelegate>

@property(strong,nonatomic) NSMutableArray * resultArray;//结果数组

@property(strong,nonatomic) NSString * searchText;//全局-实时的搜索框文本

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
    
    
    UISearchBar * bar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-100, 64)];
    
    bar.backgroundColor = [UIColor redColor];
    
    bar.delegate = self;
    //显示cancel按钮
    bar.showsCancelButton = YES;
    //是否显示搜索结果按钮
    bar.showsSearchResultsButton = YES;
    
    bar.keyboardType = UIKeyboardTypeDefault;
    bar.placeholder = @"请键入城市拼音如'beijing'";
    self.tableView.tableHeaderView = bar;
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [button addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"点击" forState:UIControlStateNormal];
    
    //注册
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
    
    
}

#pragma mark ------------cancel按钮点击事件------------
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)button:(UIButton *)sender
{
    [self makeData];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"lalala");
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"完成编辑");
    return YES;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"编辑结束调用");
}
// !!!:实时输出,显示键入的文本
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    self.searchText = searchText;
    NSLog(@"%@",self.searchText);
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    [self makeData];
    
    NSLog(@"点击搜索调用此方法");
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
        
        NSLog(@"%@",dict[@"HeWeather data service 3.0"][0][@"basic"][@"city"]);
        
        //
        NSMutableArray * dataArray = dict[@"HeWeather data service 3.0"];
        
        NSLog(@"%lu",dataArray.count);
        
        for (NSDictionary * dict in dataArray) {
            //Basic部分
            for (NSDictionary * basicDic in dict[@"basic"]) {
                
                YDWeatherModel * model = [[YDWeatherModel alloc] init];
                [model setValuesForKeysWithDictionary:basicDic];
                
                [[YDGetDataTools sharedGetData].BasicArray addObject:model];

            }
            //"Now"部分
            for (NSDictionary * NowDic in dict[@"now"]) {
                
                nowModel * model = [[nowModel alloc] init];
                [model setValuesForKeysWithDictionary:NowDic];
                [[YDGetDataTools sharedGetData].NowArray addObject:model];
            }
            //"aqi"部分
            for (NSDictionary * aqiDic in dict[@"aqi"]) {
                AqiModel * model = [[AqiModel alloc] init];
                [model setValuesForKeysWithDictionary:aqiDic];
                [[YDGetDataTools sharedGetData].AqiArray addObject:model];
            }
            //@"forecast"部分
            for (NSDictionary * forecastDic in dict[@"daily_forecast"]) {
                ForecastModel * model = [[ForecastModel alloc] init];
                [model setValuesForKeysWithDictionary:forecastDic];
                [[YDGetDataTools sharedGetData].daily_forecastArray addObject:model];
            }
            
        }
        NSLog(@"%@",[YDGetDataTools sharedGetData].BasicArray);
        
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
    
    
    cell.textLabel.text = self.resultArray[indexPath.row];
    
    
    return cell;
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
