//
//  GetDataTools.m
//  时时天气1
//
//  Created by zhouyong on 16/1/4.
//  Copyright © 2016年 zy. All rights reserved.
//

#import "GetDataTools.h"

@implementation GetDataTools

//http://weather.51wnl.com/weatherinfo/GetMoreWeather?cityCode=  &weatherType=

//创建data单例
+(instancetype)shareGetData{
    
    static GetDataTools *gd = nil;
    if (gd == nil) {
        static dispatch_once_t token;
        dispatch_once(&token, ^{
            gd = [[GetDataTools alloc]init];
        });
    }
    return gd;
}


-(void)getDataWithCityID:(NSString *)cityID andZero:(PassValue)passValue{

    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://weather.51wnl.com/weatherinfo/GetMoreWeather?cityCode=%@&weatherType=0",cityID]];
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionTask * dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        NSMutableDictionary * otherDic = [NSMutableDictionary dictionary];
        otherDic = dic[@"weatherinfo"];
        passValue(otherDic);
    }];
    [dataTask resume];
}

-(void)getDataWithCityID:(NSString *)cityID andOne:(PassValue)passValue{

    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://weather.51wnl.com/weatherinfo/GetMoreWeather?cityCode=%@&weatherType=1",cityID]];
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionTask * dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
        NSMutableDictionary * weatherDic = [NSMutableDictionary dictionary];
        weatherDic = dic[@"weatherinfo"];
        passValue(weatherDic);
    }];
    [dataTask resume];
}


















@end
