//
//  GHGestureCropImagViewController.m
//  GHGestureCropImageDemo
//
//  Created by zhaozhiwei on 2019/4/8.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import "GHGestureCropImagViewController.h"
#import "UIView+Extension.h"
#import "ZZImageEditTool.h"
#import "TKImageView.h"

@interface GHGestureCropImagViewController ()
@property (nonatomic , strong) UIView *test;
@property (nonatomic , strong)TKImageView *tkImageView;
@end

@implementation GHGestureCropImagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    
    TKImageView *tkImageView = [[TKImageView alloc] initWithFrame:CGRectMake(20, kSafeAreaTopHeight + 10, kScreenWidth - 40, kScreenHeight - 120)];
    
    [self.view addSubview:tkImageView];
    //需要进行裁剪的图片对象
    tkImageView.toCropImage = [UIImage imageNamed:@"tian"];
    //是否显示中间线
    tkImageView.showMidLines = NO;
    //是否需要支持缩放裁剪
    tkImageView.needScaleCrop = NO;
    //是否显示九宫格交叉线
    tkImageView.showCrossLines = YES;
    tkImageView.cornerBorderInImage = NO;
    tkImageView.cropAreaCornerWidth = 44;
    tkImageView.cropAreaCornerHeight = 44;
    tkImageView.minSpace = 30;
    tkImageView.cropAreaCornerLineColor = [UIColor whiteColor];
    tkImageView.cropAreaBorderLineColor = [UIColor whiteColor];
    tkImageView.cropAreaCornerLineWidth = 6;
    tkImageView.cropAreaBorderLineWidth = 1;
    tkImageView.cropAreaMidLineWidth = 20;
    tkImageView.cropAreaMidLineHeight = 6;
    tkImageView.cropAreaMidLineColor = [UIColor whiteColor];
    tkImageView.cropAreaCrossLineColor = [UIColor whiteColor];
    tkImageView.cropAreaCrossLineWidth = 0.5;
    tkImageView.initialScaleFactor = .8f;
    tkImageView.cropAspectRatio = 0;
    
    self.tkImageView = tkImageView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.tkImageView.toCropImage = [self.tkImageView currentCroppedImage];
}

@end
