//
//  MyCollectionView.m
//  自己写的collectionview
//
//  Created by zzzzz on 15/12/28.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "MyCollectionView.h"
#import "Common.h"

@interface MyCollectionView ()

@property (nonatomic, assign) NSInteger     numberOfSections;
@property (nonatomic, retain) NSIndexPath   *indexPath;

//@property (nonatomic, assign) CGPoint       currentLocation;

@end

@implementation MyCollectionView

- (void)dealloc{
    [_indexPath release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.whiteColor = [UIColor whiteColor];
        if ([@"night" isEqualToString:[USERDEFAULT objectForKey:CURRENT_SKIN]]) {
            self.backgroundColor = self.nightColor;
        }else{
            self.backgroundColor = [UIColor whiteColor];
        }
        [self reloadData];
    }
    return self;
}

- (void)reloadData{
    CGPoint currentLocation = CGPointMake(self.sectionInset.left, self.sectionInset.top);
    self.numberOfSections = [self.myDelegate numberOfSectionsInCollectionView:self];
    for (int i = 0; i < self.numberOfSections; i++) {
        if ([self.myDelegate respondsToSelector:@selector(collectionView:viewForHeaderInSection:)]) {//如果有headview
            UIView *header = [self.myDelegate collectionView:self viewForHeaderInSection:i];
            CGRect frame = header.frame;
            frame.origin.x = currentLocation.x;
            frame.origin.y = currentLocation.y;
            header.frame = frame;
            [self addSubview:header];
            
            currentLocation.y += frame.size.height + self.minimumLineSpacing;
        }
        NSInteger numberOfRow = [self.myDelegate collectionView:self numberOfItemsInSection:i];
        int perLineNumber = 1;//每行有多少个item
        CGFloat InteritemSpacing = 0;//每个item的间距
        while (1) {//计算每个item之间的距离和每行item的个数
            int perLineNumberT = perLineNumber + 1;
            CGFloat Spacing = (WIDTH - self.sectionInset.right - self.sectionInset.left - self.itemSize.width * perLineNumberT) / ((perLineNumberT - 1 > 0 ? perLineNumberT - 1 : 1));
            if (Spacing < self.minimumInteritemSpacing) {
                break;
            }
            perLineNumber = perLineNumberT;
            InteritemSpacing = Spacing;
        }
        for (int n = 0; n < numberOfRow; n++) {
            UIView *item = [[UIView alloc] initWithFrame:CGRectMake(currentLocation.x, currentLocation.y, self.itemSize.width, self.itemSize.height)];
            item.tag = i * 10000 + n * 100;
            UIView *cell = [self.myDelegate collectionView:self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:n inSection:i]];
            [item addSubview:cell];
            [self addSubview:item];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            [item addGestureRecognizer:tap];
            [tap release];
            currentLocation.x += self.itemSize.width + InteritemSpacing;
            if ((n + 1) % perLineNumber == 0 && n != 0) {//如果是每一行的开始
                    currentLocation.x = self.sectionInset.left;//重置当前x坐标
                    currentLocation.y += (self.itemSize.height + self.minimumLineSpacing);
            }
            [item release];
        }
        
    }
    self.contentSize = CGSizeMake(WIDTH, currentLocation.y);
    
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    UIView *view = tap.view;
    NSInteger section = view.tag / 10000;
    NSInteger row = view.tag / 100 % 10;
    [self.myDelegate collectionView:self didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:row inSection:section]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
