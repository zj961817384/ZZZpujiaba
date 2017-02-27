//
//  ZZZTagGameViewController.h
//  pujiaba
//
//  Created by zzzzz on 16/1/11.
//  Copyright © 2016年 zzzzz. All rights reserved.
//

#import "ZZZBaseViewController.h"

@interface ZZZTagGameViewController : ZZZBaseViewController

@property (nonatomic, copy) NSString *tagName;

@property (nonatomic, copy) NSString *language;

- (instancetype)initWithTagName:(NSString *)tag;


@end
