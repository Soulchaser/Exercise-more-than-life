//
//  GetDataTools.h
//  时时天气1
//
//  Created by zhouyong on 16/1/4.
//  Copyright © 2016年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>
//1.定义一个block类型
typedef void(^PassValue)(NSMutableDictionary * dict);

@interface GetDataTools : NSObject

//block天生在栈区,用copy拷贝到堆区才能持久
@property(nonatomic,copy)PassValue PassValue;

-(void)getDataWithCityID:(NSString *)cityID andZero:(PassValue)passValue;

-(void)getDataWithCityID:(NSString *)cityID andOne:(PassValue)passValue;
+(instancetype)shareGetData;
@end
