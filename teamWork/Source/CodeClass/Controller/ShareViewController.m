//
//  ShareViewController.m
//  teamWork
//
//  Created by hanxiaolong on 16/1/15.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "ShareViewController.h"
#import "FootPrintTableViewController.h"
#import "AddShareCollectionViewController.h"
@interface ShareViewController ()
@property(strong,nonatomic)UIButton *leftButton;//用户
@property(strong,nonatomic)UIButton *rightButton;//编辑(添加分享内容)
@end

@implementation ShareViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"足迹分享" image:[UIImage imageNamed:@"share"] selectedImage:[UIImage imageNamed:@"share_selected"]];

    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(void)viewWillAppear:(BOOL)animated{
    if ([AVUser currentUser] != nil) {
        self.view.backgroundColor = [UIColor yellowColor];
        FootPrintTableViewController *footPrintTVC = [FootPrintTableViewController shareFootPrintTVC];
        [self addChildViewController:footPrintTVC];
        [self.view addSubview:footPrintTVC.tableView];
    }else{
        NSArray *array = self.view.subviews;
        for (UIView *myView in array) {
            [myView removeFromSuperview];
        }
    }
}
-(void)viewDidAppear:(BOOL)animated{
    AVUser *currentUser = [AVUser currentUser];
    UIImage *image = nil;
    if (currentUser == nil) {
        image = [UIImage imageNamed:@"person"];
    }else {
        AVFile *avatarFile = [currentUser objectForKey:@"avatar"];
        NSData *data = [avatarFile getData];
        image = [UIImage imageWithData:data];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    //自定义leftBarButtonItem
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftButton setImage:image forState:UIControlStateNormal];
    self.leftButton.frame = CGRectMake(0, 0, 40, 40);
    self.leftButton.layer.cornerRadius = 20;
    self.leftButton.layer.masksToBounds =YES;
    [self.leftButton addTarget:self action:@selector(MyselfInfoAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.leftButton];
    //自定义rightBarButtonItem
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton setImage:[UIImage imageNamed:@"iconfont-bianji"] forState:UIControlStateNormal];
    self.rightButton.frame = CGRectMake(0, 0, 40, 40);
    self.rightButton.layer.cornerRadius = 20;
    self.rightButton.layer.masksToBounds =YES;
    [self.rightButton addTarget:self action:@selector(addShare) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
}
//用户界面
-(void)MyselfInfoAction:(UIButton *)sender
{
    //将User.storyboard作为入口
    UIStoryboard *user = [UIStoryboard storyboardWithName:@"User" bundle:nil];
    UIViewController *entranceVC = [user instantiateInitialViewController];
    //让window的rootViewController指向该控制器
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:entranceVC animated:YES completion:nil];
}
//添加分享
-(void)addShare{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    AddShareCollectionViewController *addShareCVC = [[AddShareCollectionViewController alloc]initWithCollectionViewLayout:layout];
    layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height/2);
    [self.navigationController pushViewController:addShareCVC animated:YES];
    
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
