//
//  UserInfo.m
//  teamWork
//
//  Created by hanxiaolong on 16/3/1.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "UserInfo.h"

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
    self.alpha = 0.8;
    UIView *infoView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height/4, self.frame.size.width, self.frame.size.height/3)];
    //infoView.backgroundColor = [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1];
    infoView.backgroundColor = [UIColor blackColor];
    infoView.alpha = 1;
    
    self.backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, infoView.frame.size.height/10.0, infoView.frame.size.height/10.0)];
    //self.backButton.backgroundColor = [UIColor whiteColor];
    [self.backButton setImage:[UIImage imageNamed:@"iconfont-cuowu"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.avatar = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.backButton.frame), infoView.frame.size.width*0.3, infoView.frame.size.height*0.5)];
    //self.avatar.backgroundColor = [UIColor whiteColor];
    self.avatar.image = [UIImage imageNamed:@"default_avatar"];
    
    
    
    self.nickName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.avatar.frame), CGRectGetMinY(self.avatar.frame), infoView.frame.size.width*0.7, infoView.frame.size.height*0.2)];
    //self.nickName.backgroundColor = [UIColor whiteColor];
    self.nickName.text = @"用户未上传昵称";
    self.nickName.textColor = [UIColor whiteColor];
    
    
    self.gender = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.avatar.frame), CGRectGetMaxY(self.nickName.frame), infoView.frame.size.width*0.1, infoView.frame.size.height*0.15)];
   // self.gender.backgroundColor = [UIColor whiteColor];
    
    
    self.age = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.avatar.frame), CGRectGetMaxY(self.gender.frame), infoView.frame.size.width*0.1, infoView.frame.size.height*0.3)];
    //self.age.backgroundColor = [UIColor whiteColor];
    self.age.text = @"18";
    [self.age setTextAlignment:NSTextAlignmentCenter];
    self.age.textColor = [UIColor whiteColor];
    
    self.address = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.age.frame), CGRectGetMaxY(self.nickName.frame), infoView.frame.size.width*0.5, infoView.frame.size.height*0.3)];
    //self.address.backgroundColor = [UIColor whiteColor];
    self.address.text = @"大约在北京";
    self.address.textColor = [UIColor whiteColor];
    [self.address setTextAlignment:NSTextAlignmentCenter];
    self.signature = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.address.frame), infoView.frame.size.width, infoView.frame.size.height*0.4)];
    //self.signature.backgroundColor = [UIColor whiteColor];
    self.signature.text = @"这个人很懒，什么也没说";
    self.signature.textColor = [UIColor whiteColor];
    
    [infoView addSubview:self.nickName];
    [infoView addSubview:self.avatar];
    [infoView addSubview:self.gender];
    [infoView addSubview:self.age];
    [infoView addSubview:self.address];
    [infoView addSubview:self.signature];
    [infoView addSubview:self.backButton];
    
    
    [self addSubview:infoView];
    
    
}

-(void)backAction
{
    [self removeFromSuperview];
}





@end
