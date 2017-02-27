//
//  ZZZTagGameViewController.m
//  pujiaba
//
//  Created by zzzzz on 16/1/11.
//  Copyright © 2016年 zzzzz. All rights reserved.
//

#import "ZZZTagGameViewController.h"
#import "ZZZTagGameView.h"
#import "ZZZDataBaseSingleton.h"

@interface ZZZTagGameViewController ()<ZZZMyPushViewControllerDelegate>

@property (nonatomic, retain) ZZZTagGameView *gameView;

@end

@implementation ZZZTagGameViewController

- (instancetype)initWithTagName:(NSString *)tag{
    self = [super init];
    if (self) {
        self.tagName = tag;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.title = self.tagName;
    
    self.gameView = [[ZZZTagGameView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64)];
    [self.view addSubview:self.gameView];
    [_gameView release];
    
    self.gameView.myDelegate = self;
    self.gameView.tagName = self.tagName;
    
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
    
#pragma mark -- 导航栏右侧按钮
    NSString *imgStr = @"like.png";
    if ([[ZZZDataBaseSingleton shareDataBaseManager] tagIsExistWithTagName:_tagName andUserId:[AppTools currentUserAccount].integerValue]) {
        imgStr = @"liked.png";
    }
    UIImage *imgr = [UIImage imageNamed:imgStr];
    imgr = [imgr imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIButton *rbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rbutton.frame = CGRectMake(0, 0, 30, 30);
    [rbutton setImage:imgr forState:UIControlStateNormal];
    [rbutton addTarget:self action:@selector(likeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rbtn = [[UIBarButtonItem alloc] initWithCustomView:rbutton];
    self.navigationItem.rightBarButtonItem = rbtn;
    [rbtn release];

}

- (void)backButtonClick:(UIBarButtonItem *)button{
//    NSLog(@"asdf");
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)likeButtonClick:(UIBarButtonItem *)button{
    if (![[ZZZDataBaseSingleton shareDataBaseManager] tagIsExistWithTagName:_tagName andUserId:[AppTools currentUserAccount].integerValue]) {
        
        if([[ZZZDataBaseSingleton shareDataBaseManager] insertTag:_tagName andUserId:[AppTools currentUserAccount].integerValue]){
            UIButton *btn = self.navigationItem.rightBarButtonItem.customView;
            [btn setImage:[UIImage imageNamed:@"liked.png"] forState:UIControlStateNormal];
            UIAlertController *alert = [AppTools alertWithMessage:@"收藏成功" block:^{
                ;
            }];
            [self presentViewController:alert animated:YES completion:^{
                ;
            }];
        }
    }else{
        
        if([[ZZZDataBaseSingleton shareDataBaseManager] deleteTagWith:_tagName andUserId:[AppTools currentUserAccount].integerValue]){
            UIButton *btn = self.navigationItem.rightBarButtonItem.customView;
            [btn setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
            UIAlertController *alert = [AppTools alertWithMessage:@"取消收藏成功" block:^{
                ;
            }];
            [self presentViewController:alert animated:YES completion:^{
                ;
            }];
        }
    }
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
