
//
//  ZZZContentView.m
//  pujiaba
//
//  Created by zzzzz on 15/12/30.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "ZZZContentView.h"
#import "ZZZBaseLabel.h"

#define IMAGEHEAD @"/static/upload/"

@interface ZZZContentView ()

@property (nonatomic, assign) CGFloat       width;
/**
 *  view的高度
 */
@property (nonatomic, assign) CGFloat       height;
/**
 *  当前控件要放的左上角的位置
 */
@property (nonatomic, assign) CGPoint       currentPoint;
/**
 *  文字段数,用图片的链接将文本分成几段，链接也算一段
 */
@property (nonatomic, retain) NSMutableArray    *labels;

@end

@implementation ZZZContentView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.nightColor = [UIColor clearColor];
        self.whiteColor = [UIColor clearColor];
        [self setBackgroundColor:[UIColor clearColor]];
        self.labels = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithWidth:(CGFloat)width content:(NSString *)string{
    self = [super initWithFrame:CGRectMake(0, 0, WIDTH, 10)];
    if (self) {
        self.nightColor = [UIColor clearColor];
        self.whiteColor = [UIColor clearColor];
        [self setBackgroundColor:[UIColor clearColor]];
        self.labels = [NSMutableArray array];
        self.content = string;
        [self createSubview];
    }
    return self;
}

/**
 *  移除所有子视图
 */
- (void)removeAllSubviews{
    self.currentPoint = CGPointMake(0, 0);
    for (UIView *v in self.subviews) {
        //重置布局起点
        [self.labels removeAllObjects];
        [v removeFromSuperview];
    }
}

- (void)createSubview{
//    self.height = 0;
//    i
//    [self setBackgroundColor:[UIColor whiteColor]];
    [self removeAllSubviews];
    NSString *source = [NSString stringWithFormat:@"%@", self.content];
//    source = [source stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSRange range = [source rangeOfString:IMAGEHEAD];
//    NSLog(@"%d %d", range.location, range.length);
    while ((int16_t)range.location >= 0) {//这个地方如果用int在真机上面调试会crash
        NSString *sub = [source substringToIndex:range.location];
        //去除左右空格
//        sub = [sub stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (![sub isEqualToString:@""]) {
            [self.labels addObject:sub];
        }
#warning 这个地方，如果图片后缀还有其他的话，会crash\
这个地方的图文转换没有写好       T.T😭
//#error 这个地方会有问题，点击标签“妹子福利” -->心跳。。。就会crash，原因是有人的评论里面在图片中间插入了中文，
        short length = (int)[source rangeOfString:@"jpg"].location - range.location + 3;
        if(length < 0){
            length = (int)[source rangeOfString:@"gif"].location - range.location + 3;
        }
        if (length < 0) {
            length = (int)[source rangeOfString:@"png"].location - range.location + 3;
        }
        if (length > source.length) {
            [self.labels addObject:source];
            break;
        }
        NSString *pic = [source substringWithRange:NSMakeRange(range.location, MIN(length, source.length - range.location))];
        [self.labels addObject:[BASE_URL stringByAppendingPathComponent:pic]];
        NSLog(@"图文混排中的图片%@", pic);
        source = [source substringFromIndex:length + sub.length];
        range = [source rangeOfString:IMAGEHEAD];
    }
    [self.labels addObject:source];
//    NSLog(@"%@", self.labels);
    for (NSString *str in self.labels) {
        //如果是图片
        if ([str hasPrefix:[BASE_URL stringByAppendingPathComponent:@"/static/upload/"]]) {
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(self.currentPoint.x, self.currentPoint.y, self.frame.size.width, self.frame.size.width / 1.8)];
//            [iv setBackgroundColor:[UIColor yellowColor]];
            [self addSubview:iv];
            [iv release];
            self.currentPoint = CGPointMake(self.currentPoint.x, self.currentPoint.y + iv.frame.size.height + 5);
            NSFileManager *manager = [NSFileManager defaultManager];
            NSArray *arr = [@"/static/upload/" componentsSeparatedByString:@"/"];
            NSMutableArray *folders = [NSMutableArray arrayWithObjects:@"Cache", nil];
            for (NSString *c in arr) {
                if ([c containsString:@"."]) {
                    break;
                }
                if (![c isEqualToString:@"/"]) {
                    [folders addObject:c];
                }
            }
            NSString *imgPath = [AppTools createImageLocalPathUseUrl:str withFolders:folders];
            if ([manager fileExistsAtPath:imgPath]) {
                NSData *resultData = [NSData dataWithContentsOfFile:imgPath];
                UIImage *img = [UIImage imageWithData:resultData];
                CGFloat pixw = img.size.width;
                CGFloat pixh = img.size.height;
                CGFloat framw = iv.frame.size.width;
                CGFloat framh = iv.frame.size.height;
                
                //                NSLog(@"%f", pixw / pixh);
                if (pixw / pixh > framw / framh) {
                    pixh = pixh / (pixw / framw);
                    //                    pixh = pixw / framw / framh;
                    pixw = framw;
                }else{
                    pixw = pixw / pixh * framh;
                    pixh = framh;
                }
                //                NSLog(@"%f %f", pixw, pixh);
                iv.frame = CGRectMake(iv.frame.origin.x, iv.frame.origin.y, pixw, pixh);
                iv.image = img;
            }else{
                [AppTools getDataFromNetUseGETMethodWithUrl:str andParameters:nil successBlock:^(NSData *resultData) {
                    if (resultData.length > 0) {
                        UIImage *img = [UIImage imageWithData:resultData];
                        if (img != nil) {
                            [resultData writeToFile:imgPath atomically:YES];
                            CGFloat pixw = img.size.width;
                            CGFloat pixh = img.size.height;
                            CGFloat framw = iv.frame.size.width;
                            CGFloat framh = iv.frame.size.height;
                            
                            //                NSLog(@"%f", pixw / pixh);
                            if (pixw / pixh > framw / framh) {
                                pixh = pixh / (pixw / framw);
            //                    pixh = pixw / framw / framh;
                                pixw = framw;
                            }else{
                                pixw = pixw / pixh * framh;
                                pixh = framh;
                            }
                            //                NSLog(@"%f %f", pixw, pixh);
                            iv.frame = CGRectMake(iv.frame.origin.x, iv.frame.origin.y, pixw, pixh);
                            iv.image = img;
                        }
                    }
                } failBlock:^(NSError *error) {
                    ;
                }];
            }
        }else{
            ZZZBaseLabel *label = [[ZZZBaseLabel alloc] initWithFrame:CGRectMake(self.currentPoint.x, self.currentPoint.y, self.frame.size.width, 10)];
            if (label) {
                label.text = str;
                label.lineBreakMode = NSLineBreakByCharWrapping;
                label.numberOfLines = 0;
                label.font = [UIFont systemFontOfSize:16];
                [label sizeToFit];
                self.currentPoint = CGPointMake(self.currentPoint.x, self.currentPoint.y + label.frame.size.height + 5);
                [self addSubview:label];
            }
            [label release];
        }
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.currentPoint.y > 40 ? self.currentPoint.y : 40);
}

- (void)setContent:(NSString *)content{
    if (_content != content) {
        [_content release];
        _content = [content retain];
        [self createSubview];
    }
}

@end
