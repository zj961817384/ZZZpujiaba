//
//  ZZZGameDetailView.h
//  pujiaba
//
//  Created by zzzzz on 15/12/28.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZBaseView.h"
#import "ZZZGameDetailModel.h"
#import "ZZZCommentModel.h"

@interface ZZZGameDetailView : ZZZBaseView

@property (nonatomic, retain) ZZZGameDetailModel    *detailModel;

@property (nonatomic, assign) id<ZZZMyPushViewControllerDelegate> myDelegate;

@end
