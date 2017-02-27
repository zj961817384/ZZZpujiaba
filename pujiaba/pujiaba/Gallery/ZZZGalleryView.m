//
//  ZZZGalleryView.m
//  pujiaba
//
//  Created by zzzzz on 15/12/28.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZGalleryView.h"
#import "ZZZBaseCollectionView.h"
#import "ZZZBaseScrollView.h"
#import "ZZZBaseTableView.h"
#import "ZZZBaseButton.h"
#import "ZZZGalleryCollectionCell.h"
#import "ZZZGalleryModel.h"
#import "MJRefresh.h"
#import "ZZZAlbumViewController.h"
#import "ZZZCircleButtonView.h"
#import "ZZZSleepTableViewCell.h"
#import "ZZZSleepTalkModel.h"

@interface ZZZGalleryView ()<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

#pragma mark -- 视图
/** 画廊CollectionView */
@property (nonatomic, retain) ZZZBaseCollectionView *galleryCollectionView;
/** 陪睡TableView */
@property (nonatomic, retain) ZZZBaseTableView      *sleepTableView;
/** 上面的选择视图 */
@property (nonatomic, retain) ZZZBaseView           *headView;
/** 选择视图底部的线 */
@property (nonatomic, retain) ZZZBaseView           *bottomLine;
/** 指示器视图 */
@property (nonatomic, retain) ZZZBaseView           *indicatorView;
/** 承载两个部分的ScrollView */
@property (nonatomic, retain) ZZZBaseScrollView     *bodyScrollView;

#pragma mark -- 数据
/** 当前要请求的链接 */
@property (nonatomic, copy) NSString                *currentURL;
/** 当前显示的数据源 */
@property (nonatomic, retain) NSMutableArray<ZZZGalleryModel *>             *dataArray;
/** 游戏图片数据源 */
@property (nonatomic, retain) NSMutableArray<ZZZGalleryModel *>             *gameArray;
/** 插图图片数据源 */
@property (nonatomic, retain) NSMutableArray<ZZZGalleryModel *>                     *pictureArray;
/** 妹子图片数据源 */
@property (nonatomic, retain) NSMutableArray<ZZZGalleryModel *>                 *girlArray;
/** 当前显示的是什么相册0：妹子、1：游戏、2：插图 */
@property (nonatomic, assign) NSInteger     currentGallery;


@property (nonatomic, retain) ZZZCircleButtonView *menuCircleButton;
/**
 *  菜单状态，yes代表弹出，no代表没有弹出
 */
@property (nonatomic, assign) BOOL                menuStatu;
@property (nonatomic, retain) NSMutableArray<ZZZCircleButtonView*> *subMenuButtons;
/** 让菜单按钮可以移动 */
@property (nonatomic, assign) CGPoint   oldPt;
/** 聊天对象数组 */
@property (nonatomic, retain) NSMutableArray<ZZZSleepTalkModel *> *sleepArray;

@end

@implementation ZZZGalleryView

- (void)dealloc{
    [_galleryCollectionView release];
    [_sleepTableView release];
    [_headView release];
    [_bottomLine release];
    [_indicatorView release];
    [_bodyScrollView release];
    
    [_currentURL release];
    [_dataArray release];
    [_gameArray release];
    [_girlArray release];
    [_pictureArray release];
    
    [_menuCircleButton release];
    [_subMenuButtons release];
    
    [_sleepArray release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.menuStatu = NO;
        self.currentURL = GALLERYGAME_URL;
        self.currentGallery = 1;
        self.dataArray = [NSMutableArray array];
        self.gameArray = [NSMutableArray array];
        self.girlArray = [NSMutableArray array];
        self.pictureArray = [NSMutableArray array];
        ZZZSleepTalkModel *talk = [[ZZZSleepTalkModel alloc] init];
        talk.title = @"扑家";
        talk.text = @"发送内容包含“陪我睡”或“跟你睡”计科进行陪睡\n用#号括起人名还可以店面哦，比如#福山润#陪我睡";
        talk.avatar_url = @"";
        self.sleepArray = [NSMutableArray arrayWithObjects:talk, nil];
        [self createSubview];
        [self loadData];
    }
    return self;
}

