//
//  ZZZHomeViewController.h
//  pujiaba
//
//  Created by zzzzz on 15/12/26.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZBaseViewController.h"

@protocol ZZZHomeViewControllerDelegate <NSObject>

- (void)selectGamePage;

@end

@interface ZZZHomeViewController : ZZZBaseViewController

- (instancetype)initWithViewFrame:(CGRect)frame;

@property (nonatomic, assign) id<ZZZHomeViewControllerDelegate> myDelegate;

@end
