//
//  YDDCarouseFigureView.h
//  LessonCarouselFigureView
//
//  Created by lanou3g on 15/12/12.
//  Copyright © 2015年 东东. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YDDCarouseFigureView;//在自己的类内部引用自己用@class
@protocol YDDCarouselFigureDelegate <NSObject>
/**
 *  轮播图被点击时触发的代理方法
 *
 *  @param carouselFigureView 轮播图本身
 *  @param index              传递给外界的下标
 */

-(void)carouselFigureDidCarousel:(YDDCarouseFigureView *)carouselFigureView withIndex:(NSUInteger)index;

@end

@interface YDDCarouseFigureView : UIView

/**
 *  图片数组,外界赋值轮播图片的时候用,或者获取轮播图片时使用
 */
@property(strong,nonatomic) NSArray * images;
/**
 *  图片切换时间间隔
 */
@property(assign,nonatomic) NSTimeInterval duration;//default is 2.0;
/**
 *  当前下标
 */
@property(assign,nonatomic) NSUInteger currentIndex;

/**
 *  代理对象
 */
@property(weak,nonatomic) id<YDDCarouselFigureDelegate> delegate;

@end
