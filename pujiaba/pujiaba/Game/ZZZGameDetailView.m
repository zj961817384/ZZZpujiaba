//
//  ZZZGameDetailView.m
//  pujiaba
//
//  Created by zzzzz on 15/12/28.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZGameDetailView.h"
#import "ZZZBaseScrollView.h"
#import "ZZZCommentsTableView.h"
#import "UIImageView+WebCache.h"
#import "ZZZReviewScrollView.h"
#import "ZZZBaseButton.h"
#import "ZZZWebViewController.h"

@interface ZZZGameDetailView ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, ZZZMyPushViewControllerDelegate>

@property (nonatomic, retain) ZZZBaseTableView       *mainTableView;
//图标
@property (nonatomic, retain) UIImageView       *icon;
//名字
@property (nonatomic, retain) UILabel           *title_label;
//大小和人气
@property (nonatomic, retain) UILabel           *size_label;
//标签（类型）
@property (nonatomic, retain) ZZZBaseScrollView      *tags_view;
//头部视图（承载图标，名字等）
@property (nonatomic, retain) ZZZBaseView            *headView;
//详情 - 言弹[ - 测评]
@property (nonatomic, retain) ZZZBaseScrollView *titleScrollView;

//显示所有下面的信息
//承载详情，言弹等内容的横向scrollview
@property (nonatomic, retain) ZZZBaseScrollView *bodyScrollView;
//详情描述上面的滚动视图
@property (nonatomic, retain) ZZZBaseScrollView *imageScrollView;
//描述
@property (nonatomic, retain) UILabel           *description_label;
//评测内容
@property (nonatomic, retain) UILabel           *review_label;
//指示视图
@property (nonatomic, retain) ZZZBaseView       *identifierView;

//当body不在最上面的时候，禁止tableview滚动
@property (nonatomic, assign) BOOL              forbidTableScroll;

/** 评测视图 */
@property (nonatomic, retain) ZZZReviewScrollView   *reviewScrollView;


@property (nonatomic, retain) NSMutableArray<ZZZCommentModel *> *list_comment;
//言弹tableview
@property (nonatomic, retain) ZZZCommentsTableView *commentsTableView;

@property (nonatomic, retain) NSFileManager     *fileManager;

@end

@implementation ZZZGameDetailView

- (void)dealloc{
    [_mainTableView release];
    [_icon release];
    [_title_label release];
    [_size_label release];
    [_tags_view release];
    [_titleScrollView release];
    [_bodyScrollView release];
    [_imageScrollView release];
    [_description_label release];
    [_commentsTableView release];
    [_review_label release];
    
    [_detailModel release];
    
    [_fileManager release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.fileManager = [NSFileManager defaultManager];
        [self createSubview];
        [self createBannerHeaderView];
    }
    return self;
}

