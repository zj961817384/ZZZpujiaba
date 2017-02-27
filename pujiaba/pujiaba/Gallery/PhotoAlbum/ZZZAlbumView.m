//
//  ZZZAlbumView.m
//  pujiaba
//
//  Created by zzzzz on 16/1/8.
//  Copyright © 2016年 zzzzz. All rights reserved.
//

#import "ZZZAlbumView.h"
#import "ZZZBaseScrollView.h"

@interface ZZZAlbumView ()<UIScrollViewDelegate>

@property (nonatomic, retain) ZZZBaseScrollView *mainScrollView;

@property (nonatomic, retain) UILabel           *indicateLabel;

@property (nonatomic, retain) NSMutableArray<ZZZBaseScrollView *> *imgViewArr;

@end

@implementation ZZZAlbumView

- (void)dealloc{
    [_mainScrollView release];
    [_indicateLabel release];
    [_imgViewArr release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.imgViewArr = [NSMutableArray array];
        [self createSubview];
    }
    return self;
}

- (void)createSubview{
    self.mainScrollView = [[ZZZBaseScrollView alloc] initWithFrame:self.bounds];
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.delegate = self;
//    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.mainScrollView];
    [_mainScrollView release];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapAction:)];
    [self.mainScrollView addGestureRecognizer:tap];
    [tap release];
    
    self.indicateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 40)];
    [self.indicateLabel setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:0.5]];
    self.indicateLabel.textColor = [UIColor whiteColor];
    self.indicateLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:self.indicateLabel];
    [_indicateLabel release];
}

- (void)setGalleryModel:(ZZZGalleryModel *)galleryModel{
    if (_galleryModel != galleryModel) {
        [_galleryModel release];
        _galleryModel = [galleryModel retain];
        
        self.indicateLabel.text = [NSString stringWithFormat:@"      %d/%lu", (int)(self.mainScrollView.contentOffset.x / self.mainScrollView.frame.size.width) + 1, (unsigned long)_galleryModel.imgs.count];
        
        self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.frame.size.width * _galleryModel.imgs.count, self.mainScrollView.frame.size.height);
//        self.mainScrollView.contentOffset = CGPointMake(0.5, 0);
        
        [self loadData];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
}

- (void)loadData{
    [self getDataFromNet];
}

- (void)getDataFromNet{
    for (int i = 0; i < _galleryModel.imgs.count; i++) {
        UIScrollView *imgSV = [[UIScrollView alloc] initWithFrame:CGRectMake((self.mainScrollView.frame.size.width) * i + 3, self.mainScrollView.frame.origin.y + 3, self.mainScrollView.frame.size.width - 6, self.mainScrollView.frame.size.height - 6)];
        imgSV.delegate = self;
        imgSV.minimumZoomScale = 0.8;
        imgSV.maximumZoomScale = 3;
        [self.mainScrollView addSubview:imgSV];
        [imgSV release];
        
         UIImageView *imgV = [[UIImageView alloc] initWithFrame:imgSV.bounds];
        imgV.userInteractionEnabled = YES;
        [imgSV addSubview:imgV];
        [imgV release];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
//        longPress.minimumPressDuration = 1;
        [imgV addGestureRecognizer:longPress];
//        [longPress release];
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapAction:)];
//        [imgV addGestureRecognizer:tap];
//        [tap release];
        
        NSString *str = _galleryModel.imgs[i];
        str = [str substringToIndex:[str rangeOfString:@"."].location + 4];
        
        NSFileManager *manager = [NSFileManager defaultManager];
        NSArray *arr = [str componentsSeparatedByString:@"/"];
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
            if (img != nil) {
                CGFloat pixw = img.size.width;
                CGFloat pixh = img.size.height;
                CGFloat framw = imgV.frame.size.width;
                CGFloat framh = imgV.frame.size.height;
                
                if (pixw / pixh > framw / framh) {
                    pixh = pixh / (pixw / framw);
                    pixw = framw;
                }else{
                    pixw = pixw / pixh * framh;
                    pixh = framh;
                }
                imgV.frame = CGRectMake(imgV.frame.origin.x, imgV.frame.origin.y, pixw, pixh);
                imgV.image = img;
                
                imgV.frame = PCENTER(imgSV, imgV);
            }
        }else{
            [AppTools getDataFromNetUseGETMethodWithUrl:[BASE_URL stringByAppendingPathComponent:str] andParameters:nil successBlock:^(NSData *resultData) {
                if (resultData.length > 0) {
                    UIImage *img = [UIImage imageWithData:resultData];
                    if (img != nil) {
                        [resultData writeToFile:imgPath atomically:YES];
                        CGFloat pixw = img.size.width;
                        CGFloat pixh = img.size.height;
                        CGFloat framw = imgV.frame.size.width;
                        CGFloat framh = imgV.frame.size.height;
                        
                        if (pixw / pixh > framw / framh) {
                            pixh = pixh / (pixw / framw);
                            pixw = framw;
                        }else{
                            pixw = pixw / pixh * framh;
                            pixh = framh;
                        }
                        imgV.frame = CGRectMake(imgV.frame.origin.x, imgV.frame.origin.y, pixw, pixh);
                        imgV.image = img;
                        
                        imgV.frame = PCENTER(imgSV, imgV);
                    }
                }else{
                    if ([self.myDelegate respondsToSelector:@selector(presentMyViewController:)]) {
                        UIAlertController *alert = [AppTools alertWithMessage:@"网络不给力啊~" block:^{
                            ;
                        }];
                        [self.myDelegate presentMyViewController:alert];
                    }
                }
            } failBlock:^(NSError *error) {
                ;
            }];
        }
    }
}

