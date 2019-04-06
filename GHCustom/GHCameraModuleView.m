//
//  FSCameraModuleView.m
//  FangShengyun
//
//  Created by mac on 2018/11/20.
//  Copyright © 2018年 http://www.xinfangsheng.com. All rights reserved.
//

#import "GHCameraModuleView.h"
#import "GHScanView.h"
#import "GHAdjustFocal.h"
#import "GHTimerManager.h"
#import "UIView+Extension.h"

#define kFont(size) kAutoWithSize(size)

#define kImageNameCameraNormal @"cameraModule_cameraNormal"
#define kImageNameCameraSeleted @"cameraModule_cameraSeleted"
#define kImageNamePhoto @"cameraModule_photo"
#define kImageNameFlashlightNormal @"cameraModule_torchNormal"
#define kImageNameFlashlightSeleted @"cameraModule_torchSeleted"
#define kImageNameSeleted @"cameraModule_photoSeleted"

@interface GHCameraModuleView()


/**
 * 矩形框
 */
@property (nonatomic , strong) GHScanView *scanView;

/**
 * 滑杆
 */
@property (nonatomic , strong) GHAdjustFocal *adjustFocal;

/**
 * 提示文字
 */
@property (nonatomic , strong) UILabel *tip;

@end

@implementation GHCameraModuleView


- (void)startAnimation {
    [self.scanView startAnimation];
}

- (void)endAnimation {
    [self.scanView endAnimation];
}

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
        [self startAnimation];
    }
    return self;
}

- (void)configuration {
    self.backgroundColor = [UIColor clearColor];
}

- (void)showAdjustFocal{
    [UIView animateWithDuration:0.25 animations:^{
        self.adjustFocal.alpha = 1;
    }];
    [GHTimerManager sharedManager].count = 0;
}

- (void)addTimer {
    
    [[GHTimerManager sharedManager] timerStartWithTimerActionBlock:^(GHTimerManager *timerManager, NSInteger count) {
        if (count == 3) {
            [UIView animateWithDuration:0.25 animations:^{
                self.adjustFocal.alpha = 0;
            }];
            [timerManager timerRemove];
        }
    }];
}

- (void)setupUI {
    [self addSubview:self.scanView];
    [self addSubview:self.tip];
    [self addSubview:self.adjustFocal];
}

- (void)moveWithType: (GHCameraModuleViewButtonType)type {
    if (type == GHCameraModuleViewButtonTypeScan) {
        [UIView animateWithDuration:0.5 animations:^{
            self.scanView.hidden = NO;
            self.tip.alpha = 1;
            self.adjustFocal.x = self.scanView.x +self.scanView.width + 15;
        } completion:^(BOOL finished) {
            
        }];
    } else if (type == GHCameraModuleViewButtonTypeTakephotos) {
        [UIView animateWithDuration:0.5 animations:^{
            self.adjustFocal.x = kScreenWidth - 30 -20;
            self.scanView.hidden = YES;
            self.tip.alpha = 0;
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
        _adjustFocal = [[GHAdjustFocal alloc]initWithFrame:CGRectMake(self.scanView.x + self.scanView.width - 30-1, self.scanView.y , 15, self.scanView.height)];
        _adjustFocal.alpha = 0;
    }
    return _adjustFocal;
}

- (GHScanView *)scanView {
    if (_scanView == nil) {
        _scanView = [[GHScanView alloc]creatScanViewWithFrame:CGRectMake((kScreenWidth - kAutoWithSize(228)) * 0.5, (kScreenHeight - kAutoWithSize(228)) * 0.5 - 64 - 100, kAutoWithSize(228), kAutoWithSize(228))];
    }
    return _scanView;
}

- (UILabel *)tip {
    if (_tip == nil) {
        _tip = [[UILabel alloc]init];
        _tip.text = @"请将二维码放入框内即可扫描";
        _tip.textColor = [UIColor whiteColor];
        _tip.font = [UIFont systemFontOfSize:kFont(14)];
        _tip.frame = CGRectMake(0, CGRectGetMaxY(self.scanView.frame) + 10, kScreenWidth, 20);
        _tip.textAlignment = NSTextAlignmentCenter;
        _tip.alpha = 0;
    }
    return _tip;
}

@end

