//
//  ZZZCommentCell.m
//  pujiaba
//
//  Created by zzzzz on 15/12/30.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZCommentCell.h"
#import "ZZZContentView.h"
#import "UIImageView+WebCache.h"

@interface ZZZCommentCell ()

@property (nonatomic, retain) UIImageView       *headIcon;
@property (nonatomic, retain) UILabel           *nameLabel;
@property (nonatomic, retain) UILabel           *timeLabel;
@property (nonatomic, retain) ZZZContentView    *myContentView;

@end

@implementation ZZZCommentCell

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
//    [self.nameLabel setBackgroundColor:[UIColor redColor]];
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    self.nameLabel.textColor = [UIColor lightGrayColor];
    self.nameLabel.text = self.model.user_name;
    [self.contentView addSubview:self.nameLabel];
    [_nameLabel release];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 70, self.nameLabel.frame.origin.y, 60, 20)];
//    [self.timeLabel setBackgroundColor:[UIColor greenColor]];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.timeLabel];
    [_timeLabel release];
    
    self.myContentView = [[ZZZContentView alloc] initWithFrame:CGRectMake(self.nameLabel.frame.origin.x, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height, self.nameLabel.frame.size.width + self.timeLabel.frame.size.width, 20)];
    [self.contentView addSubview:self.myContentView];
    [_myContentView release];
}

- (void)setModel:(ZZZCommentModel *)model{
    if (_model != model) {
        [_model release];
        _model = [model retain];
    }
    self.nameLabel.text = _model.user_name;
    self.timeLabel.text = [self timeChange:_model.created_on];
//    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:[BASE_URL stringByAppendingPathComponent:_model.user_gravatar]]];
    [AppTools getDataFromNetUseGETMethodWithUrl:[BASE_URL stringByAppendingPathComponent:_model.user_gravatar] andParameters:nil successBlock:^(NSData *resultData) {
        if (resultData.length > 0) {
            self.headIcon.image = [UIImage imageWithData:resultData];
        }
    } failBlock:^(NSError *error) {
        NSLog(@"网络请求图片失败");
    }];
    self.myContentView.content = _model.content;
    self.cellHeight = self.myContentView.frame.size.height + self.myContentView.frame.origin.y + 10;
}

/**
 *  把传过来的时间转换成相对现在的时间
 *
 *  @param time 需要转换的时间，格式：2015-12-27 17:33:28
 *
 *  @return 转换后的时间，例如，1小时前，1天前...
 */
- (NSString *)timeChange:(NSString *)time{
    NSString *result = @"";
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *now = [NSDate date];
    NSDate *create = [format dateFromString:time];
    NSUInteger mktime = [now timeIntervalSinceDate:create];
//    NSLog(@"%lu", mktime);
    NSInteger day = mktime / 86400;//一天是86400秒
    if (day < 1) {//如果小于一天
        NSInteger m = mktime;
        if (m < 60) {
            result = [NSString stringWithFormat:@"1分钟以内"];
        }else{
            NSInteger minute = mktime / 60;
            if (minute < 60) {
                result = [NSString stringWithFormat:@"%ld分钟前", minute];
            }else{
                NSInteger hour = minute / 60;
                if (hour < 24) {
                    result = [NSString stringWithFormat:@"%ld小时前", hour];
                }
            }
        }
    }else{
        if (day < 30) {
            result = [NSString stringWithFormat:@"%ld天前", day];
        }else{
            NSInteger mouth = day / 30;
            if (mouth <= 12) {
                result = [NSString stringWithFormat:@"%ld月前", mouth];
            }else{
                NSInteger year = mouth / 12;
                result = [NSString stringWithFormat:@"%ld年前", year];
            }
        }
    }
    return result;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
