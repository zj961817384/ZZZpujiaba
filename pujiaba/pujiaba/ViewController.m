//
//  ViewController.m
//  pujiaba
//
//  Created by zzzzz on 15/12/26.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ViewController.h"
#import "ZZZHomeViewController.h"
#import "ZZZGameViewController.h"
#import "ZZZCommunityViewController.h"
#import "ZZZCollectViewController.h"
#import "ZZZGalleryViewController.h"
#import "ZZZConfigViewController.h"
#import "ZZZDrawViewController.h"
#import "ZZZSearchResultViewController.h"


#define ANIMATIONDURATION 0.2

@interface ViewController ()<ZZZDrawViewControllerDelegate, ZZZHomeViewControllerDelegate>

@property (nonatomic, retain) ZZZHomeViewController         *home;

@property (nonatomic, retain) ZZZGameViewController         *game;

@property (nonatomic, retain) ZZZCommunityViewController    *community;

@property (nonatomic, retain) ZZZCollectViewController      *collect;

@property (nonatomic, retain) ZZZGalleryViewController      *gallery;

@property (nonatomic, retain) ZZZConfigViewController       *config;

@property (nonatomic, retain) UIBarButtonItem   *leftButton;

@property (nonatomic, retain) UIBarButtonItem   *rightButton;

@property (nonatomic, retain) UIImage       *menuImg;

@property (nonatomic, retain) UIImage       *backImg;

@property (nonatomic, retain) UIButton      *costumBt;

@property (nonatomic, retain) ZZZDrawViewController *drawer;

@property (nonatomic, retain) UIView        *forbidView;

@property (nonatomic, retain) UITextField   *searchTextField;

@end

@implementation ViewController

- (void)dealloc{
    [_home release];
    [_gallery release];
    [_game release];
    [_community release];
    [_collect release];
    [_config release];
    
    [_leftButton release];
    [_menuImg release];
    [_backImg release];
    [_costumBt release];
    
    [_drawer release];
    [_forbidView release];
    [_searchTextField release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //这个设置不透明，下面的属性默认为yes的话，就会自动按照屏幕0 0坐标布局，否则会按照0，64布局
//    self.navigationController.navigationBar.translucent = NO;
    //这个属性会让所有继承uiscrollview的类根据导航控制器自动调整布局，设置为no就可以不让它自动布局！！！！！！！！
    self.automaticallyAdjustsScrollViewInsets = NO;
#pragma mark -- 创建子viewcontroller
    self.home = [[ZZZHomeViewController alloc] initWithViewFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64)];
    self.home.myDelegate = self;
    [self.view addSubview:self.home.view];
    [self addChildViewController:self.home];
    [_home release];
    
    self.game = [[ZZZGameViewController alloc] initWithViewFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64)];
    [self.view addSubview:self.game.view];
    [self addChildViewController:self.game];
    [_game release];
    
    self.community = [[ZZZCommunityViewController alloc] init];
    [self.view addSubview:self.community.view];
    [self addChildViewController:self.community];
    [_community release];
    
    self.collect = [[ZZZCollectViewController alloc] init];
    [self.view addSubview:self.collect.view];
    [self addChildViewController:self.collect];
    [_collect release];
    
    self.gallery = [[ZZZGalleryViewController alloc] init];
    [self.view addSubview:self.gallery.view];
    [self addChildViewController:self.gallery];
    [_gallery release];
    
    self.config = [[ZZZConfigViewController alloc] init];
    [self.view addSubview:self.config.view];
    [self addChildViewController:self.config];
    [_config release];
    
    
    [self selectHomePage];
    
