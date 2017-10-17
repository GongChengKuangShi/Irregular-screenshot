//
//  SinpViewController.m
//  不规则截图
//
//  Created by xrh on 2017/10/16.
//  Copyright © 2017年 xrh. All rights reserved.
//

#define SCREEN [UIScreen mainScreen].bounds

#import "SinpViewController.h"
#import "MaskView.h"

@interface SinpViewController ()

@property(strong, nonatomic) UIImageView *imageView;

@end

@implementation SinpViewController

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        self.image = image;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, CGRectGetWidth(SCREEN), CGRectGetHeight(SCREEN) * 0.38)];
    self.imageView.backgroundColor = [UIColor blackColor];
    self.imageView.image = self.image;
    
    [self.view addSubview:self.imageView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
