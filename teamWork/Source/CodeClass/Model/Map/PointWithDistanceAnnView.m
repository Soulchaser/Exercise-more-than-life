//
//  PointWithDistanceAnnView.m
//  teamWork
//
//  Created by hanxiaolong on 16/1/19.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "PointWithDistanceAnnView.h"


@interface PointWithDistanceAnnView ()

@property(nonatomic, strong, readwrite)DistanceCalloutView *calloutView;

@end

@implementation PointWithDistanceAnnView
//气泡大小
#define kCalloutWidth       40.0
#define kCalloutHeight      15.0
//DistanceStr的set方法，用来保证一旦气泡显示的文字一被赋值就将气泡显示出来
-(void)setDistanceStr:(NSString *)distanceStr
{
    if (self.calloutView == nil)
    {
        self.calloutView = [[DistanceCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
        self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,-CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
    }
    
    self.calloutView.title = distanceStr;
    //添加气泡
    [self addSubview:self.calloutView];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    /*
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.calloutView == nil)
        {
            self.calloutView = [[DistanceCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,-CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
        }
        
        self.calloutView.title = self.distanceStr;
        
        
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
     */
    return;
}


@end
