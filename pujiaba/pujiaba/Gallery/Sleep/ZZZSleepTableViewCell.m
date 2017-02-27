//
//  ZZZSleepTableViewCell.m
//  pujiaba
//
//  Created by zzzzz on 16/1/18.
//  Copyright © 2016年 zzzzz. All rights reserved.
//

#import "ZZZSleepTableViewCell.h"
#import "ZZZBaseLabel.h"

@interface ZZZSleepTableViewCell ()

@property (nonatomic, retain) UIImageView   *headImageView;
@property (nonatomic, retain) UIImageView   *talkImageView;
@property (nonatomic, retain) ZZZBaseLabel  *talkLabel;
@property (nonatomic, retain) ZZZBaseLabel  *nameLabel;

@end

@implementation ZZZSleepTableViewCell

- (void)dealloc{
    [_sleepModel release];
    
    [_headImageView release];
    [_talkLabel release];
    [_nameLabel release];
    
    [super dealloc];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
        [self.contentView addSubview:_headImageView];
        [_headImageView release];
        
        self.nameLabel = [[ZZZBaseLabel alloc] initWithFrame:CGRectMake(5, _headImageView.frame.size.height + 5, 30, 20)];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_nameLabel];
        [_nameLabel release];
        
        self.talkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5 + _headImageView.frame.size.width, 5, WIDTH - 10, 50)];
        [self.contentView addSubview:_talkImageView];
        [_talkImageView release];
        
        self.talkLabel = [[ZZZBaseLabel alloc] initWithFrame:CGRectMake(5 + _headImageView.frame.size.width + 5, 5 + 5, WIDTH - 15, 40)];
        [self.contentView addSubview:_talkLabel];
        [_talkLabel release];
        
    }
    return self;
}



- (void)setSleepModel:(ZZZSleepTalkModel *)sleepModel{
    if (_sleepModel != sleepModel) {
        [_sleepModel release];
        _sleepModel = [sleepModel retain];
        
        
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
