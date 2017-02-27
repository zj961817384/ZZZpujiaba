//
//  ZZZGameDetailViewController.m
//  pujiaba
//
//  Created by zzzzz on 15/12/28.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZGameDetailViewController.h"
#import "ZZZGameDetailView.h"
#import "ZZZDataBaseSingleton.h"
#import "UMSocial.h"

@interface ZZZGameDetailViewController ()<ZZZMyPushViewControllerDelegate>

@property (nonatomic, retain) ZZZGameDetailView *detailView;

@end

@implementation ZZZGameDetailViewController

- (void)dealloc{
    [_detailView release];
    [_model release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.model.title_cn;
    self.detailView = [[ZZZGameDetailView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64)];
    self.detailView.myDelegate = self;
    [self.view addSubview:self.detailView];
    [self loadData];
    
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
    if ([[ZZZDataBaseSingleton shareDataBaseManager] gameIsExistWithGameId:_model.game_id andUserId:[AppTools currentUserAccount].integerValue]) {
        imgStr = @"liked.png";
    }
    UIImage *imgr = [UIImage imageNamed:imgStr];
    imgr = [imgr imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIButton *rbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rbutton.frame = CGRectMake(0, 0, 30, 30);
    [rbutton setImage:imgr forState:UIControlStateNormal];
    [rbutton addTarget:self action:@selector(likeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rbtn = [[UIBarButtonItem alloc] initWithCustomView:rbutton];
    
    UIImage *imgS = [UIImage imageNamed:@"share.png"];
    imgS = [imgS imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIButton *buttonS = [UIButton buttonWithType:UIButtonTypeSystem];
    buttonS.frame = CGRectMake(0, 0, 30, 30);
    [buttonS setImage:imgS forState:UIControlStateNormal];
    [buttonS addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sbtn = [[UIBarButtonItem alloc] initWithCustomView:buttonS];
    
    self.navigationItem.rightBarButtonItems = @[rbtn, sbtn];
//    [rbtn release];
    
}

- (void)backButtonClick:(UIBarButtonItem *)button{
    //    NSLog(@"asdf");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)likeButtonClick:(UIBarButtonItem *)button{
    if (![[ZZZDataBaseSingleton shareDataBaseManager] gameIsExistWithGameId:_model.game_id andUserId:[AppTools currentUserAccount].integerValue]) {
        ZZZDBGameModel *model = [[ZZZDBGameModel alloc] init];
        model.gameId = _model.game_id;
        model.gameName = _model.title_cn;
        model.gamePack = _model.pack;
        
        if([[ZZZDataBaseSingleton shareDataBaseManager] insertGame:model andUserId:[AppTools currentUserAccount].integerValue]){
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
        
        if([[ZZZDataBaseSingleton shareDataBaseManager] deleteGameWith:_model.game_id andUserId:[AppTools currentUserAccount].integerValue]){
        UIButton *btn = self.navigationItem.rightBarButtonItem.customView;
        [btn setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
        }
        UIAlertController *alert = [AppTools alertWithMessage:@"取消收藏成功" block:^{
            ;
        }];
        [self presentViewController:alert animated:YES completion:^{
            ;
        }];
    }
}

- (void)shareButtonClick:(UIButton *)button{
    if (_model != nil) {
        if (_model.image != nil && ![@"" isEqualToString:_model.image]) {
            [AppTools getDataFromNetUseGETMethodWithUrl:[BASE_URL stringByAppendingPathComponent:_model.image] andParameters:nil successBlock:^(NSData *resultData) {
                if (resultData.length > 0) {
//                    UIImage *image = [UIImage imageWithData:resultData];
                    NSString *shareText = [NSString stringWithFormat:@"游戏资源来自扑家汉化平台~~%@     \n  \n%@", _model.title_cn, [@"http://www.pujia8.com/search/?w=" stringByAppendingString:[_model.title_cn stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]]]];
//                    [UMSocialSnsService presentSnsController:self appKey:UMSOCIALKEY shareText:shareText shareImage:resultData shareToSnsNames:@[UMShareToSina, UMShareToWechatTimeline] delegate:nil];
                     [UMSocialSnsService presentSnsIconSheetView:self appKey:UMSOCIALKEY shareText:shareText shareImage:resultData shareToSnsNames:@[UMShareToSina] delegate:nil];
                }
            } failBlock:^(NSError *error) {
                ;
            }];
        }else{
            NSString *shareText = [NSString stringWithFormat:@"游戏资源来自扑家汉化平台~~%@     \n  \n%@", _model.title_cn, [@"http://www.pujia8.com/search/?w=" stringByAppendingString:[_model.title_cn stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]]]];
//            [UMSocialSnsService presentSnsController:self appKey:UMSOCIALKEY shareText:shareText shareImage:nil shareToSnsNames:@[UMShareToSina, UMShareToWechatTimeline] delegate:nil];
                [UMSocialSnsService presentSnsIconSheetView:self appKey:UMSOCIALKEY shareText:shareText shareImage:nil shareToSnsNames:@[UMShareToSina] delegate:nil];
        }
    }
}

- (void)loadData{
    NSString *urlString = self.model.pack;
//    [AppTools getDataFromNetUseGETMethodAFNWithUrl:[INFO_URL stringByAppendingPathComponent:urlString]andParameters:nil successBlock:^(NSData *resultData) {
//        NSLog(@"%@", resultData);
//    } failBlock:^(NSError *error) {
//        NSLog(@"游戏详细信息数据请求失败:err=%@",error);
//    }];
    [AppTools getDataFromNetUseGETMethodWithUrl:[INFO_URL stringByAppendingPathComponent:urlString] andParameters:nil successBlock:^(NSData *resultData) {
//        NSLog(@"%@", [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding] );
        if (resultData.length > 0) {
            NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
            //        NSLog(@"%@", dic);
            NSDictionary *gameDic = [dic objectForKey:GAME];
            ZZZGameDetailModel *game = [[ZZZGameDetailModel alloc] init];
            [game setValuesForKeysWithDictionary:gameDic];
            game.pack = self.model.pack;
            game.title_cn = self.model.title_cn;
            game.game_id = self.model.game_id;
            self.detailView.detailModel = game;//属性传值
        }else{
            UIAlertController *alert = [AppTools alertWithMessage:@"网络不给力啊~" block:^{
                ;
            }];
            [self presentViewController:alert animated:YES completion:^{
                ;
            }];
        }
    } failBlock:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)presentMyViewController:(UIViewController *)viewController{
    [self presentViewController:viewController animated:YES completion:^{
        ;
    }];
}

- (void)pushMyViewController:(UIViewController *)viewController{
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
