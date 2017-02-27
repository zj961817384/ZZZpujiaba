//
//  ZZZHomeViewController.m
//  pujiaba
//
//  Created by zzzzz on 15/12/26.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZHomeViewController.h"
#import "ZZZHomeView.h"

@interface ZZZHomeViewController ()<ZZZHomeViewDelegate>

@property (nonatomic, retain) ZZZHomeView       *homeView;



@end

@implementation ZZZHomeViewController

- (void)dealloc{
    [_homeView release];
    [super dealloc];
}

- (instancetype)initWithViewFrame:(CGRect)frame{
    self = [super init];
    if (self) {
        self.view.frame = frame;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createSubview];
    [self loadData];
}

- (void)createSubview{

//    self.navigationItem.title = @"主页";
    
    self.homeView = [[ZZZHomeView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64)];
//    self.homeView = [[ZZZHomeView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64)];

    self.homeView.myDelegate = self;
    [self.view addSubview:_homeView];
    [_homeView release];
}

- (void)loadData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:FOCUS_URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSMutableArray *resultArr = [responseObject objectForKey:FOCUS_LIST];
        NSMutableArray *arr_focus = [NSMutableArray array];
        for (NSDictionary *dic in resultArr) {
            ZZZGameScrollModel *m = [[ZZZGameScrollModel alloc] init];
            [m setValuesForKeysWithDictionary:dic];
            [arr_focus addObject:m];
            [m release];
        }
        
        NSMutableArray *list_tag = [NSMutableArray array];
        for (NSString *str in [responseObject objectForKey:HOT_TAGS_LIST]) {
            [list_tag addObject:str];
        }
        _homeView.list_tag = list_tag;
        
        _homeView.focus = arr_focus;
        resultArr = [responseObject objectForKey:HOT_GAMES_LIST];
        NSMutableArray *arr_list = [NSMutableArray array];
        for (NSDictionary *dic in resultArr) {
            ZZZGameListModel *m = [[ZZZGameListModel alloc] init];
            [m setValuesForKeysWithDictionary:dic];
            [arr_list addObject:m];
            [m release];
        }
        _homeView.list_hotArray = arr_list;
        resultArr = [responseObject objectForKey:NEW_GAMES_LIST];
        NSMutableArray *arr_list_new = [NSMutableArray array];
        for (NSDictionary *dic in resultArr) {
            ZZZGameListModel *m = [[ZZZGameListModel alloc] init];
            [m setValuesForKeysWithDictionary:dic];
            [arr_list_new addObject:m];
            [m release];
        }
        _homeView.list_newArray = arr_list_new;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushMyViewController:(UIViewController *)viewController{
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)showMoreNewGames{
    [self.myDelegate selectGamePage];
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
