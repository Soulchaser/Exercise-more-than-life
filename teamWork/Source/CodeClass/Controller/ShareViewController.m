//
//  ShareViewController.m
//  teamWork
//
//  Created by hanxiaolong on 16/1/15.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"足迹分享" image:[UIImage imageNamed:@"share"] selectedImage:[UIImage imageNamed:@"share_selected"]];

    }
    return self;
}

-(void)MyselfInfoAction:(UIBarButtonItem *)sender
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationController.navigationItem.title = @"足迹分享";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"person"] style:UIBarButtonItemStylePlain target:self action:@selector(MyselfInfoAction:)];
    
    
    
    
    self.view.backgroundColor = [UIColor yellowColor];
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
