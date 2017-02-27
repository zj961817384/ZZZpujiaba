//
//  ZZZHomeView.m
//  pujiaba
//
//  Created by zzzzz on 15/12/26.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZHomeView.h"
#import "ZZZBaseCollectionView.h"
#import "MyCollectionView.h"
#import "ZZZGameDetailViewController.h"
#import "ZZZGameViewController.h"
#import "MJRefresh.h"
#import "ZZZTagGameViewController.h"
#import "ZZZBaseLabel.h"

#define COLLECTIONCELLIDEN @"cellC"

@interface ZZZHomeView ()<MyCollectionViewDelegate, UIScrollViewDelegate>

@property (nonatomic, retain) MyCollectionView *collectionView;

@property (nonatomic, retain) UIScrollView *focusView;

@property (nonatomic, retain) NSFileManager *fileManager;

@property (nonatomic, retain) NSTimer       *focusTimer;

@property (nonatomic, retain) UIActivityIndicatorView *indicator;

@end

@implementation ZZZHomeView

- (void)dealloc{
    [_collectionView release];
    [_focus release];
    [_list_tag release];
    [_list_hotArray release];
    [_list_newArray release];
    [_focusView release];
    [_fileManager release];
    [_focusTimer release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.fileManager = [NSFileManager defaultManager];
        self.focus = [NSMutableArray array];
        self.list_newArray = [NSMutableArray array];
        self.list_hotArray = [NSMutableArray array];
        [self createSubview];
        
        self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.indicator.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.indicator.frame = self.bounds;
        [self addSubview:self.indicator];
        [_indicator release];
        [self.indicator startAnimating];
        
        [self addObserver:self forKeyPath:@"focus" options:NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([@"focus" isEqualToString:keyPath]) {
        if (change[@"old"] == nil) {
            [self.indicator stopAnimating];
            [UIView animateWithDuration:1 animations:^{
                self.indicator.alpha = 0;
            } completion:^(BOOL finished) {
                [self.indicator removeFromSuperview];
            }];
        }else{
            if ([change[@"old"] count] == 0) {
                [self.indicator stopAnimating];
                [UIView animateWithDuration:1 animations:^{
                    self.indicator.alpha = 0;
                } completion:^(BOOL finished) {
                    [self.indicator removeFromSuperview];
                }];
            }
        }
        [self removeObserver:self forKeyPath:@"focus"];
    }
}

- (void)reloadMyCollectionView{
    for (UIView *v in [self subviews]) {
        [v removeFromSuperview];
    }
//    self.focus = [NSMutableArray array];
//    self.list_newArray = [NSMutableArray array];
//    self.list_hotArray = [NSMutableArray array];
//    [self.collectionView removeFromSuperview];
////    [_collectionView release];
//    [self.focusView removeFromSuperview];
//    [_focusView release];
    
    [self createSubview];
}

- (void)createSubview{
    
    self.collectionView = [[MyCollectionView alloc] initWithFrame:self.frame];
    self.collectionView.myDelegate = self;
    self.collectionView.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.collectionView.itemSize = CGSizeMake((WIDTH - 10 - 10) / 3, (WIDTH - 10 - 10) / 3 + 30);
    self.collectionView.minimumLineSpacing = 5;
    self.collectionView.minimumInteritemSpacing = 5;
//    [self.collectionView addHeaderWithCallback:^{
//        [self reloadMyCollectionView];
//    }];
    [self addSubview:self.collectionView];
    [_collectionView release];
    
    self.focusView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 5, WIDTH - 10, (WIDTH - 10) / 1.825)];
    self.focusView.delegate = self;
//    [self.focusView setBackgroundColor:[UIColor yellowColor]];
    self.focusView.pagingEnabled = YES;
    self.focusView.bounces = NO;
    //    self.focusView.showsHorizontalScrollIndicator = NO;
    [_focusView release];
}

- (void)setFocus:(NSMutableArray<ZZZGameScrollModel *> *)focus{
    
    if (_focus != focus) {
        [_focus release];
        _focus = [focus retain];
        NSInteger n = _focus.count;
        self.focusView.contentSize = CGSizeMake(self.focusView.frame.size.width * n, self.focusView.frame.size.height);
//        for (int i = 0; i < n; i++) {
//            NSLog(@"%@", focus[i].image);
//        }
        [self setBanner];
    }
}
//
//- (void)getDataFromNet{
//    
//}
//
//- (void)loadData{
//    [self getDataFromNet];
//}

