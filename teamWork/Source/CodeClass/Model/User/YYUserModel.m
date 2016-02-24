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
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
#warning --------运动记录储存方式--------------------------------------
    /*
    //获取当前用户
    AVUser *currentUser = [AVUser currentUser];
    //创建一条运动记录
    AVObject *exercise = [AVObject objectWithClassName:@"Exercise"];//运动记录在Exercise表中
    [exercise setObject:currentUser forKey:@"exercise_user"];//运动记录创建者 (当前用户)
    //数据位字符串类型
    [exercise setObject:@"开始时间" forKey:@"start_time"];//开始时间
    [exercise setObject:@"总时间" forKey:@"all_time"];//总时间
    [exercise setObject:@"运动时间" forKey:@"exercise_time"];//运动时间
    [exercise setObject:@"最高时速" forKey:@"most_speed"];//最高时速
    [exercise setObject:@"运动类型" forKey:@"exercise_type"];//运送类型
    [exercise setObject:@"总路程" forKey:@"all_length"];//总路程
    
    //运动点记录 将所有点数组转化为data类型
    NSData *allPoint = [];
    
    AVFile *pointFile = [AVFile fileWithData:allPoint];//运动点记录在AVFile表中
    [exercise setObject:pointFile forKey:@"all_point"];//该条记录所有的运动点
    [exercise saveEventually:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //储存成功执行
            
        }
    }];
    */
#warning --------获取方式------------------获取当前用户的所有运动记录--------------------
    /*
    AVUser *currentUser = [AVUser currentUser];//获取当前用户
    
    //创建查询 设置查询条件
    AVQuery *query = [AVQuery queryWithClassName:@"Exercise"];//查询Exercise表
    [query whereKey:@"exercise_user" equalTo:currentUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        //NSArray *objects存储的所有的查找出的运动记录 每个元素为一条记录
        
        for (AVObject *exercise in objects) {
            //取出数据
            NSString *start_time = [exercise objectForKey:@"start_time"];
            NSString *all_time = [exercise objectForKey:@"all_time"];
            NSString *exercise_time = [exercise objectForKey:@"exercise_time"];
            NSString *most_speed = [exercise objectForKey:@"most_speed"];
            NSString *exercise_type = [exercise objectForKey:@"exercise_type"];
            NSString *all_length = [exercise objectForKey:@"all_length"];
            
            AVFile *pointFile = [exercise objectForKey:@"all_point"];
            NSData *allPoint = [pointFile getData];
            
        }
        
        
    }];
    */
    
#warning --------团队活动储存方式--------------------------------------
    /*
    //获取当前用户
    AVUser *currentUser = [AVUser currentUser];
    //创建一条团队活动
    AVObject *activity = [AVObject objectWithClassName:@"Activity"];//团队活动在Activity表中
    [activity setObject:currentUser forKey:@"activity_user"];//团队活动发起人 (当前用户)
    
    [activity setObject:@"集合地" forKey:@"collection_place"];//集合地点
    [activity setObject:@"路程" forKey:@"length"];//路程
    [activity setObject:@"难度等级" forKey:@"difficult_class"];//难度等级
    [activity setObject:@"开始时间" forKey:@"start_time"];//开始时间
    [activity setObject:@"结束时间" forKey:@"end_time"];//结束时间
    [activity setObject:@"费用" forKey:@"cost"];//费用
    [activity setObject:@"总人数" forKey:@"people_count"];//总人数
    [activity setObject:@"当前参与人数" forKey:@"current_people"];//当前人数
    [activity saveEventually:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //储存成功执行
            
        }
    }];
     */
    /*
#warning --------团队活动加入方式--------------------------------------
    //获取当前用户 即为将要加入的用户
    AVUser *currentUser = [AVUser currentUser];
    //获取要加入的团队活动
    AVQuery *query = [AVQuery queryWithClassName:@"Activity"];
    
    
    
   */
    
}





@end