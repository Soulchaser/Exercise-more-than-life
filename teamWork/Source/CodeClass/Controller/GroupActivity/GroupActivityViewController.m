//
//  GroupActivityViewController.m
//  teamWork
//
//  Created by hanxiaolong on 16/1/15.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "GroupActivityViewController.h"

@interface GroupActivityViewController ()

@end

@implementation GroupActivityViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"寻找组织" image:[UIImage imageNamed:@"group"] selectedImage:[UIImage imageNamed:@"group_select"]];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建" style: UIBarButtonItemStylePlain target:self action:@selector(pushToCreatPage)];
        
    }
    return self;
}

#pragma mark **********"创建"按钮响应事件
-(void)pushToCreatPage
{
    CreatActivityViewController_1 * creatVC = [CreatActivityViewController_1 new];
    
    [self.navigationController pushViewController:creatVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
  //  self.navigationController.title = @"寻找组织";
    // Do any additional setup after loading the view.
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
