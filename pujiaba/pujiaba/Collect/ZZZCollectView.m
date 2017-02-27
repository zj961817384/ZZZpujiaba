//
//  ZZZCollectView.m
//  pujiaba
//
//  Created by zzzzz on 15/12/28.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZCollectView.h"
#import "ZZZBaseTableView.h"
#import "ZZZBaseCollectionView.h"
#import "ZZZBaseScrollView.h"
#import "ZZZBaseButton.h"
#import "ZZZTagCollectViewCell.h"
#import "ZZZBaseTableViewCell.h"
#import "ZZZGameDetailViewController.h"
#import "ZZZTagGameViewController.h"
#import "ZZZGameScrollModel.h"

@interface ZZZCollectView ()<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

/** 标签CollectionView */
@property (nonatomic, retain) ZZZBaseCollectionView *tagCollectionView;
/** 游戏TableView */
@property (nonatomic, retain) ZZZBaseTableView      *gameTable;
/** 上面的选择视图 */
@property (nonatomic, retain) ZZZBaseView           *headView;
/** 选择视图底部的线 */
@property (nonatomic, retain) ZZZBaseView           *bottomLine;
/** 指示器视图 */
@property (nonatomic, retain) ZZZBaseView           *indicatorView;
/** 承载两个部分的ScrollView */
@property (nonatomic, retain) ZZZBaseScrollView     *bodyScrollView;


@end

@implementation ZZZCollectView

