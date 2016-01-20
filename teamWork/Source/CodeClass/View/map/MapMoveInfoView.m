//
//  MapMoveInfoView.m
//  teamWork
//
//  Created by hanxiaolong on 16/1/19.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "MapMoveInfoView.h"

@implementation MapMoveInfoView

#define kLabelWidth self.frame.size.width/3
#define kLabelHeight self.frame.size.height/3
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self drawView];
        
    }
    return self;
}

-(void)drawView
{
    self.backgroundColor = [UIColor whiteColor];
    self.alpha = 0.8;
    self.distanceTilelLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kLabelWidth, kLabelHeight)];
    
    self.distanceTilelLabel.textAlignment = NSTextAlignmentCenter;
    self.distanceTilelLabel.text = @"总距离";
    
    self.speedTilelLabel = [[UILabel alloc]initWithFrame:CGRectMake(kLabelWidth, 0, kLabelWidth, kLabelHeight)];
    self.speedTilelLabel.textAlignment = NSTextAlignmentCenter;
    self.speedTilelLabel.text = @"当前速度";
    
    self.timeTilelLabel = [[UILabel alloc]initWithFrame:CGRectMake(kLabelWidth*2, 0, kLabelWidth, kLabelHeight)];
    self.timeTilelLabel.textAlignment = NSTextAlignmentCenter;
    self.timeTilelLabel.text = @"运动时间";
    
    
    self.distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, kLabelHeight, kLabelWidth, kLabelHeight*2)];
    self.distanceLabel.textAlignment = NSTextAlignmentCenter;
    self.distanceLabel.text = @"0.00";
    self.distanceLabel.font = [UIFont systemFontOfSize:23];
    
    self.speedLabel = [[UILabel alloc]initWithFrame:CGRectMake(kLabelWidth, kLabelHeight, kLabelWidth, kLabelHeight*2)];
    self.speedLabel.textAlignment = NSTextAlignmentCenter;
    self.speedLabel.text = @"0.0";
    self.speedLabel.font = [UIFont systemFontOfSize:23];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kLabelWidth*2, kLabelHeight, kLabelWidth, kLabelHeight*2)];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.text = @"0:00:00";
    self.timeLabel.font = [UIFont systemFontOfSize:23];
    
    [self addSubview:self.distanceLabel];
    [self addSubview:self.distanceTilelLabel];
    [self addSubview:self.speedLabel];
    [self addSubview:self.speedTilelLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.timeTilelLabel];
    
    
    
}


@end
