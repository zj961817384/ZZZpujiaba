//
//  ZZZGameListModel.h
//  pujiaba
//
//  Created by zzzzz on 15/12/26.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "BaseModel.h"
#import "ZZZGameScrollModel.h"

/**
 *  游戏列表展示类
 */
@interface ZZZGameListModel : ZZZGameScrollModel

@property (nonatomic, copy)     NSString    *pub_time;//挂出时间
@property (nonatomic, assign)   NSInteger    pub_mktime;//挂出时间的时间戳
@property (nonatomic, copy)     NSString    *icon;//展示的图标
@property (nonatomic, copy)     NSString    *hot;//暂时不知道是什么含义，热度？
@property (nonatomic, copy)     NSString    *size;//游戏大小
@property (nonatomic, copy)     NSString    *language;//语言
@property (nonatomic, copy)     NSString    *type;//类型

@end
