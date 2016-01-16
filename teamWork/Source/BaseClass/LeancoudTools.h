//
//  LeancoudTools.h
//  teamWork
//
//  Created by lanou3g on 16/1/16.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
//传出登陆结果
typedef void (^yyResultPassBlock)(BOOL succeed,NSError *error);
@interface LeancoudTools : NSObject
//传入用户model
@property(strong,nonatomic)YYUserModel *model;
//用户登陆
-(void)userLogin:(yyResultPassBlock)result;
//用户注册
-(void)userRegist:(yyResultPassBlock)result;
//修改密码
-(void)userChangePassword:(yyResultPassBlock)result;
//重置密码
-(void)userResetPassword:(yyResultPassBlock)result;


@end
