//
//  UserAllAttentionTVC.m
//  teamWork
//
//  Created by lanou3g on 16/2/25.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "UserAllAttentionTVC.h"

@interface UserAllAttentionTVC ()
@property(strong,nonatomic)NSMutableArray *dataArray;
@end

@implementation UserAllAttentionTVC
static NSString *const attentionCellID = @"attentionCellID";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UserAttentionCell class]) bundle:nil] forCellReuseIdentifier:attentionCellID];
    __unsafe_unretained UITableView *tableView = self.tableView;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self makeData];
        // 结束刷新
        [tableView.mj_header endRefreshing];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    //马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
}

-(void)viewWillAppear:(BOOL)animated{
    /*@property(strong,nonatomic)NSString *userName;//用户名(手机号)
     @property(strong,nonatomic)NSString *nickName;//昵称
     @property(strong,nonatomic)NSString *password;//密码
     @property(strong,nonatomic)NSString *phone;//手机号
     @property(strong,nonatomic)NSString *gender;//性别
     @property(strong,nonatomic)NSString *age;//年龄
     @property(strong,nonatomic)NSString *signature;//个性签名
     @property(strong,nonatomic)UIImage *avatar;//头像
     @property(strong,nonatomic)NSMutableArray *joinActivity;//参加的活动*/
}
-(void)makeData{
    //初始化数组
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
    UserAttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:attentionCellID forIndexPath:indexPath];
    YYUserModel_Phone *model = self.dataArray[indexPath.row];
    cell.nickName.text = model.nickName;
    cell.avatar.image = model.avatar;
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.tableView.frame.size.width,100)];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor greenColor];
    backButton.frame = CGRectMake(10, 40, 100, 40);
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:backButton];
    return headerView;
}
-(void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 100;
}
//cell的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //跳转到详情页
    AttentionDetailVC *attentionDVC = [AttentionDetailVC new];
    attentionDVC.model = self.dataArray[indexPath.row];
    [self presentViewController:attentionDVC animated:YES completion:nil];
    
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
