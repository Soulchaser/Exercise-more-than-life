//
//  SettingViewController.m
//  teamWork
//
//  Created by lanou3g on 16/1/25.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "SettingViewController.h"
#import "YDGetDataTools.h"
@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic) UITableView * tableView;

@end

static NSString * const settingCellID = @"settingViewCellIdentifier";

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    
    
    
    //注册
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:settingCellID];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.tableView];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [YDGetDataTools sharedGetData].BasicArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:settingCellID forIndexPath:indexPath];
    
    cell.textLabel.text = [YDGetDataTools sharedGetData].BasicArray[indexPath.row];
    return cell;
    
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
