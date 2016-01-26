//
//  LeancoudTools.m
//  teamWork
//
//  Created by lanou3g on 16/1/16.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "LeancoudTools.h"

@implementation LeancoudTools
+(instancetype)shareLeancoudTools{
    static LeancoudTools *handler = nil;
    if (handler == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            handler = [LeancoudTools new];
        });
    }
    return handler;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark ------ 邮箱用户------------------
//重写用户model的setter方法
-(void)setModel:(YYUserModel *)model{
    if (_model != model) {
        _model = nil;
        _model = model;
    }
}
//result ①是否操作成功   ②error信息
//用户登陆(邮箱+密码)
-(void)userLoginByEmail:(yyResultPassBlock)result{
    [AVUser logInWithUsernameInBackground:self.model.email password:self.model.password block:^(AVUser *user, NSError *error) {
        //用户存在 登陆成功
        if (user != nil) {
            result(YES,nil);
        }else{
            //登陆失败 根据error.code 查找失败原因
            result(NO,error);
        }
    }];
}
//用户注册
-(void)userRegisterByEmail:(yyResultPassBlock)result{
    AVUser *user = [AVUser user];
    user.username = self.model.email;
    user.password = self.model.password;
    user.email = self.model.email;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //注册成功
            result(YES,nil);
        }else {
            //注册失败
            result(NO,error);
        }
    }];
}
//修改密码
//旧密码替代新密码
-(void)userChangePasswordByEmailWithNewPassword:(NSString *)newPassword resultBlock:(yyResultPassBlock)result{
    //先进行登陆 修改当前用户的密码
    [AVUser logInWithUsername:self.model.userName password:self.model.password error:nil];
    //修改当前用户的密码
    [[AVUser currentUser] updatePassword:self.model.password newPassword:newPassword block:^(id object, NSError *error) {
        if (error == nil) {
            //修改成功
            result(YES,nil);
            //修改成功 退出当前用户
            [AVUser logOut];
        }else {
            //修改失败
            result(NO,error);
        }
    }];
}
//找回密码
//填入邮箱, 邮箱验证正确后会向邮箱发送重置密码的邮件
-(void)userResetPasswordWithEmail:(NSString *)email resultBlock:(yyResultPassBlock)result{
    [AVUser requestPasswordResetForEmailInBackground:email block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //邮件发送成功
            result(YES,nil);
        }else {
            //找回失败(邮件发送失败)
            result(NO,error);
        }
    }];
}
//根据用户名验证用户是否已注册过
-(void)userDidBecomeRegisterWithUserName:(NSString *)userName resultBlock:(yyResultPassBlock)result{
    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:userName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count > 0) {
            //用户存在
            result(YES,nil);
        }else {
            //用户不存在
            result(NO,nil);
        }
    }];
}
#pragma mark ---------- 手机用户 -------------------
-(void)setModel_Phone:(YYUserModel_Phone *)model_Phone{
    if (_model_Phone != model_Phone) {
        _model_Phone = nil;
        _model_Phone = model_Phone;
    }
}

//用户登陆(手机号码+密码)
-(void)userLoginByPhone:(yyResultPassBlock)result{
    [AVUser logInWithMobilePhoneNumberInBackground:self.model_Phone.userName password:self.model_Phone.password block:^(AVUser *user, NSError *error) {
        //用户存在 登陆成功
        if (user != nil) {
            result(YES,nil);
        }else{
            //登陆失败 根据error.code 查找失败原因
            result(NO,error);
        }
    }];
}
//用户登录(手机号码+短信验证码)
//先输入手机号码,根据手机号码发送验证码,验证成功后登录
//输入手机号
-(void)userLoginInputByPhone:(NSString *)phone resultBlock:(yyResultPassBlock)result{
    [AVUser requestLoginSmsCode:phone withBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //短信发送成功
            result(YES,nil);
        }else {
            //短信发送失败
            result(NO,error);
        }
    }];
}
//短信验证
-(void)userLoginBySMSCode:(NSString *)smsCode resultBlock:(yyResultPassBlock)result{
    [AVUser logInWithMobilePhoneNumberInBackground:self.model_Phone.userName smsCode:smsCode block:^(AVUser *user, NSError *error) {
        if (user != nil) {
            //用户验证成功
            result(YES,nil);
        }else {
            //验证失败
            result(NO,error);
        }
    }];
}

//用户注册分为用户注册+短信验证手机号
//用户注册
-(void)userRegisterByPhone:(yyResultPassBlock)result{
    AVUser *user = [AVUser user];
    user.username = self.model_Phone.phone;
    user.password = self.model_Phone.password;
    user.mobilePhoneNumber = self.model_Phone.phone;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //信息无误,接收短信验证码
            result(YES,nil);
        }else {
            //信息填写不正确
            result(NO,error);
        }
    }];
}
//验证手机号
-(void)userRegisterBySMSCode:(NSString *)smsCode resultBlock:(yyResultPassBlock)result{
    [AVUser verifyMobilePhone:smsCode withBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //短信验证成功
            result(YES,nil);
        }else {
            //短信验证失败
            result(NO,error);
        }
    }];
}
//忘记密码
//根据手机号发送验证码
-(void)userResetPasswordWithPhone:(NSString *)phone resultBlock:(yyResultPassBlock)result{
    [AVUser requestPasswordResetWithPhoneNumber:phone block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //短信发送成功
            result(YES,nil);
        }else {
            //短信发送失败.
            result(NO,error);
        }
    }];
}
//验证
-(void)userResetBySMSCode:(NSString *)smsCode andNewPassword:(NSString *)newPassword resultBlock:(yyResultPassBlock)result{
    [AVUser resetPasswordWithSmsCode:smsCode newPassword:newPassword block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //密码修改成功
            result(YES,nil);
        }else {
            //密码修改失败
            result(NO,error);
        }
    }];
}

#pragma mark --- 匿名用户(匿名评论时使用) ---------
-(void)anonymousUserLogin{
    [AVAnonymousUtils logInWithBlock:^(AVUser *user, NSError *error) {
        if (user != nil) {
            
        }
    }];
}







@end