- (void)createSubview{
    self.bodyScrollView = [[ZZZBaseScrollView alloc] initWithFrame:CGRectMake(0, 10, WIDTH, HEIGHT - 40 - 10 - 64)];
    
    self.mainTableView = [[ZZZBaseTableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.mainTableView.bounces = NO;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"bodyCell"];
//    self.mainTableView.bounces = NO;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    
    [self addSubview:self.mainTableView];
    [_mainTableView release];
    
    self.titleScrollView = [[ZZZBaseScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    
}
- (void)createBannerHeaderView{
    self.headView = [[ZZZBaseView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH / 3.325)];
    //    [self.headView setBackgroundColor:[UIColor colorWithWhite:0.980 alpha:1.000]];
    self.headView.whiteColor = [UIColor whiteColor];
    if ([@"night" isEqualToString:[USERDEFAULT objectForKey:CURRENT_SKIN]]) {
        [self.headView setBackgroundColor:self.headView.nightColor];
    }else{
        [self.headView setBackgroundColor:self.headView.whiteColor];
    }
    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 20, WIDTH / 5, WIDTH / 5)];
    [self.icon setBackgroundColor:[UIColor clearColor]];
    //        [self.icon setBackgroundColor:[UIColor redColor]];
    [self.headView addSubview:self.icon];
    [_icon release];
    
    self.title_label = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.frame.size.width + 10, 20, WIDTH - 180, self.icon.frame.size.height / 3)];
    self.title_label.font = [UIFont systemFontOfSize:17 weight:0.2];
    //        [self.title_label setBackgroundColor:[UIColor grayColor]];
    [self.headView addSubview:self.title_label];
    [_title_label release];
    
    self.size_label = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.frame.size.width + 10, self.title_label.frame.size.height + 20, WIDTH - 180, self.icon.frame.size.height / 3)];
    self.size_label.font = [UIFont systemFontOfSize:13];
    [self.size_label setTextColor:[UIColor grayColor]];
    //        [self.size_label setBackgroundColor:[UIColor lightGrayColor]];
    [self.headView addSubview:self.size_label];
    [_size_label release];
    
    self.tags_view = [[ZZZBaseScrollView alloc] initWithFrame:CGRectMake(self.icon.frame.size.width + 10, self.title_label.frame.size.height + 20 + self.size_label.frame.size.height, WIDTH - self.icon.frame.size.width - 15, self.icon.frame.size.height / 3)];
    //        [self.tags_view setBackgroundColor:[UIColor lightGrayColor]];
    [self.headView addSubview:self.tags_view];
    [_tags_view release];
    [_headView release];
    
    
    ZZZBaseButton *webButton = [ZZZBaseButton buttonWithType:UIButtonTypeCustom];
    webButton.frame = CGRectMake(WIDTH - 80, 20, 60, 30);
    webButton.whiteBackColor = [UIColor colorWithWhite:0.850 alpha:1.000];
    webButton.nightTextColor = [UIColor lightGrayColor];
    if ([@"night" isEqualToString:[USERDEFAULT objectForKey:CURRENT_SKIN]]) {
        webButton.backgroundColor = webButton.nightBackColor;
        [webButton setTitleColor:webButton.nightTextColor forState:UIControlStateNormal];
    }else{
        webButton.backgroundColor = webButton.whiteBackColor;
        [webButton setTitleColor:webButton.whiteTextColor forState:UIControlStateNormal];
    }
    webButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [webButton setTitle:@"扑家查看" forState:UIControlStateNormal];
    webButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    webButton.layer.borderWidth = 0.3;
    webButton.layer.cornerRadius = 2;
    [webButton addTarget:self action:@selector(gameEnterWeb:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:webButton];
}

