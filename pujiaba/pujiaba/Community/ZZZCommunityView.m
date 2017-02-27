//
//  ZZZCommunityView.m
//  pujiaba
//
//  Created by zzzzz on 15/12/28.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZCommunityView.h"
#import "ZZZTopicCell.h"
#import "MJRefresh.h"
#import "ZZZTopicDetailViewController.h"

@interface ZZZCommunityView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) ZZZBaseTableView  *tableView;

@property (nonatomic, retain) NSMutableArray<ZZZTopicModel *>    *topicArray;

@property (nonatomic, assign) NSInteger     cellHeight;

@end

@implementation ZZZCommunityView

- (void)dealloc{
    [_tableView release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.topicArray = [NSMutableArray array];
        self.tableView = [[ZZZBaseTableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self addSubview:self.tableView];
        [_tableView release];
        
        [self.tableView registerClass:[ZZZTopicCell class] forCellReuseIdentifier:@"cell4"];
        [self.tableView addHeaderWithCallback:^{
            [self loadData];
        }];
        
        [self.tableView headerBeginRefreshing];
    }
    return self;
}

- (void)loadData{
    [AppTools getDataFromNetUseGETMethodWithUrl:TOPICLIST_URL andParameters:nil successBlock:^(NSData *resultData) {
        if (resultData.length > 0) {
            [self.topicArray removeAllObjects];
            NSMutableDictionary *all = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            for (NSDictionary *dic in [all objectForKey:TOPICS_LIST]) {
                ZZZTopicModel *m = [[ZZZTopicModel alloc] init];
                [m setValuesForKeysWithDictionary:dic];
                [self.topicArray addObject:m];
                [m release];
            }
            [self.tableView addFooterWithCallback:^{
                [self loadMoreData];
            }];
        }else{
            if ([self.myDelegate respondsToSelector:@selector(presentMyViewController:)]) {
                UIAlertController *alert = [AppTools alertWithMessage:@"网络不给力啊~" block:^{
                    ;
                }];
                [self.myDelegate presentMyViewController:alert];
            }
        }
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    } failBlock:^(NSError *error) {
        if ([self.myDelegate respondsToSelector:@selector(presentMyViewController:)]) {
            UIAlertController *alert = [AppTools alertWithMessage:@"我没有拿到数据 😭" block:^{
                ;
            }];
            [self.myDelegate presentMyViewController:alert];
        }
    }];
}

- (void)loadMoreData{
    NSDictionary *parameters = @{@"since_id":[NSNumber numberWithInteger:[self.topicArray lastObject].topic_id]};
    [AppTools getDataFromNetUseGETMethodWithUrl:TOPICLIST_URL andParameters:parameters successBlock:^(NSData *resultData) {
        if (resultData.length > 0) {
            NSMutableDictionary *all = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            for (NSDictionary *dic in [all objectForKey:TOPICS_LIST]) {
                ZZZTopicModel *m = [[ZZZTopicModel alloc] init];
                [m setValuesForKeysWithDictionary:dic];
                [self.topicArray addObject:m];
                [m release];
            }
        }else{
            if ([self.myDelegate respondsToSelector:@selector(presentMyViewController:)]) {
                UIAlertController *alert = [AppTools alertWithMessage:@"网络不给力啊~" block:^{
                    ;
                }];
                [self.myDelegate presentMyViewController:alert];
            }
        }
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
    } failBlock:^(NSError *error) {
        if ([self.myDelegate respondsToSelector:@selector(presentMyViewController:)]) {
            UIAlertController *alert = [AppTools alertWithMessage:@"获取数据失败了😲" block:^{
                ;
            }];
            [self.myDelegate presentMyViewController:alert];
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZZTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
//    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.topicArray[indexPath.row].subject];
    cell.model = self.topicArray[indexPath.row];
    self.cellHeight = cell.cellHeight;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return self.cellHeight;
    return self.cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.topicArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZZZTopicModel *model = self.topicArray[indexPath.row];
    ZZZTopicDetailViewController *vc = [[ZZZTopicDetailViewController alloc] init];
    vc.topicId = model.topic_id;
    vc.topicTitle = model.subject;
    [self.myDelegate pushMyViewController:vc];
    [vc release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
