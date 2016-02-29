//
//  LoginViewController.m
//  teamWork
//
//  Created by lanou3g on 16/1/20.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>


@property(strong,nonatomic)NYSegmentedControl *segmentedControl;
@property UIView *visibleExampleView;
@property NSArray *exampleViews;
//segmentView
@property (weak, nonatomic) IBOutlet UIView *segBGView;
//textBGView
@property (weak, nonatomic) IBOutlet UIView *textfieldBGView;
//手机登陆
@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;//手机号
@property (weak, nonatomic) IBOutlet UITextField *password;//密码
@property (weak, nonatomic) IBOutlet UIButton *sendSMS;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property(strong,nonatomic)NSString *smsCode;//短信验证码
//计时器 控制验证码发送倒计时60s结束
@property(assign,nonatomic)NSInteger num;
//textfield通知
@property(strong,nonatomic)NSNotificationCenter *observe;

@end

@implementation LoginViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.phoneTextfield.delegate = self;
    self.password.delegate = self;
    //登陆无法点击
    self.loginButton.userInteractionEnabled = NO;
    self.loginButton.backgroundColor = [UIColor grayColor];
    //隐藏验证码发送按钮
    self.sendSMS.userInteractionEnabled = NO;
    self.sendSMS.backgroundColor = [UIColor whiteColor];
    _num = 59;
    //segmentedControl视图
    self.segmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"手机账号登陆", @"动态密码登陆"]];
    [self.segmentedControl addTarget:self action:@selector(segmentSelected) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.titleFont = [UIFont fontWithName:@"AvenirNext-Medium" size:14.0f];
    self.segmentedControl.titleTextColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
    self.segmentedControl.selectedTitleFont = [UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0f];
    self.segmentedControl.selectedTitleTextColor = [UIColor whiteColor];
    self.segmentedControl.borderWidth = 1.0f;
    self.segmentedControl.borderColor = [UIColor colorWithWhite:0.15f alpha:1.0f];
    self.segmentedControl.drawsGradientBackground = YES;
    self.segmentedControl.segmentIndicatorInset = 2.0f;
    self.segmentedControl.segmentIndicatorGradientTopColor = [UIColor colorWithRed:0.30 green:0.50 blue:0.88f alpha:1.0f];
    self.segmentedControl.segmentIndicatorGradientBottomColor = [UIColor greenColor];
    self.segmentedControl.drawsSegmentIndicatorGradientBackground = YES;
    self.segmentedControl.segmentIndicatorBorderWidth = 0.0f;
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl sizeToFit];
    self.segmentedControl.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 80);
    [self.view addSubview:self.segmentedControl];
    self.password.secureTextEntry = YES;
}
//segment选择
-(void)segmentSelected{
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        self.sendSMS.userInteractionEnabled = NO;
        self.sendSMS.backgroundColor = [UIColor whiteColor];
        self.password.placeholder = @"请输入密码";
        self.password.secureTextEntry = YES;
    }else{
        self.sendSMS.userInteractionEnabled = YES;
        self.sendSMS.backgroundColor = [UIColor greenColor];
        self.password.placeholder = @"输入验证码";
        self.password.secureTextEntry = NO;
    }
}
//发送验证短信
- (IBAction)sendSMSAction:(id)sender {
    [[LeancoudTools shareLeancoudTools]userLoginInputByPhone:self.phoneTextfield.text resultBlock:^(BOOL succeed, NSError *error) {
        if (succeed) {
            _num = 59;
            //短信发送成功
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"信息发送成功" message:@"请注意查收" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertC animated:YES completion:^{
                //一秒后回收alert
                [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(recycleAction) userInfo:nil repeats:NO];
            }];
            //关闭segment用户交互(倒计时完成后开放)
            self.segmentedControl.userInteractionEnabled = NO;
            self.segmentedControl.segmentIndicatorGradientTopColor = [UIColor grayColor];
        }else{
            //短信发送失败
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"信息发送失败" message:@"已超出每日限制" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertC animated:YES completion:^{
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            
        }
    }];
}
//计时器方法(回收alertController)
-(void)recycleAction{
    //回收alertController
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.sendSMS startWithTime:_num title:@"发送验证码" countDownTitle:@"S" mainColor:[UIColor greenColor] countColor:[UIColor grayColor]];
}
-(void)viewWillDisappear:(BOOL)animated{
    //取消观察者
    [[NSNotificationCenter defaultCenter]removeObserver:self.observe];
    [self.sendSMS removeObserver:self forKeyPath:@"userInteractionEnabled"];
}

