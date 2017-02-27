//
//  ZZZGameScrollModel.m
//  pujiaba
//
//  Created by zzzzz on 15/12/26.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZGameScrollModel.h"

@implementation ZZZGameScrollModel

- (void)dealloc{
    [_image release];
    [_title_cn release];
    [_pack release];
    [super dealloc];
}

@end
