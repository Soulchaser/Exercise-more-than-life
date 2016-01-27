//
//  DetailModel.m
//  测试
//
//  Created by lanou3g on 16/1/16.
//  Copyright © 2016年 袁东东. All rights reserved.
//

#import "DetailModel.h"

@implementation DetailModel

-(NSString *)Description
{
    return [NSString stringWithFormat:@"%@,%@",_title,_ID];;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _ID = value;
    }
    if ([key isEqualToString:@"description"]) {
        _Description = value;
    }
    
//    NSLog(@"不能识别的键值--%@",key);
    
}



@end
