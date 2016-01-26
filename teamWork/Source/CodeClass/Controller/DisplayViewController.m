//
//  DisplayViewController.m
//  teamWork
//
//  Created by hanxiaolong on 16/1/15.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "DisplayViewController.h"

@interface DisplayViewController ()

@end

@implementation DisplayViewController
+(instancetype)shareDisplayViewController {
    static DisplayViewController *handler = nil;
    if (handler == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            handler = [[DisplayViewController alloc]init];
        });
    }
    return handler;
}


-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {

        self.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"健康资讯" image:[UIImage imageNamed:@"news"] selectedImage:[UIImage imageNamed:@"news_selected"]];
       self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"person"] style:UIBarButtonItemStylePlain target:self action:@selector(MyselfInfoAction:)];
//
    }
    return self;
}
//用户界面
-(void)MyselfInfoAction:(UIBarButtonItem *)sender
{
    //将User.storyboard作为入口
    UIStoryboard *user = [UIStoryboard storyboardWithName:@"User" bundle:nil];
    UIViewController *entranceVC = [user instantiateInitialViewController];
    //让window的rootViewController指向该控制器
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:entranceVC animated:YES completion:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    // Do any additional setup after loading the view.
    // self.navigationController.title = @"健康资讯";
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
