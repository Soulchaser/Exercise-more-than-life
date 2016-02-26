//
//  FindPasswordVC__Three.m
//  teamWork
//
//  Created by lanou3g on 16/1/22.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "FindPasswordVC__Three.h"

@interface FindPasswordVC__Three ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *setPassword;//新密码
@property (weak, nonatomic) IBOutlet UITextField *setPasswordToo;//确认密码

@property (weak, nonatomic) IBOutlet UIButton *setButton;//确定按钮
@property(strong,nonatomic)NSNotificationCenter *observer;
@end

@implementation FindPasswordVC__Three
-(void)setSMSCode:(NSString *)SMSCode{
    _SMSCode = SMSCode;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.setPassword.delegate = self;
    self.setPasswordToo.delegate = self;
    //    //关闭按钮交互
        self.setButton.userInteractionEnabled = NO;
        self.setButton.backgroundColor = [UIColor grayColor];
}
-(void)viewDidAppear:(BOOL)animated{
    _observer = [[NSNotificationCenter defaultCenter]addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        //保证密码为6-16位
        if (self.setPassword.text.length < 6 || self.setPassword.text.length > 16) {
            self.setPassword.backgroundColor = [UIColor colorWithRed:248/255.0 green:229/255.0 blue:150/255.0 alpha:1];
        }else {
            self.setPassword.backgroundColor = [UIColor whiteColor];
            if (self.setPasswordToo.text.length < 6 || self.setPasswordToo.text.length > 16) {
                self.setPasswordToo.backgroundColor = [UIColor colorWithRed:248/255.0 green:229/255.0 blue:150/255.0 alpha:1];
            }else {
                //在两次输入均为6-16位下
                self.setPasswordToo.backgroundColor = [UIColor whiteColor];
                self.setButton.userInteractionEnabled = YES;
                self.setButton.backgroundColor = [UIColor greenColor];
            }
        }
        
        
        
    }];
}
-(void)viewWillDisappear:(BOOL)animated{
    //注销通知
    [[NSNotificationCenter defaultCenter]removeObserver:self.observer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//返回登陆界面
- (IBAction)backLoginAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    
    UIStoryboard *userStoryboard = [UIStoryboard storyboardWithName:@"User" bundle:nil];
    LoginViewController *loginVC = [userStoryboard instantiateViewControllerWithIdentifier:@"login"];
    [self presentViewController:loginVC animated:YES completion:nil];
}
//确定设置
- (IBAction)setPasswordAction:(id)sender {
    //两次输入一致
    if ([self.setPassword.text isEqualToString:self.setPasswordToo.text]) {
        [[LeancoudTools shareLeancoudTools]userResetBySMSCode:self.SMSCode andNewPassword:self.setPassword.text resultBlock:^(BOOL succeed, NSError *error) {
            if (succeed) {
                //重置成功 ->提示用户 跳转登陆界面
                UIAlertController *success = [UIAlertController alertControllerWithTitle:@"提示" message:@"重置成功" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:success animated:YES completion:^{
                    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(backLoginAction:) userInfo:nil repeats:NO];
                }];
            }else{
                //重置失败
                UIAlertController *failure = [UIAlertController alertControllerWithTitle:@"重置失败" message:@"验证码有误" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:failure animated:YES completion:^{
                    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(backNextTwoAction) userInfo:nil repeats:NO];
                }];
            }
        }];
    }else{
        //密码不一致
        self.setPasswordToo.backgroundColor = [UIColor redColor];
    }
    
}
//返回验证界面重新获取或输入验证码
-(void)backNextTwoAction{
    [self dismissViewControllerAnimated:NO completion:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}
//键盘回收
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.setPassword) {
        [self.setPasswordToo becomeFirstResponder];
    }else if(textField == self.setPasswordToo) {
        [self.setPasswordToo resignFirstResponder];
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{

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
