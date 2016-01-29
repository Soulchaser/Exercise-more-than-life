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

#pragma mark -----上拉加载和下拉刷新-------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName: NSStringFromClass([QFRootTableViewCell class]) bundle:nil] forCellReuseIdentifier:shareCellID];
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
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
    //马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
}
/*//用户分享model
 @interface YYUserShare : NSObject
 //如果未设置昵称,这里的昵称<==>用户名
 @property(strong,nonatomic)NSString *nickname;//昵称
 @property(strong,nonatomic)NSString *gender;//性别
 @property(strong,nonatomic)UIImage *avatar;//头像
 @property(strong,nonatomic)NSString *shareTime;//分享时间
 @property(strong,nonatomic)NSString *votes_count;//点赞数
 @property(strong,nonatomic)NSString *comment_count;//评论数
 @property(strong,nonatomic)NSString *share_txt;//分享内容(文本)
 @property(strong,nonatomic)NSArray *share_picture;//分享内容(图片) 图片数组 元素为AVFile类型
*/
-(void)makeData
{
    //清理dataArray
    if (_dataArray != nil) {
        _dataArray = nil;
        _dataArray = [NSMutableArray new];
    }
    AVQuery *query = [AVQuery queryWithClassName:@"Share"];
    query.limit = 10*self.page++;
    [query includeKey:@"share_picture"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (AVObject *share in objects) {
            YYUserShare *shareModel = [YYUserShare new];
            shareModel.nickname = [share objectForKey:@"nickname"];//昵称
            shareModel.gender = [share objectForKey:@"gender"];//性别
            //头像
            AVFile *avatarFile = [share objectForKey:@"avatar"];
            NSData *avatarData = [avatarFile getData];
            shareModel.avatar = [UIImage imageWithData:avatarData];
            
            shareModel.shareTime = [share objectForKey:@"shareTime"];//分享时间
            shareModel.votes_count = [share objectForKey:@"votes_count"];//点赞数
            shareModel.comment_count = [share objectForKey:@"comment_count"];//评论数
            shareModel.share_txt = [share objectForKey:@"share_txt"];//分享内容(文本)
            //分享内容(图片) 图片数组 元素为AVFile类型 (处理在自定义cell中)
            shareModel.share_picture = [share objectForKey:@"share_picture"];
            NSLog(@"%@",shareModel.share_picture);
            [self.dataArray addObject:shareModel];
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
    [cell createCellViews:_dataArray[indexPath.row]];
    return cell;
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:shareCellID configuration:^(id cell) {
        [cell createCellViews:_dataArray[indexPath.row]];
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
