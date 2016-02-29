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
@property(strong,nonatomic)NSString *userName;//用户名(邮箱)
@property(strong,nonatomic)NSString *password;//密码
@property(strong,nonatomic)NSString *email;//邮箱
@property(strong,nonatomic)NSString *gender;//性别
@property(strong,nonatomic)NSString *age;//年龄
@property(strong,nonatomic)UIImage *avatar;//头像
@property(strong,nonatomic)NSMutableArray *joinActivity;//参加的活动

@end

//用户分享model
@interface YYUserShare : NSObject
@property(strong,nonatomic)NSString *userName;//用户名(手机号)
//如果未设置昵称,这里的昵称<==>用户名
@property(strong,nonatomic)NSString *nickname;//昵称
@property(strong,nonatomic)NSString *gender;//性别
@property(strong,nonatomic)UIImage *avatar;//头像
@property(strong,nonatomic)NSString *shareTime;//分享时间
@property(strong,nonatomic)NSString *votes_count;//点赞数
@property(strong,nonatomic)NSString *comment_count;//评论数
@property(strong,nonatomic)NSString *share_txt;//分享内容(文本)
@property(strong,nonatomic)NSArray *share_picture;//分享内容(图片) 图片数组 元素为AVFile类型

@end
//用户活动model
@interface YYUserActivity : NSObject
@property(strong,nonatomic) NSString * title;//标题
@property(strong,nonatomic) NSString * myDescription;//描述
@property(strong,nonatomic) NSString * address;//集合地点
@property(strong,nonatomic) NSString * distance;//距离
@property(strong,nonatomic) NSString * start_time;//开始时间
@property(strong,nonatomic) NSString * end_time;//结束时间
@property(strong,nonatomic) NSString * people_count;//人数限制
@property(strong,nonatomic) NSString * people_current;//当前参与人数
@property(strong,nonatomic) NSString * phone;//手机号
@property(strong,nonatomic)NSMutableArray *activity_picture;//活动内容(图片) 图片数组 元素为NSData类型
//发起人信息
@property(strong,nonatomic)UIImage *avatar;//头像
@property(strong,nonatomic)NSString *nickname;//昵称
@end


//用户评论model(评论时需要展示的信息)有昵称优先使用,否则显示用户名
@interface YYUserComment : NSObject
@property(strong,nonatomic)NSString *anonymousUser;//是否匿名
@property(strong,nonatomic)NSString *userName;//用户名
@property(strong,nonatomic)NSString *nickname;//昵称
@property(strong,nonatomic)NSString *commentDetail;//评论内容

@end
#pragma mark ------ 手机号------------------------
//用户信息model(存储在leancoud上)  用户登陆时, 用手机号+密码登陆  昵称用来展示
@interface YYUserModel_Phone : NSObject
@property(strong,nonatomic)NSString *userName;//用户名(手机号)
@property(strong,nonatomic)NSString *nickName;//昵称
@property(strong,nonatomic)NSString *password;//密码
@property(strong,nonatomic)NSString *phone;//手机号
@property(strong,nonatomic)NSString *gender;//性别
@property(strong,nonatomic)NSString *age;//年龄
@property(strong,nonatomic)NSString *address;//地址

@property(strong,nonatomic)NSString *signature;//个性签名
@property(strong,nonatomic)UIImage *avatar;//头像
@property(strong,nonatomic)NSMutableArray *joinActivity;//参加的活动
@end

/*
 [currentUser setObject:self.nickname.text forKey:@"nickname"];
 [currentUser setObject:self.gender forKey:@"gender"];
 [currentUser setObject:self.year forKey:@"age"];
 [currentUser setObject:self.signature.text forKey:@"signature"];
 currentUser.email = self.email.text;
 [currentUser setObject:self.address.text forKey:@"address"];
 //头像
 //删除原头像
 AVFile *oldAvatar = [currentUser objectForKey:@"avatar"];

 */






