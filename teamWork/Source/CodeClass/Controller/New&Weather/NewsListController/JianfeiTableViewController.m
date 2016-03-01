//
//  JianfeiTableViewController.m
//  newsListText
//
//  Created by lanou3g on 16/1/22.
//  Copyright © 2016年 东东. All rights reserved.
//

#import "JianfeiTableViewController.h"

@interface JianfeiTableViewController ()
@property(strong,nonatomic) NSMutableArray * LWArray;
@property(assign,nonatomic) NSInteger page;//数据页数,表示请求第几页的数据
@end


@implementation JianfeiTableViewController

//懒加载LWArray
-(NSMutableArray *)LWArray
{
    if (!_LWArray) {
        _LWArray = [NSMutableArray array];
    }
    return _LWArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:LWID];
    
    __unsafe_unretained UITableView *tableView = self.tableView;
    
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
   
        self.page = 1;
        
        [self makeData];
        
        // 结束刷新
        [tableView.mj_header endRefreshing];

    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉加载
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
       
        [self makeData];
        
        // 结束刷新
        [tableView.mj_footer endRefreshing];
        
    }];
    
    //马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];


}

-(void)makeData
{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://apis.baidu.com/tngou/lore/list?id=11&page=%ld&rows=20",(long)self.page++]] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    
    NSLog(@"%ld",(long)self.page);
    
    [request setHTTPMethod: @"GET"];
    [request addValue: kApiKey forHTTPHeaderField: @"apikey"];
    
    NSURLSessionDataTask * dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data) {
            
            [self endRefresh];
            
            //从第一页开始请求数据
            //page = 2的时候将数组清空初始化;
            //当持续下拉刷新的时候,这个方法是不走的,只有回到顶端,下拉刷新数据的时候,会重新置空数组
            if (2 == self.page) {
                self.LWArray = nil;
            }
            
            NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            NSMutableArray * array = dataDic[@"tngou"];
            
            //DLog(@"YDD单例数据方法中打印数组第一条数据***%@",array[0]);
            
            NSMutableArray * DataArray = [NSMutableArray array];
            
            for (NSDictionary * dict in array) {
                
                DogModel * model = [[DogModel alloc] init];
                
                [model setValuesForKeysWithDictionary:dict];
                
                [DataArray addObject:model];
            }
            
            [self.LWArray addObjectsFromArray:DataArray];
            
            NSLog(@"%lu",(unsigned long)self.LWArray.count);
            
            //主线程刷新数据
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });

            
        }else
        {
            DLog(@"网络不佳");
        }
        
        
    }];
    
    [dataTask resume];

}

/**
 *  停止刷新
 */
-(void)endRefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScreenHeight/10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.LWArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LWID forIndexPath:indexPath];
    
    DogModel * model = self.LWArray[indexPath.row];
    
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.Description;
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController * detailVC = [DetailViewController new];
    DogModel * model = self.LWArray[indexPath.row];
    detailVC.IDString = model.ID;
    [self.navigationController pushViewController:detailVC animated:YES];
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
