//
//  SettingViewController.m
//  teamWork
//
//  Created by lanou3g on 16/1/25.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "SettingViewController.h"
@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic) UITableView * tableView;

@end

static NSString * const settingCellID = @"settingViewCellIdentifier";
BOOL b = YES;
@implementation SettingViewController

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    }
    return _tableView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(doneAction)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(EditAction:)];
    self.navigationItem.title = @"位置管理";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //注册
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:settingCellID];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.tableView];
    NSLog(@"%@",kGD.BasicArray);
    
}

-(void)doneAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)EditAction:(UIBarButtonItem*)barButton
{
    b = YES;
    if ([barButton.title isEqualToString:@"编辑"]) {
        [self.tableView setEditing:YES];
        barButton.title = @"完成";
    }else
    {
        [self.tableView setEditing:NO animated:YES];
        barButton.title = @"编辑";
    }

}

//设定可编辑区域
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//设定编辑样式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (b) {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleInsert;
}
//完成编辑
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //如果数组元素为0,删除分区
    if (kGD.BasicArray.count == 0) {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:indexPath.section];
        [tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];

    }else
        //如果当前分区不止一条数据,那么删除一行即可
    {
        //删除要操作的数组
        [kGD.BasicArray removeObject:kGD.BasicArray[indexPath.row]];
        //删除UI(根据当前所操作的位置来删除cell视图)
        //        NSArray *indexPathArray = [NSArray arrayWithObjects:indexPath, nil];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kGD.BasicArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:settingCellID forIndexPath:indexPath];
    
    YDWeatherModel * model = kGD.BasicArray[indexPath.row];
    
    cell.textLabel.text = model.city;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
