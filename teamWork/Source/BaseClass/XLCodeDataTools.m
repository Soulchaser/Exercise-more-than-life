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

#pragma mark -------写入--------
-(void)insertData:(CordDataInfo *)info
{
    
    Entity *ent = [NSEntityDescription insertNewObjectForEntityForName:@"Entity" inManagedObjectContext:self.context];
    
    ent.startDate = info.startDate;
    ent.movementTime = [NSNumber numberWithInteger:info.movementTime];
    ent.totleTime = [NSNumber numberWithDouble:info.totleTime];
    ent.maxSpeed = [NSNumber numberWithFloat:info.maxSpeed];
    ent.sportType = [NSNumber numberWithInteger:info.sportType];
    ent.totleDistance = [NSNumber numberWithFloat:info.totleDistance];
    ent.infoData = [NSKeyedArchiver archivedDataWithRootObject:info.infoArray];
 
    [self.context save:nil];
}

#pragma mark -------查---------
-(NSArray *)getDataFromLibrary
{
    //先填写一份查询表
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Entity"];
    
    //填写查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"1=1"];
    
    request.predicate = predicate;
    
    //排序条件
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES]];
    
    NSArray *array = [self.context executeFetchRequest:request error:nil];

//    for (Entity *dataInfo in array)
//    {
//        DLog(@"%@",dataInfo.infoData);
//    }
    
    return array;
}
//删除某一条
-(void)deleteDataFromLibraryWithstartDate:(NSDate *)startDate
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entity" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"startDate = %@", startDate];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        
    }
    
    //开始删除
    for (Entity *ent in fetchedObjects)
    {
        [self.context deleteObject:ent];
    }
    
    [self.context save:nil];
    
}
//删除全部
-(void)deleteAllDataFromLibrary
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entity" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"1=1", nil];
    [fetchRequest setPredicate:predicate];

    NSError *error = nil;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        
    }
    
    //开始删除
    for (Entity *emp in fetchedObjects)
    {
        [self.context deleteObject:emp];
    }
    
    [self.context save:nil];
}



@end
