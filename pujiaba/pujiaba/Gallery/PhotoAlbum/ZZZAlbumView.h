//
//  ZZZAlbumView.h
//  pujiaba
//
//  Created by zzzzz on 16/1/8.
//  Copyright © 2016年 zzzzz. All rights reserved.
//

#import "ZZZBaseView.h"
#import "ZZZGalleryModel.h"

@protocol ZZZAlbumViewDelegate <NSObject>

- (void)setNavigationBarAlpha:(CGFloat)alpha;

- (void)shareCurrentImage:(UIImage *)img;

@end

@interface ZZZAlbumView : ZZZBaseView

@property (nonatomic, retain) ZZZGalleryModel *galleryModel;

@property (nonatomic, retain) UIImage *currentImage;

@property (nonatomic, assign) id<ZZZAlbumViewDelegate, ZZZMyPushViewControllerDelegate> myDelegate;

@end
