//
//  YDDCarouseFigureView.m
//  LessonCarouselFigureView
//
//  Created by lanou3g on 15/12/12.
//  Copyright © 2015年 东东. All rights reserved.
//

#import "YDDCarouseFigureView.h"

@interface YDDCarouseFigureView ()<UIScrollViewDelegate>
@property (strong,nonatomic) UIScrollView  * scrollView;
@property (strong,nonatomic) UIPageControl * pageControl;
/**
 * 驱动轮播图的Timer
 */
@property(strong,nonatomic) NSTimer *timer;

@end


@implementation YDDCarouseFigureView
//每个视图
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _duration = 2;
        _timer = [NSTimer new];
    }
    return self;
}

-(void)setDuration:(NSTimeInterval)duration
{

    [self.timer invalidate];
    self.timer = nil;
    _duration = duration;//基本数据类型直接赋值
    
    self.timer  = [NSTimer scheduledTimerWithTimeInterval:_duration target:self selector:@selector(carouselAction:) userInfo:self repeats:YES];
}

/**
 *  images的setter,当对图片数组赋值时触发
 *
 *  @param images 图片数组
 */
-(void)setImages:(NSArray *)images
{
    //让Timer停止并且为空
    [self.timer invalidate];
    self.timer = nil;
    
    if (_images != images) {
        _images = nil;
        _images = images;
    }
    //在外界对图片数组进行赋值的时候,开始绘图
    [self drawView];
    
    //在外界对图片数组进行赋值的时候,启动Timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.duration target:self selector:@selector(carouselAction:) userInfo:nil repeats:YES];
    

    
}
//绘制视图的方法
-(void)drawView
{
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
}
//当前视图宽度
#define kWidth self.bounds.size.width
//当前视图高度
#define kHeight self.bounds.size.height
//当前图片个数
#define kCount self.images.count
//懒加载ScrollView
-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];//写bounces而不是frame,从(0,0)开始,它终将贴到self上
        [_scrollView setBounces:NO];
        [_scrollView setPagingEnabled:YES];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setContentSize:CGSizeMake(kWidth * kCount, kHeight)];
        
        [_scrollView setDelegate:self];
        
        
        //添加图片视图
        for (int i = 0; i < kCount; i++) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kWidth, 0, kWidth, kHeight)];
            imgView.image = self.images[i];
            imgView.userInteractionEnabled = YES;//默认关闭
            imgView.tag = 1000 + i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapActionInImageView:)];
            [imgView addGestureRecognizer:tap];
            [_scrollView addSubview:imgView];
        }
        
    }
    return _scrollView;
}

//懒加载PageControll
#define kGap 10
#define kPageControlHeight 29
-(UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, kWidth, kPageControlHeight)];
        [_pageControl setCenter:CGPointMake(kWidth/2, kHeight - kPageControlHeight / 2 - kGap)];
        [_pageControl setBackgroundColor:[UIColor whiteColor]];
        [_pageControl setAlpha:0.3];
        [_pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor redColor]];
        [_pageControl setNumberOfPages:kCount];
    }
    return _pageControl;
}

#pragma mark --Timer 驱动轮播机制--
-(void)carouselAction:(id)sender
{
    //每次方法执行的时候,"当前页 + 1
    self.currentIndex ++;
    
    //越界判断
    if (self.currentIndex == kCount) {
        self.currentIndex = 0;
    }
    
    
    //根据当前页这个属性来设置pageControl当前页
    self.pageControl.currentPage = self.currentIndex;
    //根据"当前页"这个属性来设置ScrollView的偏移量
    self.scrollView.contentOffset = CGPointMake(kWidth * self.currentIndex, 0);
    
    
}


#pragma mark --UIScrollViewDelegate--
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    //开始拖拽时,timer驱动机制停止
    [self.timer invalidate];

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //根据视图偏移校正当前下标
    self.currentIndex = scrollView.contentOffset.x / kWidth;
    //根据新的下标较正PageControl当前页
    self.pageControl.currentPage = self.currentIndex;

    //停止减速后启动timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.duration target:self selector:@selector(carouselAction:) userInfo:self repeats:YES];
    
}

#pragma mark -- Tap 手势 --

-(void)handleTapActionInImageView:(UITapGestureRecognizer *)tap
{
//    //获取所点击的视图
//    UIImageView *imgView = (UIImageView *)tap.view;
//    //获取对一个下标
//    NSUInteger index = [self.images indexOfObject:imgView.image];
    
    //获取所点击的视图
    UIImageView *imgView = (UIImageView *)tap.view;
    //获取下标
    NSUInteger index = imgView.tag - 1000;
    
    
    //当手势触发时,代理对象执行代理方法
    //将当前视图和当前下标携带给外界
    if (_delegate && [_delegate respondsToSelector:@selector(carouselFigureDidCarousel:withIndex:)]) {
        
        [_delegate carouselFigureDidCarousel:self withIndex:index];
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