- (void)createHeadScrollView{
    //
    //    self.titleScrollView = [[ZZZBaseScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    self.titleScrollView.whiteColor = [UIColor colorWithWhite:0.944 alpha:1.000];
    self.titleScrollView.nightColor = [UIColor colorWithWhite:0.226 alpha:1.000];
    if ([@"night" isEqualToString:[USERDEFAULT objectForKey:CURRENT_SKIN]]) {
        [self.titleScrollView setBackgroundColor:self.titleScrollView.nightColor];
    }else{
        [self.titleScrollView setBackgroundColor:self.titleScrollView.whiteColor];
    }
    ZZZBaseButton *btn1 = [ZZZBaseButton buttonWithType:UIButtonTypeSystem];
    btn1.frame = CGRectMake(0, 0, WIDTH / 4, self.titleScrollView.frame.size.height);
    [btn1 setTitle:@"详情" forState:UIControlStateNormal];
    //        [btn1 setBackgroundColor:[UIColor whiteColor]];
    //    [btn1 setTitleColor:[UIColor colorWithWhite:0.198 alpha:1.000] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleScrollView addSubview:btn1];
    
    UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(WIDTH / 4 - 1, 10, 1, 20)];
    [sep setBackgroundColor:[UIColor lightGrayColor]];
    [self.titleScrollView addSubview:sep];
    [sep release];
    
    ZZZBaseButton *btn2 = [ZZZBaseButton buttonWithType:UIButtonTypeSystem];
    btn2.frame = CGRectMake(WIDTH / 4, 0, WIDTH / 4, self.titleScrollView.frame.size.height);
    [btn2 setTitle:@"言弹" forState:UIControlStateNormal];
    //        [btn2 setBackgroundColor:[UIColor whiteColor]];
    //    [btn2 setTitleColor:[UIColor colorWithWhite:0.198 alpha:1.000] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleScrollView addSubview:btn2];
    
    ZZZBaseView *bottomLine = [[ZZZBaseView alloc] initWithFrame:CGRectMake(0, self.titleScrollView.frame.size.height - 3, WIDTH, 3)];
    bottomLine.whiteColor = [UIColor colorWithRed:0.149 green:0.557 blue:0.376 alpha:1.000];
    bottomLine.nightColor = [UIColor lightGrayColor];
    if ([@"night" isEqualToString:[USERDEFAULT objectForKey:CURRENT_SKIN]]) {
        [bottomLine setBackgroundColor:bottomLine.nightColor];
    }else{
        [bottomLine setBackgroundColor:bottomLine.whiteColor];
    }
    [self.titleScrollView addSubview:bottomLine];
    [bottomLine release];
    self.identifierView = [[ZZZBaseView alloc] init];
    self.identifierView.frame = CGRectMake(0, self.titleScrollView.frame.size.height - 8, WIDTH / 4, 8);
    //    [self.identifierView setBackgroundColor:[UIColor colorWithRed:0.149 green:0.557 blue:0.376 alpha:1.000]];
    self.identifierView.nightColor = [UIColor lightGrayColor];
    if ([@"night" isEqualToString:[USERDEFAULT objectForKey:CURRENT_SKIN]]) {
        [self.identifierView setBackgroundColor:self.identifierView.nightColor];
    }else{
        [self.identifierView setBackgroundColor:self.identifierView.whiteColor];
    }
    [self.titleScrollView addSubview:self.identifierView];
    [_identifierView release];
    
    if (self.detailModel.review) {
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(WIDTH / 4 * 2 - 1, 10, 1, 20)];
        [sep setBackgroundColor:[UIColor lightGrayColor]];
        [self.titleScrollView addSubview:sep];
        [sep release];
        
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
        btn2.frame = CGRectMake(WIDTH / 4 * 2, 0, WIDTH / 4, self.titleScrollView.frame.size.height);
        [btn2 setTitle:@"评测" forState:UIControlStateNormal];
        //        [btn2 setBackgroundColor:[UIColor whiteColor]];
        [btn2 setTitleColor:[UIColor colorWithWhite:0.198 alpha:1.000] forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleScrollView addSubview:btn2];
        
    }
}

#pragma mark -- tableview代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return WIDTH / 3.325;
    }else{
        return 40;
    }
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return self.headView;//[headView autorelease];
    }else{
//        [self createHeadScrollView];
        return self.titleScrollView;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bodyCell"];
    [cell.contentView addSubview:self.bodyScrollView];
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.bodyScrollView.frame.size.height + self.bodyScrollView.frame.origin.y;
}


