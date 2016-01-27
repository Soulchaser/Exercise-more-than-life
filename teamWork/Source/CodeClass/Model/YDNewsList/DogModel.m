//
//  DogModel.m
//  测试
//
//  Created by 袁东东 on 16/1/15.
//  Copyright © 2016年 袁东东. All rights reserved.
//

#import "DogModel.h"

@implementation DogModel

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@,%@",_title,_ID];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _ID = value;
    }
    if ([key isEqualToString:@"description"]) {
        _Description = value;
    }
//    NSLog(@"不能识别的key,,,,%@",key);
}

-(void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    
    if ([key isEqualToString:@"id"]) {
        
        self.ID = [NSString stringWithFormat:@"%@",value];
    }
}


@end
