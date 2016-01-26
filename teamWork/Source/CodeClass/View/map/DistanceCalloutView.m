//
//  DistanceCalloutView.m
//  teamWork
//
//  Created by hanxiaolong on 16/1/18.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//

#import "DistanceCalloutView.h"

@interface DistanceCalloutView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation DistanceCalloutView


#define kArrorHeight        0

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self drawInContext:UIGraphicsGetCurrentContext()];
    //气泡颜色
    self.layer.shadowColor = [[UIColor whiteColor] CGColor];
    //气泡透明度
    self.layer.shadowOpacity = 1.0;
    //气泡偏移量
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}

- (void)drawInContext:(CGContextRef)context
{
    //宽度
    CGContextSetLineWidth(context, 1.0);
    //颜色
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.8].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
    
}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-kArrorHeight;
    
    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    // 添加标题，即商户名
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:8];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.text = @"titletitletitletitle";
    [self addSubview:self.titleLabel];
}
//title的set方法，用来给titleLabel赋值
- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}




@end
