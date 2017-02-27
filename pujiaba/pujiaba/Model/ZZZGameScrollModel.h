//
//  ZZZGameScrollModel.h
//  pujiaba
//
//  Created by zzzzz on 15/12/26.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "BaseModel.h"

/**
 *  游戏滚动视图展示
 */
@interface ZZZGameScrollModel : BaseModel

@property (nonatomic, assign)   NSInteger   game_id;//游戏id
@property (nonatomic, copy)     NSString    *image;//游戏图片
@property (nonatomic, copy)     NSString    *title_cn;//游戏中文名字
@property (nonatomic, copy)     NSString    *pack;//游戏信息后的链接

@end
