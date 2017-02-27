//
//  ZZZTopicCell.h
//  pujiaba
//
//  Created by zzzzz on 16/1/6.
//  Copyright © 2016年 zzzzz. All rights reserved.
//

#import "ZZZBaseTableViewCell.h"
#import "ZZZTopicModel.h"

@interface ZZZTopicCell : ZZZBaseTableViewCell

@property (nonatomic, assign) NSInteger     cellHeight;

@property (nonatomic, retain) ZZZTopicModel *model;

@end
