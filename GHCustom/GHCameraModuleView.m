//
//  GHCameraModuleView.m
//  GHCameraModuleDemo
//
//  Created by mac on 2018/11/27.
//  Copyright © 2018年 GHome. All rights reserved.
//

#import "GHCameraModuleView.h"
#import "UIView+Extension.h"
#import "GHScanView.h"
#import "GHAdjustFocal.h"

#define kImageNameCameraNormal @"cameraModule_cameraNormal"
#define kImageNameCameraSeleted @"cameraModule_cameraSeleted"
#define kImageNamePhoto @"cameraModule_photo"
#define kImageNameFlashlightNormal @"cameraModule_torchNormal"
#define kImageNameFlashlightSeleted @"cameraModule_torchSeleted"

@interface GHCameraModuleView()
/** 相册 */
@property (nonatomic , strong) UIButton *photo;
/** 相机 */
@property (nonatomic , strong) UIButton *camera;
/** 扫一扫 */
@property (nonatomic , strong) UIButton *scan;
/** 拍照 */
@property (nonatomic , strong) UIButton *takephotos;
/** 手电 */
@property (nonatomic , strong) UIButton *flashlight;
/** 点 */
@property (nonatomic , strong) UIView *point;

@property (nonatomic , strong) GHScanView *scanView;

@property (nonatomic , strong) GHAdjustFocal *adjustFocal;

@property (nonatomic , strong) NSTimer *timer;

@property (nonatomic , assign) NSInteger count;

@end

@implementation GHCameraModuleView

- (void)setCircleCenterY:(CGFloat)circleCenterY {
    _circleCenterY = circleCenterY;
    self.adjustFocal.circleCenterY = circleCenterY;
}
- (CGFloat)getCircleCenterY {
    return [self.adjustFocal getCircleCenterY];
}
- (CGFloat)getSliderHeight {
    return [self.adjustFocal getSliderHeight];
}

- (void)actionAdjustFocalWith: (BOOL)hidden {
    [UIView animateWithDuration:0.25 animations:^{
        self.adjustFocal.alpha = 1;
    }];
}

#pragma mark - private
- (CGFloat)actionCircleCenterY: (CGFloat)circleCenterY {
    if (circleCenterY <= 0) {
        circleCenterY = 0;
    }
    
    if (circleCenterY >= [self.adjustFocal getSliderHeight]) {
        circleCenterY = [self.adjustFocal getSliderHeight];
    }
    return circleCenterY;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setupUI];
        [self configuration];
    }
    return self;
}

- (void)configuration {
    self.count = 0;
    self.backgroundColor = [UIColor clearColor];
    
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerMethod) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)addTimer {
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)timerMethod {
    self.count++;
   
    if (self.count == 3) {
        [UIView animateWithDuration:0.25 animations:^{
            self.adjustFocal.alpha = 0;
        }];
        [self.timer invalidate];
        self.timer = nil;
        self.count = 0;
    }
}

- (void)setupUI {
    [self addSubview:self.scanView];
    [self addSubview:self.adjustFocal];
    [self addSubview:self.camera];
    [self addSubview:self.photo];
    [self addSubview:self.flashlight];
    [self addSubview:self.scan];
    [self addSubview:self.takephotos];
    [self addSubview:self.point];
}

