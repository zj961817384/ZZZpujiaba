//
//  ZZZSearchResultView.h
//  pujiaba
//
//  Created by zzzzz on 16/1/11.
//  Copyright © 2016年 zzzzz. All rights reserved.
//

#import "ZZZBaseView.h"
#import "ZZZGameListModel.h"

@interface ZZZSearchResultView : ZZZBaseView

@property (nonatomic, copy) NSString *searchKey;

@property (nonatomic, assign) id<ZZZMyPushViewControllerDelegate> myDelegate;
@end
