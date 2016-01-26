//
//  SportInfoView.m
//  teamWork
//
//  Created by hanxiaolong on 16/1/25.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "SportInfoView.h"

#define kWidth self.frame.size.width
#define kHeight self.frame.size.height

@implementation SportInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawView];
    }
    return self;
}

-(void)drawView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight*0.21)];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame), kWidth, kHeight*0.07)];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"时速";
    
    self.currentSpeedLB = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label1.frame), kWidth, kHeight*0.35)];
    self.currentSpeedLB.textAlignment = NSTextAlignmentCenter;
    self.currentSpeedLB.font = [UIFont systemFontOfSize:self.currentSpeedLB.frame.size.height*3/7];
    self.currentSpeedLB.text = @"0.00";
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.currentSpeedLB.frame), kWidth, kHeight*0.07)];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"km/h";
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label2.frame)+kHeight*0.045, kWidth/3.0, kHeight*0.045)];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.text = @"里程";
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label3.frame), label3.frame.origin.y, kWidth/3.0, kHeight*0.045)];
    label4.textAlignment = NSTextAlignmentCenter;
    label4.text = @"时间";
    
    UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label4.frame), label3.frame.origin.y, kWidth/3.0, kHeight*0.045)];
    label5.textAlignment = NSTextAlignmentCenter;
    label5.text = @"均速";
    
    self.distanceLB = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label3.frame), kWidth/3, kHeight*0.12)];
    self.distanceLB.textAlignment = NSTextAlignmentCenter;
    self.distanceLB.font = [UIFont systemFontOfSize:self.distanceLB.frame.size.height/3];
    self.distanceLB.text = @"0.00";
    
    self.timeLB = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/3.0, CGRectGetMaxY(label3.frame), kWidth/3.0, kHeight*0.12)];
    self.timeLB.textAlignment = NSTextAlignmentCenter;
    self.timeLB.font = [UIFont systemFontOfSize:self.timeLB.frame.size.height/3];
    self.timeLB.text = @"0:00:00";
    
    self.averageSpeedLB = [[UILabel alloc]initWithFrame:CGRectMake(kWidth*2/3.0, CGRectGetMaxY(label3.frame), kWidth/3.0, kHeight*0.12)];
    self.averageSpeedLB.textAlignment = NSTextAlignmentCenter;
    self.averageSpeedLB.font = [UIFont systemFontOfSize:self.timeLB.frame.size.height/3];
    self.averageSpeedLB.text = @"0.00";
    
    UILabel *label6 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.averageSpeedLB.frame), kWidth/3, kHeight*0.045)];
    label6.textAlignment = NSTextAlignmentCenter;
    label6.text = @"km";
    
    UILabel *label7 = [[UILabel alloc]initWithFrame:CGRectMake(kWidth*2/3.0, label6.frame.origin.y, kWidth/3.0, kHeight*0.045)];
    label7.textAlignment = NSTextAlignmentCenter;
    label7.text = @"km/h";
    
    
    
    [self addSubview:label1];
    [self addSubview:label2];
    [self addSubview:label3];
    [self addSubview:label4];
    [self addSubview:label5];
    [self addSubview:label6];
    [self addSubview:label7];
    [self addSubview:self.currentSpeedLB];
    [self addSubview:self.distanceLB];
    [self addSubview:self.timeLB];
    [self addSubview:self.averageSpeedLB];
    
    
    
    
    
}

@end
