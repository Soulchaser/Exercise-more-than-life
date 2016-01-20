//
//  YYUserModel.h
//  teamWork
//
//  Created by lanou3g on 16/1/16.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
#pragma mark --- 邮箱--------------------
//用户信息model(存储在leancoud上)  用户登陆时, 用邮箱+密码登陆  昵称用来展示
@interface YYUserModel : NSObject
@property(strong,nonatomic)NSString *userName;//昵称
@property(strong,nonatomic)NSString *password;//密码
@property(strong,nonatomic)NSString *email;//邮箱
@property(strong,nonatomic)NSString *gender;//性别
@property(strong,nonatomic)NSString *age;//年龄
@property(strong,nonatomic)UIImage *headerImage;//头像
@property(strong,nonatomic)NSMutableArray *joinActivity;//参加的活动

@end

//用户分享model
@interface YYUserShare : NSObject
@property(strong,nonatomic)NSString *userName;//用户名
@property(strong,nonatomic)UIImage *headerImage;//密码
@property(strong,nonatomic)NSString *shareTime;//分享时间
@property(strong,nonatomic)NSData *shareDetail;//分享内容

@end

//用户评论model(评论时需要展示的信息)
@interface YYUserComment : NSObject
@property(strong,nonatomic)NSString *userName;//用户名
@property(strong,nonatomic)NSString *commentDetail;//评论内容

@end
#pragma mark ------ 手机号------------------------
//用户信息model(存储在leancoud上)  用户登陆时, 用手机号+密码登陆  昵称用来展示
@interface YYUserModel_Phone : NSObject
@property(strong,nonatomic)NSString *userName;//昵称
@property(strong,nonatomic)NSString *password;//密码
@property(strong,nonatomic)NSString *phone;//手机号
@property(strong,nonatomic)NSString *gender;//性别
@property(strong,nonatomic)NSString *age;//年龄
@property(strong,nonatomic)UIImage *headerImage;//头像
@property(strong,nonatomic)NSMutableArray *joinActivity;//参加的活动
@end








