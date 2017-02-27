//
//  ZZZDBGameModel.h
//  pujiaba
//
//  Created by zzzzz on 16/1/13.
//  Copyright © 2016年 zzzzz. All rights reserved.
//

#import "BaseModel.h"

/** 数据库游戏收藏类 */
@interface ZZZDBGameModel : BaseModel

@property (nonatomic, copy) NSString    *gameName;
@property (nonatomic, assign) NSInteger  gameId;
@property (nonatomic, copy) NSString    *gamePack;
@property (nonatomic, copy) NSString    *gameIcon;
@property (nonatomic, copy) NSString    *gameSize;
@property (nonatomic, copy) NSString    *gameLanguage;
@property (nonatomic, copy) NSString    *gameType;
@property (nonatomic, assign) NSInteger  userId;

@end
