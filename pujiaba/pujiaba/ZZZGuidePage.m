//
//  ZZZGuidePage.m
//  pujiaba
//
//  Created by zzzzz on 16/1/13.
//  Copyright © 2016年 zzzzz. All rights reserved.
//

#import "ZZZGuidePage.h"
#import "ZZZBaseScrollView.h"

@interface ZZZGuidePage ()<UIScrollViewDelegate>

@property (nonatomic, retain) ZZZBaseScrollView *scrollView;
@property (nonatomic, retain) UIImageView *bag1;
@property (nonatomic, retain) UIImageView *bag2;
@property (nonatomic, retain) UIImageView *bag3;
@property (nonatomic, retain) UIPageControl *pageControl;

@end

@implementation ZZZGuidePage

- (void)dealloc{
    [_bag1 release];
    [_scrollView release];
    [_bag2 release];
    [_bag3 release];
    [_pageControl release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView = [[ZZZBaseScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.contentSize = CGSizeMake(WIDTH * 3, HEIGHT);
        [self addSubview:self.scrollView];
        self.scrollView.whiteColor = [UIColor clearColor];
        self.scrollView.nightColor = [UIColor clearColor];
        [self.scrollView setBackgroundColor:[UIColor clearColor]];
        [self setBackgroundColor:[UIColor clearColor]];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.bounces = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.delegate = self;
        for (int i = 2; i >= 0; i--) {
            if (i == 0) {
                UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
                self.bag1 = imgV;
                imgV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
                [self addSubview:imgV];
                imgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide%d", i]];
                [imgV release];
            }else if(i == 1){
                {
                    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
                    self.bag2 = imgV;
                    imgV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
                    [self addSubview:imgV];
                    imgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide%d", i]];
                    [imgV release];
                }

            }else{
            UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
                self.bag3 = imgV;
                imgV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
                [self addSubview:imgV];
                imgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide%d", i]];
                [imgV release];
//                if (i == 2) {
//                    imgV.userInteractionEnabled = YES;
//                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterAPP)];
//                    [imgV addGestureRecognizer:tap];
//                }
            }
        }
        [self bringSubviewToFront:self.scrollView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterAPP:)];
        [self.scrollView addGestureRecognizer:tap];
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((WIDTH - 80) / 2, HEIGHT - 60, 80, 20)];
        self.pageControl.numberOfPages = 3;
        self.pageControl.currentPage = 0;
        self.pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.807 alpha:1.000];
        self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.055 green:0.897 blue:1.000 alpha:1.000];
        [self addSubview:self.pageControl];
        [_pageControl release];
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat x = scrollView.contentOffset.x;
    if (x / self.frame.size.width < 1) {
        self.bag1.alpha = 1 - x / self.frame.size.width;
        self.bag2.alpha = x / self.frame.size.width;
        self.bag3.alpha = 0;
    }else if (x / self.frame.size.width < 2){
        self.bag1.alpha = 0;
        self.bag2.alpha = 2 - x / self.frame.size.width;
        self.bag3.alpha = x / self.frame.size.width - 1;
    }else{
        self.bag1.alpha = 0;
        self.bag2.alpha = 0;
        self.bag3.alpha = 1;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.pageControl.currentPage = self.scrollView.contentOffset.x / self.frame.size.width;
}

- (void)enterAPP:(UITapGestureRecognizer *)tap{
    if(tap.view == self.scrollView){
        if (self.scrollView.contentOffset.x == self.scrollView.contentSize.width - self.scrollView.frame.size.width) {
            [UIView animateWithDuration:0.8 animations:^{
                self.alpha = 0;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
                [USERDEFAULT setObject:@"YES" forKey:@"notFirstRun"];
            }];
        }
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
