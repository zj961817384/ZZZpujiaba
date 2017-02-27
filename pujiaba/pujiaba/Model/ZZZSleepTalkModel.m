//
//  ZZZSleepTalkModel.m
//  pujiaba
//
//  Created by zzzzz on 16/1/18.
//  Copyright © 2016年 zzzzz. All rights reserved.
//

#import "ZZZSleepTalkModel.h"

@implementation ZZZSleepTalkModel

- (void)dealloc{
    [_avatar_url release];
    [_title release];
    [_text release];
    [_file release];
    [super dealloc];
}

@end
