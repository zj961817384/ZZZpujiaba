//
//  ZZZTopicModel.m
//  pujiaba
//
//  Created by zzzzz on 15/12/26.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZTopicModel.h"

@implementation ZZZTopicModel

- (void)dealloc{
    [_content release];
    [_user_gravatar release];
    [_subject release];
    [_created_on release];
    [_user_name release];
    [super dealloc];
}

@end