- (void)setBanner{
    NSFileManager *manager = [NSFileManager defaultManager];
    for (int i = 0; i < self.focus.count; i++) {
        CGFloat w = self.focusView.frame.size.width;
        CGFloat h = self.focusView.frame.size.height;
        NSArray *arr = [self.focus[i].image componentsSeparatedByString:@"/"];
        NSMutableArray *folders = [NSMutableArray arrayWithObjects:@"Cache", nil];
        for (NSString *c in arr) {
            if ([c containsString:@"."]) {
                break;
            }
            if (![c isEqualToString:@"/"]) {
                [folders addObject:c];
            }
        }
        NSString *imgPath = [AppTools createImageLocalPathUseUrl:self.focus[i].image withFolders:folders];
        if ([manager fileExistsAtPath:imgPath]) {
            NSData *resultData = [NSData dataWithContentsOfFile:imgPath];
            UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(i * w, 0, w, h)];
            imgV.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewClick:)];
            [imgV addGestureRecognizer:tap];
            [tap release];
            imgV.image = [UIImage imageWithData:resultData];
            [self.focusView addSubview:imgV];
            //            [self makeAutoScroll];
//            [self.indicator removeFromSuperview];
            [imgV release];
        }else{
            [AppTools getDataFromNetUseGETMethodWithUrl:[BASE_URL stringByAppendingPathComponent:self.focus[i].image] andParameters:nil successBlock:^(NSData *resultData) {
                UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(i * w, 0, w, h)];
                imgV.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewClick:)];
                [imgV addGestureRecognizer:tap];
                [tap release];
                imgV.image = [UIImage imageWithData:resultData];
                [self.focusView addSubview:imgV];
                [imgV release];
                [resultData writeToFile:imgPath atomically:YES];
            } failBlock:^(NSError *error) {
                NSLog(@"图片请求失败");
                UIAlertController *alert = [AppTools alertWithMessage:@"网络不给力啊！" block:^{
                    ;
                }];
                [self.myDelegate presentMyViewController:alert];[self.indicator stopAnimating];
                [UIView animateWithDuration:1 animations:^{
                    self.indicator.alpha = 0;
                } completion:^(BOOL finished) {
                    [self.indicator removeFromSuperview];
                }];
            }];
        }
    }
//    [self makeAutoScroll];
}

- (void)makeAutoScroll{
    if (self.focusTimer == nil) {
        self.focusTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerProc) userInfo:nil repeats:YES];
    }
}

- (void)timerProc{
    CGPoint pt = self.focusView.contentOffset;
    pt.x += self.focusView.frame.size.width;
    if (pt.x >= self.self.focusView.frame.size.width * self.focus.count) {
        pt.x = 0;
    }
    [self.focusView setContentOffset:pt animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    if (self.focusTimer == nil) {
//    self.focusTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerProc) userInfo:nil repeats:YES];
//    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    if (self.focusTimer != nil) {
//        [self.focusTimer invalidate];
//        self.focusTimer = nil;
//    }
}

- (void)setList_hotArray:(NSMutableArray<ZZZGameListModel *> *)list_hotArray{
    if (_list_hotArray != list_hotArray) {
        [_list_hotArray release];
        _list_hotArray = [list_hotArray retain];
    }
//    [self.collectionView reloadData];
}

- (void)setList_newArray:(NSMutableArray<ZZZGameListModel *> *)list_newArray{
    if (_list_newArray != list_newArray) {
        [_list_newArray release];
        _list_newArray = [list_newArray retain];
    }
    //因为最后赋值的是new，所以只在这些reloaddata
    [self.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(MyCollectionView *)collectionView{
    return 3;
}

- (NSInteger)collectionView:(MyCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    } else if (section == 1) {
        return self.list_hotArray.count > 6 ? 6 : self.list_hotArray.count;
    }else {
        return self.list_newArray.count > 6 ? 6 : self.list_newArray.count;
    }
}

- (UIView *)collectionView:(MyCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.collectionView.itemSize.width, collectionView.itemSize.height)];
//    [view setBackgroundColor:[UIColor greenColor]];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 30, view.frame.size.width, 30)];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:14];
    [view addSubview:title];
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height - 30)];
    imgV.userInteractionEnabled = YES;
    title.userInteractionEnabled = YES;
    [view addSubview:imgV];
    ZZZGameListModel *model;
    if (indexPath.section == 1) {
        model = self.list_hotArray[indexPath.row];
    } else{
        model = self.list_newArray[indexPath.row];
    }
    
    NSArray *arr = [model.icon componentsSeparatedByString:@"/"];
    NSMutableArray *folders = [NSMutableArray arrayWithObjects:@"Cache", nil];
    for (NSString *c in arr) {
        if ([c containsString:@"."]) {
            break;
        }
        if (![c isEqualToString:@"/"]) {
            [folders addObject:c];
        }
    }
    NSString *iconPath = [AppTools createImageLocalPathUseUrl:model.icon withFolders:folders];
    if ([self.fileManager fileExistsAtPath:iconPath]) {
        NSData *resultData = [NSData dataWithContentsOfFile:iconPath];
        imgV.image = [UIImage imageWithData:resultData];
    }else{
        [AppTools getDataFromNetUseGETMethodWithUrl:[BASE_URL stringByAppendingPathComponent:model.icon] andParameters:nil successBlock:^(NSData *resultData) {
            NSLog(@"网络获取图片成功");
            imgV.image = [UIImage imageWithData:resultData];
            [resultData writeToFile:iconPath atomically:YES];
        } failBlock:^(NSError *error) {
            NSLog(@"网络获取图片失败");
        }];
    }
    title.text = model.title_cn;
    
    [title release];
    [imgV release];
    
    return [view autorelease];
    
}

