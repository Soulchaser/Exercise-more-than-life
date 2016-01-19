//
//  PointWithDistanceAnn.h
//  teamWork
//
//  Created by hanxiaolong on 16/1/19.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface PointWithDistanceAnn : MAPointAnnotation<MAAnnotation>
@property(assign,nonatomic)CGFloat pointDistance;
@property(strong,nonatomic)NSString *distanceStr;
@end
