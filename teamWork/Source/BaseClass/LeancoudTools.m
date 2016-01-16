//
//  LeancoudTools.m
//  teamWork
//
//  Created by lanou3g on 16/1/16.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "LeancoudTools.h"

@implementation LeancoudTools
//重写用户model的setter方法
-(void)setModel:(YYUserModel *)model{
    if (_model != model) {
        _model = nil;
        _model = model;
    }
}
//result ①是否操作成功   ②error信息
//用户登陆
-(void)userLogin:(yyResultPassBlock)result{
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
-(void)userRegist:(yyResultPassBlock)result{
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
-(void)userChangePasswordWithNewPassword:(NSString *)newPassword resultBlock:(yyResultPassBlock)result{
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



@end


