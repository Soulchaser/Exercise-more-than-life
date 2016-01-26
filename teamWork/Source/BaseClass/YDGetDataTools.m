//
//  YDGetDataTools.m
//  teamWork
//
//  Created by lanou3g on 16/1/22.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "YDGetDataTools.h"

@implementation YDGetDataTools

+(instancetype)sharedGetData
{
    static YDGetDataTools * YDG = nil;
    if (YDG == nil) {
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            YDG = [[YDGetDataTools alloc] init];
        });
    }
    return YDG;
}

-(NSMutableArray *)BasicArray
{
    if (!_BasicArray) {
        _BasicArray = [NSMutableArray array];
    }
    return _BasicArray;
}

@end
