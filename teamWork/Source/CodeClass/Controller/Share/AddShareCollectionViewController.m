//
//  AddShareCollectionViewController.m
//  teamWork
//
//  Created by lanou3g on 16/1/27.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "AddShareCollectionViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface AddShareCollectionViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate>
@property(strong,nonatomic)NSMutableArray *imageArray;//图片数据 image类型->用于实时显示
@property(strong,nonatomic)NSMutableArray *dataArray;//图片数据 data类型->用于网络存储 比imageArray少一个iconfont-tianjia.png元素
@property(strong,nonatomic)AvatarsourceType *sourceType;//图片获取
@property(strong,nonatomic)UITextView *shareContent_txt;
@property(strong,nonatomic)UIButton *rightButton;
@property(strong,nonatomic)NSTimer *remindTimer;
@property(strong,nonatomic)UILabel *remindLabel;
@end

@implementation AddShareCollectionViewController

static NSString * const reuseIdentifier = @"Cell";
static NSString * const headerReuserID = @"headerReuserID";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.shareContent_txt becomeFirstResponder];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    //发布按钮
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.frame = CGRectMake(0, 0, 40, 40);
    [self.rightButton setTitle:@"发布" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(publishAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonAction)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    self.navigationItem.title = @"分享";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    _dataArray = [[NSMutableArray alloc]initWithCapacity:1];
    _imageArray = [[NSMutableArray alloc]initWithCapacity:1];
    //_imageArray初始值
    UIImage *picture_one = [UIImage imageNamed:@"iconfont-tianjia"];
    [_imageArray addObject:picture_one];
    
    //注册cell
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    //注册增补视图
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReuserID];
    
    //设置文本输入框
    self.shareContent_txt = [[UITextView alloc]initWithFrame:CGRectMake(20, 0, kScreenWidth-40, kScreenHeight/2)];
    self.shareContent_txt.backgroundColor = [UIColor whiteColor];
    self.shareContent_txt.delegate = self;
    self.shareContent_txt.keyboardType = UIKeyboardTypeDefault;
    self.shareContent_txt.returnKeyType = UIReturnKeyDone;
    self.shareContent_txt.text = @"说点啥吧";
    self.shareContent_txt.font = [UIFont systemFontOfSize:17];
    self.shareContent_txt.textColor = [UIColor grayColor];
    self.shareContent_txt.layer.borderColor = [UIColor grayColor].CGColor;
    
    self.shareContent_txt.layer.borderWidth =0.5;
    
    self.shareContent_txt.layer.cornerRadius =5.0;
}

-(void)leftBarButtonAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)timeAction{
    
    [self.remindLabel removeFromSuperview];
}
//发布按钮点击事件
-(void)publishAction{
    
    [self.shareContent_txt resignFirstResponder];
    
    //如果发布字数小于5 发布失败
    if (self.shareContent_txt.text.length < 5) {
        self.remindLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.collectionView.frame.size.height-100, self.collectionView.frame.size.width/2, 20)];
        self.remindLabel.center = CGPointMake(self.collectionView.frame.size.width/2, self.collectionView.frame.size.height-100);
        self.remindLabel.text = @"字数不能少于5";
        self.remindLabel.textColor = [UIColor whiteColor];
        [self.remindLabel setTextAlignment:NSTextAlignmentCenter];
        self.remindLabel.backgroundColor = [UIColor blackColor];
        [self.view addSubview:self.remindLabel];
        //self.remindTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timeAction) userInfo:nil repeats:NO];
        //用2秒内完成animation内的操作,透明度设为0
        [UIView animateWithDuration:2 animations:^{
            self.remindLabel.alpha= 0;
        } completion:^(BOOL finished) {
            [self.remindLabel removeFromSuperview];
            self.remindLabel.alpha = 1;
        }];
        return;
    }
    //分享类
    AVObject *share = [AVObject objectWithClassName:@"Share"];
    /*
     因为要添加关注 将分享创建时的用户改为关联用户,而不是仅存储当时时间点的用户信息
    //昵称 如果用户未设置昵称 , 则昵称 == 用户名(手机号)
    if ([[currentUser objectForKey:@"nickname"] isEqualToString:@""]) {
        [share setObject:[currentUser objectForKey:@"nickname"] forKey:@"username"];
    }else{
        [share setObject:[currentUser objectForKey:@"nickname"] forKey:@"nickname"];
    }
    //性别
    [share setObject:[currentUser objectForKey:@"gender"] forKey:@"gender"];
    //头像
    [share setObject:[currentUser objectForKey:@"avatar"] forKey:@"avatar"];
     */
    [share setObject:[AVUser currentUser] forKey:@"shareuser"];
    //分享时间
    [share setObject:[NSDate date] forKey:@"sharetime"];
    //点赞数 初始为0
    [share setObject:[NSString stringWithFormat:@"0"] forKey:@"votes_count"];
    //评论数 初始为0
    [share setObject:[NSString stringWithFormat:@"0"] forKey:@"comment_count"];
    //分享内容(文本)
    [share setObject:self.shareContent_txt.text forKey:@"share_txt"];
    //如果分享内容中有图片
    NSMutableArray *imageArray = [NSMutableArray array];
    if (self.dataArray.count > 0) {
        //分享内容(图片) leancloud中AVFile存储,如果只有一个,直接将AVFile对象设置为属性即可,但如果是AVFile数组的情况下,直接存储会失败,需要先将数组当中的一个元素设置为属性,并将其他元素想保存到数据库中,然后数组存储才能实现.
        for (int i = 0; i<self.dataArray.count; i++) {
            //如果是第一个元素 在数据表中单独设置一个属性
            if (i == 0) {
                AVFile *file0 = [AVFile fileWithName:@"shareImage.png" data:_dataArray[i]];
                [share setObject:file0 forKey:@"share_first_picture"];
                [imageArray addObject:file0];
            }else{
                //其他元素保存到数据库中
                AVFile *fileX = [AVFile fileWithName:@"shareImage.png" data:_dataArray[i]];
                [fileX saveInBackground];
                [imageArray addObject:fileX];
            }
        }
    }
    [share setObject:imageArray forKey:@"share_picture"];
    
    //保存这条share
    [share saveEventually:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //保存成功
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>
//区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//cell个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imageArray.count;
}
//设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    UIImage *picture = _imageArray[indexPath.row];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:cell.contentView.frame];
    imgView.image = picture;
    [cell.contentView addSubview:imgView];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
