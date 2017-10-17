//
//  SinpViewController.h
//  不规则截图
//
//  Created by xrh on 2017/10/16.
//  Copyright © 2017年 xrh. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 这个控制器里面的内容就是一张图片 把那张截图传进来就可以了 具体的初始化和模态切换是在ViewController2里面的按钮方法里面实现的 也就两句话
 */

@interface SinpViewController : UIViewController

@property(strong, nonatomic) UIImage *image;

- (instancetype)initWithImage:(UIImage *)image;

@end
