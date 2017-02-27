//
//  ZZZCommentModel.m
//  pujiaba
//
//  Created by zzzzz on 15/12/26.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZCommentModel.h"

@implementation ZZZCommentModel

- (void)dealloc{
    [_user_gravatar release];
    [_content release];
    [_created_on release];
    [_user_name release];
    [super dealloc];
}

@end
