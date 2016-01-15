//
//  TrackLoggingViewController.m
//  teamWork
//
//  Created by hanxiaolong on 16/1/15.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "TrackLoggingViewController.h"

@interface TrackLoggingViewController ()

@end

@implementation TrackLoggingViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"跟你走" image:[UIImage imageNamed:@"daohang"] selectedImage:[UIImage imageNamed:@"daohang_selected"]];
       
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor orangeColor];
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
