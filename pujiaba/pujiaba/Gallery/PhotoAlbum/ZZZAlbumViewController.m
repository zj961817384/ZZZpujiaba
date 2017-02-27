//
//  ZZZAlbumViewController.m
//  pujiaba
//
//  Created by zzzzz on 16/1/8.
//  Copyright © 2016年 zzzzz. All rights reserved.
//

#import "ZZZAlbumViewController.h"
#import "UMSocial.h"

#import "ZZZAlbumView.h"

@interface ZZZAlbumViewController ()<ZZZAlbumViewDelegate, ZZZMyPushViewControllerDelegate>

@property (nonatomic, retain) ZZZAlbumView *albumView;


@end

@implementation ZZZAlbumViewController

- (void)dealloc{
    [_albumView release];
    [super dealloc];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self createSubview];
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
    
#pragma mark -- 创建导航栏右侧按钮
//    UIImage *imgS = [UIImage imageNamed:@"share.png"];
//    imgS = [imgS imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIButton *buttonS = [UIButton buttonWithType:UIButtonTypeSystem];
//    buttonS.frame = CGRectMake(0, 0, 30, 30);
//    [buttonS setImage:imgS forState:UIControlStateNormal];
//    [buttonS addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *sbtn = [[UIBarButtonItem alloc] initWithCustomView:buttonS];
//    
//    self.navigationItem.rightBarButtonItem = sbtn;
    
}

- (void)backButtonClick:(UIBarButtonItem *)button{
    //    NSLog(@"asdf");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareButtonClick:(UIButton *)button{
    
}

- (void)shareCurrentImage:(UIImage *)img{
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMSOCIALKEY shareText:@"" shareImage:img shareToSnsNames:@[UMShareToQQ, UMShareToSina, UMShareToTencent, UMShareToWechatSession, UMShareToWechatFavorite] delegate:nil];
}


- (void)createSubview{
    self.albumView = [[ZZZAlbumView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.albumView.myDelegate = self;
    self.albumView.galleryModel = self.galleryModel;
    [self.view addSubview:self.albumView];
//    [_albumView autorelease];
    
}

- (void)setNavigationBarAlpha:(CGFloat)alpha{
    static CGFloat navigationBarAlpha = -1;
    if (navigationBarAlpha == -1) {
        navigationBarAlpha = self.navigationController.navigationBar.alpha;
    }
    if (alpha == 1) {
        self.navigationController.navigationBar.alpha = navigationBarAlpha;
    }else{
        self.navigationController.navigationBar.alpha = 0;
    }
}

//- (void)viewWillDisappear:(BOOL)animated{
//    self.navigationController.navigationBar.alpha = 1;
//}

- (void)presentMyViewController:(UIViewController *)viewController{
    [self presentViewController:viewController animated:YES completion:^{
        ;
    }];
}

@end