-(void)viewDidAppear:(BOOL)animated{
    AVUser *currentUser = [AVUser currentUser];
    if (currentUser != nil) {
        self.phoneTextfield.text = currentUser.username;
        self.password.text = currentUser.password;
    }
    //通知中心
    _observe = [[NSNotificationCenter defaultCenter]addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        //监测输入框中内容变化
        if (self.phoneTextfield.text.length == 11) {
            self.phoneTextfield.backgroundColor = [UIColor whiteColor];
            if (self.password.text.length <6 || self.password.text.length > 16) {
                self.password.backgroundColor = [UIColor colorWithRed:248/255.0 green:229/255.0 blue:150/255.0 alpha:1];
                //登陆无法点击
                self.loginButton.userInteractionEnabled = NO;
                self.loginButton.backgroundColor = [UIColor grayColor];
            }else{
                self.password.backgroundColor = [UIColor whiteColor];
                self.loginButton.userInteractionEnabled = YES;
                self.loginButton.backgroundColor = [UIColor greenColor];
            }
        }else {
            self.phoneTextfield.backgroundColor = [UIColor colorWithRed:248/255.0 green:229/255.0 blue:150/255.0 alpha:1];
        }
        
    }];
    //添加观察者
    [self.sendSMS addObserver:self forKeyPath:@"userInteractionEnabled" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];
}

//观察者响应方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    //监测sendSMS
    if ([keyPath isEqualToString:@"userInteractionEnabled"]) {
        if ([change[@"new"]boolValue] == YES) {
            //打开segment交互
            self.segmentedControl.userInteractionEnabled = YES;
            self.segmentedControl.segmentIndicatorGradientTopColor = [UIColor colorWithRed:0.30 green:0.50 blue:0.88f alpha:1.0f];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//登陆
- (IBAction)loginAction:(id)sender {
    //先退出上一个账户
    AVUser *currentUser = [AVUser currentUser];
    if (currentUser != nil) {
        [AVUser logOut];
    }
    YYUserModel_Phone *model = [YYUserModel_Phone new];
    model.userName = self.phoneTextfield.text;
    model.password = self.password.text;
    //传入账号和密码
    [LeancoudTools shareLeancoudTools].model_Phone = model;
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        //手机账号登陆
        [[LeancoudTools shareLeancoudTools] userLoginByPhone:^(BOOL succeed, NSError *error) {
            if (succeed) {
                //登陆成功
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"登陆成功" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alertC animated:YES completion:^{
                    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(alertCBackAction) userInfo:nil repeats:NO];
                }];
            }else {
                //登陆失败
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"登陆失败" message:@"密码错误" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alertC addAction:cancel];
                [self presentViewController:alertC animated:YES completion:nil];
            }
        }];
    }else {
        //短信验证码登陆
        [[LeancoudTools shareLeancoudTools]userLoginBySMSCode:self.password.text resultBlock:^(BOOL succeed, NSError *error) {
            if (succeed) {
                //验证成功
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"登陆成功" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alertC animated:YES completion:^{
                    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(alertCBackAction) userInfo:nil repeats:NO];
                }];
            }else {
                //登陆失败
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"登陆失败" message:@"验证码有误" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alertC addAction:cancel];
                [self presentViewController:alertC animated:YES completion:nil];
            }
        }];
        
    }
}
-(void)alertCBackAction{
    AVUser *currentUser = [AVUser currentUser];
    AVFile *oldFile = [currentUser objectForKey:@"avatar"];
    //确定用户是否设置过头像,如果没有,设置默认头像
    if (oldFile == nil) {
        //添加头像
        AVFile *avatarFile = [AVFile fileWithName:@"avatar.png"data:UIImagePNGRepresentation([UIImage imageNamed:@"default_avatar"])];
        [currentUser setObject:avatarFile forKey:@"avatar"];
        [currentUser saveInBackground];
    }
  
    //回收alertController
    [self dismissViewControllerAnimated:YES completion:nil];
    //跳转主界面
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
        [self.password becomeFirstResponder];
    }else if(self.password == textField){
        [textField resignFirstResponder];
    }
    return YES;
}
//
-(IBAction)unwindSegue:(UIStoryboardSegue *)sender{
    
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
