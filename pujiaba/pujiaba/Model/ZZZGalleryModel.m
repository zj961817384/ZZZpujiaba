//
//  ZZZGalleryModel.m
//  pujiaba
//
//  Created by zzzzz on 15/12/26.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZGalleryModel.h"

@implementation ZZZGalleryModel

- (void)dealloc{
    [_add_time release];
    [_tags release];
    [_title release];
    [_imgs release];
    [super dealloc];
}

@end
