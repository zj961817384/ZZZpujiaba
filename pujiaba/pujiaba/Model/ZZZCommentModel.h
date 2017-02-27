//
//  ZZZCommentModel.h
//  pujiaba
//
//  Created by zzzzz on 15/12/26.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "BaseModel.h"

/**
 *  评论
 */
@interface ZZZCommentModel : BaseModel

/**
 *  用户头像
 */
@property (nonatomic, copy) NSString *user_gravatar;
/**
 *  回复内容
 */
@property (nonatomic, copy) NSString *content;
/**
 *  创建时间
 */
@property (nonatomic, copy) NSString *created_on;
/**
 *  回复id
 */
@property (nonatomic, assign) NSInteger comment_id;
/**
 *  回复用户的用户名
 */
@property (nonatomic, copy) NSString *user_name;
/**
 *  是否是超言弹
 */
@property (nonatomic, assign) BOOL      hot;

@end
