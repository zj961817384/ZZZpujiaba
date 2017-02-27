//
//  MyCollectionView.h
//  自己写的collectionview
//
//  Created by zzzzz on 15/12/28.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZZBaseScrollView.h"
@class MyCollectionView;

@protocol MyCollectionViewDelegate <NSObject>
@required

- (NSInteger)collectionView:(MyCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;

- (UIView *)collectionView:(MyCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)numberOfSectionsInCollectionView:(MyCollectionView *)collectionView;

- (void)collectionView:(MyCollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath;

@optional
- (UIView * _Nullable)collectionView:( MyCollectionView * _Nonnull )collectionView viewForHeaderInSection:(NSInteger )section;


//- (UIView *)
@end

@interface MyCollectionView : ZZZBaseScrollView

@property (nonatomic, assign) UIEdgeInsets      sectionInset;
@property (nonatomic, assign) CGFloat           minimumLineSpacing;
@property (nonatomic, assign) CGFloat           minimumInteritemSpacing;
@property (nonatomic, assign) CGSize            itemSize;

@property (nonatomic, assign) id<MyCollectionViewDelegate> myDelegate;

- (void)reloadData;

@end