- (void)imageViewTapAction:(UITapGestureRecognizer*)tap{
    [UIView animateWithDuration:0.4 animations:^{
        self.indicateLabel.alpha = !self.indicateLabel.alpha;
        [self.myDelegate setNavigationBarAlpha:self.indicateLabel.alpha];
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.mainScrollView) {
        self.indicateLabel.text = [NSString stringWithFormat:@"      %d/%d", (int)(self.mainScrollView.contentOffset.x / self.mainScrollView.frame.size.width) + 1, (int)_galleryModel.imgs.count];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
//    NSLog(@"qwr");
    CGFloat scale = scrollView.zoomScale;
    UIImageView *iv = [[scrollView subviews] objectAtIndex:0];
    CGSize size = scrollView.contentSize;
    NSLog(@"%f,%f", iv.frame.size.width, iv.frame.size.height);
    size.width = MAX(scrollView.frame.size.width, iv.frame.size.width);
    size.height = MAX(scrollView.frame.size.height, iv.frame.size.height);
    if (scale < 1.0) {
        iv.frame = PCENTER(scrollView, iv);
    }else{
        if (iv.frame.size.width > scrollView.frame.size.width) {
            iv.frame = CGRectMake(0, iv.frame.origin.y, iv.frame.size.width, iv.frame.size.height);
            iv.frame = VCENTER(scrollView, iv);
        }
        if (iv.frame.size.height > scrollView.frame.size.height) {
            iv.frame = CGRectMake(iv.frame.origin.x, 0, iv.frame.size.width, iv.frame.size.height);
        }
    }
    scrollView.contentSize = size;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return [[scrollView subviews] objectAtIndex:0];
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longPress{
    UIImageView *imageView = (UIImageView *)longPress.view;
    UIImage *img = imageView.image;
    if (img != nil) {
        self.currentImage = img;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"操作" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *share = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.myDelegate shareCurrentImage:img];
        }];
        UIAlertAction *save = [UIAlertAction actionWithTitle:@"保存到本地" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:share];
        [alert addAction:save];
        [alert addAction:cancel];
        [self.myDelegate presentMyViewController:alert];
    }
    
}

//上面保存图片的回调方法，只能是这个方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error == nil) {
        UIAlertController *alert = [AppTools alertWithMessage:@"保存成功 ^_^" block:^{
            ;
        }];
        [self.myDelegate presentMyViewController:alert];
    }else{
        UIAlertController *alert = [AppTools alertWithMessage:@"保存失败 T^T" block:^{
            ;
        }];
        [self.myDelegate presentMyViewController:alert];
    }
}

@end
