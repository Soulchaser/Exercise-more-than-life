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
@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
<<<<<<< HEAD
    

    
=======
>>>>>>> 4cb81522133430929d3d89ec838cb923e019527f
}
-(void)viewDidAppear:(BOOL)animated{
    //检测当前用户
    AVUser *currentUser = [AVUser currentUser];
    if (currentUser != nil) {
        AVFile *avatarFile = [currentUser objectForKey:@"avatar"];
        NSData *data = [avatarFile getData];
        self.headerImageView.image = [UIImage imageWithData:data];
        if ([currentUser[@"nickname"] isEqualToString:@""]) {
           [self.loginButton setTitle:currentUser.username forState:UIControlStateNormal];
        }else{
            [self.loginButton setTitle:currentUser[@"nickname"] forState:UIControlStateNormal];
        }
        [self.loginButtonToo setTitleColor:[UIColor colorWithRed:144/255.0 green:1 blue:1 alpha:1] forState:UIControlStateNormal];
        self.loginButtonToo.userInteractionEnabled = NO;
    }
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
//    currentUser = nil;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
