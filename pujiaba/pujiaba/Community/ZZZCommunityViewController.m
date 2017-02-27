//
//  ZZZCommunityViewController.m
//  pujiaba
//
//  Created by zzzzz on 15/12/28.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZCommunityViewController.h"
#import "ZZZCommunityView.h"

@interface ZZZCommunityViewController ()<ZZZCommunityViewDelegate,ZZZMyPushViewControllerDelegate>

@property (nonatomic, retain) ZZZCommunityView *communityView;

@end

@implementation ZZZCommunityViewController

- (void)dealloc{
    [_communityView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.communityView = [[ZZZCommunityView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.communityView = [[ZZZCommunityView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64)];
    self.communityView.myDelegate = self;
    [self.view addSubview:self.communityView];
    [_communityView release];
}

- (void)pushMyViewController:(UIViewController *)viewController{
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)presentMyViewController:(UIViewController *)viewController{
    [self presentViewController: viewController animated:YES completion:^{
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
