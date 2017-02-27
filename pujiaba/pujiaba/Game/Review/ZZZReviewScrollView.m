//
//  ZZZReviewScrollView.m
//  pujiaba
//
//  Created by zzzzz on 16/1/5.
//  Copyright © 2016年 zzzzz. All rights reserved.
//

#import "ZZZReviewScrollView.h"
#import "ZZZContentView.h"

@interface ZZZReviewScrollView ()

@property (nonatomic, retain) ZZZContentView *myContentView;

@end

@implementation ZZZReviewScrollView

- (void)dealloc{
    [_myContentView release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.myContentView = [[ZZZContentView alloc] initWithFrame:self.bounds];
        self.bounces = NO;
        [self addSubview:self.myContentView];
        [_myContentView release];
    }
    return self;
}

- (void)setReviewContent:(NSString *)reviewContent{
    if (_reviewContent != reviewContent) {
        [_reviewContent release];
        _reviewContent = [reviewContent retain];
    }
    self.myContentView.content = _reviewContent;
    self.contentSize = CGSizeMake(self.myContentView.frame.size.width, self.myContentView.frame.size.height);
}

@end
