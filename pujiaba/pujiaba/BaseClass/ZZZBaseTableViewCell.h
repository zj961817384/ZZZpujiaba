//
//  ZZZBaseTableViewCell.h
//  pujiaba
//
//  Created by zzzzz on 15/12/26.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZZBaseTableViewCell : UITableViewCell

@property (nonatomic, copy)UIColor *whiteColor;
@property (nonatomic, copy)UIColor *nightColor;

@property (nonatomic, copy)UIColor *whiteSelectColor;
@property (nonatomic, copy)UIColor *nightSelectColor;

- (void)changeSkin:(NSNotification *)notification;

@end
