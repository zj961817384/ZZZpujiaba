//
//  ZZZWebView.m
//  pujiaba
//
//  Created by zzzzz on 16/1/12.
//  Copyright © 2016年 zzzzz. All rights reserved.
//

#import "ZZZWebView.h"
#import "ZZZCircleButtonView.h"

@interface ZZZWebView ()

@property (nonatomic, retain) UIWebView *webView;

@property (nonatomic, retain) NSMutableArray<ZZZCircleButtonView*> *subMenuButtons;

@property (nonatomic, retain) ZZZCircleButtonView *menuCircleButton;

@property (nonatomic, assign) BOOL menuStatu;

@property (nonatomic, assign) CGPoint oldPt;

@end

@implementation ZZZWebView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubview];
    }
    return self;
}

- (void)createSubview{
    self.webView = [[UIWebView alloc] initWithFrame:self.bounds];
    self.webView.scrollView.bounces = NO;
    [self addSubview:self.webView];
    [_webView release];
    
    [self createCircleButton];
    
}

- (void)loadWebPage{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.gameURL]];
    [self.webView loadRequest:request];
    [self.webView reload];
}

- (void)setGameURL:(NSString *)gameURL{
    if (_gameURL != gameURL) {
        [_gameURL release];
        _gameURL = [gameURL copy];
        [self loadWebPage];
    }
}

#pragma mark -- 创建右下角的圆形按钮
- (void)createCircleButton{
    
    self.subMenuButtons = [NSMutableArray array];
    
    
    ZZZCircleButtonView *viewButton2 = [[ZZZCircleButtonView alloc] initWithCenterPoint:CGPointMake(self.frame.size.width - 40, self.frame.size.height - 80) andRadius:25];
    UIImage *img2 = [UIImage imageNamed:@"iconfont_shuaxin"];
    viewButton2.myIcon = img2;
    [self addSubview:viewButton2];
    [self.subMenuButtons addObject:viewButton2];
    [viewButton2 release];
    
    //一个手势只能添加在一个view上面？
    UITapGestureRecognizer *subMenuTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subMenuClickAction:)];
    [viewButton2 addGestureRecognizer:subMenuTap];
    [subMenuTap release];
    
    viewButton2 = [[ZZZCircleButtonView alloc] initWithCenterPoint:CGPointMake(self.frame.size.width - 40, self.frame.size.height - 80) andRadius:25];
    img2 = [UIImage imageNamed:@"iconfont_qianjin.png"];
    viewButton2.myIcon = img2;
    [self addSubview:viewButton2];
    [self.subMenuButtons addObject:viewButton2];
    [viewButton2 release];
    
    subMenuTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subMenuClickAction:)];
    [viewButton2 addGestureRecognizer:subMenuTap];
    [subMenuTap release];
    
    viewButton2 = [[ZZZCircleButtonView alloc] initWithCenterPoint:CGPointMake(self.frame.size.width - 40, self.frame.size.height - 80) andRadius:25];
    img2 = [UIImage imageNamed:@"iconfont_houtui.png"];
    viewButton2.myIcon = img2;
    [self addSubview:viewButton2];
    [self.subMenuButtons addObject:viewButton2];
    [viewButton2 release];
    
    subMenuTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subMenuClickAction:)];
    [viewButton2 addGestureRecognizer:subMenuTap];
    [subMenuTap release];
    
    
    
    
    self.menuCircleButton = [[ZZZCircleButtonView alloc] initWithCenterPoint:CGPointMake(self.frame.size.width - 40, self.frame.size.height - 80) andRadius:25];
    UIImage *img = [UIImage imageNamed:@"iconfont_menu.png"];
    self.menuCircleButton.myIcon = img;
    [self addSubview:self.menuCircleButton];
    [_menuCircleButton release];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainMenuCircleButtonAction:)];
    [self.menuCircleButton addGestureRecognizer:tap];
    [tap release];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [self.menuCircleButton addGestureRecognizer:pan];
    [pan release];
    
}

- (void)panGestureAction:(UIPanGestureRecognizer *)pan{
    if(pan.state == UIGestureRecognizerStateBegan){
        self.oldPt = self.menuCircleButton.centerPoint;
    }
    CGPoint newPt;
    CGPoint pt = [pan translationInView:self.webView];
    newPt.x = pt.x + self.oldPt.x;
    newPt.y = pt.y + self.oldPt.y;
    newPt.x = MAX(newPt.x, 230);
    newPt.x = MIN(newPt.x, WIDTH - 30);
    newPt.y = MAX(newPt.y, 80);
    newPt.y = MIN(newPt.y, HEIGHT - 64 - 40);
    self.menuCircleButton.centerPoint = newPt;
    for (ZZZCircleButtonView *v in self.subMenuButtons) {
//        [UIView animateWithDuration:0.2 animations:^{
            v.centerPoint = newPt;
//        }];
    }
//    NSLog(@"%@", NSStringFromCGPoint(pt));
}

- (void)mainMenuCircleButtonAction:(UITapGestureRecognizer *)tap{
    //    int n = (int)self.subMenuButtons.count;
    self.menuStatu = !self.menuStatu;
    if (self.menuStatu) {
#if 0//扇形弹出菜单,写的是错的，没有写完
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
            pt.x -= (i + 1) * (radiu * 2 + 20);
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
        switch (index) {
            case 0:
                //菜单1
                [self.webView reload];
                break;
            case 1:
                NSLog(@"2");
                //菜单2
                if ([self.webView canGoForward]) {
                    [self.webView goForward];
                }
                break;
            case 2:
                NSLog(@"3");
                //菜单3
                if ([self.webView canGoBack]) {
                    [self.webView goBack];
                }
                break;
            default:
                break;
        }
}


@end
