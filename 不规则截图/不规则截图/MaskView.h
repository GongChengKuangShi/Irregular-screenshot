//
//  MaskView.h
//  不规则截图
//
//  Created by xrh on 2017/10/16.
//  Copyright © 2017年 xrh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPoint : NSObject

@property (assign, nonatomic) CGFloat x;
@property (nonatomic, assign) CGFloat y;

- (instancetype)initWithX:(CGFloat)x andY:(CGFloat)y;
/**
 x,y的设置或更新方法，只不过传入的是CGPoint结构体
 */
- (void)setPoint:(CGPoint)point;
/**
 获取x，y。方法中用了CGPointMake(x,y)进行结构转换
 */
- (CGPoint)getPoint;

/**
 这个方法的作用比较大，因为手势判断的时候触摸点位置不好判断。
 有一个方法是CGRectContainsPoint(rect, point)，就是用来判断这个point点的位置是不是在rect里面
 */
- (CGRect)getRect;
@end

@interface MaskView : UIView

- (NSArray *)getPoints;

- (UIImage *)getSinpImageWithImage:(UIImage *)image;

@end
