//
//  ZZZTopicCell.m
//  pujiaba
//
//  Created by zzzzz on 16/1/6.
//  Copyright © 2016年 zzzzz. All rights reserved.
//

#import "ZZZTopicCell.h"
#import "ZZZContentView.h"
#import "UIImageView+WebCache.h"

@interface ZZZTopicCell ()

@property (nonatomic, retain) UIImageView       *headIcon;
@property (nonatomic, retain) UILabel           *nameLabel;
@property (nonatomic, retain) UILabel           *timeLabel;
@property (nonatomic, retain) ZZZContentView     *myContentView;

@end

@implementation ZZZTopicCell

- (void)dealloc{
    [_headIcon release];
    [_nameLabel release];
    [_timeLabel release];
    [_myContentView release];
    [super dealloc];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        [self createSubview];
    }
    return self;
}


- (void)createSubview{
    self.headIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 60, 60)];
//    [self.headIcon setBackgroundColor:[UIColor greenColor]];
    self.headIcon.layer.cornerRadius = self.headIcon.frame.size.width / 2;
    self.headIcon.layer.masksToBounds = YES;
    [self.contentView addSubview:self.headIcon];
    [_headIcon release];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + self.headIcon.frame.size.width + 5, 15, WIDTH - self.headIcon.frame.size.width - self.headIcon.frame.origin.x - 5 - 70, 20)];
//        [self.nameLabel setBackgroundColor:[UIColor purpleColor]];
    self.nameLabel.font = [UIFont systemFontOfSize:14];
//    self.nameLabel.textColor = [UIColor lightGrayColor];

    [self.contentView addSubview:self.nameLabel];
    [_nameLabel release];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.frame.origin.x, self.nameLabel.frame.origin.y, 60, 20)];
//        [self.timeLabel setBackgroundColor:[UIColor yellowColor]];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.timeLabel];
    [_timeLabel release];
    
    self.myContentView = [[ZZZContentView alloc] initWithFrame:CGRectMake(self.nameLabel.frame.origin.x, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height, self.nameLabel.frame.size.width + self.timeLabel.frame.size.width, 20)];
    [self.contentView addSubview:self.myContentView];
    [_myContentView release];
}

- (void)setModel:(ZZZTopicModel *)model{
    if (_model != model) {
        [_model release];
        _model = [model retain];
    }
    self.nameLabel.text = _model.user_name;
    self.timeLabel.text = _model.created_on;
//    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:[BASE_URL stringByAppendingPathComponent:_model.user_gravatar]]];
    [AppTools getDataFromNetUseGETMethodWithUrl:[BASE_URL stringByAppendingPathComponent:_model.user_gravatar] andParameters:nil successBlock:^(NSData *resultData) {
        if (resultData.length > 0) {
            self.headIcon.image = [UIImage imageWithData:resultData];
        }
    } failBlock:^(NSError *error) {
        NSLog(@"网络请求图片失败");
    }];
    self.myContentView.content = _model.subject;
    CGRect frame = self.timeLabel.frame;
    frame.origin.x = self.nameLabel.frame.origin.x;
    frame.origin.y = self.myContentView.frame.origin.y + self.myContentView.frame.size.height;
    self.timeLabel.frame = frame;
    [self.timeLabel sizeToFit];
    self.cellHeight = self.timeLabel.frame.size.height + self.timeLabel.frame.origin.y + 10;
}


@end
