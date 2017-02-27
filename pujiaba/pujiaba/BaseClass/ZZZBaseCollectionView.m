//
//  ZZZBaseCollectionView.m
//  pujiaba
//
//  Created by zzzzz on 15/12/26.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZBaseCollectionView.h"

@implementation ZZZBaseCollectionView

- (void)dealloc{
    //在dealloc的时候取消通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CHANGE_SKIN object:nil];
    [_nightColor release];
    [_whiteColor release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
//        self.backgroundColor = [UIColor whiteColor];
        self.whiteColor = [UIColor whiteColor];
        self.nightColor = [UIColor colorWithRed:0.184 green:0.243 blue:0.243 alpha:1.000];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:CHANGE_SKIN object:nil];
        
        if ([USERDEFAULT objectForKey:CURRENT_SKIN] == nil || [@"white" isEqualToString:[USERDEFAULT objectForKey:CURRENT_SKIN]]) {
            self.backgroundColor = self.whiteColor;
        }else{
            self.backgroundColor = self.nightColor;
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
        self.backgroundColor = self.nightColor;
    }else if ([@"white" isEqualToString:str]){
        //        self.backgroundColor = [UIColor colorWithRed:0.086 green:0.641 blue:0.433 alpha:1.000];
        self.backgroundColor = self.whiteColor;
        [USERDEFAULT setObject:@"white" forKey:CURRENT_SKIN];
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