- (void)createSubview{
    self.headView = [[ZZZBaseView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH / 7.6)];
//    [self.headView setBackgroundColor:[UIColor colorWithWhite:0.956 alpha:1.000]];
    self.headView.nightColor = [UIColor colorWithWhite:0.226 alpha:1.000];
    self.headView.whiteColor = [UIColor colorWithWhite:0.956 alpha:1.000];
    if ([@"night" isEqualToString:[USERDEFAULT objectForKey:CURRENT_SKIN]]) {
        [self.headView setBackgroundColor:self.headView.nightColor];
    }else{
        [self.headView setBackgroundColor:self.headView.whiteColor];
    }
    [self addSubview:self.headView];
    [_headView release];
    
#pragma mark -- 上面可以点的两个按钮
    ZZZBaseButton *galleryButton = [ZZZBaseButton buttonWithType:UIButtonTypeCustom];
    galleryButton.frame = CGRectMake(0, 0, self.headView.frame.size.width / 4, self.headView.frame.size.height);
    [galleryButton setTitle:@"图库" forState:UIControlStateNormal];
    galleryButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [galleryButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [galleryButton addTarget:self action:@selector(headButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:galleryButton];
    
#pragma mark -- 两个按钮之间的分割线
    ZZZBaseView *separ = [[ZZZBaseView alloc] initWithFrame:CGRectMake(galleryButton.frame.size.width - 0.5, 10, 1, self.headView.frame.size.height - 20)];
    [separ setBackgroundColor:[UIColor grayColor]];
    [self.headView addSubview:separ];
    [separ release];
    
    ZZZBaseButton *sleepButton = [ZZZBaseButton buttonWithType:UIButtonTypeCustom];
    sleepButton.frame = CGRectMake(galleryButton.frame.size.width, 0, self.headView.frame.size.width / 4, self.headView.frame.size.height);
    [sleepButton setTitle:@"福利" forState:UIControlStateNormal];
    sleepButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [sleepButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [sleepButton addTarget:self action:@selector(headButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:sleepButton];
    
#pragma mark -- 创建底下的蓝线
    self.bottomLine = [[ZZZBaseView alloc] initWithFrame:CGRectMake(0, self.headView.frame.size.height - 3, self.headView.frame.size.width, 3)];
    [self.headView addSubview:self.bottomLine];
//    self.bottomLine.whiteColor = [UIColor colorWithRed:0.149 green:0.557 blue:0.376 alpha:1.000];
    self.bottomLine.nightColor = [UIColor lightGrayColor];
    if ([@"night" isEqualToString:[USERDEFAULT objectForKey:CURRENT_SKIN]]) {
        [self.bottomLine setBackgroundColor:self.bottomLine.nightColor];
    }else{
        [self.bottomLine setBackgroundColor:self.bottomLine.whiteColor];
    }

    [_bottomLine release];
    
#pragma mark -- 创建指示器的蓝线
    self.indicatorView = [[ZZZBaseView alloc] initWithFrame:CGRectMake(0, self.headView.frame.size.height - 8, galleryButton.frame.size.width, 8)];
    [self.headView addSubview:self.indicatorView];
    self.indicatorView.nightColor = [UIColor lightGrayColor];
    if ([@"night" isEqualToString:[USERDEFAULT objectForKey:CURRENT_SKIN]]) {
        [self.indicatorView setBackgroundColor:self.indicatorView.nightColor];
    }else{
        [self.indicatorView setBackgroundColor:self.indicatorView.whiteColor];
    }
    [_indicatorView release];
    
#pragma mark -- 创建承载画廊和陪睡scrollview
    self.bodyScrollView = [[ZZZBaseScrollView alloc] initWithFrame:CGRectMake(0, self.headView.frame.origin.y + self.headView.frame.size.height, WIDTH, self.frame.size.height - self.headView.frame.origin.y - self.headView.frame.size.height)];
    [self.bodyScrollView setBackgroundColor:[UIColor whiteColor]];
    self.bodyScrollView.pagingEnabled = YES;
    self.bodyScrollView.bounces = NO;
    self.bodyScrollView.delegate = self;
    self.bodyScrollView.contentSize = CGSizeMake(self.bodyScrollView.frame.size.width * 2, self.bodyScrollView.frame.size.height);
    self.bodyScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.bodyScrollView];
    [_bodyScrollView release];
    
//    UIView *del = [[UIView alloc] initWithFrame:CGRectMake(200, 300, 200, 40)];
//    [del setBackgroundColor:[UIColor blackColor]];
//    [self.bodyScrollView addSubview:del];
//    [del release];
#pragma mark -- 创建画廊collectionview
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((WIDTH - 20) / 2.0, (WIDTH - 20) / 2.0 + 40);
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    
    self.galleryCollectionView = [[ZZZBaseCollectionView alloc] initWithFrame:self.bodyScrollView.bounds collectionViewLayout:layout];
    self.galleryCollectionView.delegate = self;
    self.galleryCollectionView.dataSource = self;
    self.galleryCollectionView.whiteColor = [UIColor colorWithWhite:0.924 alpha:1.000];
    if ([@"night" isEqualToString:[USERDEFAULT objectForKey:CURRENT_SKIN]]) {
        ;
    }else{
        self.galleryCollectionView.backgroundColor = self.galleryCollectionView.whiteColor;
    }
    [self.bodyScrollView addSubview:self.galleryCollectionView];
    [_galleryCollectionView release];
    [layout release];
    
    [self.galleryCollectionView registerClass:[ZZZGalleryCollectionCell class] forCellWithReuseIdentifier:@"collectionCell1"];
    
    [self.galleryCollectionView addHeaderWithCallback:^{
        [self getDataFromNet];
    }];
    [self.galleryCollectionView headerBeginRefreshing];
    
#pragma mark -- 创建右下角的圆形按钮
    [self createCircleButton];
    
#pragma mark -- 创建聊天tableview
//    self.sleepTableView = [[ZZZBaseTableView alloc] initWithFrame:CGRectMake(WIDTH, 0, WIDTH, self.bodyScrollView.frame.size.height) style:UITableViewStyleGrouped];
////    [self.sleepTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    self.sleepTableView.delegate = self;
//    self.sleepTableView.dataSource = self;
//    [self.sleepTableView registerClass:[ZZZSleepTableViewCell class] forCellReuseIdentifier:@"sleepCell"];
//    [self.bodyScrollView addSubview:self.sleepTableView];
//    [_sleepTableView release];
    
}

#pragma mark -- 创建右下角的圆形按钮
- (void)createCircleButton{
    
    self.subMenuButtons = [NSMutableArray array];
    
    
    ZZZCircleButtonView *viewButton2 = [[ZZZCircleButtonView alloc] initWithCenterPoint:CGPointMake(self.bodyScrollView.frame.size.width - 40, self.bodyScrollView.frame.size.height - 80) andRadius:25];
    UIImage *img2 = [UIImage imageNamed:@"meinv.png"];
    viewButton2.myIcon = img2;
    [self.bodyScrollView addSubview:viewButton2];
    [self.subMenuButtons addObject:viewButton2];
    [viewButton2 release];
    
    //一个手势只能添加在一个view上面？
    UITapGestureRecognizer *subMenuTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subMenuClickAction:)];
    [viewButton2 addGestureRecognizer:subMenuTap];
    [subMenuTap release];
    
    viewButton2 = [[ZZZCircleButtonView alloc] initWithCenterPoint:CGPointMake(self.bodyScrollView.frame.size.width - 40, self.bodyScrollView.frame.size.height - 80) andRadius:25];
    img2 = [UIImage imageNamed:@"youxi.png"];
    viewButton2.myIcon = img2;
    [self.bodyScrollView addSubview:viewButton2];
    [self.subMenuButtons addObject:viewButton2];
    [viewButton2 release];
    
    subMenuTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subMenuClickAction:)];
    [viewButton2 addGestureRecognizer:subMenuTap];
    [subMenuTap release];
    
    viewButton2 = [[ZZZCircleButtonView alloc] initWithCenterPoint:CGPointMake(self.bodyScrollView.frame.size.width - 40, self.bodyScrollView.frame.size.height - 80) andRadius:25];
    img2 = [UIImage imageNamed:@"chatu.png"];
    viewButton2.myIcon = img2;
    [self.bodyScrollView addSubview:viewButton2];
    [self.subMenuButtons addObject:viewButton2];
    [viewButton2 release];
    
    subMenuTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subMenuClickAction:)];
    [viewButton2 addGestureRecognizer:subMenuTap];
    [subMenuTap release];

    
    
    
    self.menuCircleButton = [[ZZZCircleButtonView alloc] initWithCenterPoint:CGPointMake(self.bodyScrollView.frame.size.width - 40, self.bodyScrollView.frame.size.height - 80) andRadius:25];
    UIImage *img = [UIImage imageNamed:@"menuIcon.png"];
    self.menuCircleButton.myIcon = img;
    [self.bodyScrollView addSubview:self.menuCircleButton];
    [_menuCircleButton release];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainMenuCircleButtonAction:)];
    [self.menuCircleButton addGestureRecognizer:tap];
    [tap release];
    
    //解注这个就可以让按钮可以拖动
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
//    [self.menuCircleButton addGestureRecognizer:pan];
//    [pan release];
    
}
#pragma mark -- 菜单按钮的点击事件
- (void)panGestureAction:(UIPanGestureRecognizer *)pan{
    if(pan.state == UIGestureRecognizerStateBegan){
        self.oldPt = self.menuCircleButton.centerPoint;
    }
    CGPoint newPt;
    CGPoint pt = [pan translationInView:self.self.bodyScrollView];
    newPt.x = pt.x + self.oldPt.x;
    newPt.y = pt.y + self.oldPt.y;
    newPt.x = MAX(newPt.x, 230);
    newPt.x = MIN(newPt.x, WIDTH - 30);
    newPt.y = MAX(newPt.y, 80);
    newPt.y = MIN(newPt.y, HEIGHT - 64 - 40);
    self.menuCircleButton.centerPoint = newPt;
    for (ZZZCircleButtonView *v in self.subMenuButtons) {
        [UIView animateWithDuration:0.2 animations:^{
            v.centerPoint = newPt;
        }];
    }
    NSLog(@"%@", NSStringFromCGPoint(pt));
}