#pragma mark -- 创建导航栏上面的按钮
    self.backImg = [UIImage imageNamed:@"iconfont_back.png"];
    self.menuImg = [UIImage imageNamed:@"iconfont_menu.png"];
    self.costumBt = [UIButton buttonWithType:UIButtonTypeCustom];
    self.costumBt.frame = CGRectMake(0, 0, 30, 30);
    [self.costumBt setImage:self.menuImg forState:UIControlStateNormal];
    [self.costumBt addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:self.costumBt];
    self.navigationItem.leftBarButtonItem = leftButton;
    [leftButton release];
    
    UIImage *searchIcon = [UIImage imageNamed:@"searchIcon.png"];
    searchIcon = [searchIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIButton *rightC = [UIButton buttonWithType:UIButtonTypeCustom];
    rightC.frame = CGRectMake( 0, 0, 20, 20);
    [rightC setImage:searchIcon forState:UIControlStateNormal];
    self.rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightC];
    [rightC addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = self.rightButton;
    [_rightButton release];
    

#pragma mark -- 创建左边抽屉
    self.drawer = [[ZZZDrawViewController alloc] init];
    self.drawer.myDelegate = self;
    [self addChildViewController:self.drawer];
    [self.view addSubview:self.drawer.view];
    
    self.forbidView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64)];
    [self.forbidView setBackgroundColor:[UIColor blackColor]];
    self.forbidView.alpha = 0;
    [self.view addSubview:self.forbidView];
    [_forbidView release];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.forbidView addGestureRecognizer:tap];
    [tap release];
}

- (void)leftButtonClick:(UIButton *)button{
    
    if (button.imageView.image == self.menuImg) {
//        [UIView animateWithDuration:0.3 animations:^{
//            button.transform = CGAffineTransformRotate(button.transform, M_PI);
//        }];
        
        //用下面这个动画方法，在按钮变换的时候可以点击，用上面的方法，动画的时候，按钮就不能被点击
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:ANIMATIONDURATION];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        button.transform = CGAffineTransformRotate(button.transform, M_PI);
        [UIView commitAnimations];
        [button setImage:self.backImg forState:UIControlStateNormal];
        NSLog(@"弹出左边菜单栏");
        [self showDrawerViewController:YES];
    }else{
        [UIView animateWithDuration:ANIMATIONDURATION animations:^{
            button.transform = CGAffineTransformRotate(button.transform, M_PI);
        }];
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.3];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//            button.transform = CGAffineTransformRotate(button.transform, M_PI);
//        [UIView commitAnimations];
        [button setImage:self.menuImg forState:UIControlStateNormal];
        NSLog(@"回收左边栏");
        [self showDrawerViewController:NO];
    }
}

//点击右边搜索按钮，弹出搜索框
- (void)rightButtonClick:(UIBarButtonItem *)button{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"搜索" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        NSLog(@"%@", textField);
        self.searchTextField = textField;
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        [self.searchTextField resignFirstResponder];
    }];
    [alert addAction:action1];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"%@", self.searchTextField.text);
        [self searchAction:self.searchTextField.text];
    }];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:^{
        ;
    }];
}

#pragma mark -- 搜索确认点击事件
- (void)searchAction:(NSString *)key{
    if ([@"" isEqualToString:key]) {
        return;
    }
    ZZZSearchResultViewController *searchViewController = [[ZZZSearchResultViewController alloc] initWithSearchKey:key];
    [self.navigationController pushViewController:searchViewController animated:YES];
    [searchViewController release];
}

- (void)showDrawerViewController:(BOOL)show{
    CGRect frame = self.drawer.view.frame;
    
    [self.view bringSubviewToFront:self.drawer.view];
    if (show) {
        frame.origin.x = 0;
        self.forbidView.alpha = 0.1;//本来是想用这个解决一起点击左边按钮和游戏时，不会同时弹出，但是，还是不管用啊。。。
        [UIView animateWithDuration:ANIMATIONDURATION animations:^{
            self.drawer.view.frame = frame;
            self.forbidView.alpha = 0.5;
        }];
    }else{
        frame.origin.x = -frame.size.width;
        [UIView animateWithDuration:ANIMATIONDURATION animations:^{
            self.drawer.view.frame = frame;
            self.forbidView.alpha = 0.0;
        }];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:ANIMATIONDURATION animations:^{
        tap.view.alpha = 0;
        [self leftButtonClick:self.costumBt];
    } completion:^(BOOL finished) {
    }];
}

