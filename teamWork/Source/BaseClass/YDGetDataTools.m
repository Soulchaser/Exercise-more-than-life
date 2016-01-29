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

-(NSMutableArray *)TempArray
{
    if (!_TempArray) {
        _TempArray = [NSMutableArray array];
    }
    return _TempArray;
}

-(NSMutableArray *)AqiArray
{
    if (!_AqiArray) {
        _AqiArray = [NSMutableArray array];
    }
    return _AqiArray;
}
-(NSMutableArray *)daily_forecastArray
{
    if (!_daily_forecastArray) {
        _daily_forecastArray = [NSMutableArray array];
    }
    return _daily_forecastArray;
}



-(NSString*)weekdayStringFromDate:(NSString*)dateString {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    //NSString转NSDate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    //NSGregorianCalendar
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    //NSWeekdayCalendarUnit
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:localeDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}


@end
