//
//  QFRootTableViewCell.m
//  QFCommentListDemo
//
//  Created by Mr.Yao on 15/12/16.
//  Copyright © 2015年 Mr.Yao. All rights reserved.
//

#import "QFRootTableViewCell.h"
@interface QFRootTableViewCell ()
@property(strong,nonatomic)NSString *shareTime;//根据分享时间在数据表中查找分享记录
@end
@implementation QFRootTableViewCell

- (void)awakeFromNib {
    //背景图
    UIImage *image = [UIImage imageNamed:@"commentBackground.png"];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)];
    self.backgroundImageView.image = image;

}
//创建视图
-(void)createCellViews:(YYUserShare *)item{
    //判断该cell分享者是否已经被当前用户关注
    AVQuery *query = [AVQuery queryWithClassName:@"Follow"];
    [query whereKey:@"from" equalTo:[AVUser currentUser]];
    [query includeKey:@"to"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (AVObject *to in objects) {
            AVUser *toUser = [to  objectForKey:@"to"];
            if ([toUser isEqual:[AVUser currentUser]]) {
                self.attentionButton.userInteractionEnabled = NO;
                [self.attentionButton setTitle:@"已关注" forState:UIControlStateNormal];
                break;
            }
        }
    }];
    self.userImageView.image = item.avatar;//头像
    self.nameLabel.text = item.nickname;//昵称
    self.shareTime = item.shareTime;//根据分享时间在数据表中查找分享记录
    self.shareTimeLabel.text = [NSString stringWithFormat:@"%@",item.shareTime];//日期
    
    
    
    self.commentLabel.text = item.share_txt;//txt
    //取出分享图片的文件数组,改成data数组
    NSMutableArray *dataArray = [NSMutableArray array];
    for (AVFile *pictureFile in item.share_picture) {
        if (pictureFile == nil) {
            continue;
        }
        NSData *pictureData = [pictureFile getData];
        [dataArray addObject:pictureData];
    }
    [self createShareDetailPicture:dataArray];
}

- (void)createShareDetailPicture:(NSArray *)picture{
    //移除前一个cell图片视图
    for (UIView *v in self.commentListView.subviews){
        [v removeFromSuperview];
    }
    //有图片,展示backgroundImageView.
    //分享中包含的图片均贴在backgroundImageView上
    if (picture.count) {
        self.backgroundImageView.hidden = NO;
    }else{
        self.backgroundImageView.hidden = YES;
    }
    //根据图片个数设置图片视图个数
    if (picture.count) {
        UIView *previousItemView = nil;
        UIView *lastItemView = nil;
        for (NSData *data in picture) {
            //设置图片展示Size
            UIImageView *sharePicture_one = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.commentListView.frame), 80)];
            sharePicture_one.image = [UIImage imageWithData:data];
            sharePicture_one.translatesAutoresizingMaskIntoConstraints = NO;
            
            [self.commentListView addSubview:sharePicture_one];
            [self.commentListView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[sharePicture_one]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(sharePicture_one)]];
            
            if (previousItemView){
                [self.commentListView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[previousItemView]-[sharePicture_one]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(previousItemView,sharePicture_one)]];
            }else{
                [self.commentListView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[sharePicture_one]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(sharePicture_one)]];
            }
            previousItemView = sharePicture_one;
            lastItemView = sharePicture_one;
        }
        
        if (lastItemView){
            [self.commentListView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lastItemView]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lastItemView)]];
        }
        
    }
    [self.commentListView updateConstraintsIfNeeded];
    [self.commentListView layoutIfNeeded];

}
//添加关注
- (IBAction)attendButtonAction:(id)sender {
    AVQuery *query = [AVQuery queryWithClassName:@"Share"];
    [query includeKey:@"shareuser"];
    [query whereKey:@"sharetime" equalTo:self.shareTime];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects) {
            for (AVObject *share in objects) {
                AVUser *otherUser = [share objectForKey:@"shareuser"];
                AVObject *follow = [AVObject objectWithClassName:@"Follow"];
                [follow setObject:[AVUser currentUser] forKey:@"from"];//主动者
                [follow setObject:otherUser forKey:@"to"];//被关注者
                //对于关注事件本身 添加一些属性
                [follow setObject:[NSDate date] forKey:@"date"];//关注时间
                [follow saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        //关注成功
                        self.attentionButton.userInteractionEnabled = NO;
                        [self.attentionButton setTitle:@"已关注" forState:UIControlStateNormal];
                    }
                }];
            }
        }
        
    }];
    
}

/*
 
 //使用关联表添加用户之间的互相关系(关注from和被关注to)
 //关注用户名为18701032556的用户
 //查找用户是否存在
 AVQuery *queryUser = [AVQuery queryWithClassName:@"_User"];
 [queryUser whereKey:@"username" equalTo:@"18701032556"];
 [queryUser findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
 //用户存在添加关注
 if (objects) {
 AVUser *otherUser = objects[0];
 AVObject *follow = [AVObject objectWithClassName:@"Follow"];
 [follow setObject:[AVUser currentUser] forKey:@"from"];//主动者
 [follow setObject:otherUser forKey:@"to"];//被关注者
 //对于关注事件本身 添加一些属性
 [follow setObject:[NSDate date] forKey:@"date"];//关注时间
 [follow saveInBackground];
 }else {
 //用户不存在
 }
 }];*/


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

