//
//  ZZZDataBaseSingleton.h
//  pujiaba
//
//  Created by zzzzz on 16/1/12.
//  Copyright © 2016年 zzzzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZZDBGameModel.h"

@interface ZZZDataBaseSingleton : NSObject

+ (instancetype)shareDataBaseManager;

- (BOOL)openDB;

- (BOOL)createTable;

- (BOOL)insertTag:(NSString *)tagName andUserId:(NSInteger)userId;

- (BOOL)insertGame:(ZZZDBGameModel *)game andUserId:(NSInteger)userId;

- (BOOL)tagIsExistWithTagName:(NSString *)tagName andUserId:(NSInteger)userId;

- (BOOL)gameIsExistWithGameId:(NSInteger)gameId andUserId:(NSInteger)userId;

- (NSMutableArray<NSString*>*)selectTagWithUserId:(NSInteger)userId;

- (NSMutableArray<ZZZDBGameModel*>*)selectGameWithUserId:(NSInteger)userId;

- (BOOL)deleteGameWith:(NSInteger)gameId andUserId:(NSInteger)userId;

- (BOOL)deleteTagWith:(NSString *)tagName andUserId:(NSInteger)userId;

@end
