//
//  FriendsViewController.m
//  teamWork
//
//  Created by hanxiaolong on 16/1/15.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "FriendsViewController.h"

@interface FriendsViewController ()
//用户
@property(strong,nonatomic)UIButton *leftButton;
@end

@implementation FriendsViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"关注" image:[UIImage imageNamed:@"haoyou"] selectedImage:[UIImage imageNamed:@"haoyou-selected"]];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关注";
    //字体颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1]];
    self.view.backgroundColor = [UIColor grayColor];

}
-(void)viewWillAppear:(BOOL)animated{
    if ([AVUser currentUser] != nil) {
        Friend *friend = [Friend shareFriend];
        [self addChildViewController:friend];
        [self.view addSubview:friend.tableView];
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
        UIView *view = [[UIView alloc]initWithFrame:self.view.frame];
        
        view.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, self.view.frame.size.height/2)];
        imgView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
        imgView.image = [UIImage imageNamed:@"background.jpg"];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame), view.frame.size.width, 40)];
        [label setTextAlignment:NSTextAlignmentCenter];
        label.text = @"您尚未登录，请先登录";
        [view addSubview:label];
        [view addSubview:imgView];
        
        
        self.view = view;
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