- (void)removeAllView{
    [self.game.view removeFromSuperview];
    [self.community.view removeFromSuperview];
    [self.home.view removeFromSuperview];
    [self.gallery.view removeFromSuperview];
    [self.collect.view removeFromSuperview];
    [self.config.view removeFromSuperview];
}

- (void)selectHomePage{
//    [self.view bringSubviewToFront:self.home.view];
    [self removeAllView];
    [self.view addSubview:self.home.view];
    self.navigationItem.title = @"主页";
    [self.view bringSubviewToFront:self.forbidView];
}

- (void)selectGamePage{
//    [self.view bringSubviewToFront:self.game.view];
    [self removeAllView];
    [self.view addSubview: self.game.view];
    self.navigationItem.title = @"游戏";
    [self.view bringSubviewToFront:self.forbidView];
}

- (void)selectCommunityPage{
    [self removeAllView];
    [self.view addSubview:self.community.view];
    self.navigationItem.title = @"社区";
    [self.view bringSubviewToFront:self.forbidView];
}

- (void)selectGalleryPage{
    [self removeAllView];
    [self.view addSubview:self.gallery.view];
    self.navigationItem.title = @"福利";
    [self.view bringSubviewToFront:self.forbidView];
}

- (void)selectCollectPage{
    [self removeAllView];
    [self.view addSubview:self.collect.view];
    self.navigationItem.title = @"收藏";
    [self.view bringSubviewToFront:self.forbidView];
}

- (void)selectSettingPage{
    [self removeAllView];
    [self.view addSubview:self.config.view];
    self.navigationItem.title = @"设置";
    [self.view bringSubviewToFront:self.forbidView];
}

- (void)pageSelect:(NSIndexPath *)indexPath{
    int index = indexPath.row;
    int section = indexPath.section;
    if (section == 1) {
        switch (index) {
            case 0:
                [self selectHomePage];
//                [self refreshPage:0];
                break;
            case 1:
                [self selectGamePage];
                break;
            case 2:
                [self selectCommunityPage];
                break;
            case 3:
                [self selectCollectPage];
                break;
            case 4:
                [self selectGalleryPage];
                break;
            default:
                break;
        }
    }else if(section == 2){
        [self selectSettingPage];
    }
    [self.view bringSubviewToFront:self.forbidView];
    [self leftButtonClick:self.costumBt];
}

- (void)pageRefresh:(NSInteger)index{
    switch (index) {
        case 0:
            [self.home removeFromParentViewController];
            self.home = [[ZZZHomeViewController alloc] initWithViewFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64)];
            self.home.myDelegate = self;
            [self.view addSubview:self.home.view];
            [self addChildViewController:self.home];
            [_home release];
            [self selectHomePage];
            break;
//        case 1:
//            [self.game removeFromParentViewController];
//            self.game = [[ZZZGameViewController alloc] initWithViewFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64)];
//            [self.view addSubview:self.game.view];
//            [self addChildViewController:self.game];
//            [_game release];
//            [self pageSelect:[NSIndexPath indexPathForRow:index inSection:1]];
//            break;
//        case 2:
//            [self.community  removeFromParentViewController];
//            self.community = [[ZZZCommunityViewController alloc] init];
//            [self.view addSubview:self.community.view];
//            [self addChildViewController:self.community];
//            [_community release];
//            [self pageSelect:[NSIndexPath indexPathForRow:index inSection:1]];
//            break;
//        case 3:
//            [self.collect removeFromParentViewController];
//            self.collect = [[ZZZCollectViewController alloc] init];
//            [self.view addSubview:self.collect.view];
//            [self addChildViewController:self.collect];
//            [_collect release];
//            [self pageSelect:[NSIndexPath indexPathForRow:index inSection:1]];
//            break;
//        case 4:
//            [self.gallery removeFromParentViewController];
//            self.gallery = [[ZZZGalleryViewController alloc] init];
//            [self.view addSubview:self.gallery.view];
//            [self addChildViewController:self.gallery];
//            [_gallery release];
//            [self pageSelect:[NSIndexPath indexPathForRow:index inSection:1]];
//            break;
        default:
            break;
    }
    [self.view bringSubviewToFront:self.forbidView];
    [self leftButtonClick:self.costumBt];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
