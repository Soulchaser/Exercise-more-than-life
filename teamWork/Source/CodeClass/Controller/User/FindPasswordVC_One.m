//
//  FindPasswordVC_One.m
//  teamWork
//
//  Created by lanou3g on 16/1/22.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "FindPasswordVC_One.h"
#import "FindPasswordVC_Tow.h"
@interface FindPasswordVC_One ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *showResult;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
//通知中心
@property(strong,nonatomic)NSNotificationCenter *observer;
@end

@implementation FindPasswordVC_One

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userName.delegate = self;
    self.nextButton.userInteractionEnabled = NO;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//返回登陆界面
- (IBAction)goBackAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    //添加观察者
   _observer = [[NSNotificationCenter defaultCenter]addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
       //如果不为11位手机号
       //如果不为11位手机号
       if (self.userName.text.length != 11) {
           self.showResult.text = @"用户名不正确";
           self.showResult.backgroundColor = [UIColor colorWithRed:248/255.0 green:229/255.0 blue:150/255.0 alpha:1];
           self.showResult.textColor = [UIColor colorWithRed:228/255.0 green:131/255.0 blue:38/255.0 alpha:1];
           //保持下一步按钮关闭状态
           self.nextButton.userInteractionEnabled = YES;
           self.nextButton.backgroundColor = [UIColor grayColor];
       }else{
           //用户是否存在
           [[LeancoudTools shareLeancoudTools]userDidBecomeRegisterWithUserName:self.userName.text resultBlock:^(BOOL succeed, NSError *error) {
               if (succeed) {
                   //存在 打开nextbutton交互
                   self.nextButton.userInteractionEnabled = YES;
                   self.nextButton.backgroundColor = [UIColor greenColor];
                   self.showResult.textColor = [UIColor whiteColor];
                   self.showResult.backgroundColor = [UIColor whiteColor];
               }else {
                   //不存在
                   self.showResult.text = @"用户不存在";
                   self.showResult.textColor = [UIColor colorWithRed:228/255.0 green:131/255.0 blue:38/255.0 alpha:1];
                   self.showResult.backgroundColor = [UIColor colorWithRed:248/255.0 green:229/255.0 blue:150/255.0 alpha:1];
                   self.nextButton.userInteractionEnabled = YES;
                   self.nextButton.backgroundColor = [UIColor grayColor];
               }
           }];
       }
   }];
}
-(void)viewWillDisappear:(BOOL)animated{
    //取消观察者
    [[NSNotificationCenter defaultCenter]removeObserver:self.observer];
}

//键盘回收
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.userName) {
        [textField endEditing:YES];
    }
    return YES;
}


#pragma mark - Navigation
//将手机号传入nextTwo
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"nextTwo"]) {
        FindPasswordVC_Tow *findVC_Two = (FindPasswordVC_Tow *)segue.destinationViewController;
        findVC_Two.phone = self.userName.text;
    }
    
}


@end
