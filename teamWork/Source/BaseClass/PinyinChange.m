//
//  PinyinChange.m
//  teamWork
//
//  Created by hanxiaolong on 16/1/27.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "PinyinChange.h"

@implementation PinyinChange
//汉字转拼音
-(NSString *)ChineseChangeToSpelling:(NSString *)chinese
{
   // NSString *hanziText = obj;
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:chinese];
    NSMutableString *finalStr = [[NSMutableString alloc]initWithCapacity:1];
    // DLog(@"%lu",(unsigned long)str.length);
    //之所以一个字一个字的转化，是为了去除集体转换是每个字之间的空格
    for (int i = 0; i<str.length; i++)
    {
        NSRange range = {i,1};
        NSString *subStr = (NSMutableString *)[str substringWithRange:range];
        //必须用可变string来进行转换
        NSMutableString *subMuStr = [NSMutableString stringWithString:subStr];
        //先转换为带声调的拼音
        CFStringTransform((CFMutableStringRef)subMuStr,NULL, kCFStringTransformMandarinLatin,NO);
        //再转换为不带声调的拼音
        CFStringTransform((CFMutableStringRef)subMuStr,NULL, kCFStringTransformStripDiacritics,NO);
        [finalStr appendString:subMuStr];
        
    }
    return finalStr;
}



@end
