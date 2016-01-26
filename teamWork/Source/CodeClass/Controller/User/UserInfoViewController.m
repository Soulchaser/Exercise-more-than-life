//
//  UserInfoViewController.m
//  teamWork
//
//  Created by lanou3g on 16/1/22.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "UserInfoViewController.h"
#import "AvatarsourceType.h"

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
@property (weak, nonatomic) IBOutlet UIButton *age;
@property(strong,nonatomic)NSString *year;
//个性签名
@property (weak, nonatomic) IBOutlet UITextView *signature;
//邮箱
@property (weak, nonatomic) IBOutlet UITextField *email;
//地址
@property (weak, nonatomic) IBOutlet UITextField *address;


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
//保存
- (IBAction)saveAction:(id)sender {
    AVUser *currentUser = [AVUser currentUser];
    [currentUser setObject:self.nickname.text forKey:@"nickname"];
    [currentUser setObject:self.gender forKey:@"gender"];
    [currentUser setObject:self.year forKey:@"age"];
    [currentUser setObject:self.signature.text forKey:@"signature"];
    currentUser.email = self.email.text;
    [currentUser setObject:self.address.text forKey:@"address"];
    //头像
    AVFile *avatarFile = [AVFile fileWithData:self.avatarData];
    [currentUser setObject:avatarFile forKey:@"avatar"];
    [currentUser saveEventually:^(BOOL succeeded, NSError *error) {
        NSLog(@"设置成功");
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}
//头像
- (void)headerImageAction{
    self.sourceType = [[AvatarsourceType alloc]init];
    [self addChildViewController:self.sourceType];
    [self.view addSubview:self.sourceType.view];
    [self.sourceType.cameraButton addTarget:self action:@selector(pickImageFromCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.sourceType.albumButton addTarget:self action:@selector(pickImageFromAlbum) forControlEvents:UIControlEventTouchUpInside];
}
//相机选取头像
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
        [self.sourceType removeFromParentViewController];
        [self.sourceType.view removeFromSuperview];
    }
}
//相册选取头像
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
        [self.sourceType removeFromParentViewController];
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

    
    //获取图片路径
    self.headerImage.image = image;
    self.avatarData = UIImagePNGRepresentation(image);
    
    
    
}
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize{
    
    return image;
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
//年龄设置
- (IBAction)ageAction:(id)sender {
    NSLog(@"没有方法");
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //头像切圆
    self.headerImage.layer.cornerRadius = self.headerImage.frame.size.height/2;
    self.headerImage.layer.masksToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerImageAction)];
    [self.headerImage addGestureRecognizer:tap];
    self.headerImage.userInteractionEnabled = YES;
    

}
-(void)viewWillAppear:(BOOL)animated{
    AVUser *currentUser = [AVUser currentUser];
    self.nickname.text = [currentUser objectForKey:@"nickname"];
    self.signature.text = [currentUser objectForKey:@"signature"];
    self.email.text = currentUser.email;
    self.address.text = [currentUser objectForKey:@"address"];
    self.gender = [currentUser objectForKey:@"gender"];
    if ([self.gender isEqualToString:@"男"]) {
        [self.gender_Boy setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.gender_Girl setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }else {
        [self.gender_Boy setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.gender_Girl setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
