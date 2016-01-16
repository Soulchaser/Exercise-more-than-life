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
//用户登陆
-(void)userLogin:(yyResultPassBlock)result{
    
    
}
//用户注册
-(void)userRegist:(yyResultPassBlock)result{
    
}
//修改密码
-(void)userChangePassword:(yyResultPassBlock)result{
    
}
//重置密码
-(void)userResetPassword:(yyResultPassBlock)result{
    
}



@end
