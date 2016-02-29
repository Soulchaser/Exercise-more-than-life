//
//  NSObject+AutoEncode.m
//  Runtime自动归档
//
//  Created by 李志强 on 15/2/25.
//  Copyright © 2015年 男孩无衣. All rights reserved.
//

#import "NSObject+AutoEncode.h"
#import <objc/runtime.h>

@implementation NSObject (AutoEncode)
/**
 *  归档
 *
 *  @param aCoder 归档器
 */
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    // 归档时, 需要对value根据一个key进行归档.
    // 这个过程我们主要需要两个东西:
    // 1.需要拿到这对象的所有属性的值.
    // 2.我们要为这个值找一个唯一的编码key, 这个key我们通常使用变量名.
    // 最终我们的需求转换为: 拿到这个对象的所有变量名和值.
    
    // 我们的需求是对所有的对象都进行自动归档, Person和Dog两个类的属性肯定不一样.
    // 所以我们无论是什么对象, 都需要一种通用的方法拿到其变量和值.
    
    // 这里就用到了运行时.
    
    // 用来存放有多少个属性/成员变量.
    unsigned int iVarCount = 0;
    // 首先拿到所有变量列表.
    Ivar * ivars = class_copyIvarList([self class], &iVarCount);
    
    // 对这个变量列表进行遍历
    for (int i = 0; i < iVarCount; i++) {
        // 得到一个变量名:
        NSString * varName = [NSString stringWithUTF8String:ivar_getName(ivars[i])];
        // 拿到这个变量对应的值.
        // 你都拿到变量名了, 害怕拿不到值么?
        id varValue = [self valueForKey:varName];
        
        // 归档
        [aCoder encodeObject:varValue forKey:varName];
    }
    // 释放变量列表
    free(ivars);
}
/**
 *  反归档初始化方法
 *
 *  @param aDecoder 反归档器
 *
 *  @return 返回反归档后的对象
 */
-(id)initWithCoder:(NSCoder *)aDecoder
{
    // 因为self已经是NSObject了, 所以不能再使用super了.
    if (self = [self init]) {
        // 用来存放有多少个属性/成员变量.
        unsigned int iVarCount = 0;
        // 首先拿到所有变量列表.
        Ivar * ivars = class_copyIvarList([self class], &iVarCount);
        
        // 对这个变量列表进行遍历
        for (int i = 0; i < iVarCount; i++) {
            // 得到一个变量名:
            NSString * varName = [NSString stringWithUTF8String:ivar_getName(ivars[i])];
            
            id varValue = [aDecoder decodeObjectForKey:varName];
            [self setValue:varValue forKey:varName];
        }
        // 释放变量列表
        free(ivars);
    }
    return self;
}
@end
