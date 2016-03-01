//
//  CreatActivityViewController_1.m
//  teamWork
//
//  Created by lanou3g on 16/2/25.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "CreatActivityViewController_1.h"

@interface CreatActivityViewController_1 () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UITextViewDelegate>


@property (weak, nonatomic) IBOutlet UITextField *textfieldTitle;//活动标题

@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;//活动描述

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

@property(strong,nonatomic)NSMutableArray *dataArray;//活动图片按钮
@property(strong,nonatomic)UIButton *rightButton;//发布活动按钮
@end

#define kGap (([UIScreen mainScreen].bounds.size.height)/15)

@implementation CreatActivityViewController_1

-(NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
#pragma mark -----------设置代理对象
    self.TextFieldStartTime.delegate = self;
    self.TextFieldEndTime.delegate = self;
    self.textfieldTitle.delegate = self;
    self.textfieldAddress.delegate = self;
    //自定义键盘返回键
#pragma mark ---------------标题
    // 自定义的view-标题
    UIView *customView_title = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kGap)];
    customView_title.backgroundColor = [UIColor lightGrayColor];
    self.textfieldTitle.inputAccessoryView = customView_title;
    
    self.textfieldTitle.delegate = self;
    // 往自定义view中添加各种UI控件(以UIButton为例)
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-kGap, 0, kGap,kGap)];
    [btn setImage:[UIImage imageNamed:@"download_deepblue_64"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    [customView_title addSubview:btn];
    
#pragma mark -----------------自定义弹出键盘--描述
    
    self.textViewDescription.delegate = self;
    
#pragma mark ----------------集合地点
    // 自定义的view-
    UIView *customView_address = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kGap)];
    customView_address.backgroundColor = [UIColor lightGrayColor];
    self.textfieldAddress.inputAccessoryView = customView_address;
    
    
    // 往自定义view中添加各种UI控件(以UIButton为例)
    UIButton *btn_address = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-kGap, 0, kGap,kGap)];
    [btn_address setImage:[UIImage imageNamed:@"download_deepblue_64"] forState:UIControlStateNormal];
    [btn_address addTarget:self action:@selector(btnClicked_address) forControlEvents:UIControlEventTouchUpInside];
    [customView_address addSubview:btn_address];
#pragma mark -----------------里程
    
    // 自定义的view-
    UIView *customView_distance = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kGap)];
    customView_distance.backgroundColor = [UIColor lightGrayColor];
    self.textfieldDistance.inputAccessoryView = customView_distance;
    
    
    // 往自定义view中添加各种UI控件(以UIButton为例)
    UIButton *btn_distance = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-kGap, 0, kGap,kGap)];
    [btn_distance setImage:[UIImage imageNamed:@"download_deepblue_64"] forState:UIControlStateNormal];
    [btn_distance addTarget:self action:@selector(btnClicked_distance) forControlEvents:UIControlEventTouchUpInside];
    [customView_distance addSubview:btn_distance];
    
#pragma mark ---------------开始时间
    // 自定义的view-
    UIView *customView_startTime = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kGap)];
    customView_startTime.backgroundColor = [UIColor lightGrayColor];
    self.TextFieldStartTime.inputAccessoryView = customView_startTime;
    
    
    // 往自定义view中添加各种UI控件(以UIButton为例)
    UIButton *btn_starTime = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-kGap, 0, kGap,kGap)];
    [btn_starTime setImage:[UIImage imageNamed:@"download_deepblue_64"] forState:UIControlStateNormal];
    [btn_starTime addTarget:self action:@selector(btnClicked_startTime) forControlEvents:UIControlEventTouchUpInside];
    [customView_startTime addSubview:btn_starTime];
#pragma mark ---------------结束时间
    // 自定义的view-
    UIView *customView_endTime = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kGap)];
    customView_endTime.backgroundColor = [UIColor lightGrayColor];
    self.TextFieldEndTime.inputAccessoryView = customView_endTime;
    
    
    // 往自定义view中添加各种UI控件(以UIButton为例)
    UIButton *btn_endTime = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-kGap, 0, kGap,kGap)];
    [btn_endTime setImage:[UIImage imageNamed:@"download_deepblue_64"] forState:UIControlStateNormal];
    [btn_endTime addTarget:self action:@selector(btnClicked_endTime) forControlEvents:UIControlEventTouchUpInside];
    [customView_endTime addSubview:btn_endTime];
#pragma mark ----------------活动人数
    // 自定义的view-
    UIView *customView_people = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kGap)];
    customView_people.backgroundColor = [UIColor lightGrayColor];
    self.textfieldPeopleCount.inputAccessoryView = customView_people;
    
    
    // 往自定义view中添加各种UI控件(以UIButton为例)
    UIButton *btn_people = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-kGap, 0, kGap,kGap)];
    [btn_people setImage:[UIImage imageNamed:@"download_deepblue_64"] forState:UIControlStateNormal];
    [btn_people addTarget:self action:@selector(btnClicked_people) forControlEvents:UIControlEventTouchUpInside];
    [customView_people addSubview:btn_people];
