//
//  UserInfoViewController.m
//  teamWork
//
//  Created by lanou3g on 16/1/22.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "UserInfoViewController.h"

@interface UserInfoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
//头像
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property(strong,nonatomic)NSData *avatarData;
@property(strong,nonatomic)AvatarsourceType *sourceType;

//昵称
@property (weak, nonatomic) IBOutlet UITextField *nickname;
//性别
@property (weak, nonatomic) IBOutlet UIButton *gender_Boy;//性别男
@property (weak, nonatomic) IBOutlet UIButton *gender_Girl;//性别女
@property(strong,nonatomic)NSString *gender;
//年龄
@property (weak, nonatomic) IBOutlet UITextField *age;

//个性签名
@property (weak, nonatomic) IBOutlet UITextView *signature;
//邮箱
@property (weak, nonatomic) IBOutlet UITextField *email;
//地址
@property (weak, nonatomic) IBOutlet UITextField *address;

@property (weak, nonatomic) IBOutlet UIView *avatarBGView;

@end

@implementation UserInfoViewController
+(instancetype)shareUserInfoViewController{
    static UserInfoViewController *handler = nil;
    if (handler == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            handler = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];
        });
    }
    return handler;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
//返回
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//保存用户设置
- (IBAction)saveAction:(id)sender {
    
    AVUser *currentUser = [AVUser currentUser];
    [currentUser setObject:self.nickname.text forKey:@"nickname"];
    [currentUser setObject:self.gender forKey:@"gender"];
    [currentUser setObject:self.age.text forKey:@"age"];
    [currentUser setObject:self.signature.text forKey:@"signature"];
    currentUser.email = self.email.text;
    [currentUser setObject:self.address.text forKey:@"address"];
    //头像
    if (self.avatarData) {
        //删除原头像
        AVFile *oldAvatar = [currentUser objectForKey:@"avatar"];
        [oldAvatar deleteInBackground];
        //添加新头像
        AVFile *avatarFile = [AVFile fileWithName:@"avatar.png"data:self.avatarData];
        [currentUser setObject:avatarFile forKey:@"avatar"];
    }
    [currentUser saveEventually:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
           [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }];
}
//设置头像
- (void)headerImageAction{
    self.sourceType = [[AvatarsourceType alloc]init];
    self.sourceType.view.frame = self.view.frame;
    [self.view addSubview:self.sourceType.view];
    [self.sourceType.cameraButton addTarget:self action:@selector(pickImageFromCamera) forControlEvents:UIControlEventTouchUpInside];
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
        picker.editing = YES;
        //打开相册选择图片
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //模态选择图片
        [self presentViewController:picker animated:YES completion:nil];
        [self.sourceType.view removeFromSuperview];
    }
}
//选取完成是触发的方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //返回
    [picker dismissViewControllerAnimated:YES completion:nil];
    //此处info有六个类型
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    //压缩图片尺寸
    CGSize imageSize = CGSizeMake(100, 100);
    UIGraphicsBeginImageContext(imageSize);
    [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //获取图片路径
    self.avatarData = UIImagePNGRepresentation(image);
    //压缩图片大小
    self.avatarData = UIImageJPEGRepresentation(image, 0.00001);
    //替换头像
    dispatch_async(dispatch_get_main_queue(), ^{
        self.headerImage.image = [UIImage imageWithData:self.avatarData];
    });
}

//性别设置为男
- (IBAction)genderBoyAction:(id)sender {
    [self.gender_Boy setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.gender_Girl setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.gender = @"男";
}
//性别设置为女
- (IBAction)genderGirlAction:(id)sender {
    [self.gender_Girl setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.gender_Boy setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.gender = @"女";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.avatarBGView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg2"]];
    //头像切圆
    self.headerImage.layer.cornerRadius = self.headerImage.frame.size.width/3;
    self.headerImage.layer.masksToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerImageAction)];
    [self.headerImage addGestureRecognizer:tap];
    self.headerImage.userInteractionEnabled = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    AVUser *currentUser = [AVUser currentUser];
    self.nickname.text = [currentUser objectForKey:@"nickname"];
    self.age.text = [currentUser objectForKey:@"age"];
    self.signature.text = [currentUser objectForKey:@"signature"];
    self.email.text = currentUser.email;
    self.address.text = [currentUser objectForKey:@"address"];
    self.gender = [currentUser objectForKey:@"gender"];
    if ([self.gender isEqualToString:@"男"]) {
        [self.gender_Boy setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.gender_Girl setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }else {
        [self.gender_Boy setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.gender_Girl setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    //头像
    AVFile *avatarFile = [currentUser objectForKey:@"avatar"];
    NSData *avatarData = [avatarFile getData];
    self.headerImage.image = [UIImage imageWithData:avatarData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//键盘回收
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