#pragma mark -- 创建主要描述视图
- (void)createBodyView{
    if (self.detailModel != nil) {

        self.bodyScrollView.bounces = NO;
        self.bodyScrollView.pagingEnabled = YES;
        self.bodyScrollView.delegate = self;
        //    [self.bodyScrollView setBackgroundColor:[UIColor grayColor]];
        int n = 2;
        if (self.detailModel.review) {
            n++;
        }
        self.bodyScrollView.contentSize = CGSizeMake(n * WIDTH, self.bodyScrollView.frame.size.height);
        
        //创建承载详情部分的scrollview
        ZZZBaseScrollView *contentScrollView = [[ZZZBaseScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, self.bodyScrollView.frame.size.height)];
        [self.bodyScrollView addSubview:contentScrollView];
        
        //创建展示言弹部分的tableview
        self.commentsTableView = [[ZZZCommentsTableView alloc] initWithFrame:CGRectMake(WIDTH, 0, WIDTH, self.bodyScrollView.frame.size.height) style:UITableViewStylePlain];
        self.commentsTableView.myDelegate = self;
//        self.commentsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.commentsTableView.myDelegate = self;
        [self.bodyScrollView addSubview:self.commentsTableView];
        [_commentsTableView release];
        _commentsTableView.pack = self.detailModel.pack;
        
        contentScrollView.delegate = self;//这个地方签代理是想实现，滚动的时候先滚动父视图（tableview）
        contentScrollView.tag = 99999;
//        contentScrollView.bounces = NO;
        [contentScrollView release];
        
        CGFloat w = contentScrollView.frame.size.width;
        CGFloat y = [self createImageScrollViewOnView:contentScrollView] + 10;
        UILabel *intro = [[UILabel alloc] initWithFrame:CGRectMake(10, y, w - 20, 30)];
        intro.text = @"介绍";
        intro.font = [UIFont systemFontOfSize:17 weight:0.1];
        [contentScrollView addSubview:intro];
        [intro release];
        
        y += intro.frame.size.height + 10;
        
        self.description_label = [[UILabel alloc] initWithFrame:CGRectMake(10, y, w - 20, 30)];
        self.description_label.lineBreakMode = NSLineBreakByCharWrapping;
        self.description_label.numberOfLines = 0;
        self.description_label.font = [UIFont systemFontOfSize:16];
//        [self.description_label setBackgroundColor:[UIColor lightGrayColor]];
        [contentScrollView addSubview:self.description_label];
        [_description_label release];
        
        self.description_label.text = self.detailModel.content;
        [self.description_label sizeToFit];
        NSLog(@"%f", y + self.description_label.frame.size.height);
        contentScrollView.contentSize = CGSizeMake(w, y + self.description_label.frame.size.height + 20);
        
        //如果有测评，显示测评
        if (_detailModel.review) {
            self.reviewScrollView = [[ZZZReviewScrollView alloc] initWithFrame:CGRectMake(2 * WIDTH, 0, WIDTH, self.bodyScrollView.frame.size.height)];
            self.reviewScrollView.delegate = self;
            self.reviewScrollView.bounces = YES;
            self.reviewScrollView.reviewContent = _detailModel.review_content;
//            [self.reviewScrollView setBackgroundColor:[UIColor purpleColor]];
            self.reviewScrollView.whiteColor = [UIColor whiteColor];
            if ([@"night" isEqualToString:[USERDEFAULT objectForKey:CURRENT_SKIN]]) {
                [self.reviewScrollView setBackgroundColor:self.reviewScrollView.nightColor];
            }else{
                [self.reviewScrollView setBackgroundColor:self.reviewScrollView.whiteColor];
            }
            [self.bodyScrollView addSubview:self.reviewScrollView];
        }
    }
}

- (CGFloat)createImageScrollViewOnView:(UIView *)view{
    CGFloat h = WIDTH / 2.025;
    self.imageScrollView = [[ZZZBaseScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, h)];
    [view addSubview:self.imageScrollView];
    [_imageScrollView release];
    __block CGFloat x = 5;
    
    for (NSString *str in self.detailModel.images_list) {
        NSArray *arr = [str componentsSeparatedByString:@"/"];
        NSMutableArray *folders = [NSMutableArray arrayWithObjects:@"Cache", nil];
        for (NSString *c in arr) {
            if ([c containsString:@"."]) {
                break;
            }
            if (![c isEqualToString:@"/"]) {
                [folders addObject:c];
            }
        }
        NSString *imgPath = [AppTools createImageLocalPathUseUrl:str withFolders:folders];
        if ([self.fileManager fileExistsAtPath:imgPath]) {
            NSData *resultData = [NSData dataWithContentsOfFile:imgPath];
            UIImage *img = [UIImage imageWithData:resultData];
            if (img == nil) {
                img = [UIImage imageNamed:@"imageNotFound.jpg"];
            }
            CGFloat w = img.size.width * h / img.size.height;
            UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
            imgv.frame = CGRectMake(x, 0, w, h);
            imgv.image = img;
            x += w + 5;
            self.imageScrollView.contentSize = CGSizeMake(x, h);

            //这个地方打开就可以让详情页面的滚动图片可以点开缩放查看
#if 1//让详情信息的图片可以点开缩放
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigImageOnFrontView:)];
            imgv.userInteractionEnabled = YES;
            [imgv addGestureRecognizer:tap];
//            [tap release];
#endif
            [self.imageScrollView addSubview:imgv];
            [imgv release];
        }else{
            [AppTools getDataFromNetUseGETMethodWithUrl:[BASE_URL stringByAppendingPathComponent:str] andParameters:nil successBlock:^(NSData *resultData) {
                UIImage *img = [UIImage imageWithData:resultData];
                if (img == nil) {
                    img = [UIImage imageNamed:@"imageNotFound.jpg"];
                }else{
                    [resultData writeToFile:imgPath atomically:YES];
                }
                CGFloat w = img.size.width * h / img.size.height;
               UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)]; //如果在这个地方创建imageview，那请求出来的图片顺序就是随机的。
                imgv.frame = CGRectMake(x, 0, w, h);
                imgv.image = img;
                x += w + 5;
                self.imageScrollView.contentSize = CGSizeMake(x, h);
                
                //这个地方打开就可以让详情页面的滚动图片可以点开缩放查看
#if 1//让详情信息的图片可以点开缩放
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigImageOnFrontView:)];
                imgv.userInteractionEnabled = YES;
                [imgv addGestureRecognizer:tap];
                //            [tap release];
