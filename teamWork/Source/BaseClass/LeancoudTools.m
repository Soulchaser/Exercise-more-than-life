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
            result(NO,error);
        }
    }];
}
//修改密码
//填入邮箱, 邮箱验证正确后会向邮箱发送修改密码的邮件
-(void)userChangePasswordWithNewPassword:(NSString *)newPassword resultBlock:(yyResultPassBlock)result{
    //先进行登陆
    [AVUser logInWithUsername:self.model.userName password:self.model.password error:nil];
    //修改当前用户的密码
    [[AVUser currentUser] updatePassword:self.model.password newPassword:newPassword block:^(id object, NSError *error) {
        if (object) {
            
        }
    }];
    
    
}
//忘记密码 进行重置

-(void)userResetPassword:(yyResultPassBlock)result{
    
}



@end
