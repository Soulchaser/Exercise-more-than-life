//
//  YYUserModel.h
//  teamWork
//
//  Created by lanou3g on 16/1/16.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
//用户信息model(存储在leancoud上)
@interface YYUserModel : NSObject
@property(strong,nonatomic)NSString *userName;//用户名
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

//用户评论model(评论时需要的信息)
@interface YYUserComment : NSObject
@property(strong,nonatomic)NSString *userName;//用户名
@property(strong,nonatomic)NSString *commentDetail;//评论内容

@end