//
//  Friend.m
//  teamWork
//
//  Created by lanou3g on 16/2/27.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "Friend.h"

@interface Friend ()
@property(strong,nonatomic)NSMutableArray *dataArray;
@end

@implementation Friend
static NSString *const friendCellID = @"friendCellID";
+(instancetype)shareFriend{
    static Friend *handler = nil;
    if (handler == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            handler = [[Friend alloc]init];
        });
    }
    return handler;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UserAttentionCell class]) bundle:nil] forCellReuseIdentifier:friendCellID];
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self makeData];
        // 结束刷新
        [tableView.mj_header endRefreshing];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self refreshUI];
}
-(void)refreshUI{
    //马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}
-(void)makeData{
    //初始化数组
    self.dataArray = nil;
    self.dataArray = [[NSMutableArray alloc]initWithCapacity:1];
    //获取所有当前用户已关注的对象
    AVQuery *query = [AVQuery queryWithClassName:@"Follow"];
    [query whereKey:@"from" equalTo:[AVUser currentUser]];
    [query includeKey:@"to"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects) {
            //如果获取到数据
            [self endRefresh];
            for (AVObject *follow in objects) {
                AVUser *toUser = [follow objectForKey:@"to"];
                YYUserModel_Phone *model = [YYUserModel_Phone new];
                model.address = [toUser objectForKey:@"address"];
                model.signature = [toUser objectForKey:@"signature"];
                model.nickName = [toUser objectForKey:@"nickname"];
                model.userName = [toUser objectForKey:@"username"];
                model.age = [toUser objectForKey:@"age"];
                model.gender = [toUser objectForKey:@"gender"];
                //头像
                AVFile *avatarFile = [toUser objectForKey:@"avatar"];
                NSData *avatarData = [avatarFile getData];
                model.avatar = [UIImage imageWithData:avatarData];
                
                [self.dataArray addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserAttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:friendCellID forIndexPath:indexPath];
    YYUserModel_Phone *model = self.dataArray[indexPath.row];
    if ([model.nickName isEqualToString:@""] || model.nickName == nil) {
        cell.nickName.text = model.userName;
    }else{
        cell.nickName.text = model.nickName;
    }
    
    cell.avatar.image = model.avatar;
    cell.userName = model.userName;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

//cell的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        //跳转到详情页
//        AttentionDetailVC *attentionDVC = [[AttentionDetailVC alloc]init];
//    attentionDVC.view.alpha = 0.5;
//    
//        attentionDVC.model = self.dataArray[indexPath.row];
//    [self.view addSubview:attentionDVC.view];
   // [self.navigationController presentViewController:attentionDVC animated:NO completion:nil];
    YYUserModel_Phone *model = self.dataArray[indexPath.row];
    
    UserInfo *userView = [[UserInfo alloc]initWithFrame:self.view.frame];
    if (model.avatar != nil)
    {
         userView.avatar.image = model.avatar;
    }
    if (model.nickName != nil)
    {
        userView.nickName.text = model.nickName;
    }

    if ([model.gender isEqualToString:@"男"]) {
        userView.gender.image = [UIImage imageNamed:@"iconfont-iconfontnan"];
    }else if([model.gender isEqualToString:@"女"]){
        userView.gender.image = [UIImage imageNamed:@"iconfont-nv"];
    }else{
        userView.gender.image = [UIImage imageNamed:@"iconfont-wenhao.png"];
    }
    if (model.age != nil)
    {
       userView.age.text = model.age;
    }
    
    if (model.signature == nil) {
        
    }else{
        userView.signature.text = model.signature;
    }
    if (model.address != nil)
    {
      userView.address.text = model.address;  
    }
    
    
    
    [[UIApplication sharedApplication].delegate.window addSubview:userView];
    
}

@end
