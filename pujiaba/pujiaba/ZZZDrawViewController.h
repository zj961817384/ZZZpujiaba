//
//  ZZZDrawViewController.h
//  pujiaba
//
//  Created by zzzzz on 15/12/31.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZBaseViewController.h"

@protocol ZZZDrawViewControllerDelegate <NSObject>

- (void)pageSelect:(NSIndexPath *)index;

- (void)pageRefresh:(NSInteger)index;

@end

@interface ZZZDrawViewController : ZZZBaseViewController

@property (nonatomic, assign) id<ZZZDrawViewControllerDelegate> myDelegate;

@end
