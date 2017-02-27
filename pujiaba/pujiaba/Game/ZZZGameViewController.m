//
//  ZZZGameViewController.m
//  pujiaba
//
//  Created by zzzzz on 15/12/28.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZGameViewController.h"
#import "ZZZView.h"

@interface ZZZGameViewController ()<ZZZViewDelegate>

@property (nonatomic, retain) ZZZView *listView;

@property (nonatomic, retain) NSMutableArray<ZZZGameListModel *> *games;

@end

@implementation ZZZGameViewController

- (void)dealloc{
    [_listView release];
    [_games release];
    
    [super dealloc];
}

- (instancetype)initWithGameListURL:(NSString *)url{
    self = [super init];
    
    self.gameListURL = url;
    return self;
}

- (instancetype)initWithViewFrame:(CGRect)frame{
    self = [super init];
//    self.view = [[UIView alloc] initWithFrame:frame];
    self.view.frame = frame;
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.games = [NSMutableArray array];
    if (![self.gameListURL isEqualToString:@""] && self.gameListURL != nil) {
    self.listView = [[ZZZView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64) andURL:self.gameListURL];
    }else{
        self.listView = [[ZZZView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) andURL:self.gameListURL];

    }
//    self.listView = [[ZZZView alloc] initWithFrame:self.view.bounds andURL:self.gameListURL];
    [self.navigationController addChildViewController:self];
    self.listView.myDelegate = self;
    [self.view addSubview:self.listView];
    [_listView release];
    
//    [self loadData];
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

//- (void)loadData{
//    [AppTools getDataFromNetUseGETMethodWithUrl:GAMELIST_URL andParameters:nil successBlock:^(NSData *resultData) {
//        NSLog(@"数据请求成功");
//        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
////        NSLog(@"%@", dic);[1]	(null)	@"games_list" : @"10 objects"
//        NSMutableArray *allArray = [dic objectForKey:GAMES_LIST];
//        for (NSDictionary *d in allArray) {
//            ZZZGameListModel *m = [[ZZZGameListModel alloc] init];
//            [m setValuesForKeysWithDictionary:d];
//            [self.games addObject:m];
//            [m release];
//        }
//        
//        self.listView.games = self.games;
//        
//    } failBlock:^(NSError *error) {
//        NSLog(@"数据请求失败");
//    }];
//}


- (void)setGameListURL:(NSString *)gameListURL{
    if (_gameListURL != gameListURL) {
        [_gameListURL release];
        _gameListURL = [gameListURL copy];
        self.listView.dataURL = _gameListURL;
    }
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
