//
//  RegisterViewController.m
//  teamWork
//
//  Created by lanou3g on 16/1/20.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>
//手机号
@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;
//验证码
@property (weak, nonatomic) IBOutlet UITextField *SMSCodeTextfield;
//密码
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
//发送验证码
@property (weak, nonatomic) IBOutlet UIButton *sendSMSButton;
//注册
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
//计时器 控制验证码发送倒计时60s结束
@property(assign,nonatomic)NSInteger num;

//是否同意用户协议
@property BOOL agreement;


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.phoneTextfield.delegate = self;
    self.SMSCodeTextfield.delegate = self;
    self.passwordTextfield.delegate = self;
    //注册按钮不可点击
    self.registerButton.backgroundColor = [UIColor grayColor];
    self.registerButton.userInteractionEnabled = NO;
    _num = 59;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//取消
- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//发送验证码
- (IBAction)sendSMSAction:(id)sender {
    //如果号码不为11位
    if (self.phoneTextfield.text.length != 11) {
        //手机号输入变为红色
        self.phoneTextfield.backgroundColor = [UIColor redColor];
        return;
    }
    self.phoneTextfield.backgroundColor = [UIColor whiteColor];
    //如果密码不为6-16位
    if (self.passwordTextfield.text.length <6 || self.passwordTextfield.text.length > 16) {
        self.passwordTextfield.backgroundColor = [UIColor redColor];
        return;
    }
    self.passwordTextfield.backgroundColor = [UIColor whiteColor];
    //传入model
    YYUserModel_Phone *model = [YYUserModel_Phone new];
    model.phone = self.phoneTextfield.text;
    model.password = self.passwordTextfield.text;
    
    [LeancoudTools shareLeancoudTools].model_Phone = model;
    //手机号正确 发送验证信息
    [[LeancoudTools shareLeancoudTools]userRegisterByPhone:^(BOOL succeed, NSError *error) {
        //验证码发送成功(提示用户)
        if (succeed) {
            _num = 59;
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"信息发送成功" message:@"请注意查收" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertC animated:YES completion:^{
                //一秒后回收alert
                [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(recycleAction) userInfo:nil repeats:NO];
            }];
        }else {
            //验证码发送失败根据返回的error提醒用户
        }
    }];
    
}
//
//计时器方法(回收alertController)
-(void)recycleAction{
    //回收alertController
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.sendSMSButton startWithTime:_num title:@"发送验证码" countDownTitle:@"S" mainColor:[UIColor greenColor] countColor:[UIColor grayColor]];
}
//用户协议
- (IBAction)userAgreement:(id)sender {
    UIButton *button = (UIButton *)sender;
    //用户之前不同意用户协议(触发该事件后为同意状态)
    if (self.agreement == NO) {
        [button setImage:[UIImage imageNamed:@"iconfont-quedinggouxuanxuanxiang"] forState:UIControlStateNormal];
        self.agreement = YES;
        //注册按钮可以点击
        self.registerButton.backgroundColor = [UIColor colorWithRed:227/255.0 green:127/255.0 blue:30/255.0 alpha:1];
        self.registerButton.userInteractionEnabled = YES;
    }else {
        //用户之前同意用户协议
        [button setImage:[UIImage imageNamed:@"iconfont-yansebiankuang"] forState:UIControlStateNormal];
        self.agreement = NO;
        //注册按钮不可点击
        self.registerButton.backgroundColor = [UIColor grayColor];
        self.registerButton.userInteractionEnabled = NO;
    }
}

//注册
- (IBAction)registerAction:(id)sender {
    if (self.agreement == NO) {
        return;
    }
    [[LeancoudTools shareLeancoudTools]userRegisterBySMSCode:self.SMSCodeTextfield.text resultBlock:^(BOOL succeed, NSError *error) {
        //验证码正确 注册成功
        if (succeed) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"注册成功" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertC animated:YES completion:^{
                [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(alertCBackAction) userInfo:nil repeats:NO];
            }];
        }else {
            //根据返回的error提醒用户
            NSString *errorInformation = @"注册失败";
            switch (error.code) {
                case 203:
                    errorInformation = error.localizedDescription;
                    break;
                case 202:
                    errorInformation = @"用户已存在";
                    break;
                case 603:
                    errorInformation = @"无效的验证码";
                    break;
                default:
                    errorInformation = @"请重新注册";
                    break;
            }
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"注册失败" message:errorInformation preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertC addAction:cancel];
            [self presentViewController:alertC animated:YES completion:nil];
        }
        
    }];
    
}
//计数器方法(注册成功,返回登陆界面)
-(void)alertCBackAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];

}


//键盘回收
//空白处回收键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
//键盘回收
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.phoneTextfield == textField) {
        [self.SMSCodeTextfield becomeFirstResponder];
    }else if(self.SMSCodeTextfield == textField){
        [self.passwordTextfield becomeFirstResponder];
    }else if (self.passwordTextfield == textField){
        [textField resignFirstResponder];
    }
    return YES;
}
//文本框输入结束
-(void)textFieldDidEndEditing:(UITextField *)textField{
    //手机号输入完成
    if (self.phoneTextfield == textField) {
        textField.backgroundColor = [UIColor whiteColor];
        //密码输入完成
    }else if (self.passwordTextfield == textField){
        textField.backgroundColor = [UIColor whiteColor];
    }else if (self.SMSCodeTextfield == textField){
        if (self.SMSCodeTextfield.text.length == 0) {
            //如果用户没有输入
            self.SMSCodeTextfield.backgroundColor = [UIColor whiteColor];
            return;
        }
        //验证码输入完成(判断六位验证码)
        if (textField.text.length != 6) {
            self.SMSCodeTextfield.backgroundColor = [UIColor redColor];
        }else {
            self.SMSCodeTextfield.backgroundColor = [UIColor whiteColor];
        }
    }
    
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
