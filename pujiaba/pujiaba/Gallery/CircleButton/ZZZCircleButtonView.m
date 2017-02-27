//
//  ZZZCircleButtonView.m
//  pujiaba
//
//  Created by zzzzz on 16/1/8.
//  Copyright © 2016年 zzzzz. All rights reserved.
//

#import "ZZZCircleButtonView.h"

@interface ZZZCircleButtonView ()

@property (nonatomic, retain) ZZZBaseView   *menuView;

@property (nonatomic, retain) UIImageView   *iconView;

@end

@implementation ZZZCircleButtonView

- (void)dealloc{
    [_menuView release];
    [_iconView release];
    [_myIcon release];
    [super dealloc];
}

- (instancetype)initWithCenterPoint:(CGPoint)point andRadius:(CGFloat)radius{
    self = [super initWithFrame:CGRectMake(point.x - radius, point.y - radius, 2 * radius, 2 * radius)];
    if (self) {
        _radius = radius;
        _centerPoint = point;
        [self createSubview];
    }
    return self;
}

- (void)createSubview{
    
    self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _radius * sqrt(2), _radius * sqrt(2))];
    self.iconView.frame = PCENTER(self, self.iconView);
    [self addSubview:self.iconView];
    self.iconView.image = self.myIcon;
    [_iconView release];
    
    self.layer.cornerRadius = _radius;
}

- (void)setMyIcon:(UIImage *)myIcon{
    if (_myIcon != myIcon) {
        [_myIcon release];
        _myIcon = [myIcon retain];
        self.iconView.image = _myIcon;
    }
}

- (void)setCenterPoint:(CGPoint)centerPoint{
    CGFloat xOffset = centerPoint.x - _centerPoint.x;
    CGFloat yOffset = centerPoint.y - _centerPoint.y;
    _centerPoint.x = centerPoint.x;
    _centerPoint.y = centerPoint.y;
    CGRect frame = self.frame;
    frame.origin.x += xOffset;
    frame.origin.y += yOffset;
    self.frame = frame;
}

@end
