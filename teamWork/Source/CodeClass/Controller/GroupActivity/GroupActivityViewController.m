//
//  GroupActivityViewController.m
//  teamWork
//
//  Created by hanxiaolong on 16/1/15.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "GroupActivityViewController.h"

@interface GroupActivityViewController () <UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic) UITableView * tableView;

@property(strong,nonatomic)NSMutableArray *dataArray;//请求的数据 - 为YYUserActivity类型
@property(assign,nonatomic) NSInteger page;//数据页数,表示请求第几页的数据
@end

static NSString * const creatTableViewCellID = @"creatTableViewCellIdentifier";

@implementation GroupActivityViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"寻找组织" image:[UIImage imageNamed:@"group"] selectedImage:[UIImage imageNamed:@"group_select"]];

        UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20,20)];
        [rightButton setImage:[UIImage imageNamed:@"add_white_64"] forState:UIControlStateNormal];
        
        [rightButton addTarget:self action:@selector(pushToCreatPage) forControlEvents:UIControlEventTouchUpInside];
        

        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建" style: UIBarButtonItemStylePlain target:self action:@selector(pushToCreatPage)];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];

        
    }
    return self;
}
//懒加载_dataArray
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
#pragma mark **********"创建"按钮响应事件
-(void)pushToCreatPage
{
    if ([AVUser currentUser] == nil) {
        //如果未登录,跳转到登陆界面
        //将User.storyboard作为入口
        UIStoryboard *user = [UIStoryboard storyboardWithName:@"User" bundle:nil];
        UIViewController *entranceVC = [user instantiateInitialViewController];
        //让window的rootViewController指向该控制器
        [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:entranceVC animated:YES completion:nil];
    }else{
    CreatActivityViewController_1 * creatVC = [CreatActivityViewController_1 new];
    [self.navigationController pushViewController:creatVC animated:YES];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    self.navigationItem.title = @"寻找组织";
    //字体颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1]];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    
    //设置代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    //注册
//    [self.tableView registerNib:[UINib nibWithNibName:@"GroupActivityTableViewCell" bundle:nil] forCellReuseIdentifier:creatTableViewCellID];
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
    AVQuery *query = [AVQuery queryWithClassName:@"Activity"];
    //限制查询条件
    //limit 属性来控制返回结果的数量
    query.limit = 10*self.page++;
    //skip 用来跳过初始结果
    query.skip = 10*(self.page-2);
    [query orderByDescending:@"createdAt"];//对要查询的的数据排序
    [query includeKey:@"activity_picture"];//图片为AVFile类型,查询出要特殊处理
    [query includeKey:@"activityuser"];//活动发起者
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects) {
            //如果获取到数据
            [self endRefresh];
            if (self.page == 2) {
                self.dataArray = nil;
            }
            
            for (AVObject *activity in objects) {
                YYUserActivity *activityModel = [YYUserActivity new];
                //分享用户
                AVUser *activityUser = [activity objectForKey:@"activityuser"];
                //昵称
                if ([[activityUser objectForKey:@"nickname"] isEqualToString:@""] || [activityUser objectForKey:@"nickname"] == nil) {
                    activityModel.nickname = [activityUser objectForKey:@"username"];
                }else{
                    activityModel.nickname = [activityUser objectForKey:@"nickname"];
                }
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
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
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
//    GroupActivityTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:creatTableViewCellID forIndexPath:indexPath];
    GroupActibityCell *cell = [tableView dequeueReusableCellWithIdentifier:creatTableViewCellID forIndexPath:indexPath];
    YYUserActivity * model = self.dataArray[indexPath.row];

    //赋值
    cell.titleLabel.text = model.title;
    cell.addressLabel.text = model.address;
    //截取字符串
    NSRange range = {4,2};
    NSString *  subsString = [model.start_time substringWithRange:range];
    cell.calendarLabel.text = subsString;
    cell.progressLabel.text = [NSString stringWithFormat:@"%d/%@",model.people_current,model.people_count];
    cell.distanceLabel.text = [NSString stringWithFormat:@"%@km",model.distance];
    
    if (model.activity_picture.count) {
        cell.userPicImgView.image = [UIImage imageWithData:model.activity_picture[0]];
    }
    
    
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScreenHeight/5;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
