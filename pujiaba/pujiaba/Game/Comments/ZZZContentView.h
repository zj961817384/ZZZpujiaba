//
//  ZZZContentView.h
//  pujiaba
//
//  Created by zzzzz on 15/12/30.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZBaseView.h"


/**
 自定义图文混排的视图类
 
*/
@interface ZZZContentView : ZZZBaseView

/**
 *  内容
 */
@property (nonatomic, copy) NSString        *content;

- (instancetype)initWithWidth:(CGFloat)width content:(NSString *)string;

@end
