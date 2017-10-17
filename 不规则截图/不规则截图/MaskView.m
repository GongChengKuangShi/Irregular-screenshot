//
//  MaskView.m
//  不规则截图
//
//  Created by xrh on 2017/10/16.
//  Copyright © 2017年 xrh. All rights reserved.
//

#import "MaskView.h"

@implementation TPoint

- (instancetype)initWithX:(CGFloat)x andY:(CGFloat)y {
    if (self = [super init]) {
        self.x = x;
        self.y = y;
    }
    return self;
}

- (void)setPoint:(CGPoint)point {
    self.x = point.x;
    self.y = point.y;
}

- (CGPoint)getPoint {
    return CGPointMake(self.x, self.y);
}

- (CGRect)getRect {
    return CGRectMake(MAX(self.x - 40, 0), MAX(self.y - 40, 0), self.x + 40, self.y + 40);
}

@end

@interface MaskView () {
    CGPoint _offset;
    TPoint *_movePoint;
}

@property(strong, nonatomic) UIColor *currentColor;

@property(strong, nonatomic) NSArray *arrayOfPoint;

@end

@implementation MaskView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        UIGraphicsBeginImageContext(self.bounds.size);
        
    }
    return self;
}

- (NSArray *)arrayOfPoint {
    if (!_arrayOfPoint) {
        
        CGFloat kWidth = CGRectGetWidth(self.bounds) * 0.25;
        CGFloat kHeight = CGRectGetHeight(self.bounds) * 0.25;
        TPoint *point1 = [[TPoint alloc] initWithX:kWidth andY:kHeight];
        TPoint *point2 = [[TPoint alloc] initWithX:kWidth * 3 andY:kHeight];
        TPoint *point3 = [[TPoint alloc] initWithX:kWidth * 3 andY:kHeight * 3];
        TPoint *point4 = [[TPoint alloc] initWithX:kWidth andY:kHeight * 3];
        _arrayOfPoint = [NSArray arrayWithObjects:point1, point2, point3, point4, nil];
    }
    return _arrayOfPoint;
}

- (NSArray *)getPoints {
    return [self.arrayOfPoint copy];
}

//勾股定律
- (CGFloat)distanceFromePoint:(CGPoint)sou ToPoint:(CGPoint)des {
    return sqrt(pow(des.x - sou.x, 2) + pow(des.y - sou.y, 2));
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    _movePoint = nil;
    __block CGFloat distance = 100.0;
    [self.arrayOfPoint enumerateObjectsUsingBlock:^(TPoint *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint([obj getRect], [touch locationInView:self])) {//判断某个点是否包含在CGRect里面
            if ([self distanceFromePoint:[obj getPoint] ToPoint:[touch locationInView:self]] < distance) {
                distance = [self distanceFromePoint:[obj getPoint] ToPoint:[touch locationInView:self]];
                _offset = CGPointMake([obj getPoint].x - [touch locationInView:self].x, [obj getPoint].y - [touch locationInView:self].y);
                _movePoint = obj;
            }
        }
    }];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self moveWithTouch:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self moveWithTouch:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self moveWithTouch:touches withEvent:event];
}

- (void)moveWithTouch:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGFloat x = MIN(MAX([touch locationInView:self].x + _offset.x, 0), CGRectGetWidth(self.bounds));
    CGFloat y = MIN(MAX([touch locationInView:self].y + _offset.y, 0), CGRectGetHeight(self.bounds));
    [_movePoint setPoint:CGPointMake(x, y)];
    
    /**
     添加判断四边形任意两边是否都不交叉（非端点），如果交叉则对点的数组重新排列
     */
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextBeginPath(ctx);
    CGContextSetLineWidth(ctx, 1);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor blackColor] CGColor]);
    [self.arrayOfPoint enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint point = [[self.arrayOfPoint objectAtIndex:idx] getPoint];
        if (idx == 0) {
            CGContextMoveToPoint(ctx, point.x, point.y);
        } else {
            CGContextAddLineToPoint(ctx, point.x, point.y);
        }
    }];
    CGContextClosePath(ctx);
    CGContextStrokePath(ctx);
    
    CGContextSetLineWidth(ctx, 1);
    
    //指定小椭圆作为连接点
    for (TPoint *point in self.arrayOfPoint) {
        CGContextStrokeEllipseInRect(ctx, CGRectMake(point.x-10, point.y-10, 20, 20));
    }
    
    //设置上层截取图片
    CGContextBeginPath(ctx);
    [self.arrayOfPoint enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint point = [[self.arrayOfPoint objectAtIndex:idx] getPoint];
        if (idx == 0) {
            CGContextMoveToPoint(ctx, point.x, point.y);
        } else {
            CGContextAddLineToPoint(ctx, point.x, point.y);
        }
    }];
    CGContextAddRect(ctx, self.bounds);
    CGContextClosePath(ctx);
    CGContextEOClip(ctx);
    CGContextSetFillColorWithColor(ctx, [[[UIColor blackColor]colorWithAlphaComponent:0.3] CGColor]);
    CGContextFillRect(ctx, self.bounds);
}

- (UIImage *)getSinpImageWithImage:(UIImage *)image {
    UIGraphicsBeginImageContext(self.bounds.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextBeginPath(ctx);
    
    [self.arrayOfPoint enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint point = [[self.arrayOfPoint objectAtIndex:idx] getPoint];
        if (idx == 0) {
            CGContextMoveToPoint(ctx, point.x, point.y);//起点
        } else {
            CGContextAddLineToPoint(ctx, point.x, point.y);//除起点外其他的点
        }
    }];
    
    CGContextClosePath(ctx);
    CGContextClip(ctx);
    [image drawInRect:self.bounds];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    return newImage;
}

@end