- (void)mainMenuCircleButtonAction:(UITapGestureRecognizer *)tap{
//    int n = (int)self.subMenuButtons.count;
    self.menuStatu = !self.menuStatu;
    if (self.menuStatu) {
#if 0//扇形弹出菜单
        ZZZCircleButtonView *v = (ZZZCircleButtonView *)tap.view;
        CGFloat length = (2 * sqrt(2) + sqrt((20 - 1) + 2 * v.radius))/6;
        for (int i = 0; i < _subMenuButtons.count; i++) {
            CGFloat x = _menuCircleButton.frame.origin.x - cos(i * M_PI_4) * length;
            CGFloat y = _menuCircleButton.frame.origin.y - sin(i * M_PI_4) * length;
            CGPoint pt = CGPointMake(x, y);
            ZZZCircleButtonView *v = _subMenuButtons[i];
            [UIView animateWithDuration:0.4 animations:^{
                v.centerPoint = pt;
            }];
        }
#else
        for (int i = 0; i < _subMenuButtons.count; i++) {
            CGPoint pt = self.menuCircleButton.centerPoint;
            CGFloat radiu = self.menuCircleButton.radius;
            pt.y -= (i + 1) * (radiu * 2 + 30);
            [UIView animateWithDuration:0.2 animations:^{
//                _subMenuButtons[i].frame = CGRectMake(0, 0, radiu * 2, radiu * 2);
                _subMenuButtons[i].centerPoint = pt;
//                _subMenuButtons[i].frame = HCENTER(self.menuCircleButton, _subMenuButtons[i]);
            }];
        }
#endif
    }else{
        for (int i = 0; i < _subMenuButtons.count; i++) {
            [UIView animateWithDuration:0.2 animations:^{
//                _subMenuButtons[i].frame = CGRectMake(0, 0, 1, 1);
                _subMenuButtons[i].centerPoint = self.menuCircleButton.centerPoint;
            }];
        }
    }
}

