//
//  ZZZDrawViewController.m
//  pujiaba
//
//  Created by zzzzz on 15/12/31.
//  Copyright © 2015年 zzzzz. All rights reserved.
//



#import "ZZZDrawViewController.h"
#import "ZZZBaseTableView.h"
#import "ZZZBaseTableViewCell.h"
#import "ZZZBaseView.h"

@interface ZZZDrawViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UIView            *myView;
@property (nonatomic, retain) ZZZBaseTableView  *tableView;
@property (nonatomic, retain) NSMutableArray    *dataArray;
@property (nonatomic, retain) NSMutableArray    *imgArray;

@end

@implementation ZZZDrawViewController

- (void)dealloc{
    [_myView release];
    [_tableView release];
    [_dataArray release];
    
    [super dealloc];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self createSubview];
    //选中第一个cell
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1] animated:NO scrollPosition:UITableViewScrollPositionTop];
}

- (void)createSubview{
    
    self.dataArray = [NSMutableArray arrayWithObjects:@"主页", @"游戏", @"社区", @"收藏", @"福利", nil];
    self.imgArray = [NSMutableArray arrayWithObjects:@"iconfont-home.png",
                     @"iconfont-game.png",
                     @"iconfont-fire.png",
                     @"iconfont-star.png",
                     @"iconfont-liwu.png", nil];
    
    
    self.view.frame = CGRectMake(-DRAWERWIDTH, 64, DRAWERWIDTH, HEIGHT - 64);
    self.myView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.myView];
//    [self.myView setBackgroundColor:[UIColor greenColor]];
    [_myView release];
    
    self.tableView = [[ZZZBaseTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.myView addSubview:self.tableView];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.scrollEnabled = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [_tableView release];
    [self.tableView registerClass:[ZZZBaseTableViewCell class] forCellReuseIdentifier:@"cell2"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else if (section == 1){
        return self.dataArray.count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZZBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
//    [cell setBackgroundColor:[UIColor whiteColor]];
    if (indexPath.section == 1) {
        cell.textLabel.text = self.dataArray[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:self.imgArray[indexPath.row]];
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        if (indexPath.row == 0) {
            cell.contentView.tag = 1000 + indexPath.row;
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
            [cell.contentView addGestureRecognizer:longPress];
            [longPress release];
        }
        
    }else{
        cell.textLabel.text = @"设置";
        cell.imageView.image = [UIImage imageNamed:@"iconfont-config.png"];
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 130;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        ZZZBaseView *view = [[ZZZBaseView alloc] initWithFrame:CGRectMake(0, 0, DRAWERWIDTH, 160)];
        view.whiteColor = [UIColor colorWithRed:0.715 green:1.000 blue:0.731 alpha:1.000];
        if ([@"night" isEqualToString:[USERDEFAULT objectForKey:CURRENT_SKIN]]) {
            ;
        }else{
            [view setBackgroundColor:view.whiteColor];
        }
        return view;
    }else{
        ZZZBaseView *view = [[ZZZBaseView alloc] initWithFrame:CGRectMake(0, 0, DRAWERWIDTH, 1)];
        view.whiteColor = [UIColor lightGrayColor];
        view.nightColor = [UIColor lightGrayColor];
        if ([@"night" isEqualToString:[USERDEFAULT objectForKey:CURRENT_SKIN]]) {
            [view setBackgroundColor:view.nightColor];
        }else{
            [view setBackgroundColor:view.whiteColor];
        }
        return view;
    }
}

- (void)longPressGesture:(UILongPressGestureRecognizer *)longPress{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if (longPress.view.tag == 1000) {
            [self.myDelegate pageRefresh:0];
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.myDelegate pageSelect:indexPath];
}




@end
