//
//  XLCodeDataTools.m
//  teamWork
//
//  Created by hanxiaolong on 16/1/29.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "XLCodeDataTools.h"

@implementation XLCodeDataTools


+(instancetype)shareXLCoreDataTools
{
    static XLCodeDataTools *xl = nil;
    if (xl == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            xl = [[XLCodeDataTools alloc]init];
        });
    }
    return xl;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //配置协调器，他链接三部分
        //协调器->数据模型
        //协调器->数据库
        //协调器->上下文
        
        //协调器->模型
        //创建模型，从主Bundel中获得
        NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
        //创建协调器，并且链接model
        NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
        
        //协调器->上下文
        //创建上下文
        self.context = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
        //上下文指向协调器
        self.context.persistentStoreCoordinator = persistentStoreCoordinator;
        
        //协调器->数据库
        NSString *DocumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
        
        NSString *dataBasePath = [DocumentPath stringByAppendingPathComponent:@"XLCoreData.sqlite"];
        NSLog(@"%@",dataBasePath);
        
        
        [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:dataBasePath] options:nil error:nil];
    }
    return self;
}

@end
