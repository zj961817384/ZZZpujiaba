//
//  ZZZSearchResultViewController.m
//  pujiaba
//
//  Created by zzzzz on 16/1/11.
//  Copyright © 2016年 zzzzz. All rights reserved.
//

#import "ZZZSearchResultViewController.h"
#import "ZZZSearchResultView.h"

@interface ZZZSearchResultViewController ()<ZZZMyPushViewControllerDelegate>

@property (nonatomic, copy) NSString *searchKey;

@property (nonatomic, retain) ZZZSearchResultView *searchView;

@end

@implementation ZZZSearchResultViewController

- (void)dealloc{
    [_searchView release];
    [super dealloc];
}

- (instancetype)initWithSearchKey:(NSString *)key{
    self = [super init];
    if (self) {
        self.searchKey = key;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.title = @"搜索结果";
    
    self.searchView = [[ZZZSearchResultView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64)];
    self.searchView.myDelegate = self;
    self.searchView.searchKey = self.searchKey;
    [self.view addSubview:self.searchView];
    [_searchView release];
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

- (void)pushMyViewController:(UIViewController *)viewController{
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)presentMyViewController:(UIViewController *)viewController{
    [self presentViewController:viewController animated:YES completion:^{
        ;
    }];
}

@end
