//
//  CreatActivityViewController_1.m
//  teamWork
//
//  Created by lanou3g on 16/2/25.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "CreatActivityViewController_1.h"

@interface CreatActivityViewController_1 () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *textfieldTitle;//活动标题

@property (weak, nonatomic) IBOutlet UITextView *textfieldDescription;//活动描述

@property (weak, nonatomic) IBOutlet UITextField *textfieldAddress;//集合地点

@property (weak, nonatomic) IBOutlet UITextField *textfieldDistance;//距离

@property (weak, nonatomic) IBOutlet UITextField *TextFieldStartTime;//开始时间

@property (weak, nonatomic) IBOutlet UITextField *TextFieldEndTime;//结束时间

@property (weak, nonatomic) IBOutlet UITextField *textfieldPeopleCount;//人数

@property (weak, nonatomic) IBOutlet UITextField *textfieldPhone;//手机号

@property (weak, nonatomic) IBOutlet UIButton *buttonPic1;//接收第一张图片的button

@property (weak, nonatomic) IBOutlet UIButton *buttonPic2;//接收第二张图片的button

@property (weak, nonatomic) IBOutlet UIButton *buttonPic3;//接收第三张图片的button

@property(strong,nonatomic) UIDatePicker * datePicker;

@property(strong,nonatomic) UITextField * currentDateTextField;//当前的textfield

@property(assign,nonatomic) NSInteger z_count;//用于标记三个接收图片的属性

//相机或者相册的资源类型
@property(strong,nonatomic)AvatarsourceType *sourceType;

@end

@implementation CreatActivityViewController_1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
#pragma mark -----------设置代理对象
    self.TextFieldStartTime.delegate = self;
    self.TextFieldEndTime.delegate = self;
    
    UIDatePicker * datePicker = [[UIDatePicker alloc] init];
    //    self.datePicker.datePickerMode = UIDatePickerModeDate;
    
    //设置显示格式
    //默认根据手机本地设置显示为中文还是其他语言
    NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CH"];//设置为中文显示
    self.datePicker.locale = locale;
    //当前时间创建NSDate
    NSDate * locaDate = [NSDate date];
    //在当前时间加上的时间,格里高利历
    NSCalendar * gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents * offsetComponents = [[NSDateComponents alloc] init];
    //设置时间
    [offsetComponents setYear:0];
    [offsetComponents setMonth:0];
    [offsetComponents setDay:5];
    [offsetComponents setHour:20];
    [offsetComponents setMinute:0];
    [offsetComponents setSecond:0];
    
    //设置最大值
    NSDate * maxDate = [gregorian dateByAddingComponents:offsetComponents toDate:locaDate options:0];
    //设置属性
    datePicker.minimumDate = locaDate;
    datePicker.maximumDate = maxDate;
    
    [datePicker addTarget:self action:@selector(aaa:) forControlEvents:UIControlEventValueChanged];
    self.TextFieldStartTime.inputView = datePicker;
    self.TextFieldEndTime.inputView = datePicker;
    // Do any additional setup after loading the view from its nib.
    
    
}

-(void)makeData
{
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
    //压缩图片大小
    NSData * data = UIImageJPEGRepresentation(image, 0.00001);
    //替换头像
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (self.z_count) {
            case 1:
                [self.buttonPic1 setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
                break;
                
            case 2:
                [self.buttonPic2 setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
                break;
                
            default:
                [self.buttonPic3 setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
                break;
        }
    });
}

#pragma mark -------------获取到用户选择上传的图片

- (IBAction)buttonPic1Setting:(id)sender {
    
    self.z_count = 1;
    
    [self makeData];
    
}

- (IBAction)buttonPic2Setting:(id)sender {
    
    self.z_count = 2;
    
    [self makeData];
    
}

- (IBAction)buttonPic3Setting:(id)sender {
    
    self.z_count = 3;
    
    [self makeData];
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.TextFieldStartTime ||
        textField == self.TextFieldEndTime)
    {
        self.currentDateTextField = textField;
    }
}

-(void)aaa:(UIDatePicker *)sender
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy年MM月dd日 HH:mm"];
    self.currentDateTextField.text = [formatter stringFromDate:sender.date];
    NSLog(@"%@",self.currentDateTextField.text);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
