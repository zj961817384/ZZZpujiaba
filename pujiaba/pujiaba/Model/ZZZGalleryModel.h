//
//  ZZZGalleryModel.h
//  pujiaba
//
//  Created by zzzzz on 15/12/26.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "BaseModel.h"
/**
 *  画廊展示类
 */
@interface ZZZGalleryModel : BaseModel

/**
 *  添加时间
 */
@property (nonatomic, copy) NSString *add_time;
/**
 *  标记
 */
@property (nonatomic, copy) NSString *tags;
/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  图片链接字符串数组
 */
@property (nonatomic, strong) NSArray<NSString *> *imgs;
/**
 *  福利id
 */
@property (nonatomic, assign) NSInteger gallery_id;

@end
