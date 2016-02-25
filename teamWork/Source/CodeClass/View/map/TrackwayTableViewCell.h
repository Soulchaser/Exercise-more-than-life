//
//  TrackwayTableViewCell.h
//  teamWork
//
//  Created by hanxiaolong on 16/2/24.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackwayTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *DistanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *SpeedLabel;
@end
