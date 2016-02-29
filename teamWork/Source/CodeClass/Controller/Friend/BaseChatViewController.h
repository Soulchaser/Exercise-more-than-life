//
//  BaseChatViewController.h
//  LeanMessageDemo
//
//  Created by LeanCloud on 15/5/14.
//  Copyright (c) 2015年 leancloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloudIM.h>
#import "MessageToolBarView.h"

static NSInteger kPageSize = 5;


@class BaseChatViewController;

@interface BaseChatViewController :UIViewController<UITableViewDataSource, UITableViewDelegate, AVIMClientDelegate>



@property(strong,nonatomic)UITableView *messageTableView;
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) AVIMClient *imClient;
@property (nonatomic,strong) AVIMConversation *currentConversation;
@property (nonatomic,strong) MessageToolBarView *messageToolBar;
@property (nonatomic,strong) NSString *targetClientId;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(void)initMessageToolBar;
@end





