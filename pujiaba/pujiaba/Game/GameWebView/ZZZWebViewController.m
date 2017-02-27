//
//  ZZZWebViewController.m
//  pujiaba
//
//  Created by zzzzz on 16/1/12.
//  Copyright © 2016年 zzzzz. All rights reserved.
//

#import "ZZZWebViewController.h"
#import "ZZZWebView.h"

@interface ZZZWebViewController ()

@property (nonatomic, retain) ZZZWebView *webView;

@end

@implementation ZZZWebViewController

- (void)dealloc{
    [_webView release];
    [super dealloc];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.webView = [[ZZZWebView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64)];
    self.webView.gameURL = self.gameURL;
//    self.navigationItem.title = self.gameName;
    self.navigationItem.title = @"扑家吧";
    [self.view addSubview:self.webView];
    [_webView release];
    
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
}

- (void)backButtonClick:(UIBarButtonItem *)button{
    //    NSLog(@"asdf");
    [self.navigationController popViewControllerAnimated:YES];
}


@end
