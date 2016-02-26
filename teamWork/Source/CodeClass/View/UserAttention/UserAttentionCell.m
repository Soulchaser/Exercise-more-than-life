//
//  UserAttentionCell.m
//  teamWork
//
//  Created by lanou3g on 16/2/25.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "UserAttentionCell.h"

@implementation UserAttentionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//取消关注
- (IBAction)attentionButtonAction:(id)sender {
    //获取所有当前用户已关注的对象
    AVQuery *query = [AVQuery queryWithClassName:@"Follow"];
    [query whereKey:@"from" equalTo:[AVUser currentUser]];
    [query includeKey:@"to"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            for (AVObject *follow in objects) {
                AVUser *toUser = [follow objectForKey:@"to"];
                if ([self.userName isEqualToString:toUser.username]) {
                    //删除这条关注记录 数据库
                    [follow deleteInBackground];
                    //显示给用户处理结果
                    [self.attentionButton setTitle:@"已取消" forState:UIControlStateNormal];
                    self.attentionButton.userInteractionEnabled = NO;
                }
            }
    }];
}

@end
