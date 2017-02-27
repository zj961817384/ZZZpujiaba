//
//  ZZZCommentsTableView.m
//  pujiaba
//
//  Created by zzzzz on 15/12/30.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZCommentsTableView.h"
#import "ZZZCommentCell.h"
#import "MJRefresh.h"

@interface ZZZCommentsTableView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSMutableArray<ZZZCommentModel *> *list_comment;
@property (nonatomic, retain) NSMutableArray<NSNumber *>       *heightForRow;

@end

@implementation ZZZCommentsTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        //这个高度的数组，如果不设置第一个的话，后面显示的时候都是从5开始显示，可能是因为最先显示的不是言弹部分，而整个打的tableview言弹部分超出下面的范围，所以下面的显示，但是上面部分不显示
        self.heightForRow = [NSMutableArray arrayWithObjects:@(80), nil];
        self.list_comment = [NSMutableArray array];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[ZZZCommentCell class] forCellReuseIdentifier:@"cell1"];
//        [self addFooterWithCallback:^{
//            [self loadMoreData];
//        }];
        [self addHeaderWithCallback:^{
            [self loadData];
        }];
        //加了这个方法，整个tableview都会向上移动
//        [self headerBeginRefreshing];
//        [self loadData];
    }
    return self;
}

- (void)loadData{
    //如果点击theroom就会crash，本来是请求两次数据，但是都不对
    [AppTools getDataFromNetUseGETMethodWithUrl:[COMMENTS_URL stringByAppendingPathComponent:self.pack] andParameters:nil successBlock:^(NSData *resultData) {
        if (resultData.length > 0) {
            [self.list_comment removeAllObjects];
            NSDictionary *d = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            for (NSDictionary *dic in [d objectForKey:COMMENTS_LIST]) {
                ZZZCommentModel *m = [[ZZZCommentModel alloc] init];
                [m setValuesForKeysWithDictionary:dic];
                [self.list_comment addObject:m];
                [m release];
                while (self.heightForRow.count < self.list_comment.count) {
                    [self.heightForRow addObject:@(0)];
                }
            }
            [self reloadData];
            if ([[d objectForKey:COMMENTS_LIST] count] == 0) {
                [self removeFooter];
            }else{
                [self addFooterWithCallback:^{
                    [self loadMoreData];
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
        [self footerEndRefreshing];
        [self headerEndRefreshing];
        
    } failBlock:^(NSError *error) {
        NSLog(@"网络请求数据失败：%@", error);
    }];
}

- (void)loadMoreData{
    if (self.list_comment.count > 0) {
        NSDictionary *paramegers = @{@"since_id":[NSNumber numberWithInteger:self.list_comment[self.list_comment.count - 1].comment_id]};
        [AppTools getDataFromNetUseGETMethodWithUrl:[COMMENTS_URL stringByAppendingPathComponent:self.pack] andParameters:paramegers successBlock:^(NSData *resultData) {
            if (resultData.length > 0) {
                NSDictionary *d = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                for (NSDictionary *dic in [d objectForKey:COMMENTS_LIST]) {
                    ZZZCommentModel *m = [[ZZZCommentModel alloc] init];
                    [m setValuesForKeysWithDictionary:dic];
                    [self.list_comment addObject:m];
                    [m release];
                    while (self.heightForRow.count < self.list_comment.count) {
                        [self.heightForRow addObject:@(0)];
                    }
                }
                [self reloadData];
                if ([[d objectForKey:COMMENTS_LIST] count] == 0) {
                    [self removeFooter];
                    UIAlertController *alert = [AppTools alertWithMessage:@"没有更多数据了~" block:^{
                        ;
                    }];
                    [self.myDelegate presentMyViewController:alert];
                }
            }else{
                if ([self.myDelegate respondsToSelector:@selector(presentMyViewController:)]) {
                    UIAlertController *alert = [AppTools alertWithMessage:@"网络不给力啊~" block:^{
                        ;
                    }];
                    [self.myDelegate presentMyViewController:alert];
                }
            }
            [self footerEndRefreshing];
            [self headerEndRefreshing];
            
        } failBlock:^(NSError *error) {
            if ([self.myDelegate respondsToSelector:@selector(presentMyViewController:)]) {
                UIAlertController *alert = [AppTools alertWithMessage:@"没有拿到数据 T.T " block:^{
                    ;
                }];
                [self.myDelegate presentMyViewController:alert];
            }
            NSLog(@"网络请求数据失败：%@", error);
        }];
    }else{
        [self loadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list_comment.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZZCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    cell.model = self.list_comment[indexPath.row];
    self.heightForRow[indexPath.row] = [NSNumber numberWithFloat:cell.cellHeight];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%d %f", indexPath.row, [self.heightForRow[indexPath.row] floatValue]);
    return [self.heightForRow[indexPath.row] floatValue];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self) {
        [self.myDelegate scrollViewDidScroll:scrollView];
    }
}



- (void)setPack:(NSString *)pack{
    if (_pack != pack) {
        [_pack release];
        _pack = [pack copy];
        [self loadData];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
