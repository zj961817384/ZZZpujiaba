
//
//  ZZZBaseLabel.m
//  pujiaba
//
//  Created by zzzzz on 16/1/12.
//  Copyright © 2016年 zzzzz. All rights reserved.
//

#import "ZZZBaseLabel.h"

@implementation ZZZBaseLabel

- (void)dealloc{
    //在dealloc的时候取消通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CHANGE_SKIN object:nil];
    [_whiteBackColor release];
    [_nightBackColor release];
    [_whiteTextColor release];
    [_nightTextColor release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.whiteBackColor = [UIColor whiteColor];
        self.nightBackColor = [UIColor colorWithRed:0.184 green:0.243 blue:0.243 alpha:1.000];
        self.whiteTextColor = [UIColor blackColor];
        self.nightTextColor = [UIColor lightGrayColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:CHANGE_SKIN object:nil];
        
        if ([@"night" isEqualToString:[USERDEFAULT objectForKey:CURRENT_SKIN]]) {
            self.backgroundColor = self.nightBackColor;
            self.textColor = self.nightTextColor;
        }else{
            self.backgroundColor = self.whiteBackColor;
            self.textColor = self.whiteTextColor;
        }
    }
    return self;
}


- (void)changeSkin:(NSNotification *)notification{
    //    NSLog(@"切换皮肤（夜间模式）");
    NSString *str = notification.object;
    //    NSLog(@"%@", str);
    if ([@"night" isEqualToString:str]) {
        [USERDEFAULT setObject:@"night" forKey:CURRENT_SKIN];
        self.backgroundColor = self.nightBackColor;
        self.textColor = self.nightTextColor;
    }else if ([@"white" isEqualToString:str]){
        self.backgroundColor = self.whiteBackColor;
        self.textColor = self.whiteTextColor;
        [USERDEFAULT setObject:@"white" forKey:CURRENT_SKIN];
    }
}

@end
