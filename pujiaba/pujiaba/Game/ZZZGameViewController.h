//
//  ZZZGameViewController.h
//  pujiaba
//
//  Created by zzzzz on 15/12/28.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZBaseViewController.h"

@interface ZZZGameViewController : ZZZBaseViewController

@property (nonatomic, copy) NSString *gameListURL;

/**
 *  用将要显示的游戏列表作为链接初始化
 *
 *  @param url 要显示的列表的接口
 *
 *  @return 对象实例
 */
- (instancetype)initWithGameListURL:(NSString *)url;

- (instancetype)initWithViewFrame:(CGRect)frame;

@end
