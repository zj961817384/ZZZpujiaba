//
//  ZZZTopicDetailViewController.m
//  pujiaba
//
//  Created by zzzzz on 16/1/6.
//  Copyright © 2016年 zzzzz. All rights reserved.
//

#import "ZZZTopicDetailViewController.h"
#import "ZZZBaseTableView.h"
#import "ZZZTopicModel.h"
#import "ZZZCommentModel.h"
#import "ZZZCommentCell.h"
#import "MJRefresh.h"

@interface ZZZTopicDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) ZZZBaseTableView *tableView;

@property (nonatomic, retain) NSMutableArray<ZZZCommentModel *>     *dataArray;
@property (nonatomic, retain) ZZZTopicModel *topic;

@property (nonatomic, assign) CGFloat   cellHeight;

@end

@implementation ZZZTopicDetailViewController

- (void)dealloc{
    [_tableView release];
    [super dealloc];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = self.topicTitle;
    self.dataArray = [NSMutableArray array];
    self.topic = [[ZZZTopicModel alloc] init];
    self.tableView = [[ZZZBaseTableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview: self.tableView];
    [_tableView release];
    
    [self.tableView registerClass:[ZZZCommentCell class] forCellReuseIdentifier:@"cell6"];
    [self.tableView addHeaderWithCallback:^{
        [self getDataFromNet];
    }];
//    [self.tableView addFooterWithCallback:^{
//        [self getMoreDataFromNet];
//    }];
    [self.tableView headerBeginRefreshing];
#pragma mark -- 创建导航栏左边按钮
    UIImage *img = [UIImage imageNamed:@"iconfont_backT.png"];
    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button setImage:img forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btn;
    [btn release];
}

- (void)backButtonClick:(UIBarButtonItem *)button{
    //    NSLog(@"asdf");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData{
    [self getDataFromNet];
}

- (void)getDataFromNet{
    [AppTools getDataFromNetUseGETMethodWithUrl:[TOPICINFO_URL stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld",(long)self.topicId]] andParameters:nil successBlock:^(NSData *resultData) {
        if (resultData.length > 0) {
            [self.dataArray removeAllObjects];
            NSMutableDictionary *all = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dic = [all objectForKey:TOPIC];
            [self.topic setValuesForKeysWithDictionary:dic];
            ZZZCommentModel *commentModel = [[ZZZCommentModel alloc] init];
            commentModel.user_gravatar = self.topic.user_gravatar;
            commentModel.user_name = self.topic.user_name;
            commentModel.created_on = self.topic.created_on;
            commentModel.content = self.topic.content;
            [self.dataArray addObject:commentModel];
            
            [AppTools getDataFromNetUseGETMethodWithUrl:[TOPICCOMMENTSLIST_URL stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld",(long)self.topicId]] andParameters:nil successBlock:^(NSData *resultData) {
                if (resultData.length > 0) {
                    NSMutableDictionary *all = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                    for (NSDictionary *dic in [all objectForKey:POSTS_LIST]) {
                        ZZZCommentModel *m = [[ZZZCommentModel alloc] init];
                        [m setValuesForKeysWithDictionary:dic];
                        [self.dataArray addObject:m];
                        [m release];
                    }
                    [self.tableView addFooterWithCallback:^{
                        [self getMoreDataFromNet];
                    }];
                }else{
                    UIAlertController *alert = [AppTools alertWithMessage:@"网络不给力啊~" block:^{
                        ;
                    }];
                    [self presentViewController:alert animated:YES completion:^{
                        ;
                    }];
                }
                [self.tableView reloadData];
            } failBlock:^(NSError *error) {
                ;
            }];
        }else{
            UIAlertController *alert = [AppTools alertWithMessage:@"网络不给力啊~" block:^{
                ;
            }];
            [self presentViewController:alert animated:YES completion:^{
                ;
            }];
        }
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    } failBlock:^(NSError *error) {
        ;
    }];
}

- (void)getMoreDataFromNet{
    if (self.dataArray.count > 0) {
        NSDictionary *parameters = @{@"max_id":[NSNumber numberWithInteger:self.dataArray[self.dataArray.count - 1].comment_id]};
        [AppTools getDataFromNetUseGETMethodWithUrl:[TOPICCOMMENTSLIST_URL stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld",(long)self.topicId]] andParameters:parameters successBlock:^(NSData *resultData) {
            if (resultData.length > 0) {
                NSMutableDictionary *all = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                for (NSDictionary *dic in [all objectForKey:POSTS_LIST]) {
                    ZZZCommentModel *m = [[ZZZCommentModel alloc] init];
                    [m setValuesForKeysWithDictionary:dic];
                    [self.dataArray addObject:m];
                    [m release];
                }
                [self.tableView reloadData];
                if ([[all objectForKey:POSTS_LIST] count] <= 0) {
                    UIAlertController *alert = [AppTools alertWithMessage:@"没有更多数据了~" block:^{
                        [self.tableView removeFooter];
                    }];
                    [self presentViewController:alert animated:YES completion:^{
                        ;
                    }];
                }
            }else{
                UIAlertController *alert = [AppTools alertWithMessage:@"网络不给力啊~" block:^{
                    ;
                }];
                [self presentViewController:alert animated:YES completion:^{
                    ;
                }];
            }
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
        } failBlock:^(NSError *error) {
            NSLog(@"评论获取更多数据失败");
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZZCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell6"];
    cell.model = self.dataArray[indexPath.row];
    self.cellHeight = cell.cellHeight;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHeight;
}


@end
