//
//  UserInfo.h
//  teamWork
//
//  Created by hanxiaolong on 16/3/1.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfo : UIView


@property(nonatomic,strong)UIButton *backButton;

@property (strong, nonatomic)  UIImageView *avatar;//头像
@property (strong, nonatomic)  UILabel *nickName;//昵称
@property (strong, nonatomic)  UIImageView *gender;//性别
@property (strong, nonatomic)  UILabel *age;//年龄
@property (strong, nonatomic)  UILabel *signature;//个性签名
@property (strong, nonatomic)  UILabel *address;//地址
@property(strong,nonatomic)UIView *infoView;



@end
