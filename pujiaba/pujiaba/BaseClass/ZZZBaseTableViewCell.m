//
//  ZZZBaseTableViewCell.m
//  pujiaba
//
//  Created by zzzzz on 15/12/26.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZBaseTableViewCell.h"

@implementation ZZZBaseTableViewCell

- (void)dealloc{
    //在dealloc的时候取消通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CHANGE_SKIN object:nil];
    [_nightColor release];
    [_whiteColor release];
    [_nightSelectColor release];
    [_whiteSelectColor release];
    [super dealloc];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.whiteColor = [UIColor whiteColor];
        self.nightColor = [UIColor colorWithRed:0.184 green:0.243 blue:0.243 alpha:1.000];
        self.whiteSelectColor = [UIColor colorWithWhite:0.895 alpha:1.000];
        self.nightSelectColor = [UIColor colorWithWhite:0.274 alpha:1.000];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:CHANGE_SKIN object:nil];
        
        UIView *bv = [[UIView alloc] init];

        if ([USERDEFAULT objectForKey:CURRENT_SKIN] == nil || [@"white" isEqualToString:[USERDEFAULT objectForKey:CURRENT_SKIN]]) {
            self.backgroundColor = self.whiteColor;
            [bv setBackgroundColor:self.whiteSelectColor];
        }else{
            [bv setBackgroundColor:self.nightSelectColor];
            self.backgroundColor = self.nightColor;
        }
        self.selectedBackgroundView = bv;
    }
    return self;
}

- (void)changeSkin:(NSNotification *)notification{
    //    NSLog(@"切换皮肤（夜间模式）");
    NSString *str = notification.object;
    //    NSLog(@"%@", str);
    if ([@"night" isEqualToString:str]) {
        [USERDEFAULT setObject:@"night" forKey:CURRENT_SKIN];
        self.backgroundColor = self.nightColor;
        UIView *bsv = [[UIView alloc] init];
        [bsv setBackgroundColor:self.nightSelectColor];
        self.selectedBackgroundView = bsv;
    }else if ([@"white" isEqualToString:str]){
        //        self.backgroundColor = [UIColor colorWithRed:0.086 green:0.641 blue:0.433 alpha:1.000];
        [USERDEFAULT setObject:@"white" forKey:CURRENT_SKIN];
        self.backgroundColor = self.whiteColor;
        UIView *bsv = [[UIView alloc] init];
        [bsv setBackgroundColor:self.whiteSelectColor];
        self.selectedBackgroundView = bsv;
    }
}


@end
