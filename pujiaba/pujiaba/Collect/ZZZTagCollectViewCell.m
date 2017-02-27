//
//  ZZZTagCollectViewCell.m
//  pujiaba
//
//  Created by zzzzz on 16/1/13.
//  Copyright © 2016年 zzzzz. All rights reserved.
//

#import "ZZZTagCollectViewCell.h"
#import "ZZZBaseLabel.h"

@interface ZZZTagCollectViewCell ()

@property (nonatomic, retain) ZZZBaseLabel   *tagNameLabel;

@end

@implementation ZZZTagCollectViewCell
- (void)dealloc{
    [_tagNameLabel release];
    [_tagName release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.tagNameLabel = [[ZZZBaseLabel alloc] initWithFrame:self.bounds];
        self.tagNameLabel.whiteBackColor = [UIColor colorWithRed:0.108 green:0.573 blue:0.379 alpha:1.000];
        self.tagNameLabel.nightBackColor = [UIColor colorWithRed:0.056 green:0.092 blue:0.182 alpha:1.000];
        self.tagNameLabel.textAlignment = NSTextAlignmentCenter;
        if ([@"night" isEqualToString:[USERDEFAULT objectForKey:CURRENT_SKIN]]) {
            [self.tagNameLabel setBackgroundColor:self.tagNameLabel.nightBackColor];
            self.tagNameLabel.textColor = self.tagNameLabel.nightTextColor;
        }else{
            [self.tagNameLabel setBackgroundColor:self.tagNameLabel.whiteBackColor];
            self.tagNameLabel.textColor = self.tagNameLabel.whiteTextColor;
        }
        [self.contentView addSubview:self.tagNameLabel];
        [_tagNameLabel release];
        
    }
    return self;
}

- (void)setTagName:(NSString *)tagName{
    if (_tagName != tagName) {
        [_tagName release];
        _tagName = [tagName copy];
        self.tagNameLabel.text = _tagName;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