- (void)moveWithType: (GHCameraModuleViewButtonType)type {
    if (type == GHCameraModuleViewButtonTypeScan) {
        [UIView animateWithDuration:0.5 animations:^{
            self.scanView.hidden = NO;
            self.scan.x = CGRectGetMaxX(self.camera.frame) - kAutoWithSize(60);
            self.takephotos.x = CGRectGetMaxX(self.scan.frame) + 20;
            self.scan.titleLabel.font = [UIFont systemFontOfSize:16];
            self.takephotos.titleLabel.font = [UIFont systemFontOfSize:14];
            self.camera.alpha = 0;
            self.adjustFocal.x = self.scanView.x +self.scanView.width - 15-1;
        } completion:^(BOOL finished) {
            
        }];
    } else if (type == GHCameraModuleViewButtonTypeTakephotos) {
        [UIView animateWithDuration:0.5 animations:^{
            self.adjustFocal.x = kScreenWidth - 30 -20;
            self.scanView.hidden = YES;
            self.takephotos.x = CGRectGetMaxX(self.camera.frame) - kAutoWithSize(60);
            self.scan.x = CGRectGetMinX(self.takephotos.frame) - 100;
            self.scan.titleLabel.font = [UIFont systemFontOfSize:14];
            self.takephotos.titleLabel.font = [UIFont systemFontOfSize:16];
            self.camera.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)clickButton: (UIButton *)button {
    button.selected = !button.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(cameraModuleView:button:)]) {
        [self.delegate cameraModuleView:self button:button];
    }
}

- (GHAdjustFocal *)adjustFocal {
    if (_adjustFocal == nil) {
        _adjustFocal = [[GHAdjustFocal alloc]initWithFrame:CGRectMake(self.scanView.x +self.scanView.width - 30-1, self.scanView.y, 15, 200)];
        _adjustFocal.alpha = 0;
    }
    return _adjustFocal;
}

- (GHScanView *)scanView {
    if (_scanView == nil) {
        _scanView = [[GHScanView alloc]creatScanViewWithFrame:CGRectMake((kScreenWidth - 200) * 0.5, (kScreenHeight - 200) * 0.5 - 64 - 100, 200, 200)];
    }
    return _scanView;
}

- (UIView *)point {
    if (_point == nil) {
        _point = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.camera.frame), CGRectGetMaxY(self.takephotos.frame) + 20, 10, 10)];
        _point.backgroundColor = [UIColor whiteColor];
        _point.layer.cornerRadius = 5;
        _point.layer.masksToBounds = YES;
    }
    return _point;
}

- (UIButton *)takephotos {
    if (_takephotos == nil) {
        _takephotos = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth - 80) *.5, CGRectGetMaxY(self.camera.frame) + 30, 80, 44)];
        [_takephotos addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        _takephotos.tag = GHCameraModuleViewButtonTypeTakephotos;
        [_takephotos setTitle:@"拍照" forState:UIControlStateNormal];
        _takephotos.titleLabel.font = [UIFont systemFontOfSize:14];
        _takephotos.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _takephotos;
}

- (UIButton *)scan {
    if (_scan == nil) {
        _scan = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.takephotos.frame) - 100, CGRectGetMinY(self.takephotos.frame), 80, 44)];
        [_scan addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        _scan.tag = GHCameraModuleViewButtonTypeScan;
        [_scan setTitle:@"扫一扫" forState:UIControlStateNormal];
        _scan.titleLabel.font = [UIFont systemFontOfSize:14];
        _scan.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _scan;
}
- (UIButton *)flashlight {
    if (_flashlight == nil) {
        _flashlight = [[UIButton alloc]initWithFrame:CGRectMake(self.camera.x +self.camera.width +60 , CGRectGetMinY(self.camera.frame) +  (kAutoWithSize(60) - kAutoWithSize(45))* .5, kAutoWithSize(45), kAutoWithSize(45))];
        [_flashlight addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
  
        _flashlight.tag = GHCameraModuleViewButtonTypeFlashlight;
        [_flashlight setImage:[UIImage imageNamed:kImageNameFlashlightNormal] forState:UIControlStateNormal];
        [_flashlight setImage:[UIImage imageNamed:kImageNameFlashlightSeleted] forState:UIControlStateSelected];
    }
    return _flashlight;
}
- (UIButton *)camera {
    if (_camera == nil) {
        _camera = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth -  kAutoWithSize(60)) * 0.5, kScreenHeight - 300, kAutoWithSize(60), kAutoWithSize(60))];
        [_camera addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        _camera.tag = GHCameraModuleViewButtonTypeCamera;
        [_camera setImage:[UIImage imageNamed:kImageNameCameraNormal] forState:UIControlStateNormal];
        [_camera setImage:[UIImage imageNamed:kImageNameCameraSeleted] forState:UIControlStateHighlighted];
    }
    return _camera;
}

- (UIButton *)photo {
    if (_photo == nil) {
        _photo = [[UIButton alloc]initWithFrame:CGRectMake(self.camera.x - 60 - kAutoWithSize(45), CGRectGetMinY(self.camera.frame) +  (kAutoWithSize(60) - kAutoWithSize(45))* .5, kAutoWithSize(45), kAutoWithSize(45))];
        [_photo addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        _photo.tag = GHCameraModuleViewButtonTypePhoto;
        [_photo setImage:[UIImage imageNamed:kImageNamePhoto] forState:UIControlStateNormal];
    }
    return _photo;
}

@end
