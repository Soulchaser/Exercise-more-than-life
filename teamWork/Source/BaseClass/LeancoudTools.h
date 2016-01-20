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
-(void)userLoginByEmail:(yyResultPassBlock)result;
//用户注册
-(void)userRegisterByEmail:(yyResultPassBlock)result;
//修改密码
-(void)userChangePasswordByEmailWithNewPassword:(NSString *)newPassword resultBlock:(yyResultPassBlock)result;
//找回密码
-(void)userResetPasswordWithEmail:(NSString *)email resultBlock:(yyResultPassBlock)result;

#pragma mark -----以下为手机验证---------
//传入用户model
@property(strong,nonatomic)YYUserModel_Phone *model_Phone;
//用户登陆(手机号码+密码)
-(void)userLoginByPhone:(yyResultPassBlock)result;
//用户登录(手机号码+短信验证码)
//先输入手机号码,根据手机号码发送验证码,验证成功后登录
//输入手机号
-(void)userLoginInputByPhone:(NSString *)phone resultBlock:(yyResultPassBlock)result;
//短信验证
-(void)userLoginBySMSCode:(NSString *)smsCode resultBlock:(yyResultPassBlock)result;

//用户注册分为用户注册+短信验证手机号
//用户注册
-(void)userRegisterByPhone:(yyResultPassBlock)result;
//验证手机号
-(void)userRegisterBySMSCode:(NSString *)smsCode resultBlock:(yyResultPassBlock)result;


//忘记密码
//根据手机号发送验证码
-(void)userResetPasswordWithPhone:(NSString *)phone resultBlock:(yyResultPassBlock)result;
//验证
-(void)userResetBySMSCode:(NSString *)smsCode resultBlock:(yyResultPassBlock)result;

#pragma mark --- 匿名用户(匿名评论时使用) ---------
-(void)anonymousUserLogin;
//根据用户名验证用户是否已注册过
-(void)userDidBecomeRegisterWithUserName:(NSString *)userName resultBlock:(yyResultPassBlock)result;
@end
