//
//  ZZZBaseViewController.m
//  pujiaba
//
//  Created by zzzzz on 15/12/26.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZBaseViewController.h"

@interface ZZZBaseViewController ()

@end

@implementation ZZZBaseViewController

- (void)dealloc{
    //在dealloc的时候取消通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CHANGE_SKIN object:nil];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin) name:CHANGE_SKIN object:nil];
    
    if ([USERDEFAULT objectForKey:CURRENT_SKIN] == nil || [[USERDEFAULT objectForKey:CURRENT_SKIN] isEqualToString:@"white"]) {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.086 green:0.641 blue:0.433 alpha:1.000];
    }else{
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.202 green:0.282 blue:0.282 alpha:1.000];
    }
}

- (void)changeSkin{
    NSLog(@"切换皮肤（夜间模式）");
    if ([[USERDEFAULT objectForKey:CURRENT_SKIN] isEqualToString:@"night"]) {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.202 green:0.282 blue:0.282 alpha:1.000];
    }else if ([[USERDEFAULT objectForKey:CURRENT_SKIN] isEqualToString:@"white"]){
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.086 green:0.641 blue:0.433 alpha:1.000];
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
