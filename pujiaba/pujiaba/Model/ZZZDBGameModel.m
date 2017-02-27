//
//  ZZZDBGameModel.m
//  pujiaba
//
//  Created by zzzzz on 16/1/13.
//  Copyright © 2016年 zzzzz. All rights reserved.
//

#import "ZZZDBGameModel.h"

@implementation ZZZDBGameModel

- (void)dealloc{
    [_gameName release];
    [_gamePack release];
    [_gameIcon release];
    [_gameSize release];
    [_gameLanguage release];
    [_gameType release];
    [super dealloc];
}

@end
