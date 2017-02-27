//
//  ZZZGameDetailModel.m
//  pujiaba
//
//  Created by zzzzz on 15/12/26.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZGameDetailModel.h"

@implementation ZZZGameDetailModel

- (void)dealloc{
    [_images_list release];
    [_obb_link release];
    [_obb_path release];
    [_apk_link release];
    [_review_content release];
    [_content release];
    [_create_on release];
    [super dealloc];
}

@end
