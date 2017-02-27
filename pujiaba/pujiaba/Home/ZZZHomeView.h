//
//  ZZZHomeView.h
//  pujiaba
//
//  Created by zzzzz on 15/12/26.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZBaseView.h"
#import "ZZZGameScrollModel.h"
#import "ZZZGameListModel.h"

@protocol ZZZHomeViewDelegate <NSObject>

- (void)pushMyViewController:(UIViewController *)viewController;

- (void)presentMyViewController:(UIViewController *)viewController;

- (void)showMoreNewGames;

@end

@interface ZZZHomeView : ZZZBaseView

@property (nonatomic, retain) NSMutableArray<ZZZGameScrollModel *>  *focus;
@property (nonatomic, retain) NSMutableArray<ZZZGameListModel *>    *list_hotArray;
@property (nonatomic, retain) NSMutableArray<ZZZGameListModel *>    *list_newArray;
@property (nonatomic, retain) NSMutableArray<NSString *>            *list_tag;

@property (nonatomic, assign) id<ZZZHomeViewDelegate> myDelegate;

@end
