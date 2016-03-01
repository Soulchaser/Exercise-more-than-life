//
//  ActivityDetailViewController.m
//  teamWork
//
//  Created by lanou3g on 16/2/27.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "ActivityDetailViewController.h"

@interface ActivityDetailViewController () <YDDCarouselFigureDelegate>

@property (weak, nonatomic) IBOutlet UILabel *activityDescriptionLabel;//描述

@property (weak, nonatomic) IBOutlet UIView *G_View;//承载轮播图的View

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;//距离

@property (weak, nonatomic) IBOutlet UILabel *progressLabel;//参与进度

@property (weak, nonatomic) IBOutlet UILabel *activityTimeLabel;//活动时间

@property (weak, nonatomic) IBOutlet UILabel *activityAddressLabel;//活动地址

@property (weak, nonatomic) IBOutlet UILabel *activityPhoneLabel;//手机号

@property (weak, nonatomic) IBOutlet UIImageView *userPic;//用户头像

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;//用户昵称

@property (weak, nonatomic) IBOutlet UIScrollView *MyscrollView;

@property (weak, nonatomic) IBOutlet UIView *theLastView;

@property (weak, nonatomic) IBOutlet UIButton *JoinButton;


@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //标题
    self.title = self.PassActivity.title;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(backAction)];
    //描述
    self.activityDescriptionLabel.text = self.PassActivity.myDescription;

    //自适应描述文本的高度
    CGRect rect = [self.PassActivity.myDescription boundingRectWithSize:CGSizeMake(kScreenWidth-20, 10000)
                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                             attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]}
                                                                context:nil];
    CGRect currentFrame = self.activityDescriptionLabel.frame;
    currentFrame.size.height = rect.size.height;
    self.activityDescriptionLabel.frame = currentFrame;
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.MyscrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetHeight(self.theLastView.frame));
    
    NSMutableArray * array = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<self.PassActivity.activity_picture.count; i++) {
     
        UIImage * image = [UIImage imageWithData:self.PassActivity.activity_picture[i]];
        [array addObject:image];
        
    }
    
    YDDCarouseFigureView *carouselView = [[YDDCarouseFigureView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, 200)];
    //    carouselView.duration = 1;
    carouselView.delegate = self;
    carouselView.images = array;
    [self.G_View addSubview: carouselView];
    //距离
    self.distanceLabel.text = [NSString stringWithFormat:@"%@km",self.PassActivity.distance];
    //参与进度
    self.progressLabel.text = [NSString stringWithFormat:@"%ld/%@",self.PassActivity.people_current,self.PassActivity.people_count];
    //时间
    self.activityTimeLabel.text = [NSString stringWithFormat:@"%@到%@",self.PassActivity.start_time,self.PassActivity.end_time];
    //地址
    self.activityAddressLabel.text = self.PassActivity.address;
    //手机号
    self.activityPhoneLabel.text = self.PassActivity.phone;
    
}
//每次进入一个界面时,判断该活动是否已经加入过
-(void)viewWillAppear:(BOOL)animated{
    //拿到数据库中的所有当前用户已参加的活动
    AVQuery *query = [AVQuery queryWithClassName:@"Join"];
    [query whereKey:@"joinuser" equalTo:[AVUser currentUser]];
    [query includeKey:@"activity"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (AVObject *join in objects) {
            //如果在已加入的活动中存在当前活动(根据活动的创建时间判断)
            AVObject *activity = [join objectForKey:@"activity"];//已加入的活动
            NSString *createdAt = [activity objectForKey:@"createdAt"];//已加入活动的创建时间
            if ([createdAt isEqual:self.PassActivity.createdAt]) {
                //改变按钮的样式
                self.JoinButton.userInteractionEnabled = NO;
                [self.JoinButton setTitle:@"已加入" forState:UIControlStateNormal];
                return ;
            }
        }
    }];
}
//活动加入按钮
- (IBAction)JoinAction:(id)sender {
    AVObject *join = [AVObject objectWithClassName:@"Join"];
    [join setObject:[AVUser currentUser] forKey:@"joinuser"];//加入者
    //查找加入的活动
    AVQuery *query = [AVQuery queryWithClassName:@"Activity"];
    [query whereKey:@"createdAt" equalTo:self.PassActivity.createdAt];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        AVObject *activity = [objects firstObject];
        [join setObject:activity forKey:@"activity"];//关联活动
        //更新活动人数
        [activity incrementKey:@"people_current"];//增加当前参与人数
        activity.fetchWhenSave = YES;
        [activity saveInBackground];
        //保存加入记录
        [join saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            //改变按钮的样式
            self.JoinButton.userInteractionEnabled = NO;
            [self.JoinButton setTitle:@"已加入" forState:UIControlStateNormal];
        }];
    }];
    
}


-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
