//
//  ZZZConfigView.m
//  pujiaba
//
//  Created by zzzzz on 15/12/28.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZConfigView.h"
#import "ZZZBaseTableView.h"
#import "ZZZBaseTableViewCell.h"

#define CONFIGCELL      @"configCell"

@interface ZZZConfigView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) ZZZBaseTableView *tableView;

@property (nonatomic, retain) UISwitch *nightSwitch;

@end

@implementation ZZZConfigView

- (void)dealloc{
    [_tableView release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubview];
    }
    return self;
}

- (void)createSubview{
    self.tableView = [[ZZZBaseTableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
    [_tableView release];
    
    [self.tableView registerClass:[ZZZBaseTableViewCell class] forCellReuseIdentifier:CONFIGCELL];
    
    self.nightSwitch = [[[UISwitch alloc] initWithFrame:CGRectMake(WIDTH - 70, 12.5, 5, 5)] autorelease];
    [self.nightSwitch addTarget:self action:@selector(changeNightSwitch:) forControlEvents:UIControlEventValueChanged];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZZBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CONFIGCELL];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"关于我们";
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"清除缓存";
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"夜间模式";
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:self.nightSwitch];
        if ([@"night" isEqualToString:[USERDEFAULT objectForKey:CURRENT_SKIN]]) {
            [self.nightSwitch setOn:YES];
        }else{
            [self.nightSwitch setOn:NO];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1) {
        NSLog(@"清除缓存");
        CGFloat size = [self calculateDocumentSize];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"是否确定清除所有缓存?\n当前有%.2fM缓存", size] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            documentPath = [documentPath stringByAppendingPathComponent:@"Cache"];
            NSLog(@"%@", documentPath);
            if (![[NSFileManager defaultManager] fileExistsAtPath:documentPath]) {
                NSLog(@"路径不存在， 缓存数据已经被清空");
            }else{
                BOOL res = [[NSFileManager defaultManager] removeItemAtPath:documentPath error:nil];
                NSLog(@"%@", res ? @"清除成功" : @"清除失败");
            }
            UIAlertController *alerts = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"清除成功"]preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *acts1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alerts addAction:acts1];
            [self.myDelegate presentMyViewController:alerts];
        }];
        UIAlertAction *act2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            ;
        }];
        [alert addAction:act1];
        [alert addAction:act2];
        [self.myDelegate presentMyViewController:alert];
    }
}

/**
 *  计算document里面的Cache文件大小
 *
 *  @return 文件大小单位 ( M )
 */
- (CGFloat)calculateDocumentSize{
    NSFileManager *manage = [NSFileManager defaultManager];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    documentPath = [documentPath stringByAppendingPathComponent:@"Cache"];
    NSArray *arr = [manage subpathsAtPath:documentPath];
    CGFloat size = 0;
    for (NSString *pa in arr) {
        //        NSLog(@"%@", [manage attributesOfItemAtPath:[documentPath stringByAppendingPathComponent:pa] error:nil]);
        NSNumber *num = [[manage attributesOfItemAtPath:[documentPath stringByAppendingPathComponent:pa] error:nil] objectForKey:NSFileSize];
        size += num.floatValue;
    }
    return size / 1024 / 1024;
}


- (void)changeNightSwitch:(UISwitch *)nSwitch{
    if (nSwitch.on) {
        NSLog(@"打开夜间模式");
        [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_SKIN object:@"night"];
    }else{
        NSLog(@"关闭夜间模式");
        [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_SKIN object:@"white"];

    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
