//
//  FindPasswordVC_Tow.m
//  teamWork
//
//  Created by lanou3g on 16/1/22.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "FindPasswordVC_Tow.h"
#import "FindPasswordVC__Three.h"
@interface FindPasswordVC_Tow ()<UITextFieldDelegate>
//提示信息
@property (weak, nonatomic) IBOutlet UILabel *showResult;
//输入验证码
@property (weak, nonatomic) IBOutlet UITextField *password;
//sendSMS
@property (weak, nonatomic) IBOutlet UIButton *sendSMS;
//验证按钮
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
//通知中心
@property(strong,nonatomic)NSNotificationCenter *observer;
@end

@implementation FindPasswordVC_Tow
-(void)setPhone:(NSString *)phone{
    _phone = phone;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.password.delegate = self;
    //初始关闭验证button的用户交互
    self.nextButton.userInteractionEnabled = NO;
    self.nextButton.backgroundColor = [UIColor grayColor];
}
-(void)viewWillAppear:(BOOL)animated{
    self.showResult.text = self.phone;
    //
    _observer = [[NSNotificationCenter defaultCenter]addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        if (self.password.text.length == 6) {
            //打开验证按钮
            self.nextButton.userInteractionEnabled = YES;
            self.nextButton.backgroundColor = [UIColor greenColor];
        }else {
            //关闭验证button的用户交互
            self.nextButton.userInteractionEnabled = NO;
            self.nextButton.backgroundColor = [UIColor grayColor];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//发送验证码
- (IBAction)sendSMSAction:(id)sender {
    [[LeancoudTools shareLeancoudTools]userResetPasswordWithPhone:self.phone resultBlock:^(BOOL succeed, NSError *error) {
        if (succeed) {
            //发送成功
            [self.sendSMS startWithTime:60 title:@"发送验证码" countDownTitle:@"S" mainColor:[UIColor greenColor] countColor:[UIColor grayColor]];
        }else {
            //发送失败
        }
    }];
}
//验证
- (IBAction)nextButtonAction:(id)sender {
    //->重置密码界面
    FindPasswordVC__Three *findVC_Three = [FindPasswordVC__Three new];
    [self presentViewController:findVC_Three animated:YES completion:nil];
    findVC_Three.SMSCode = self.password.text;
}

//键盘回收
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.password) {
        [textField endEditing:YES];
    }
    return YES;
}


@end
