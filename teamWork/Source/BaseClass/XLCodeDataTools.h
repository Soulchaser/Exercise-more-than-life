//
//  XLCodeDataTools.h
//  teamWork
//
//  Created by hanxiaolong on 16/1/29.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CordDataInfo;
@interface XLCodeDataTools : NSObject
//上下文
@property(strong,nonatomic)NSManagedObjectContext *context;
//单例初始化
+(instancetype)shareXLCoreDataTools;
//添加
-(void)insertData:(CordDataInfo *)info;
//查找
-(NSArray *)getDataFromLibrary;
//根据开始时间查找某一条
-(NSArray *)getDataFromLibraryWithstartDate:(NSDate *)startDate;
//删除某一条
-(void)deleteDataFromLibraryWithstartDate:(NSDate *)startDate;
//删除全部
-(void)deleteAllDataFromLibrary;
//更新
-(void)updata:(CordDataInfo *)info;
@end
