//
//  UserInfo.m
//  teamWork
//
//  Created by hanxiaolong on 16/3/1.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "UserInfo.h"

@interface UserInfo ()



@end

@implementation UserInfo

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self drawView];
    }
    return self;
}

-(void)drawView
{
    self.alpha = 0.5;
    self.backgroundColor = [UIColor blackColor];
    self.infoView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height/4, self.frame.size.width, self.frame.size.height/2)];
    //infoView.backgroundColor = [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1];
    //self.infoView.backgroundColor = [UIColor whiteColor];
    self.infoView.alpha = 1;
    
    self.backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.infoView.frame.size.height/10.0, self.infoView.frame.size.height/10.0)];
    self.backButton.backgroundColor = [UIColor whiteColor];
    [self.backButton setImage:[UIImage imageNamed:@"iconfont-cuowu"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.avatar = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.backButton.frame), self.infoView.frame.size.width*0.3, self.infoView.frame.size.height*0.5)];
    self.avatar.backgroundColor = [UIColor whiteColor];
    self.avatar.image = [UIImage imageNamed:@"default_avatar"];
    
    
    
    self.nickName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.avatar.frame), CGRectGetMinY(self.avatar.frame), self.infoView.frame.size.width*0.7, self.infoView.frame.size.height*0.2)];
    self.nickName.backgroundColor = [UIColor whiteColor];
    self.nickName.text = @"用户未上传昵称";
    //self.nickName.textColor = [UIColor whiteColor];
    
    
    self.gender = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.avatar.frame), CGRectGetMaxY(self.nickName.frame), self.infoView.frame.size.width*0.1, self.infoView.frame.size.height*0.15)];
    self.gender.backgroundColor = [UIColor whiteColor];
    
    
    self.age = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.avatar.frame), CGRectGetMaxY(self.gender.frame), self.infoView.frame.size.width*0.1, self.infoView.frame.size.height*0.15)];
    self.age.backgroundColor = [UIColor whiteColor];
    self.age.text = @"18";
    self.age.font = [UIFont systemFontOfSize:13];
    [self.age setTextAlignment:NSTextAlignmentCenter];
    //self.age.textColor = [UIColor whiteColor];
    
    self.address = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.age.frame), CGRectGetMaxY(self.nickName.frame), self.infoView.frame.size.width*0.6, self.infoView.frame.size.height*0.3)];
    self.address.backgroundColor = [UIColor whiteColor];
    self.address.text = @"大约在北京";
    //self.address.textColor = [UIColor whiteColor];
    self.address.numberOfLines = 0;
    [self.address setTextAlignment:NSTextAlignmentCenter];
    self.signature = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.address.frame), self.infoView.frame.size.width, self.infoView.frame.size.height*0.4)];
    self.signature.backgroundColor = [UIColor whiteColor];
    self.signature.text = @"这个人很懒，什么也没说";
    //self.signature.textColor = [UIColor whiteColor];
    self.signature.numberOfLines = 0;
    [self.infoView addSubview:self.nickName];
    [self.infoView addSubview:self.avatar];
    [self.infoView addSubview:self.gender];
    [self.infoView addSubview:self.age];
    [self.infoView addSubview:self.address];
    [self.infoView addSubview:self.signature];
    [self.infoView addSubview:self.backButton];
    
    

     [[UIApplication sharedApplication].delegate.window addSubview:self.infoView];
    
}

-(void)backAction
{
    [self.infoView removeFromSuperview];
    [self removeFromSuperview];
}





@end
