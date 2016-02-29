//
//  GroupActibityCell.h
//  teamWork
//
//  Created by lanou3g on 16/2/27.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupActibityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userPicImgView;//活动图片

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//活动标题

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;//地址

@property (weak, nonatomic) IBOutlet UILabel *calendarLabel;//活动日期

@property (weak, nonatomic) IBOutlet UILabel *progressLabel;//参与进度

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;//路程

@end
