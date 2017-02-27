//
//  ZZZBaseButton.m
//  pujiaba
//
//  Created by zzzzz on 15/12/26.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZBaseButton.h"

@implementation ZZZBaseButton

- (void)dealloc{
    //在dealloc的时候取消通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CHANGE_SKIN object:nil];
    [_nightBackColor release];
    [_whiteBackColor release];
    [_whiteTextColor release];
    [_nightTextColor release];
    [super dealloc];
}

+ (instancetype)buttonWithType:(UIButtonType)buttonType{
    ZZZBaseButton *btn = [super buttonWithType:buttonType];
    if (btn) {
        btn.whiteBackColor = [UIColor clearColor];
//        btn.nightBackColor = [UIColor colorWithRed:0.184 green:0.243 blue:0.243 alpha:1.000];
        btn.nightBackColor = [UIColor clearColor];
        btn.whiteTextColor = [UIColor colorWithWhite:0.198 alpha:1.000];
        btn.nightTextColor = [UIColor lightGrayColor];
        
        //不能直接在便利构造器里面（或者说是类方法里面）注册消息，因为方法选择器参数会被认为也是静态方法（类方法），然后导致找不到方法而crash
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:CHANGE_SKIN object:nil];
        
        [btn registNotification];
        if ([@"night" isEqualToString:[USERDEFAULT objectForKey:CURRENT_SKIN]]) {
            btn.backgroundColor = btn.nightBackColor;
//            btn.titleLabel.textColor = btn.nightTextColor;
            [btn setTitleColor:btn.nightTextColor forState:UIControlStateNormal];
        }else{
            btn.backgroundColor = btn.whiteBackColor;
//            btn.titleLabel.textColor = btn.whiteTextColor;
            [btn setTitleColor:btn.whiteTextColor forState:UIControlStateNormal];
        }
    }
    return btn;
}

- (void)registNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:CHANGE_SKIN object:nil];
}

- (void)changeSkin:(NSNotification *)notification{
    //    NSLog(@"切换皮肤（夜间模式）");
    NSString *str = notification.object;
    //    NSLog(@"%@", str);
    if ([@"night" isEqualToString:str]) {
        [USERDEFAULT setObject:@"night" forKey:CURRENT_SKIN];
        self.backgroundColor = self.whiteBackColor;
        self.titleLabel.textColor = self.whiteTextColor;
    }else if ([@"white" isEqualToString:str]){
        [USERDEFAULT setObject:@"white" forKey:CURRENT_SKIN];
        self.backgroundColor = self.nightBackColor;
        self.titleLabel.textColor = self.nightTextColor;
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
