//
//  LeancoudTools.h
//  teamWork
//
//  Created by lanou3g on 16/1/16.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//
//

#import <Foundation/Foundation.h>
//传出登陆结果
typedef void (^yyResultPassBlock)(BOOL succeed,NSError *error);
@interface LeancoudTools : NSObject
#pragma mark -----以下为邮箱验证---------
//传入用户model
@property(strong,nonatomic)YYUserModel *model;
//用户登陆
-(void)userLogin:(yyResultPassBlock)result;
//用户注册
-(void)userRegist:(yyResultPassBlock)result;
//修改密码
-(void)userChangePasswordWithNewPassword:(NSString *)newPassword resultBlock:(yyResultPassBlock)result;
//找回密码
-(void)userResetPasswordWithEmail:(NSString *)email resultBlock:(yyResultPassBlock)result;
//根据用户名验证用户是否已注册过
-(void)userDidBecomeRegisterWithUserName:(NSString *)userName resultBlock:(yyResultPassBlock)result;




@end