//cell大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kScreenWidth/4,kScreenWidth/4);
}
//分区之间布局
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(20,20,0,0);
}
//增补视图----文本输入框
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReuserID forIndexPath:indexPath];
    [headView addSubview:self.shareContent_txt];
    return headView;
    
}
//cell点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.shareContent_txt resignFirstResponder];
    //最后一个image点击事件(添加)
    if (indexPath.row == _imageArray.count-1) {
        //调用添加图片方法
        [self addImageAction];
    }
}
//添加图片方法
-(void)addImageAction{
    //图片获取方式
    self.sourceType = [[AvatarsourceType alloc]init];
    self.sourceType.view.frame = self.view.frame;
    [self.collectionView addSubview:self.sourceType.view];
    //相机
    [self.sourceType.cameraButton addTarget:self action:@selector(pickImageFromCamera) forControlEvents:UIControlEventTouchUpInside];
    //相册
    [self.sourceType.albumButton addTarget:self action:@selector(pickImageFromAlbum) forControlEvents:UIControlEventTouchUpInside];
}
//相机机机机机机机机机机机机机机机选取头像
-(void)pickImageFromCamera{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //初始化
        UIImagePickerController *picker = [UIImagePickerController new];
        //设置代理
        picker.delegate = self;
        //打开相机拍摄
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        //模态选择图片
        [self presentViewController:picker animated:YES completion:nil];
        [self.sourceType.view removeFromSuperview];
    }
}
//相册册册册册册册选取头像
-(void)pickImageFromAlbum{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        //初始化
        UIImagePickerController *picker = [UIImagePickerController new];
        //设置代理
        picker.delegate = self;
        //是否可编辑
        picker.allowsEditing = YES;
        //打开相册选择图片
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //模态选择图片
        [self presentViewController:picker animated:YES completion:nil];
        [self.sourceType.view removeFromSuperview];
    }
}
//选取完成时触发的代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //返回
    [picker dismissViewControllerAnimated:YES completion:nil];
    //此处info有六个类型
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
        //压缩图片尺寸
        CGSize imageSize = CGSizeMake(100,100);
        UIGraphicsBeginImageContext(imageSize);
        [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    //压缩图片大小
    NSData *data = UIImageJPEGRepresentation(image, 1);
    
    //添加图片
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *picture_another = [UIImage imageWithData:data];
        [self.dataArray insertObject:data atIndex:0];
        [self.imageArray insertObject:picture_another atIndex:0];
        [self.collectionView reloadData];
    });
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"说点啥吧"])
    {
        textView.textColor = [UIColor blackColor];
        textView.text = @"";
    }
}


-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length < 1)
    {
        textView.text = @"说点啥吧";
        textView.textColor = [UIColor grayColor];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


@end
