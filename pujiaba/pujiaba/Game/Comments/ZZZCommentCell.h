//
//  ZZZCommentCell.h
//  pujiaba
//
//  Created by zzzzz on 15/12/30.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZBaseTableViewCell.h"
#import "ZZZCommentModel.h"

@interface ZZZCommentCell : ZZZBaseTableViewCell

@property (nonatomic, retain) ZZZCommentModel   *model;
@property (nonatomic, assign) CGFloat           cellHeight;

@end