- (UIView *)collectionView:(MyCollectionView *)collectionView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return self.focusView;
    }else if (section == 1){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH - collectionView.sectionInset.left - collectionView.sectionInset.right, (WIDTH - collectionView.sectionInset.left - collectionView.sectionInset.right) / 9.125 + 40)];
        

        //设置标签
        NSString *nightModel = [USERDEFAULT objectForKey:CURRENT_SKIN];
        CGFloat w = (view.frame.size.width - 10 * 3) / 4;
        for (int i = 0; i < self.list_tag.count; i++) {
            ZZZBaseLabel *tags_label = [[ZZZBaseLabel alloc] initWithFrame:CGRectMake((10 + w) * i, 0, w, w / 2.3)];
            tags_label.whiteBackColor = [UIColor colorWithRed:0.149 green:0.561 blue:0.380 alpha:1.000];
            tags_label.nightBackColor = [UIColor colorWithRed:0.056 green:0.092 blue:0.182 alpha:1.000];
            if ([@"night" isEqualToString:nightModel]) {
                [tags_label setBackgroundColor:tags_label.nightBackColor];
                [tags_label setTextColor:tags_label.nightTextColor];
            }else{
                [tags_label setBackgroundColor:tags_label.whiteBackColor];
                [tags_label setTextColor:tags_label.whiteTextColor];
            }
            
#warning 只有这个地方释放了label😒，有时候转换夜间模式的时候，就会出现消息发送给已经被dealloc的对象😭
            tags_label.font = [UIFont systemFontOfSize:15];
            tags_label.textAlignment = NSTextAlignmentCenter;
            tags_label.text = self.list_tag[i];
            [view addSubview:tags_label];
            [tags_label release];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagClick:)];
            tags_label.userInteractionEnabled = YES;
            [tags_label addGestureRecognizer:tap];
            [tap release];
        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 40, view.frame.size.width - 60, 40)];
        label.text = @"热门游戏";
        label.font = [UIFont systemFontOfSize:20];
        [view addSubview:label];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(view.frame.size.width - 60, view.frame.size.height - 40 + 5, 60, 30);
        [button setTitle:@"更多..." forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(moreHotGames:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        [label release];
        return [view autorelease];
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH - collectionView.sectionInset.left - collectionView.sectionInset.right, 40)];
        UILabel *label = [[UILabel alloc] initWithFrame:view.frame];
        label.text = @"最新游戏";
        label.font = [UIFont systemFontOfSize:20];
        [view addSubview:label];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(label.frame.size.width - 60, 5, 60, 30);
        [button setTitle:@"更多..." forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(moreNewGames:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        [label release];
        
        return [view autorelease];
    }
}

- (void)collectionView:(MyCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        ZZZGameListModel *mo = [self.list_hotArray objectAtIndex:indexPath.row];
        NSLog(@"%@", mo.title_cn);
        ZZZGameDetailViewController *detailViewController= [[ZZZGameDetailViewController alloc] init];
        detailViewController.model = mo;
        [self.myDelegate pushMyViewController:detailViewController];
    }else if (indexPath.section == 2){
        ZZZGameListModel *mo = self.list_newArray[indexPath.row];
        NSLog(@"%@", mo.title_cn);
        ZZZGameDetailViewController *detailViewController= [[ZZZGameDetailViewController alloc] init];
        detailViewController.model = mo;
        [self.myDelegate pushMyViewController:detailViewController];
    }
}

- (void)moreHotGames:(UIButton *)button{
    NSLog(@"更多热门游戏");
    ZZZGameViewController *vc = [[ZZZGameViewController alloc] initWithGameListURL:HOT_GAMELIST_URL];

    vc.title = @"热门游戏";
//    vc.gameListURL = HOT_GAMELIST_URL;
    [self.myDelegate pushMyViewController:vc];
    [vc release];
}

- (void)moreNewGames:(UIButton *)button{
    NSLog(@"更多新游戏");
    [self.myDelegate showMoreNewGames];
}

/**
 *  点击标签触发事件
 */
- (void)tagClick:(UITapGestureRecognizer *)tap{
    UILabel *label = (UILabel *)tap.view;
    NSString *text = label.text;
    NSLog(@"%@", text);
    
    ZZZTagGameViewController *tagController = [[ZZZTagGameViewController alloc] initWithTagName:text];
    [self.myDelegate pushMyViewController:tagController];
    [tagController release];
    
}

- (void)scrollViewClick:(UITapGestureRecognizer *)tap{
    int n = self.focusView.contentOffset.x / self.focusView.frame.size.width;
//    NSLog(@"%d", n);
    ZZZGameScrollModel *mo = self.focus[n];
    ZZZGameDetailViewController *detailViewController= [[ZZZGameDetailViewController alloc] init];
    detailViewController.model = mo;
    [self.myDelegate pushMyViewController:detailViewController];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
