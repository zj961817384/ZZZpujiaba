//
//  ZZZGameListCell.m
//  pujiaba
//
//  Created by zzzzz on 16/1/4.
//  Copyright © 2016年 zzzzz. All rights reserved.
//

#import "ZZZGameListCell.h"

@interface ZZZGameListCell ()

@property (nonatomic, retain) UIImageView       *backImage;
//图标
@property (nonatomic, retain) UIImageView       *icon;
//名字
@property (nonatomic, retain) UILabel           *title_label;
//大小和人气
@property (nonatomic, retain) UILabel           *size_label;
//标签（类型）
@property (nonatomic, retain) UIScrollView      *tags_view;

@end

@implementation ZZZGameListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createContentView];
    }
    return self;
}

- (void)createContentView{
    
    self.whiteColor = [UIColor colorWithWhite:0.901 alpha:1.000];
    if ([@"night" isEqualToString:[USERDEFAULT objectForKey:CURRENT_SKIN]]) {
        [self setBackgroundColor:self.nightColor];
    }else{
        [self setBackgroundColor:self.whiteColor];
    }


    self.backImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, WIDTH - 20, WIDTH / 5 + 20)];
    NSString *imageName = @"cell_back.png";
    if ([@"night" isEqualToString:[USERDEFAULT objectForKey:CURRENT_SKIN]]) {
        imageName = @"cell_backN.png";
    }else{
        ;
    }
    self.backImage.image = [UIImage imageNamed:imageName];
    [self.contentView addSubview:self.backImage];
    [_backImage release];
    
    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, WIDTH / 5, WIDTH / 5)];
    //        [self.icon setBackgroundColor:[UIColor redColor]];
    [self.backImage addSubview:self.icon];
    [_icon release];
    
    self.title_label = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.frame.size.width + 10, 10, WIDTH - 180, self.icon.frame.size.height / 3)];
    self.title_label.font = [UIFont systemFontOfSize:17 weight:0.2];
//            [self.title_label setBackgroundColor:[UIColor grayColor]];
    [self.backImage addSubview:self.title_label];
    [_title_label release];
    
    self.size_label = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.frame.size.width + 10, self.title_label.frame.size.height + 5, WIDTH - 170, self.icon.frame.size.height / 3)];
    self.size_label.font = [UIFont systemFontOfSize:13];
    [self.size_label setTextColor:[UIColor grayColor]];
//            [self.size_label setBackgroundColor:[UIColor lightGrayColor]];
    [self.backImage addSubview:self.size_label];
    [_size_label release];
    
    self.tags_view = [[UIScrollView alloc] initWithFrame:CGRectMake(self.icon.frame.size.width + 10, self.title_label.frame.size.height + 5 + self.size_label.frame.size.height, WIDTH - self.icon.frame.size.width - 15, self.icon.frame.size.height / 3)];
//            [self.tags_view setBackgroundColor:[UIColor lightGrayColor]];
    [self.backImage addSubview:self.tags_view];
    [_tags_view release];
}

- (void)setModel:(ZZZGameListModel *)model{
    if (_model != model) {
        [_model release];
        _model = [model retain];
    }
    self.icon.image = nil;
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *arr = [_model.icon componentsSeparatedByString:@"/"];
    NSMutableArray *folders = [NSMutableArray arrayWithObjects:@"Cache", nil];
    for (NSString *c in arr) {
        if ([c containsString:@"."]) {
            break;
        }
        if (![c isEqualToString:@"/"]) {
            [folders addObject:c];
        }
    }
    NSString *iconPath = [AppTools createImageLocalPathUseUrl:_model.icon withFolders:folders];
    if ([manager fileExistsAtPath:iconPath]) {
        NSData *resultData = [NSData dataWithContentsOfFile:iconPath];
        self.icon.image = [UIImage imageWithData:resultData];
    }else{
        [AppTools getDataFromNetUseGETMethodWithUrl:[BASE_URL stringByAppendingPathComponent:_model.icon] andParameters:nil successBlock:^(NSData *resultData) {
            if (resultData.length > 0) {
            self.icon.image = [UIImage imageWithData:resultData];
                if (self.icon.image != nil) {
                    [resultData writeToFile:iconPath atomically:YES];
                }
            }
        } failBlock:^(NSError *error) {
            NSLog(@"网络请求图片数据失败：%@",error);
        }];
    }
    self.title_label.text = _model.title_cn;
    NSArray *tags = [_model.type componentsSeparatedByString:@" "];
    CGFloat x = 2;
    CGFloat h = self.tags_view.frame.size.height;
    self.size_label.text = [NSString stringWithFormat:@"%@, Loading...人气", _model.size];
//
    //这个地方如果不移除的话，会反复的创建添加，然后卡死。。。
    [self.tags_view removeFromSuperview];
    self.tags_view = [[UIScrollView alloc] initWithFrame:CGRectMake(self.icon.frame.size.width + 10, self.title_label.frame.size.height + 5 + self.size_label.frame.size.height, self.backImage.frame.size.width - self.icon.frame.size.width - 15, self.icon.frame.size.height / 3)];
//    [self.tags_view setBackgroundColor:[UIColor lightGrayColor]];
    [self.backImage addSubview:self.tags_view];
    [_tags_view release];
    if (_model.language != nil && ![_model.language isEqualToString:@""]) {
        tags = [@[_model.language] arrayByAddingObjectsFromArray:tags];
    }
    for (int i = 0; i < MIN(5, tags.count); i++){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 3, 40, h - 6)];
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 4;
        [label setBackgroundColor:[UIColor whiteColor]];
        label.layer.borderWidth = 0.3;
        label.layer.borderColor = [UIColor lightGrayColor].CGColor;
        label.text = [NSString stringWithFormat:@"%@ ", tags[i]];
        [label sizeToFit];
        x += label.frame.size.width + 4;
//        NSLog(@"%f", x);
        if (x - 4 >= self.tags_view.frame.size.width) {
            break;
        }
        [self.tags_view addSubview:label];
        //            [label release];
    }

}

- (void)changeSkin:(NSNotification *)notification{
    [super changeSkin:notification];
    NSString *imageName = @"cell_back.png";
    if ([@"night" isEqualToString:[USERDEFAULT objectForKey:CURRENT_SKIN]]) {
        imageName = @"cell_backN.png";
    }else{
        ;
    }
    self.backImage.image = [UIImage imageNamed:imageName];
}

@end
