//
//  ZZZView.h
//  pujiaba
//
//  Created by zzzzz on 15/12/28.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZBaseView.h"
#import "ZZZGameListModel.h"

@protocol ZZZViewDelegate <NSObject>

//- (void)pushMyViewController:(UIViewController *)viewController;

@end

@interface ZZZView : ZZZBaseView

@property (nonatomic, retain) NSMutableArray<ZZZGameListModel *> *games;

@property (nonatomic, copy) NSString  *dataURL;

@property (nonatomic, assign) id<ZZZViewDelegate, ZZZMyPushViewControllerDelegate> myDelegate;

/**
 *  用要显示的列表接口初始化view
 *
 *  @param frame frame
 *  @param URL   要获取的接口链接，如果该参数为nil或为空串，则显示的是最新游戏列表
 *
 *  @return 对象实例
 */
- (instancetype)initWithFrame:(CGRect)frame andURL:(NSString *)URL;

@end