#endif
                
                [self.imageScrollView addSubview:imgv];
                [imgv release];
            } failBlock:^(NSError *error) {
                ;
            }];
        }
    }
    return h;
}


- (void)headerButtonClick:(UIButton *)button{
    CGRect frame = button.frame;
    CGRect iFrame = self.identifierView.frame;
    iFrame.origin.x = frame.origin.x;
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.1];
//    self.identifierView.frame = iFrame;
//    [UIView commitAnimations];
    
    CGPoint pt = self.bodyScrollView.contentOffset;
    pt.x = frame.origin.x / frame.size.width * WIDTH;
    [self.bodyScrollView setContentOffset:pt animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.bodyScrollView) {
        //如果不做判断下面的scrollview在右边的时候，如果我上下滑动，指示器就会回到第一个位置！!
        //所以要判断触发这个事件的是不是下面的bodyscrollview
        //因为tableview也会触发scrollview的代理事件
        CGPoint pt = scrollView.contentOffset;
        CGRect rect = self.identifierView.frame;
        rect.origin.x = pt.x / WIDTH * rect.size.width;
        self.identifierView.frame = rect;
//        NSLog(@"%f", rect.origin.x);
    }
    //如果是显示内容的滚动视图
    if (scrollView.tag == 99999) {
        /********************************************/
        CGPoint local = scrollView.contentOffset;
        NSLog(@"%f", local.y);
        CGPoint headlocal = self.mainTableView.contentOffset;
            if (local.y <= 0 && headlocal.y > 0) {
                CGFloat y = local.y + self.mainTableView.contentOffset.y;
                self.mainTableView.contentOffset = CGPointMake(0, y > 0 ? y : 0);
                scrollView.contentOffset = CGPointMake(0, 0);
            }else if (local.y > 0 && headlocal.y < -1 + self.headView.frame.size.height){
                CGFloat y = headlocal.y + local.y;
//                NSLog(@"aa%f", self.headView.frame.size.height);
                y = MIN(y, self.headView.frame.size.height - 0.5);
//                NSLog(@"y=%f", y);
                [self.mainTableView setContentOffset:CGPointMake(0, y) animated:NO];
                scrollView.contentOffset = CGPointMake(0, 0);
            }

        if (local.y > 0) {
            self.forbidTableScroll = YES;
        }else{
            self.forbidTableScroll = NO;
        }
    }
    //如果是言弹tableview滚动
    if (scrollView == self.commentsTableView) {
        CGPoint local = scrollView.contentOffset;
        NSLog(@"%f", local.y);
        CGPoint headlocal = self.mainTableView.contentOffset;
        if (local.y <= 0 && headlocal.y > 0) {
            CGFloat y = local.y + self.mainTableView.contentOffset.y;
            self.mainTableView.contentOffset = CGPointMake(0, y > 0 ? y : 0);
            scrollView.contentOffset = CGPointMake(0, 0);
        }else if (local.y > 0 && headlocal.y < -1 + self.headView.frame.size.height){
            CGFloat y = headlocal.y + local.y;
            //                NSLog(@"aa%f", self.headView.frame.size.height);
            y = MIN(y, self.headView.frame.size.height - 0.5);
            //                NSLog(@"y=%f", y);
            [self.mainTableView setContentOffset:CGPointMake(0, y) animated:NO];
            scrollView.contentOffset = CGPointMake(0, 0);
        }
        
        if (local.y > 0) {
            self.forbidTableScroll = YES;
        }else{
            self.forbidTableScroll = NO;
        }
    }
    if (scrollView == self.reviewScrollView) {
        CGPoint local = scrollView.contentOffset;
        NSLog(@"%f", local.y);
        CGPoint headlocal = self.mainTableView.contentOffset;
        if (local.y <= 0 && headlocal.y > 0) {
            CGFloat y = local.y + self.mainTableView.contentOffset.y;
            self.mainTableView.contentOffset = CGPointMake(0, y > 0 ? y : 0);
            scrollView.contentOffset = CGPointMake(0, 0);
        }else if (local.y > 0 && headlocal.y < -1 + self.headView.frame.size.height){
            CGFloat y = headlocal.y + local.y;
            //                NSLog(@"aa%f", self.headView.frame.size.height);
            y = MIN(y, self.headView.frame.size.height - 0.5);
            //                NSLog(@"y=%f", y);
            [self.mainTableView setContentOffset:CGPointMake(0, y) animated:NO];
            scrollView.contentOffset = CGPointMake(0, 0);
        }
        
        if (local.y > 0) {
            self.forbidTableScroll = YES;
        }else{
            self.forbidTableScroll = NO;
        }
    }
    
    if (self.forbidTableScroll) {//我这个地方禁止了tableview的滚动，如果下面详情没有在top的话
        self.mainTableView.scrollEnabled = NO;
    }else{
        self.mainTableView.scrollEnabled = YES;
    }
    
}













