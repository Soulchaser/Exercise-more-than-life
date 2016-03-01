//
//  AttentionDetailVC.m
//  teamWork
//
//  Created by lanou3g on 16/2/25.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "AttentionDetailVC.h"

@interface AttentionDetailVC ()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;//头像
@property (weak, nonatomic) IBOutlet UILabel *nickName;//昵称
@property (weak, nonatomic) IBOutlet UIImageView *gender;//性别
@property (weak, nonatomic) IBOutlet UILabel *age;//年龄 
@property (weak, nonatomic) IBOutlet UILabel *signature;//个性签名
@property (weak, nonatomic) IBOutlet UILabel *address;//地址
- (IBAction)gobackAction:(id)sender;



@end

@implementation AttentionDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.avatar.image = self.model.avatar;
    self.nickName.text = self.model.nickName;
    if ([self.model.gender isEqualToString:@"男"]) {
        self.gender.image = [UIImage imageNamed:@"iconfont-iconfontnan"];
    }else if([self.model.gender isEqualToString:@"女"]){
        self.gender.image = [UIImage imageNamed:@"iconfont-nv"];
    }else{
        self.gender.image = [UIImage imageNamed:@"iconfont-wenhao.png"];
    }
    self.age.text = self.model.age;
    if (self.model.signature == nil) {
        
    }else{
        self.signature.text = self.model.signature;
    }
    
    self.address.text = self.model.address;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//返回事件
- (IBAction)backButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)gobackAction:(id)sender {
     //[self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
