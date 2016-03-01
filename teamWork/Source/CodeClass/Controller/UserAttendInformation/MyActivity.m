//
//  MyActivity.m
//  teamWork
//
//  Created by lanou3g on 16/3/1.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "MyActivity.h"


@interface MyActivity ()

@property(strong,nonatomic)NSMutableArray *dataArray;//请求的数据 - 为YYUserActivity类型
@property(assign,nonatomic) NSInteger page;//数据页数,表示请求第几页的数据
@end

static NSString * const creatTableViewCellID = @"creatTableViewCellIdentifier";

@implementation MyActivity
//懒加载_dataArray
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(void)leftBarButtonAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark **********"创建"按钮响应事件
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonAction)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GroupActibityCell class]) bundle:nil] forCellReuseIdentifier:creatTableViewCellID];
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
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self makeData];
        // 结束刷新
        [tableView.mj_footer endRefreshing];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    //马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
}
-(void)makeData
{
    //获取数据(查询数据)
    //拿到数据库中的所有当前用户已参加的活动
    AVQuery *query = [AVQuery queryWithClassName:@"Join"];
    [query whereKey:@"joinuser" equalTo:[AVUser currentUser]];
    [query includeKey:@"activity"];
    [query includeKey:@"joinuser"];
    //限制查询条件
    //limit 属性来控制返回结果的数量
    query.limit = 10*self.page++;
    //skip 用来跳过初始结果
    query.skip = 10*(self.page-2);
    [query orderByDescending:@"createdAt"];//对要查询的的数据排序
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects) {
            //如果获取到数据
            [self endRefresh];
            if (self.page == 2) {
                self.dataArray = nil;
            }
            
            
            for (AVObject *join in objects) {
                YYUserActivity *activityModel = [YYUserActivity new];
                AVObject *allActivity = [join objectForKey:@"activity"];//已加入的活动
                //创建一个查找
                AVQuery *queryActivity = [AVQuery queryWithClassName:@"Activity"];
                [queryActivity includeKey:@"activity_picture"];
                [queryActivity whereKey:@"createdAt" equalTo:[allActivity objectForKey:@"createdAt"]];
                [queryActivity findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    AVObject *activity = [objects firstObject];
                    //分享用户
                    AVUser *activityUser = [activity objectForKey:@"activityuser"];
                    //昵称
                    activityModel.nickname = [activityUser objectForKey:@"nickname"];
                    //头像
                    AVFile *avatarFile = [activityUser objectForKey:@"avatar"];
                    NSData *avatarData = [avatarFile getData];
                    activityModel.avatar = [UIImage imageWithData:avatarData];
                    
                    activityModel.title = [activity objectForKey:@"title"];//标题
                    activityModel.myDescription = [activity objectForKey:@"description"];
                    activityModel.address = [activity objectForKey:@"address"];//集合地点
                    activityModel.distance = [activity objectForKey:@"distance"];//路程
                    activityModel.start_time = [activity objectForKey:@"start_time"];//开始时间
                    activityModel.end_time = [activity objectForKey:@"end_time"];//结束时间
                    activityModel.people_count = [activity objectForKey:@"people_count"];//人数限制
                    activityModel.people_current = [[activity objectForKey:@"people_current"]intValue];//当前参与人数
                    activityModel.createdAt = [activity objectForKey:@"createdAt"];//创建时间
                    activityModel.phone = [activity objectForKey:@"phone"];//发起人填写的手机号
                    
                    //活动内容(图片) 图片数组 元素为NSData类型
                    NSArray *array = [activity objectForKey:@"activity_picture"];
                    activityModel.activity_picture = [NSMutableArray array];
                    for (AVFile *pictureFile in array) {
                        if (pictureFile == nil) {
                            continue;
                        }
                        NSData *pictureData = [pictureFile getData];
                        [activityModel.activity_picture addObject:pictureData];
                    }
                    
                    
                    [self.dataArray addObject:activityModel];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                }];
            }
            
            
        }
        
    }];
    
}

/**
 *  停止刷新
 */
-(void)endRefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark ------------------ tableViewDelegate & dataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupActibityCell *cell = [tableView dequeueReusableCellWithIdentifier:creatTableViewCellID forIndexPath:indexPath];
    YYUserActivity * model = self.dataArray[indexPath.row];
    //赋值
    cell.titleLabel.text = model.title;
    cell.addressLabel.text = model.address;
    //截取字符串
    NSRange range = {4,2};
    NSString *  subsString = [model.start_time substringWithRange:range];
    cell.calendarLabel.text = subsString;
    cell.progressLabel.text = [NSString stringWithFormat:@"%lu/%@",model.people_current,model.people_count];
    cell.distanceLabel.text = [NSString stringWithFormat:@"%@km",model.distance];
    if (model.activity_picture.count) {
        cell.userPicImgView.image = [UIImage imageWithData:model.activity_picture[0]];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
//cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([AVUser currentUser] == nil) {
        //如果未登录,跳转到登陆界面
        //将User.storyboard作为入口
        UIStoryboard *user = [UIStoryboard storyboardWithName:@"User" bundle:nil];
        UIViewController *entranceVC = [user instantiateInitialViewController];
        //让window的rootViewController指向该控制器
        [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:entranceVC animated:YES completion:nil];
    }else{
        ActivityDetailViewController * detailVC = [ActivityDetailViewController new];
        detailVC.PassActivity = self.dataArray[indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
