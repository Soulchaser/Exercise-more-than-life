//
//  QFRootTableViewCell.m
//  QFCommentListDemo
//
//  Created by Mr.Yao on 15/12/16.
//  Copyright © 2015年 Mr.Yao. All rights reserved.
//

#import "QFRootTableViewCell.h"
@implementation QFRootTableViewCell

- (void)awakeFromNib {
    //背景图
    UIImage *image = [UIImage imageNamed:@"commentBackground.png"];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)];
    self.backgroundImageView.image = image;
}

-(void)createCellViews:(YYUserShare *)item{
    self.userImageView.image = item.avatar;
    self.nameLabel.text = item.nickname;
    self.commentLabel.text = item.share_txt;
    //取出分享图片的文件数组,改成data数组
    NSMutableArray *dataArray = [NSMutableArray array];
//    for (AVFile *pictureFile in item.share_picture) {
//        if (pictureFile == nil) {
//            continue;
//        }
//        NSData *pictureData = [pictureFile getData];
//        [dataArray addObject:pictureData];
//    }
    [self createShareDetailPicture:dataArray];
}

- (void)createShareDetailPicture:(NSArray *)picture{
    //移除前一个cell评论视图
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
            UIImageView *sharePicture_one = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.commentListView.frame), 20)];
            sharePicture_one.image = [UIImage imageWithData:data];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
