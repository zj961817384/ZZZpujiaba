//
//  ZZZCollectViewController.m
//  pujiaba
//
//  Created by zzzzz on 15/12/28.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZCollectViewController.h"
#import "ZZZCollectView.h"
#import "ZZZDataBaseSingleton.h"

@interface ZZZCollectViewController ()<ZZZMyPushViewControllerDelegate>

@property (nonatomic, retain) ZZZCollectView *collectView;

@end

@implementation ZZZCollectViewController

- (void)dealloc{
    [_collectView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectView = [[ZZZCollectView alloc] initWithFrame:CGRectMake(0, 63, WIDTH, HEIGHT - 64)];
    self.collectView.myDelegate = self;
    [self.view addSubview:self.collectView];
    [_collectView release];
}

- (void)viewWillAppear:(BOOL)animated{
    NSMutableArray *tags = [[ZZZDataBaseSingleton shareDataBaseManager] selectTagWithUserId:[AppTools currentUserAccount].integerValue];
    self.collectView.tagArray = tags;
    NSMutableArray *games = [[ZZZDataBaseSingleton shareDataBaseManager] selectGameWithUserId:[AppTools currentUserAccount].integerValue];
    self.collectView.gameArray = games;
}

- (void)pushMyViewController:(UIViewController *)viewController{
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)presentMyViewController:(UIViewController *)viewController{
    [self presentViewController:viewController animated:YES completion:^{
        ;
    }];
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
