//
//  Friend.m
//  teamWork
//
//  Created by lanou3g on 16/2/27.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "Friend.h"
#import "BaseChatViewController.h"
@interface Friend ()
@property(strong,nonatomic)NSMutableArray *dataArray;
@property (nonatomic,strong) NSString *selectedClientId;
@property BOOL wifi;
@end

@implementation Friend
static NSString *const friendCellID = @"friendCellID";
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
    //马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    // 创建一个 AVIMClient 实例
    AVIMClient *imClient = [AVIMClient defaultClient];
    NSString *seflClientId=[AVUser currentUser].username;
    [imClient openWithClientId:seflClientId callback:^(BOOL succeeded, NSError *error){
        if (error) {
            // 出错了，可能是网络问题无法连接 LeanCloud 云端，请检查网络之后重试。
            // 此时聊天服务不可用。
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"聊天不可用！" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [view show];
            self.wifi = NO;
        } else {
            // 成功登录，可以进入聊天主界面了。
            self.wifi = YES;
        }
    }];
    
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
    UserAttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:friendCellID forIndexPath:indexPath];
    YYUserModel_Phone *model = self.dataArray[indexPath.row];
    cell.nickName.text = model.nickName;
    cell.avatar.image = model.avatar;
    cell.userName = model.userName;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

//cell的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.wifi == YES) {
        YYUserModel_Phone *model = self.dataArray[indexPath.row];
        self.selectedClientId = model.userName;
        [[AVIMClient defaultClient] createConversationWithName:@"" clientIds:@[self.selectedClientId] callback:^(AVIMConversation *conversation, NSError *error) {
            //跳转到聊天界面
            BaseChatViewController *singleChat = [BaseChatViewController new];
//             [self.navigationController pushViewController:singleChat animated:YES];
            [self presentViewController:singleChat animated:YES completion:nil];
            //显示私聊对象 ClientId
            [singleChat setTargetClientId:self.selectedClientId];
            //设置私聊对象所在的具体对话
            [singleChat setCurrentConversation:conversation];
            
        }];
    }
    
}

@end
