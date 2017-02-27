
//
//  ZZZSearchResultView.m
//  pujiaba
//
//  Created by zzzzz on 16/1/11.
//  Copyright © 2016年 zzzzz. All rights reserved.
//

#import "ZZZSearchResultView.h"
#import "ZZZBaseTableView.h"
#import "ZZZGameListCell.h"
#import "ZZZGameDetailViewController.h"
#import "MJRefresh.h"

@interface ZZZSearchResultView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) ZZZBaseTableView *tableView;

@property (nonatomic, retain) NSMutableArray<ZZZGameListModel *> *games;

@property (nonatomic, copy) NSString *currentUrl;

@end

@implementation ZZZSearchResultView

- (void)dealloc{
    
    
    
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.whiteColor = [UIColor colorWithWhite:0.904 alpha:1.000];
        self.nightColor = [UIColor colorWithRed:0.179 green:0.244 blue:0.244 alpha:1.000];
        if ([@"night" isEqualToString:[USERDEFAULT objectForKey:CURRENT_SKIN]]) {
            self.backgroundColor = self.nightColor;
        }else{
            self.backgroundColor = self.whiteColor;
        }

        self.games = [NSMutableArray array];
        [self createSubview];
    }
    return self;
}

- (void)createSubview{
    self.tableView = [[ZZZBaseTableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.whiteColor = [UIColor colorWithWhite:0.875 alpha:1.000];
    self.tableView.nightColor = [UIColor colorWithRed:0.137 green:0.184 blue:0.184 alpha:1.000];
    if ([@"night" isEqualToString:[USERDEFAULT objectForKey:CURRENT_SKIN]]) {
        self.tableView.backgroundColor = self.nightColor;
    }else{
        self.tableView.backgroundColor = self.whiteColor;
    }
//    [self.tableView setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.000]];
    [self addSubview:self.tableView];
    [_tableView release];
    
    [self.tableView registerClass:[ZZZGameListCell class] forCellReuseIdentifier:@"cell10"];
    
    [self.tableView addHeaderWithCallback:^{
        [self getDataFromNet];
    }];
//    [self.tableView addFooterWithCallback:^{
//        [self getMoreDataFromNet];
//    }];
}

- (void)loadData{
    [self getDataFromNet];
}

- (void)getDataFromNet{
    if (![@"" isEqualToString:self.searchKey]) {
        NSDictionary *parameter = @{@"w":[self.searchKey stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]};
        [AppTools getDataFromNetUseGETMethodWithUrl:SEARCH_URL andParameters:parameter successBlock:^(NSData *resultData) {
            if (resultData.length > 0) {
                [self.games removeAllObjects];
                NSDictionary *bdic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                for (NSDictionary *dic in [bdic objectForKey:GAMES_LIST]) {
                    ZZZGameListModel *m = [[ZZZGameListModel alloc] init];
                    [m setValuesForKeysWithDictionary:dic];
                    [self.games addObject:m];
                    [m release];
                }
                [self.tableView reloadData];

                if ([[bdic objectForKey:GAMES_LIST] count] == 0) {
                    [self.tableView removeFooter];
                }else{
                    [self.tableView addFooterWithCallback:^{
                        [self getMoreDataFromNet];
                    }];
                }
            }else{
                if ([self.myDelegate respondsToSelector:@selector(presentMyViewController:)]) {
                    UIAlertController *alert = [AppTools alertWithMessage:@"网络不给力啊~" block:^{
                        ;
                    }];
                    [self.myDelegate presentMyViewController:alert];
                }
            }
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
        } failBlock:^(NSError *error) {
            NSLog(@"搜索页面从网络获取数据失败");
        }];
    }
}

- (void)getMoreDataFromNet{
    if (![@"" isEqualToString:self.searchKey]) {
        NSDictionary *parameter = @{@"w":[self.searchKey stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                    @"since_id":[NSNumber numberWithInteger:[self.games lastObject].game_id]};
        [AppTools getDataFromNetUseGETMethodWithUrl:SEARCH_URL andParameters:parameter successBlock:^(NSData *resultData) {
            if (resultData.length > 0) {
                NSDictionary *bdic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                for (NSDictionary *dic in [bdic objectForKey:GAMES_LIST]) {
                    ZZZGameListModel *m = [[ZZZGameListModel alloc] init];
                    [m setValuesForKeysWithDictionary:dic];
                    [self.games addObject:m];
                    [m release];
                }
                [self.tableView reloadData];
                if ([[bdic objectForKey:GAMES_LIST] count] == 0) {
                    
                    UIAlertController *alert = [AppTools alertWithMessage:@"没有更多数据了~" block:^{
                        [self.tableView removeFooter];
                        ;
                    }];
                    if ([self.myDelegate respondsToSelector:@selector(presentMyViewController:)]) {
                        [self.myDelegate presentMyViewController:alert];
                    }
                }
            }else{
                if ([self.myDelegate respondsToSelector:@selector(presentMyViewController:)]) {
                    UIAlertController *alert = [AppTools alertWithMessage:@"网络不给力啊~" block:^{
                        ;
                    }];
                    [self.myDelegate presentMyViewController:alert];
                }
            }
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
        } failBlock:^(NSError *error) {
            if ([self.myDelegate respondsToSelector:@selector(presentMyViewController:)]) {
                UIAlertController *alert = [AppTools alertWithMessage:@"我的请求链接好像错了😢" block:^{
                    ;
                }];
                [self.myDelegate presentMyViewController:alert];
            }
            NSLog(@"搜索页面从网络获取数据失败");
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.games.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZZGameListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell10"];
    
    cell.model = self.games[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return WIDTH / 5 + 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZZGameDetailViewController *detailVC = [[ZZZGameDetailViewController alloc] init];
    detailVC.model = self.games[indexPath.row];
    [self.myDelegate pushMyViewController:detailVC];
    [detailVC release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)setSearchKey:(NSString *)searchKey{
    if (_searchKey != searchKey){
        [_searchKey release];
        _searchKey = [searchKey copy];
//        self.currentUrl = [SEARCH_URL stringByAppendingPathComponent:self.searchKey];
        [self loadData];
    }
}

@end
