//
//  ZZZDataBaseSingleton.m
//  pujiaba
//
//  Created by zzzzz on 16/1/12.
//  Copyright © 2016年 zzzzz. All rights reserved.
//

#import "ZZZDataBaseSingleton.h"
#import "FMDatabase.h"

@interface ZZZDataBaseSingleton ()

@property (nonatomic, retain) FMDatabase *fmdb;

@end

@implementation ZZZDataBaseSingleton

- (void)dealloc{
    [_fmdb release];
    [super dealloc];
}

+ (instancetype)shareDataBaseManager{
    static ZZZDataBaseSingleton *dataBase = nil;
    static dispatch_once_t onceToken;
    if (dataBase == nil) {
        dispatch_once(&onceToken, ^{
            dataBase = [[ZZZDataBaseSingleton alloc] init];
        });
    }
    return dataBase;
}

- (BOOL)createTable{
    NSString *sqlString = @"CREATE TABLE IF NOT EXISTS tb_collectTag(\
    id INTEGER PRIMARY KEY AUTOINCREMENT,\
    tagName TEXT,\
    userId INTEGER\
    )";
    BOOL result = [self.fmdb executeUpdate:sqlString];
    if (!result) {
        NSLog(@"创建tag收藏表创建失败");
        return NO;
    }else{
        NSLog(@"创建tag收藏表创建成功");
    }
    
    sqlString = @"CREATE TABLE IF NOT EXISTS tb_collectGame(\
    id          INTEGER PRIMARY KEY AUTOINCREMENT,\
    gameName    TEXT,\
    gameId      TEXT,\
    gamePack    TEXT,\
    gameIcon    TEXT,\
    gameSize    TEXT,\
    gameLanguage TEXT,\
    gameType    TEXT,\
    userId      INTEGER\
    )";
    result = [self.fmdb executeUpdate:sqlString];
    if (!result) {
        NSLog(@"创建game收藏表创建失败");
        return NO;
    }else{
        NSLog(@"创建game收藏表创建成功");
    }

    return YES;
}

- (BOOL)openDB{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"db_pujiahh8.sqlite"];
    NSLog(@"filePath = %@",filePath);
    //创建数据库对象
    self.fmdb = [[FMDatabase alloc]initWithPath:filePath];
    //打开数据库
    BOOL result = [self.fmdb open];
    if (result) {
        NSLog(@"打开数据库成功");
    }else{
        NSLog(@"打开数据库失败");
    }
    return result;
}

- (BOOL)insertTag:(NSString *)tagName andUserId:(NSInteger)userId{
    NSString *sqlString = [NSString stringWithFormat:@"INSERT INTO tb_collectTag(tagName,userId) VALUES('%@',%ld)", tagName, (long)userId];
    NSLog(@"%@", sqlString);
    BOOL result = [self.fmdb executeUpdate:sqlString];
    if (result) {
        NSLog(@"标签收藏插入数据成功");
    }else{
        NSLog(@"标签收藏插入数据失败");
    }
    return result;
}

- (BOOL)insertGame:(ZZZDBGameModel *)game andUserId:(NSInteger)userId{
    //game的pack里面带有（点）.
    //所以要吧这些点都换成下划线（_）
    
    NSString *sqlString = [NSString stringWithFormat:@"INSERT INTO tb_collectGame(gameName,gamePack,gameId,userId) VALUES('%@','%@',%ld,%ld)", game.gameName, [game.gamePack stringByReplacingOccurrencesOfString:@"." withString:@"。。。，，，。。。"], (long)game.gameId, (long)userId];
    //之所以把点转换成这一串字符，是因为包名里面带有点（.）的话，往数据库里面存的时候会出错，开始我也转成下划线过，但是有的包里面既有点又有下划线，所以就改成这个字符了。。。
    NSLog(@"%@", sqlString);
    BOOL result = [self.fmdb executeUpdate:sqlString];
    if (result) {
        NSLog(@"游戏收藏插入数据成功");
    }else{
        NSLog(@"游戏收藏插入数据失败");
    }
    return result;
}

- (NSMutableArray<ZZZDBGameModel *> *)selectGameWithUserId:(NSInteger)userId{
    NSMutableArray *array = [NSMutableArray array];
    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM tb_collectGame where userId=%ld",userId];
    NSLog(@"%@", sqlString);
    FMResultSet *resultSet = [self.fmdb executeQuery:sqlString];
    while ([resultSet next]) {
        ZZZDBGameModel *model = [[ZZZDBGameModel alloc] init];
        model.gameName = [resultSet stringForColumn:@"gameName"];
        model.gameId = [resultSet intForColumn:@"gameId"];
        model.gameIcon = [resultSet stringForColumn:@"gameIcon"];
        model.gameLanguage = [resultSet stringForColumn:@"gameLanguage"];
        //反向转换点(.)
        model.gamePack = [[resultSet stringForColumn:@"gamePack"] stringByReplacingOccurrencesOfString:@"。。。，，，。。。" withString:@"."];
        model.gameSize = [resultSet stringForColumn:@"gameSize"];
        model.gameType = [resultSet stringForColumn:@"gameType"];
        [array addObject:model];
        [model release];
    }
    return array;
}

- (NSMutableArray<NSString *> *)selectTagWithUserId:(NSInteger)userId{
    NSMutableArray *array = [NSMutableArray array];
    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM tb_collectTag where userId=%ld",userId];
    NSLog(@"%@", sqlString);
    FMResultSet *resultSet = [self.fmdb executeQuery:sqlString];
    while ([resultSet next]) {
        [array addObject:[resultSet stringForColumn:@"tagName"]];
    }
    return array;
}

- (BOOL)tagIsExistWithTagName:(NSString *)tagName andUserId:(NSInteger)userId{
    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM tb_collectTag where userId=%ld AND tagName='%@'",userId, tagName];
    NSLog(@"%@", sqlString);
    FMResultSet *resultSet = [self.fmdb executeQuery:sqlString];
    while ([resultSet next]) {
        NSLog(@"标签已经被收藏");
        return YES;
    }
    NSLog(@"标签没有被收藏");
    return NO;
}

- (BOOL)gameIsExistWithGameId:(NSInteger)gameId andUserId:(NSInteger)userId{
    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM tb_collectGame where userId=%ld AND gameId=%ld", userId, gameId];
    NSLog(@"%@", sqlString);
    FMResultSet *resultSet = [self.fmdb executeQuery:sqlString];
    while ([resultSet next]) {
        NSLog(@"游戏已经被收藏");
        return YES;
    }
    NSLog(@"游戏没有被收藏");
    return NO;
}

- (BOOL)deleteGameWith:(NSInteger)gameId andUserId:(NSInteger)userId{
    NSString *sqlString = [NSString stringWithFormat:@"DELETE FROM tb_collectGame WHERE gameId=%ld AND userId=%ld", gameId, userId];
    BOOL result = [self.fmdb executeUpdate:sqlString];
    if (result) {
        NSLog(@"游戏收藏删除数据成功");
    }else{
        NSLog(@"游戏收藏删除数据失败");
    }
    return result;
}

- (BOOL)deleteTagWith:(NSString *)tagName andUserId:(NSInteger)userId{
    NSString *sqlString = [NSString stringWithFormat:@"DELETE FROM tb_collectTag WHERE tagName='%@' AND userId=%ld", tagName, userId];
    BOOL result = [self.fmdb executeUpdate:sqlString];
    if (result) {
        NSLog(@"标签收藏删除数据成功");
    }else{
        NSLog(@"标签收藏删除数据失败");
    }
    return result;
}

@end
