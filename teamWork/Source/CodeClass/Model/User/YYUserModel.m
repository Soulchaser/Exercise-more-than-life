//
//  YYUserModel.m
//  teamWork
//
//  Created by lanou3g on 16/1/16.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "YYUserModel.h"
//用户信息model(存储在leancoud上)------邮箱用户
@implementation YYUserModel
-(NSString *)description{
    return [NSString stringWithFormat:@"邮箱用户%@",_userName];
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{}
@end


//用户分享model
@implementation YYUserShare
-(NSString *)description{
    return [NSString stringWithFormat:@"%@",_userName];
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{}
@end


//用户评论model(评论时需要的信息)
@implementation YYUserComment
-(NSString *)description{
    return [NSString stringWithFormat:@"%@",_userName];
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{}
@end

//用户信息model(存储在leancoud上)----------手机用户
@implementation YYUserModel_Phone
-(NSString *)description{
    return [NSString stringWithFormat:@"手机用户%@",_userName];
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{}

@end