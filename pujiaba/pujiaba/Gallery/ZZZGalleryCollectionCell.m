//
//  ZZZGalleryCollectionCell.m
//  pujiaba
//
//  Created by zzzzz on 16/1/7.
//  Copyright © 2016年 zzzzz. All rights reserved.
//

#import "ZZZGalleryCollectionCell.h"
#import "UIImageView+WebCache.h"

@interface ZZZGalleryCollectionCell ()

@property (nonatomic, retain) UIImageView       *headImageView;

@property (nonatomic, retain) UILabel           *titleLabel;

@end

@implementation ZZZGalleryCollectionCell

- (void)dealloc{
    [_headImageView release];
    [_titleLabel release];
    [_model release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
//    [self setBackgroundColor:[UIColor orangeColor]];
//    [self setBackgroundColor:[UIColor whiteColor]];
    [self createSubview];
    return self;
}

- (void)createSubview{
    self.headImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    
//    self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (WIDTH - 20) / 2.0, (WIDTH - 20) / 2.0 + 60)];
    [self.contentView addSubview:self.headImageView];
    [_headImageView release];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 0, self.headImageView.frame.size.width, 0)];
    self.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.titleLabel.numberOfLines = 2;
    [self.titleLabel setBackgroundColor:[UIColor colorWithWhite:0.000 alpha:0.5]];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.titleLabel];
    [_titleLabel release];
    
//    self.layer.shadowColor = [UIColor redColor].CGColor;
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 2;
    self.layer.shadowOffset = CGSizeMake(0, -10);
}

- (void)setModel:(ZZZGalleryModel *)model{
    if (_model != model) {
        [_model release];
        _model = [model retain];
        
        self.titleLabel.text = _model.title;
        [self.titleLabel sizeToFit];
        CGRect frame = self.titleLabel.frame;
        frame.origin.y = self.headImageView.frame.size.height - frame.size.height;
        frame.size.width = self.headImageView.frame.size.width;//(WIDTH - 20) / 2.0;
        self.titleLabel.frame = frame;
        self.headImageView.image = nil;
        
        NSFileManager *manager = [NSFileManager defaultManager];
        NSArray *arr = [[_model.imgs firstObject] componentsSeparatedByString:@"/"];
        NSMutableArray *folders = [NSMutableArray arrayWithObjects:@"Cache", nil];
        for (NSString *c in arr) {
            if ([c containsString:@"."]) {
                break;
            }
            if (![c isEqualToString:@"/"]) {
                [folders addObject:c];
            }
        }
        NSString *imgPath = [AppTools createImageLocalPathUseUrl:[_model.imgs firstObject] withFolders:folders];
        if ([manager fileExistsAtPath:imgPath]) {
            NSData *resultData = [NSData dataWithContentsOfFile:imgPath];
            UIImage *img = [UIImage imageWithData:resultData];
            self.headImageView.image = img;
            self.headImageView.alpha = 0;
            [UIView animateWithDuration:0.4 animations:^{
                self.headImageView.alpha = 1;
            }];
        }else{
            [AppTools getDataFromNetUseGETMethodWithUrl:[BASE_URL stringByAppendingPathComponent:[_model.imgs firstObject]] andParameters:nil successBlock:^(NSData *resultData) {
                UIImage *img = [UIImage imageWithData:resultData];
                if (img != nil) {
                    [resultData writeToFile:imgPath atomically:YES];
                    self.headImageView.image = img;
                    self.headImageView.alpha = 0;
                    [UIView animateWithDuration:0.4 animations:^{
                        self.headImageView.alpha = 1;
                    }];
                }
                
            } failBlock:^(NSError *error) {
                ;
            }];
        }
    }
}

@end
