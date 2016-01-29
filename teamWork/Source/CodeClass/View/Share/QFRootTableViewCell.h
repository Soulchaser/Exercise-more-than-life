//
//  QFRootTableViewCell.h
//  QFCommentListDemo
//
//  Created by Mr.Yao on 15/12/16.
//  Copyright © 2015年 Mr.Yao. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kQFRootTableViewCellIdentifier = @"QFRootTableViewCell";

@interface QFRootTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//昵称
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;//头像
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;//关注
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;//文本内容
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;//图片
@property (weak, nonatomic) IBOutlet UIView *commentListView;//图片分享列表
@property (weak, nonatomic) IBOutlet UILabel *shareTimeLabel;//分享时间

- (void)createCellViews:(YYUserShare *)item;

@end
