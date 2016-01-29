//
//  CreatActivityViewController.m
//  teamWork
//
//  Created by lanou3g on 16/1/28.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "CreatActivityViewController.h"

@interface CreatActivityViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic) UIScrollView * YDScrollView;

@property(strong,nonatomic) UILabel * TitleLabel;//标题显示label

@property(strong,nonatomic) UITextView * YDTextTitleView;//标题

@property(strong,nonatomic) UILabel * DescriptionLabel;//描述显示label

@property(strong,nonatomic) UITextView * YDTextDescripView;//描述

@property(strong,nonatomic) UITableView * tableView;

@property(strong,nonatomic) UIImageView * imgViewOne;

@property(strong,nonatomic) UIImageView * imgViewTwo;

@property(strong,nonatomic) UIImageView * imgViewThree;

@property(strong,nonatomic) UIImageView * imgViewFour;

@end

static NSString * const creatTableViewCellID = @"creatTableViewCellIdentifier";

@implementation CreatActivityViewController
//懒加载滚动视图
-(UIScrollView *)YDScrollView
{
    if (!_YDScrollView) {
        _YDScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _YDScrollView;
}
//标题label
-(UILabel *)TitleLabel
{
    if (!_TitleLabel) {
        _TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, 21)];
        _TitleLabel.text = @"标题";
    }
   return  _TitleLabel;
}
//textView标题
-(UITextView *)YDTextTitleView
{
    if (!_YDTextTitleView) {
        _YDTextTitleView = [[UITextView alloc] initWithFrame:CGRectMake(10, 31, kScreenWidth-40, 42)];
    }
    return _YDTextTitleView;
}
//描述label
-(UILabel *)DescriptionLabel
{
    if (!_DescriptionLabel) {
        _DescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 83, 50, 21)];
        _DescriptionLabel.text = @"描述";
    }
    return _DescriptionLabel;
}
//textView描述
-(UITextView *)YDTextDescripView
{
    if (!_YDTextDescripView) {
        _YDTextDescripView = [[UITextView alloc] initWithFrame:CGRectMake(10, 104, kScreenWidth-40, 60)];
    }
    return _YDTextDescripView;
}
//tableView
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 164, kScreenWidth, 300) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

//图片
-(UIImageView *)imgViewOne
{
    if (!_imgViewOne) {
        _imgViewOne = [[UIImageView alloc] initWithFrame:CGRectMake(0, 400, 40 ,40)];
    }
    return _imgViewOne;
}
-(UIImageView *)imgViewTwo
{
    if (!_imgViewTwo) {
        _imgViewTwo = [[UIImageView alloc] initWithFrame:CGRectMake(60, 400, 40 ,40)];
    }
    return _imgViewTwo;
}
-(UIImageView *)imgViewThree
{
    if (!_imgViewThree) {
        _imgViewThree = [[UIImageView alloc] initWithFrame:CGRectMake(120, 400, 40 ,40)];
    }
    return _imgViewThree;
}
-(UIImageView *)imgViewFour
{
    if (!_imgViewFour) {
        _imgViewFour = [[UIImageView alloc] initWithFrame:CGRectMake(180, 400, 40 ,40)];
    }
    return _imgViewFour;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"创建活动";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(DefaltAction)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(CancelAction)];
    
    self.YDTextTitleView.backgroundColor = [UIColor whiteColor];
    self.YDTextDescripView.backgroundColor = [UIColor whiteColor];
    
    
    //注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:creatTableViewCellID];
    
    //添加到滚动视图上
    [self.YDScrollView addSubview:self.TitleLabel];
    [self.YDScrollView addSubview:self.YDTextTitleView];
    [self.YDScrollView addSubview:self.DescriptionLabel];
    [self.YDScrollView addSubview:self.YDTextDescripView];
    [self.YDScrollView addSubview:self.tableView];
    [self.YDScrollView addSubview:self.imgViewFour];
    [self.YDScrollView addSubview:self.imgViewOne];
    [self.YDScrollView addSubview:self.imgViewThree];
    [self.YDScrollView addSubview:self.imgViewTwo];
    //两个textView
    //一个TableView(数据自定义)
    //一个collectionView或者Button或者ImgView
    
    [self.view addSubview:self.YDScrollView];
    self.view.backgroundColor = [UIColor lightGrayColor];
}

#pragma mark *******"确定"--"取消"按钮点击事件
//点击确定,整理数据,提交给服务器
-(void)DefaltAction
{
    
}
//点击取消,弹窗提示"确定取消正在创建的活动?"
//确定->返回前一个页面
//去掉->不做操作
-(void)CancelAction
{
    
}

#pragma mark *************  TabelView 代理  ************

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:creatTableViewCellID forIndexPath:indexPath];
    
    cell.textLabel.text = @"设置";
    
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
