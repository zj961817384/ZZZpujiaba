//
//  ZZZCircleButtonView.h
//  pujiaba
//
//  Created by zzzzz on 16/1/8.
//  Copyright © 2016年 zzzzz. All rights reserved.
//

#import "ZZZBaseView.h"

@interface ZZZCircleButtonView : ZZZBaseView

@property (nonatomic, retain) UIImage *myIcon;

@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, assign) CGPoint centerPoint;

- (instancetype)initWithCenterPoint:(CGPoint)point andRadius:(CGFloat)radius;

@end
