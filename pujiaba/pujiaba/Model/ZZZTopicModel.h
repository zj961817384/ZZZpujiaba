//
//  ZZZTopicModel.h
//  pujiaba
//
//  Created by zzzzz on 15/12/26.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "BaseModel.h"

/**
 *  话题类
 */
@interface ZZZTopicModel : BaseModel

/**
 *  话题内容
 */
@property (nonatomic, copy) NSString *content;

/**
 *  话题id
 */
@property (nonatomic, assign) NSInteger topic_id;

/**
 *  回复数量
 */
@property (nonatomic, assign) NSInteger num_replies;

/**
 *  发表人的头像
 */
@property (nonatomic, copy) NSString *user_gravatar;

/**
 *  话题标题
 */
@property (nonatomic, copy) NSString *subject;

/**
 *  浏览次数
 */
@property (nonatomic, assign) NSInteger num_views;

/**
 *  创建按时间
 */
@property (nonatomic, copy) NSString *created_on;

/**
 *  发表话题用户的用户名
 */
@property (nonatomic, copy) NSString *user_name;

@end