#pragma mark------------------手机号
    // 自定义的view-
    UIView *customView_phone = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kGap)];
    customView_phone.backgroundColor = [UIColor lightGrayColor];
    self.textfieldPhone.inputAccessoryView = customView_phone;
    
    
    // 往自定义view中添加各种UI控件(以UIButton为例)
    UIButton *btn_phone = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-kGap, 0, kGap,kGap)];
    [btn_phone setImage:[UIImage imageNamed:@"download_deepblue_64"] forState:UIControlStateNormal];
    [btn_phone addTarget:self action:@selector(btnClicked_phone) forControlEvents:UIControlEventTouchUpInside];
    [customView_phone addSubview:btn_phone];
    
    
    
    UIDatePicker * datePicker = [[UIDatePicker alloc] init];
    //    self.datePicker.datePickerMode = UIDatePickerModeDate;
    
    //设置显示格式
    //默认根据手机本地设置显示为中文还是其他语言
    NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CH"];//设置为中文显示
    self.datePicker.locale = locale;
    //当前时间创建NSDate
    NSDate * locaDate = [NSDate date];
    //在当前时间加上的时间,格里高利历
    NSCalendar * gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
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
    //发布按钮
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.frame = CGRectMake(0, 0, 40, 40);
    [self.rightButton setTitle:@"发起" forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(publishAction) forControlEvents:
     UIControlEventTouchUpInside];
    
    self.navigationItem.title = @"活动";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
}

//
-(void)btnClicked
{
    [self.textfieldTitle resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.textfieldTitle)
    {
        [self.textfieldTitle resignFirstResponder];
    }
    else if (textField == self.textfieldAddress)
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([@"\n" isEqualToString:text])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

//-(void)btnClicked_description
//{
//     [ resignFirstResponder];
//}
-(void)btnClicked_address
{
     [self.textfieldAddress resignFirstResponder];
}

-(void)btnClicked_distance
{
     [self.textfieldDistance resignFirstResponder];
}
-(void)btnClicked_startTime
{
     [self.TextFieldStartTime resignFirstResponder];
}
-(void)btnClicked_endTime
{
     [self.TextFieldEndTime resignFirstResponder];
}
-(void)btnClicked_people
{
     [self.textfieldPeopleCount resignFirstResponder];
}
-(void)btnClicked_phone
{
     [self.textfieldPhone resignFirstResponder];
}
//发布按钮点击事件
-(void)publishAction{
    
    //发布前的判断
    //不能为空
    if ([self.textfieldTitle.text isEqualToString:@""]) {
        
    }
    
    
    //活动类
    AVObject *activity = [AVObject objectWithClassName:@"Activity"];
    [activity setObject:self.textfieldTitle.text forKey:@"title"];//标题
    [activity setObject:self.textViewDescription.text forKey:@"description"];//描述
    [activity setObject:self.textfieldAddress.text forKey:@"address"];//集合地点
    [activity setObject:self.textfieldDistance.text forKey:@"distance"];//路程
    [activity setObject:self.TextFieldStartTime.text forKey:@"start_time"];//开始时间
    [activity setObject:self.TextFieldEndTime.text forKey:@"end_time"];//结束时间
    [activity setObject:self.textfieldPeopleCount.text forKey:@"people_count"];//人数限制
    [activity setObject:[NSNumber numberWithInt:1] forKey:@"people_current"];//当前参与人数 初始值为1
    [activity setObject:self.textfieldPhone.text forKey:@"phone"];//发起人手机号
    [activity setObject:[AVUser currentUser] forKey:@"activityuser"];//发起者
    //图片三张
    //如果活动内容中有图片
    NSMutableArray *imageArray = [NSMutableArray array];
    if (self.dataArray.count > 0) {
        //活动内容(图片) leancloud中AVFile存储,如果只有一个,直接将AVFile对象设置为属性即可,但如果是AVFile数组的情况下,直接存储会失败,需要先将数组当中的一个元素设置为属性,并将其他元素想保存到数据库中,然后数组存储才能实现.
        for (int i = 0; i<self.dataArray.count; i++) {
            //如果是第一个元素 在数据表中单独设置一个属性
            if (i == 0) {
                AVFile *file0 = [AVFile fileWithName:@"activityImage.png" data:_dataArray[i]];
                [activity setObject:file0 forKey:@"activity_first_picture"];
                [imageArray addObject:file0];
            }else{
                //其他元素保存到数据库中
                AVFile *fileX = [AVFile fileWithName:@"activityImage.png" data:_dataArray[i]];
                [fileX saveInBackground];
                [imageArray addObject:fileX];
            }
        }
    }
    [activity setObject:imageArray forKey:@"activity_picture"];
    
    //保存这条activity
    [activity saveEventually:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //在Join中加入一条记录 确定当前用户加入了该活动
            AVObject *join = [AVObject objectWithClassName:@"Join"];
            [join setObject:[AVUser currentUser] forKey:@"joinuser"];//加入者
            [join setObject:activity forKey:@"activity"];
            [join saveInBackground];
            //保存成功
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

//调用系统工具选择图片
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
    CGSize imageSize = CGSizeMake(200, 200);
    UIGraphicsBeginImageContext(imageSize);
    [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //压缩图片大小
    NSData * data = UIImageJPEGRepresentation(image, 1);
    [self.dataArray insertObject:data atIndex:0];
    //替换头像
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *picture = [UIImage imageWithData:data];
        switch (self.z_count) {
            case 1:
                [self.buttonPic1 setImage:picture forState:UIControlStateNormal];
                break;
                
            case 2:
                [self.buttonPic2 setImage:picture forState:UIControlStateNormal];
                break;
                
            default:
                [self.buttonPic3 setImage:picture forState:UIControlStateNormal];
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
