//
//  FootPrintTableViewController.m
//  teamWork
//
//  Created by lanou3g on 16/1/27.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "FootPrintTableViewController.h"
#import "QFRootTableViewCell.h"
@interface FootPrintTableViewController ()
@property(strong,nonatomic)NSMutableArray *dataArray;//请求的数据 - 为YYUserShare类型
@property(assign,nonatomic) NSInteger page;//数据页数,表示请求第几页的数据
@end
static NSString *const shareCellID = @"shareCellID";
@implementation FootPrintTableViewController
+(instancetype)shareFootPrintTVC{
    static FootPrintTableViewController *handler = nil;
    if (handler == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            handler = [[FootPrintTableViewController alloc]init];
        });
    }
    return handler;
}
#pragma mark -----上拉加载和下拉刷新-------------------
//懒加载_dataArray
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName: NSStringFromClass([QFRootTableViewCell class]) bundle:nil] forCellReuseIdentifier:shareCellID];
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
    [self refreshUI];

}
-(void)refreshUI{
    //马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}
-(void)makeData
{
    //获取数据(查询数据)
    AVQuery *query = [AVQuery queryWithClassName:@"Share"];
    //限制查询条件
    //limit 属性来控制返回结果的数量
    query.limit = 10*self.page++;
    //skip 用来跳过初始结果
    query.skip = 10*(self.page-2);
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"share_picture"];//图片为AVFile类型,查询出要特殊处理
    [query includeKey:@"shareuser"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects) {
            //如果获取到数据
            [self endRefresh];
            if (self.page == 2) {
                self.dataArray = nil;
            }
            
            for (AVObject *share in objects) {
                YYUserShare *shareModel = [YYUserShare new];
                //分享用户
                AVUser *shareUser = [share objectForKey:@"shareuser"];
                //昵称
                if ([[shareUser objectForKey:@"nickname"] isEqualToString:@""]) {
                    shareModel.nickname = [shareUser objectForKey:@"username"];
                }else{
                    shareModel.nickname = [shareUser objectForKey:@"nickname"];
                }
                //头像
                AVFile *avatarFile = [shareUser objectForKey:@"avatar"];
                NSData *avatarData = [avatarFile getData];
                shareModel.avatar = [UIImage imageWithData:avatarData];
                
                shareModel.userName = [shareUser objectForKey:@"username"];//用户名
                shareModel.gender = [shareUser objectForKey:@"gender"];//性别
                shareModel.shareTime = [share objectForKey:@"sharetime"];//分享时间
                shareModel.votes_count = [share objectForKey:@"votes_count"];//点赞数
                shareModel.comment_count = [share objectForKey:@"comment_count"];//评论数
                shareModel.share_txt = [share objectForKey:@"share_txt"];//分享内容(文本)
                //分享内容(图片) 图片数组 元素为AVFile类型 (处理在自定义cell中)
                shareModel.share_picture = [share objectForKey:@"share_picture"];
                [self.dataArray addObject:shareModel];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QFRootTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:shareCellID forIndexPath:indexPath];
    if (self.dataArray.count > 0) {
        [cell createCellViews:_dataArray[indexPath.row]];
        [cell userByAttentionOrNot:_dataArray[indexPath.row]];
    }
//    [cell createCellViews:_dataArray[indexPath.row]];
    return cell;
}      
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count > 0) {
        return [tableView fd_heightForCellWithIdentifier:shareCellID configuration:^(id cell) {
            [cell createCellViews:_dataArray[indexPath.row]];
        }];
    }else{
        return 0;
    }
}


@end
