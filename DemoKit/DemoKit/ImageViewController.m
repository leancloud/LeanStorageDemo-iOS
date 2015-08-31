//
//  ImageViewController.m
//  LeanStorageDemo
//
//  Created by lzw on 15/6/7.
//  Copyright (c) 2015年 LeanCloud. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"图片";
    [self.view addSubview:self.imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
        _imageView.backgroundColor = [UIColor whiteColor];
        _imageView.contentMode = UIViewContentModeCenter;
        _imageView.image = self.image;
    }
    return _imageView;
}

@end
