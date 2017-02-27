//
//  ZZZGameListModel.m
//  pujiaba
//
//  Created by zzzzz on 15/12/26.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZGameListModel.h"

@implementation ZZZGameListModel

- (void)dealloc{
    [_pub_time release];
    [_icon release];
    [_hot release];
    [_size release];
    [_language release];
    [_type release];
    [super dealloc];
}

@end