- (void)dealloc{
    [_tagCollectionView release];
    [_gameTable release];
    [_headView release];
    [_bottomLine release];
    [_indicatorView release];
    [_bodyScrollView release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubview];
        self.tagArray = [NSMutableArray array];
        self.gameArray = [NSMutableArray array];
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
    
    ZZZBaseButton *galleryButton = [ZZZBaseButton buttonWithType:UIButtonTypeCustom];
    galleryButton.frame = CGRectMake(0, 0, self.headView.frame.size.width / 4, self.headView.frame.size.height);
    [galleryButton setTitle:@"标签" forState:UIControlStateNormal];
    galleryButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [galleryButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [galleryButton addTarget:self action:@selector(headButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:galleryButton];
    
    ZZZBaseView *separ = [[ZZZBaseView alloc] initWithFrame:CGRectMake(galleryButton.frame.size.width - 0.5, 10, 1, self.headView.frame.size.height - 20)];
    [separ setBackgroundColor:[UIColor grayColor]];
    [self.headView addSubview:separ];
    [separ release];
    
    ZZZBaseButton *sleepButton = [ZZZBaseButton buttonWithType:UIButtonTypeCustom];
    sleepButton.frame = CGRectMake(galleryButton.frame.size.width, 0, self.headView.frame.size.width / 4, self.headView.frame.size.height);
    [sleepButton setTitle:@"游戏" forState:UIControlStateNormal];
    sleepButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [sleepButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [sleepButton addTarget:self action:@selector(headButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:sleepButton];
    
    self.bottomLine = [[ZZZBaseView alloc] initWithFrame:CGRectMake(0, self.headView.frame.size.height - 3, self.headView.frame.size.width, 3)];
    [self.headView addSubview:self.bottomLine];
    self.bottomLine.nightColor = [UIColor lightGrayColor];
    if ([@"night" isEqualToString:[USERDEFAULT objectForKey:CURRENT_SKIN]]) {
        [self.bottomLine setBackgroundColor:self.bottomLine.nightColor];
    }else{
        [self.bottomLine setBackgroundColor:self.bottomLine.whiteColor];
    }
    [_bottomLine release];
    
    self.indicatorView = [[ZZZBaseView alloc] initWithFrame:CGRectMake(0, self.headView.frame.size.height - 8, galleryButton.frame.size.width, 8)];
    [self.headView addSubview:self.indicatorView];
    self.indicatorView.nightColor = [UIColor lightGrayColor];
    if ([@"night" isEqualToString:[USERDEFAULT objectForKey:CURRENT_SKIN]]) {
        [self.indicatorView setBackgroundColor:self.indicatorView.nightColor];
    }else{
        [self.indicatorView setBackgroundColor:self.indicatorView.whiteColor];
    }
    [_indicatorView release];
    
    
    self.bodyScrollView = [[ZZZBaseScrollView alloc] initWithFrame:CGRectMake(0, self.headView.frame.origin.y + self.headView.frame.size.height, WIDTH, self.frame.size.height - self.headView.frame.origin.y - self.headView.frame.size.height)];
    [self.bodyScrollView setBackgroundColor:[UIColor whiteColor]];
    self.bodyScrollView.pagingEnabled = YES;
    self.bodyScrollView.bounces = NO;
    self.bodyScrollView.delegate = self;
    self.bodyScrollView.contentSize = CGSizeMake(self.bodyScrollView.frame.size.width * 2, self.bodyScrollView.frame.size.height);
    [self addSubview:self.bodyScrollView];
    [_bodyScrollView release];
    
    //    UIView *del = [[UIView alloc] initWithFrame:CGRectMake(200, 300, 200, 40)];
    //    [del setBackgroundColor:[UIColor blackColor]];
    //    [self.bodyScrollView addSubview:del];
    //    [del release];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((WIDTH - 25) / 4 , ((WIDTH - 25) / 4) / 2);
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    
    self.tagCollectionView = [[ZZZBaseCollectionView alloc] initWithFrame:self.bodyScrollView.bounds collectionViewLayout:layout];
    self.tagCollectionView.delegate = self;
    self.tagCollectionView.dataSource = self;
    [self.bodyScrollView addSubview:self.tagCollectionView];
    [_tagCollectionView release];
    [layout release];
    
    [self.tagCollectionView registerClass:[ZZZTagCollectViewCell class] forCellWithReuseIdentifier:@"collectionCellTag"];
    
    self.gameTable = [[ZZZBaseTableView alloc] initWithFrame:CGRectMake(WIDTH, 0, self.bodyScrollView.frame.size.width, self.bodyScrollView.frame.size.height) style:UITableViewStylePlain];
    self.gameTable.delegate = self;
    self.gameTable.dataSource = self;
    [self.gameTable registerClass:[ZZZBaseTableViewCell class] forCellReuseIdentifier:@"tableCellGame"];
    [self.bodyScrollView addSubview:self.gameTable];
    
}

- (void)headButtonClicked:(UIButton *)button{
    CGFloat x = button.frame.origin.x;
    CGPoint pt = CGPointMake(self.bodyScrollView.frame.size.width * x / button.frame.size.width, 0);
    [self.bodyScrollView setContentOffset:pt animated:YES];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.tagArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZZZTagCollectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCellTag" forIndexPath:indexPath];
    cell.tagName = self.tagArray[indexPath.row];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.bodyScrollView) {
        CGRect frame = self.indicatorView.frame;
        frame.origin.x = scrollView.contentOffset.x / scrollView.frame.size.width * frame.size.width;
        self.indicatorView.frame = frame;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return MAX(self.gameArray.count, 1);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.gameArray.count > 0) {
        tableView.scrollEnabled = YES;
        return 50;
    }else{
        tableView.scrollEnabled = NO;
        return self.bodyScrollView.frame.size.height;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZZBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCellGame"];
    if (self.gameArray.count == 0) {
        cell.textLabel.text = @"~~你还没有收藏任何游戏~~";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.text = self.gameArray[indexPath.row].gameName;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.gameArray.count == 0) {
        ;
    }else{
    ZZZGameScrollModel *model = [[ZZZGameScrollModel alloc] init];
    ZZZDBGameModel *dbModel = self.gameArray[indexPath.row];
    model.game_id = dbModel.gameId;
    model.title_cn = dbModel.gameName;
    model.pack = dbModel.gamePack;
    
    ZZZGameDetailViewController *vc = [[ZZZGameDetailViewController alloc] init];
    vc.model = model;
    [self.myDelegate pushMyViewController:vc];
    }
    [self.gameTable deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ZZZTagGameViewController *vc = [[ZZZTagGameViewController alloc] initWithTagName:self.tagArray[indexPath.row]];
    [self.myDelegate pushMyViewController:vc];
    
}

- (void)setTagArray:(NSMutableArray<NSString *> *)tagArray{
    if (_tagArray != tagArray) {
        [_tagArray release];
        _tagArray = [tagArray retain];
        [self.tagCollectionView reloadData];
    }
}

- (void)setGameArray:(NSMutableArray<ZZZDBGameModel *> *)gameArray{
    if (_gameArray != gameArray) {
        [_gameArray release];
        _gameArray = [gameArray retain];
        [self.gameTable reloadData];
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
