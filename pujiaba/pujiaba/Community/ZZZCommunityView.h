//
//  ZZZCommunityView.h
//  pujiaba
//
//  Created by zzzzz on 15/12/28.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZBaseTableView.h"
#import "ZZZBaseView.h"
#import "ZZZBaseScrollView.h"
#import "ZZZTopicModel.h"

@protocol ZZZCommunityViewDelegate <NSObject>

//- (void)pushMyViewController:(UIViewController *)viewController;

@end

@interface ZZZCommunityView : ZZZBaseView

@property (nonatomic, assign) id<ZZZCommunityViewDelegate, ZZZMyPushViewControllerDelegate> myDelegate;

@end
