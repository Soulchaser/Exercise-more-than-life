//
//  DetailViewController.m
//  teamWork
//
//  Created by lanou3g on 16/1/26.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *DetailWebView;

@property(strong,nonatomic) NSMutableArray * dataArray;
@end

@implementation DetailViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.DetailWebView.delegate = self;

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goBackAction)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
    [self makeData];
    
}

-(void)makeData
{
    NSString *urlStr = [[NSString alloc]initWithFormat: @"http://apis.baidu.com/tngou/lore/show?id=%@",self.IDString];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"2914a9e8c533799c98515dbba2834624" forHTTPHeaderField: @"apikey"];
    NSURLSessionDataTask * dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"%@",data);
        
        NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"%@",dataDic);
        
        self.dataArray = [NSMutableArray array];
        
        
        DetailModel * model = [[DetailModel alloc] init];
        
        [model setValuesForKeysWithDictionary:dataDic];
        
        [self.dataArray addObject:model];
        
        //主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *HTMLString = model.message;
            
            [self.DetailWebView loadHTMLString:HTMLString baseURL:nil];
            
        });
        
    }];
    
    
    [dataTask resume];
    
}


-(void)goBackAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
