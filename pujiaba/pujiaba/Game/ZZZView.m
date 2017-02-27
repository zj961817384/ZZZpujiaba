//
//  ZZZView.m
//  pujiaba
//
//  Created by zzzzz on 15/12/28.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZView.h"
#import "ZZZBaseTableView.h"
#import "ZZZGameListCell.h"
#import "MJRefresh.h"
#import "ZZZGameDetailViewController.h"

@interface ZZZView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) ZZZBaseTableView *tableView;

@end

@implementation ZZZView

- (void)dealloc{
    [_tableView release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame andURL:(NSString *)URL{
    self = [super initWithFrame:frame];
    if (self) {
        self.games = [NSMutableArray array];
        self.tableView = [[ZZZBaseTableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.tableView];
        [_tableView release];
        
        [self.tableView registerClass:[ZZZGameListCell class] forCellReuseIdentifier:@"cell3"];
        
        [self.tableView addHeaderWithCallback:^{
            [self loadData];
        }];
//        [self.tableView addFooterWithCallback:^{
//            [self loadMoreData];
//        }];
//        [self.tableView headerBeginRefreshing];
//        [self loadData];
        if (URL == nil || [URL isEqualToString:@""]) {
            self.dataURL = GAMELIST_URL;
        }else{
            self.dataURL = URL;
        }
    }
    return self;
}

- (void)loadData{
    [AppTools getDataFromNetUseGETMethodWithUrl:self.dataURL andParameters:nil successBlock:^(NSData *resultData) {
        NSLog(@"数据请求成功");
        if (resultData.length > 0) {
        [self.games removeAllObjects];
            
            NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];

            NSMutableArray *allArray = [dic objectForKey:GAMES_LIST];
            for (NSDictionary *d in allArray) {
                ZZZGameListModel *m = [[ZZZGameListModel alloc] init];
                [m setValuesForKeysWithDictionary:d];
                [self.games addObject:m];
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
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        [self.tableView reloadData];
    } failBlock:^(NSError *error) {
        NSLog(@"数据请求失败");
        [self.tableView headerEndRefreshing];
    }];
}

- (void)loadMoreData{
    NSDictionary *paramegers = @{
                                 @"since_time":[NSNumber numberWithInteger:self.games[self.games.count - 1].pub_mktime]
                                 };
    
    [AppTools getDataFromNetUseGETMethodWithUrl:self.dataURL andParameters:paramegers successBlock:^(NSData *resultData) {
        NSLog(@"数据请求成功");
        
        if (resultData.length > 0) {
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
        
        NSMutableArray *allArray = [dic objectForKey:GAMES_LIST];
        for (NSDictionary *d in allArray) {
            ZZZGameListModel *m = [[ZZZGameListModel alloc] init];
            [m setValuesForKeysWithDictionary:d];
            [self.games addObject:m];
            [m release];
        }
        //        [self.tableView reloadData];
        int j = 0;
        NSMutableArray *arr = [NSMutableArray array];
        for (NSUInteger i = self.games.count - allArray.count; j < allArray.count; j++,i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            //            NSLog(@"%d", j);
            [arr addObject:indexPath];
        }
#if 0
        //局部刷新cell，不全部刷新,但是foot会回去让下面看不见
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.tableView insertRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationLeft];
            [self.tableView reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationLeft];
        });
#else
        [self.tableView reloadData];
#endif
        }else{
            if ([self.myDelegate respondsToSelector:@selector(presentMyViewController:)]) {
                UIAlertController *alert = [AppTools alertWithMessage:@"网络不给力啊~" block:^{
                    ;
                }];
                [self.myDelegate presentMyViewController:alert];
            }
        }
        [self.tableView footerEndRefreshing];
        [self.tableView headerEndRefreshing];
    } failBlock:^(NSError *error) {
        NSLog(@"数据请求失败");
        [self.tableView footerEndRefreshing];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.games.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZZGameListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
    
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














- (void)setDataURL:(NSString *)dataURL{
    if (_dataURL != dataURL) {
        [_dataURL release];
        _dataURL = [dataURL copy];
        [self loadData];
    }
}

- (void)setGames:(NSMutableArray<ZZZGameListModel *> *)games{
    if (_games != games) {
        [_games release];
        _games = [games retain];
    }
    [self.tableView reloadData];
}






/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
