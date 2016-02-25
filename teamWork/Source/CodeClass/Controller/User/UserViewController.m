//
//  UserViewController.m
//  teamWork
//
//  Created by lanou3g on 16/1/20.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "UserViewController.h"
#import "UserInfoViewController.h"
#import "LoginViewController.h"
@interface UserViewController ()
//头像
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
//登陆
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButtonToo;
//注销登陆按钮
@property (weak, nonatomic) IBOutlet UIButton *logOutButton;
//注销登录按钮背景
@property (weak, nonatomic) IBOutlet UIView *logOutBgView;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)viewDidAppear:(BOOL)animated{
    //检测当前用户
    AVUser *currentUser = [AVUser currentUser];
    UIImage *image = nil;
    if (currentUser != nil) {
        AVFile *avatarFile = [currentUser objectForKey:@"avatar"];
        NSData *data = [avatarFile getData];
        image = [UIImage imageWithData:data];
        self.headerImageView.layer.cornerRadius = self.headerImageView.frame.size.width/2;
        self.headerImageView.layer.masksToBounds = YES;
        if ([currentUser[@"nickname"] isEqualToString:@""]) {
           [self.loginButton setTitle:currentUser.username forState:UIControlStateNormal];
        }else{
            [self.loginButton setTitle:currentUser[@"nickname"] forState:UIControlStateNormal];
        }
        [self.loginButtonToo setTitleColor:[UIColor colorWithRed:144/255.0 green:1 blue:1 alpha:1] forState:UIControlStateNormal];
        self.loginButtonToo.userInteractionEnabled = NO;
        
        
        self.logOutButton.backgroundColor = [UIColor redColor];
        self.logOutButton.userInteractionEnabled = YES;
    }else{
        image = [UIImage imageNamed:@"person"];
        self.logOutButton.backgroundColor = [UIColor whiteColor];
        self.logOutButton.userInteractionEnabled = NO;
    }
    self.headerImageView.image = image;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//取消按钮
- (IBAction)cancelAction:(id)sender {
    //返回主界面
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)goAction:(id)sender {
    //检测当前用户
    AVUser *currentUser = [AVUser currentUser];
    if (currentUser != nil) {
    //用户已登录->用户详情页
        UserInfoViewController *userInfo = [UserInfoViewController shareUserInfoViewController];
        [self presentViewController:userInfo animated:YES completion:nil];
    }else{
        //用户未登录->登陆界面
        [self performSegueWithIdentifier:@"loginUI" sender:self];

    }
}
//界面跳转
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //跳转到登陆界面
    if ([segue.identifier isEqualToString:@"loginUI"]) {
        
    }else{
        //用户跳转到个人信息界面
    }
}
//storyboard返回时使用 百度方法
-(IBAction)nwindSegue:(UIStoryboardSegue *)sender{
    
}
#pragma mark ---------和用户信息有关的一些方法------------
//运动记录
- (IBAction)exerciseRecord:(id)sender {
    
}
//我的分享
- (IBAction)myShare:(id)sender {
    //判断用户是否登录,如果未登录,跳转到用户登录状态
    if ([self userAleadyLogin] == NO) {
        [self performSegueWithIdentifier:@"loginUI" sender:self];
    }else{
        UserAllShareTableViewController *allShare = [UserAllShareTableViewController new];
        [self presentViewController:allShare animated:YES completion:nil];
    }
    
}
//我的参与
- (IBAction)myJoinActivity:(id)sender {
}
//我的关注
- (IBAction)myAttention:(id)sender {
    //判断用户是否登录,如果未登录,跳转到用户登录状态
    if ([self userAleadyLogin] == NO) {
        [self performSegueWithIdentifier:@"loginUI" sender:self];
    }else{
        UserAllAttentionTVC *allAttention = [UserAllAttentionTVC new];
        [self presentViewController:allAttention animated:YES completion:nil];
    }
}
//登陆注销
- (IBAction)cancelLogin:(id)sender {
    [AVUser logOut];
    self.headerImageView.image = [UIImage imageNamed:@"person"];
    self.headerImageView.layer.cornerRadius = 0;
    self.headerImageView.layer.masksToBounds = NO;
    [self.loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    //隐藏注销按钮并关闭交互
    self.logOutBgView.backgroundColor = [UIColor whiteColor];
    self.logOutButton.backgroundColor = [UIColor whiteColor];
    self.logOutButton.userInteractionEnabled = NO;
    
}
//判断用户是否登录
-(BOOL)userAleadyLogin{
    AVUser *currentUser = [AVUser currentUser];
    if (currentUser == nil) {
        return NO;
    }
    return YES;
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
