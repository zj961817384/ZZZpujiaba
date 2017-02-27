//
//  ZZZSleepTableViewCell.h
//  pujiaba
//
//  Created by zzzzz on 16/1/18.
//  Copyright © 2016年 zzzzz. All rights reserved.
//

#import "ZZZBaseTableViewCell.h"
#import "ZZZSleepTalkModel.h"

@interface ZZZSleepTableViewCell : ZZZBaseTableViewCell

@property (nonatomic, retain) ZZZSleepTalkModel *sleepModel;
@property (nonatomic, assign) CGFloat           myHeight;
@end
