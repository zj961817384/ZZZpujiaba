//
//  ZZZCollectView.h
//  pujiaba
//
//  Created by zzzzz on 15/12/28.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZBaseView.h"
#import "ZZZDataBaseSingleton.h"

@interface ZZZCollectView : ZZZBaseView

@property (nonatomic, retain) NSMutableArray<NSString *> *tagArray;

@property (nonatomic, retain) NSMutableArray<ZZZDBGameModel *> *gameArray;

@property (nonatomic, assign) id<ZZZMyPushViewControllerDelegate> myDelegate;

@end
