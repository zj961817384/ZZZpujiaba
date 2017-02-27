//
//  ZZZConfigViewController.m
//  pujiaba
//
//  Created by zzzzz on 15/12/28.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZConfigViewController.h"
#import "ZZZConfigView.h"

@interface ZZZConfigViewController ()<ZZZMyPushViewControllerDelegate>

@property (nonatomic, retain) ZZZConfigView *configView;

@end

@implementation ZZZConfigViewController

- (void)dealloc{
    [_configView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.configView = [[ZZZConfigView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64)];
    self.configView.myDelegate = self;
    [self.view addSubview:self.configView];
    [_configView release];
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