- (void)setDetailModel:(ZZZGameDetailModel *)detailModel{
    if (_detailModel != detailModel) {
        [_detailModel release];
        _detailModel = [detailModel retain];
        
#if 1
        //用自己的方法请求图片
        [AppTools getDataFromNetUseGETMethodWithUrl:[BASE_URL stringByAppendingPathComponent:_detailModel.icon] andParameters:nil successBlock:^(NSData *resultData) {
            if (resultData.length > 0) {
                self.icon.image = [UIImage imageWithData:resultData];
            }
        } failBlock:^(NSError *error) {
            NSLog(@"网络请求图片数据失败：%@",error);
        }];
#else
        //用三方请求图片
        [self.icon sd_setImageWithURL:[NSURL URLWithString:[BASE_URL stringByAppendingPathComponent:_detailModel.icon]]];
#endif
        self.title_label.text = _detailModel.title_cn;
        self.size_label.text = [NSString stringWithFormat:@"%@, %ld人气", _detailModel.size, (long)_detailModel.num_views];
        NSArray *tags = [_detailModel.type componentsSeparatedByString:@" "];
        CGFloat x = 2;
        CGFloat h = self.tags_view.frame.size.height;
        if (_detailModel.language != nil && ![_detailModel.language isEqualToString:@""]) {
            tags = [@[_detailModel.language] arrayByAddingObjectsFromArray:tags];
        }
        for (int i = 0; i < tags.count; i++){
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 3, 40, h - 6)];
            label.font = [UIFont systemFontOfSize:15];
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.masksToBounds = YES;
            label.layer.cornerRadius = 4;
            [label setBackgroundColor:[UIColor whiteColor]];
            label.layer.borderWidth = 0.5;
            label.layer.borderColor = [UIColor lightGrayColor].CGColor;
            label.text = [NSString stringWithFormat:@"%@ ", tags[i]];
            [label sizeToFit];
            x += label.frame.size.width + 4;
            [self.tags_view addSubview:label];
//            [label release];
        }
        [self createHeadScrollView];
        [self createBodyView];
//        [self.commentsTableView reloadData];
    }
}

