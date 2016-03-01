//
//  WeatherCollectionViewCell.m
//  teamWork
//
//  Created by lanou3g on 16/1/25.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "WeatherCollectionViewCell.h"

@implementation WeatherCollectionViewCell

- (void)awakeFromNib {
    self.backView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImge"]];
    self.backView2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImge"]];
}


@end
