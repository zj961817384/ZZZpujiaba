//
//  ZZZCommentsTableView.h
//  pujiaba
//
//  Created by zzzzz on 15/12/30.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZBaseTableView.h"

@interface ZZZCommentsTableView : ZZZBaseTableView

@property (nonatomic, copy) NSString *pack;

@property (nonatomic, assign) id<UIScrollViewDelegate, ZZZMyPushViewControllerDelegate> myDelegate;

@end