- (void)subMenuClickAction:(UITapGestureRecognizer *)tap{
    ZZZCircleButtonView *subMenu = (ZZZCircleButtonView *)tap.view;
    int index = (int)[self.subMenuButtons indexOfObject:subMenu];
    if (index != self.currentGallery) {
        self.currentGallery = index;
        switch (index) {
            case 0:
                //菜单1
                NSLog(@"1");
                self.currentURL = [GALLERYOTHER_URL stringByAppendingPathComponent:@"%E7%BE%8E%E5%A5%B3"];
                [self loadData];
                break;
            case 1:
                self.currentURL = GALLERYGAME_URL;
                [self loadData];
                NSLog(@"2");
                //菜单2
                break;
            case 2:
                self.currentURL = [GALLERYOTHER_URL stringByAppendingPathComponent:[@"插图" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                [self loadData];
                NSLog(@"3");
                //菜单3
                break;
            default:
                break;
        }
    }
}

- (void)headButtonClicked:(UIButton *)button{
    CGFloat x = button.frame.origin.x;
    CGPoint pt = CGPointMake(self.bodyScrollView.frame.size.width * x / button.frame.size.width, 0);
    [self.bodyScrollView setContentOffset:pt animated:YES];
    
}

#pragma mark -- collectionview代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZZZGalleryCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell1" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.bodyScrollView) {
        CGRect frame = self.indicatorView.frame;
        frame.origin.x = scrollView.contentOffset.x / scrollView.frame.size.width * frame.size.width;
        self.indicatorView.frame = frame;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ZZZGalleryModel *model = self.dataArray[indexPath.row];
    ZZZAlbumViewController *vc = [[ZZZAlbumViewController alloc] init];
    vc.galleryModel = model;
    [self.myDelegate pushMyViewController:vc];
    //    [vc release];
}
#pragma mark -- 加载数据
- (void)loadData{
    
    switch (self.currentGallery) {
        case 0:
            self.dataArray = self.girlArray;
            break;
        case 1:
            self.dataArray = self.gameArray;
            break;
        case 2:
            self.dataArray = self.pictureArray;
            break;
        default:
            break;
    }
    //如果数组里面没有东西，再去请求
    if (self.dataArray.count == 0) {
        [self getDataFromNet];
    }else{
        [self.galleryCollectionView headerEndRefreshing];
        [self.galleryCollectionView footerEndRefreshing];
        [self.galleryCollectionView reloadData];
    }
}

- (void)getDataFromNet{
        [AppTools getDataFromNetUseGETMethodWithUrl:self.currentURL andParameters:nil successBlock:^(NSData *resultData) {
            if (resultData.length > 0) {
                [self.dataArray removeAllObjects];
                NSMutableDictionary *all = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                for (NSDictionary *dic in [all objectForKey:DATA]) {
                    ZZZGalleryModel *m = [[ZZZGalleryModel alloc] init];
                    [m setValuesForKeysWithDictionary:dic];
                    [self.dataArray addObject:m];
                    [m release];
                }
                [self.galleryCollectionView addFooterWithCallback:^{
                    [self getMoreDataFromNet];
                }];

                [self.galleryCollectionView reloadData];
            }else{
                if ([self.myDelegate respondsToSelector:@selector(presentMyViewController:)]) {
                    UIAlertController *alert = [AppTools alertWithMessage:@"网络不给力啊~" block:^{
                        ;
                    }];
                    [self.myDelegate presentMyViewController:alert];
                }
            }
            [self.galleryCollectionView headerEndRefreshing];
            [self.galleryCollectionView footerEndRefreshing];
        } failBlock:^(NSError *error) {
            [self.galleryCollectionView headerEndRefreshing];
            [self.galleryCollectionView footerEndRefreshing];
            if ([self.myDelegate respondsToSelector:@selector(presentMyViewController:)]) {
                UIAlertController *alert = [AppTools alertWithMessage:@"我的请求失败了 ~T.T~" block:^{
                    ;
                }];
                [self.myDelegate presentMyViewController:alert];
            }
            NSLog(@"网络请求图片数据失败");
        }];
   
}

- (void)getMoreDataFromNet{
    if (self.dataArray.count > 0) {
        
        switch (self.currentGallery) {
            case 0:
                self.dataArray = self.girlArray;
                break;
            case 1:
                self.dataArray = self.gameArray;
                break;
            case 2:
                self.dataArray = self.pictureArray;
                break;
            default:
                break;
        }
        NSDictionary *parameters = @{@"since_id":[NSNumber numberWithInteger:self.dataArray[self.dataArray.count - 1].gallery_id]};
        [AppTools getDataFromNetUseGETMethodWithUrl:self.currentURL andParameters:parameters successBlock:^(NSData *resultData) {
            if (resultData.length > 0) {
                NSMutableDictionary *all = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                for (NSDictionary *dic in [all objectForKey:DATA]) {
                    ZZZGalleryModel *m = [[ZZZGalleryModel alloc] init];
                    [m setValuesForKeysWithDictionary:dic];
                    [self.dataArray addObject:m];
                    [m release];
                }
                [self.galleryCollectionView reloadData];
            }else{
                if ([self.myDelegate respondsToSelector:@selector(presentMyViewController:)]) {
                    UIAlertController *alert = [AppTools alertWithMessage:@"网络不给力啊~" block:^{
                        ;
                    }];
                    [self.myDelegate presentMyViewController:alert];
                }
            }
            [self.galleryCollectionView headerEndRefreshing];
            [self.galleryCollectionView footerEndRefreshing];
        } failBlock:^(NSError *error) {
            if ([self.myDelegate respondsToSelector:@selector(presentMyViewController:)]) {
                UIAlertController *alert = [AppTools alertWithMessage:@"我没有拿到数据 T.T" block:^{
                    ;
                }];
                [self.myDelegate presentMyViewController:alert];
            }
            [self.galleryCollectionView headerEndRefreshing];
            [self.galleryCollectionView footerEndRefreshing];
            NSLog(@"网络请求图片数据失败");
        }];
    }else{
        [self.galleryCollectionView headerEndRefreshing];
        [self.galleryCollectionView footerEndRefreshing];
        [self.galleryCollectionView reloadData];
    }
}

#pragma mark -- tableview代理事件
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sleepArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZZSleepTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sleepCell"];
    
    cell.sleepModel = self.sleepArray[indexPath.row];
    
    return cell;
}



@end
