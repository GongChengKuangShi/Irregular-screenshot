//
//  ViewController.m
//  不规则截图
//
//  Created by xrh on 2017/10/16.
//  Copyright © 2017年 xrh. All rights reserved.
//

#define SCREEN [UIScreen mainScreen].bounds

#import "ViewController.h"
#import "SinpViewController.h"
#import "MaskView.h"

@interface ViewController ()

@property(strong, nonatomic) UIImageView *imageView;

@property(strong, nonatomic) MaskView *mView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, CGRectGetWidth(SCREEN), CGRectGetHeight(SCREEN) * 0.38)];
    imageView.image = [UIImage imageNamed:@"ed"];
    self.imageView = imageView;
    [self.view addSubview:self.imageView];
    
    MaskView *mView = [[MaskView alloc] initWithFrame:imageView.frame];
    self.mView = mView;
    [self.view addSubview:mView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 500, CGRectGetWidth(SCREEN) * 0.85, 50);
    [button addTarget:self action:@selector(snip:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"截图" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:button];
}

- (void)snip:(UIButton *)button {
    UIImage *image = [self.mView getSinpImageWithImage:self.imageView.image];
    SinpViewController *controller = [[SinpViewController alloc] initWithImage:image];
    [self presentViewController:controller animated:YES completion:nil];
}

@end
