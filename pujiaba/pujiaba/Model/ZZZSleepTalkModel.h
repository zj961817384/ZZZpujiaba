//
//  ZZZSleepTalkModel.h
//  pujiaba
//
//  Created by zzzzz on 16/1/18.
//  Copyright © 2016年 zzzzz. All rights reserved.
//

#import "BaseModel.h"

@interface ZZZSleepTalkModel : BaseModel

/** 谈话内容 */
@property (nonatomic, copy) NSString *text;
/** 用户头像链接 */
@property (nonatomic, copy) NSString *avatar_url;
@property (nonatomic, assign) BOOL success;
/** 声音文件链接 */
@property (nonatomic, copy) NSString *file;
/** 名字 */
@property (nonatomic, copy) NSString *title;

@end