- (void)gameEnterWeb:(UIButton *)button{
    ZZZWebViewController *web = [[ZZZWebViewController alloc] init];
    if ([@"" isEqualToString:self.detailModel.title_cn] || self.detailModel == nil) {
        return;
    }
    if (self.detailModel.title_cn == nil) {
        return;
    }
    web.gameURL =  [@"http://www.pujia8.com/search/?w=" stringByAppendingString:[self.detailModel.title_cn stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]]];//用这个字符集可以编码空格称百分号
    web.gameName = _detailModel.title_cn;
    
    [self.myDelegate pushMyViewController:web];
//    [web release];
    
    /**
     
     */
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return [[scrollView subviews] firstObject];
}

#pragma mark -- 弹出view，显示图片，然后可以缩放图片
- (void)showBigImageOnFrontView:(UITapGestureRecognizer *)tap{
    NSLog(@"%@", tap.view);
    UIImageView *imageView = (UIImageView *)tap.view;
    CGRect frame = [imageView convertRect:imageView.bounds toView:[[[UIApplication sharedApplication] delegate] window]];
    NSLog(@"%@", NSStringFromCGRect(frame));
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y - 64, frame.size.width, frame.size.height)];
    [view setBackgroundColor:[UIColor colorWithRed:0.089 green:0.089 blue:0.091 alpha:0.7]];
    [self addSubview:view];
//    [view release];
    
    UITapGestureRecognizer *tapc = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(unShowBigImageOnFrontView:)];
    [view addGestureRecognizer:tapc];
    [tapc release];
    
    UIImageView *showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    showImageView.backgroundColor = [UIColor clearColor];
    showImageView.image = imageView.image;
    showImageView.frame = showImageView.bounds;
    UIScrollView *imgScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    imgScroll.backgroundColor = [UIColor clearColor];
    imgScroll.minimumZoomScale = 0.7;
    imgScroll.maximumZoomScale = 2;
    imgScroll.delegate = self;
    [imgScroll addSubview:showImageView];
    [view addSubview:imgScroll];
    [imgScroll release];
    [self addSubview:view];
    [view release];
    
    CGFloat pixw = frame.size.width;
    CGFloat pixh = frame.size.height;
    CGFloat framw = self.bounds.size.width;
    CGFloat framh = self.bounds.size.height;
    
    if (pixw / pixh > framw / framh) {
        pixh = pixh / (pixw / framw);
        pixw = framw;
    }else{
        pixw = pixw / pixh * framh;
        pixh = framh;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        view.frame = self.bounds;
        imgScroll.frame = self.bounds;
//        showImageView.frame = CGRectMake(0, 0, pixw, pixh);
//        showImageView.frame = PCENTER(showImageView, view);
        showImageView.frame = CGRectMake((view.frame.size.width - pixw) / 2, (view.frame.size.height - pixh) / 2, pixw, pixh);

    }];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
//    NSLog(@"%@", [scrollView.subviews firstObject]);
//#error mark -- 当图片是横着的时候，缩放不正常，竖着的时候缩放是正常的
    UIImageView *imageView = [scrollView.subviews firstObject];
    CGRect frame = imageView.frame;
//    NSLog(@"\n%@\n%@", NSStringFromCGRect(frame), NSStringFromCGSize(scrollView.contentSize));
    frame.origin.x = MAX(0, (scrollView.frame.size.width - frame.size.width) / 2);
    frame.origin.y = MAX(0, (scrollView.frame.size.height - frame.size.height) / 2);
//    NSLog(@"%f, %f", scrollView.contentSize.height, frame.size.height);
        imageView.frame = frame;
//    imageView.center = CGPointMake(scrollView.contentSize.width / 2, scrollView.contentSize.height / 2);
}

- (void)unShowBigImageOnFrontView:(UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:0.2 animations:^{
        tap.view.alpha = 0;//CGRectMake(WIDTH / 2, HEIGHT / 2, 0, 0);
    }completion:^(BOOL finished) {
        [tap.view removeFromSuperview];
    }];
}

#pragma mark -- 正式协议弹出页面代理方法
- (void)presentMyViewController:(UIViewController *)viewController{
    [self.myDelegate presentMyViewController:viewController];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
