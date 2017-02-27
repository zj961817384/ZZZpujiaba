//
//  ZZZTagGameView.h
//  pujiaba
//
//  Created by zzzzz on 16/1/11.
//  Copyright © 2016年 zzzzz. All rights reserved.
//

#import "ZZZBaseView.h"

@interface ZZZTagGameView : ZZZBaseView

@property (nonatomic, copy) NSString *tagName;

@property (nonatomic, copy) NSString *language;

@property (nonatomic, assign) id<ZZZMyPushViewControllerDelegate> myDelegate;
@end
