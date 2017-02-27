//
//  ZZZGameDetailModel.h
//  pujiaba
//
//  Created by zzzzz on 15/12/26.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "BaseModel.h"
#import "ZZZGameListModel.h"

/**
 *  游戏详细信息类
 */
@interface ZZZGameDetailModel : ZZZGameListModel

@property (nonatomic, retain) NSMutableArray  *images_list;//游戏信息上面scrollview
@property (nonatomic, assign) NSInteger      num_comments;//评论总数
@property (nonatomic, assign) NSInteger      num_views;//不知道是啥。。。浏览次数？人气
@property (nonatomic, assign) BOOL           obb;//不知道是啥，在什么地方用,可能是 是否有数据包
@property (nonatomic, copy) NSString        *obb_path;//如果上面参数是true，这个就是数据包的lujing
@property (nonatomic, copy) NSString        *apk_link;//安卓包的下载链接
@property (nonatomic, copy) NSString        *obb_link;//数据包的下载链接
@property (nonatomic, copy) NSString        *review_content;//游戏评测的内容，如果里面有图片链接，就要转成图片
@property (nonatomic, copy) NSString        *content;//详细信息描述
@property (nonatomic, copy) NSString        *create_on;//创建时间..暂时不知道什么的创建时间
@property (nonatomic, assign) BOOL           review;//是否有评测
@property (nonatomic, assign) BOOL           gospel;//不知道是干什么的。。
@property (nonatomic, assign) NSInteger      iId;//游戏id，

@end
