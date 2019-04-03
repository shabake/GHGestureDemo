//
//  GHAdjustFocal.m
//  GHGestureDemo
//
//  Created by zhaozhiwei on 2019/4/2.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import "GHAdjustFocal.h"
#import "UIView+GHAdd.h"

#define ColorRGBA(r, g, b, a) ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)])

@interface GHAdjustFocal()

/**
 背景
 */
@property (nonatomic , strong) UIView *backGround;

/**
 内层背景
 */
@property (nonatomic , strong) UIView *inBackGround;
/**
 圆头
 */
@property (nonatomic , strong) UIView *circle;

/**
 滑杆
 */
@property (nonatomic , strong) UIView *slider;

/**
 "+"
 */
@property (nonatomic , strong) UILabel *add;

/**
 "-"
 */
@property (nonatomic , strong) UILabel *sub;

@end

@implementation GHAdjustFocal


#pragma mark - set
- (void)setCircleCenterY:(CGFloat)circleCenterY {
    
    _circleCenterY = circleCenterY;
    
    self.circle.gh_centery = circleCenterY;
    
    for (CAShapeLayer *layer in self.slider.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = CGRectMake(0, 0, self.slider.gh_width, circleCenterY);
    layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.slider.layer addSublayer:layer];
    
    CGFloat scale = ([self getSliderHeight] - circleCenterY)/[self getSliderHeight] ;/// 计算比例

    if (self.scaleBlock) {
        self.scaleBlock(scale);
    }
}

#pragma mark - 初始化
- (instancetype)init {
    if (self == [super init]) {
        [self setupUI];
        [self configuration];
    }
    return self;
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setupUI];
        [self configuration];
    }
    return self;
}

- (void)configuration {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = CGRectMake(0, 0, self.slider.gh_width, self.slider.gh_height);
    layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.slider.layer addSublayer:layer];
}

#pragma mark - 创建UI
- (void)setupUI {
    
    CGFloat totalHeight = self.bounds.size.height; /// 总长度
    CGFloat totalWidth = self.bounds.size.width;   /// 总宽度
    
    CGFloat sliderY = 0;
    
    CGFloat backGroundY = 0;
    CGFloat backGroundW = totalWidth;
    CGFloat backGroundX = 0;
    CGFloat backGroundH = totalHeight;
    self.backGround.frame = CGRectMake(backGroundX, backGroundY, backGroundW, backGroundH);
    
    self.inBackGround.frame = CGRectMake(0, 20, backGroundW, totalHeight - 40);
    
    CGFloat sliderW = 3;
    CGFloat sliderX = (totalWidth - sliderW) *.5;
    CGFloat sliderH = totalHeight - 40;
    
    self.slider.frame = CGRectMake(sliderX, sliderY, sliderW, sliderH);
    
    CGFloat circleW = 10;
    CGFloat circleH = circleW;
    CGFloat circleX = (totalWidth - circleW) *.5;
    CGFloat circleY = sliderH -circleH * 0.5;
    self.circle.frame = CGRectMake(circleX,circleY, circleW, circleH);
    
    CGFloat addY = 5;
    CGFloat addW = 20;
    CGFloat addH = 10;
    CGFloat addX = (totalWidth - addW) *.5;
    self.add.frame = CGRectMake(addX,addY, addW, addH);
    
    CGFloat subX = addX;
    CGFloat subW = addW;
    CGFloat subH = addH;
    CGFloat subY = self.inBackGround.gh_height + self.inBackGround.gh_top + 5;
    self.sub.frame = CGRectMake(subX, subY, subW, subH);
    
    [self addSubview:self.backGround];
    [self.backGround addSubview:self.inBackGround];
    [self.inBackGround addSubview:self.slider];
    [self.inBackGround addSubview:self.circle];
    [self.backGround addSubview:self.add];
    [self.backGround addSubview:self.sub];
    
}

#pragma mark - private
- (CGFloat)actionCircleCenterY: (CGFloat)circleCenterY {
    if (circleCenterY <= 0) {
        circleCenterY = 0;
    }
    
    if (circleCenterY >= [self getSliderHeight]) {
        circleCenterY = [self getSliderHeight];
    }
    return circleCenterY;
}

#pragma mark - get
- (UILabel *)sub {
    if (_sub == nil) {
        _sub = [[UILabel alloc]init];
        _sub.text = @"-";
        _sub.textColor = [UIColor whiteColor];
        _sub.textAlignment = NSTextAlignmentCenter;
    }
    return _sub;
}

- (UILabel *)add {
    if (_add == nil) {
        _add = [[UILabel alloc]init];
        _add.text = @"+";
        _add.textColor = [UIColor whiteColor];
        _add.textAlignment = NSTextAlignmentCenter;
    }
    return _add;
}

- (UIView *)circle {
    if (_circle == nil) {
        _circle = [[UIView alloc]init];
        _circle.backgroundColor = [UIColor whiteColor];
        _circle.layer.masksToBounds = YES;
        _circle.layer.cornerRadius = 5;
    }
    return _circle;
}

- (UIView *)slider {
    if (_slider == nil) {
        _slider = [[UIView alloc]init];
        _slider.backgroundColor = [UIColor whiteColor];
        _slider.layer.masksToBounds = YES;
        _slider.layer.cornerRadius = 5;
    }
    return _slider;
}

- (UIView *)inBackGround {
    if (_inBackGround == nil) {
        _inBackGround = [[UIView alloc]init];
        _inBackGround.backgroundColor = [UIColor redColor];
    }
    return _inBackGround;
}

- (UIView *)backGround {
    if (_backGround == nil) {
        _backGround = [[UIView alloc]init];
        _backGround.backgroundColor = [UIColor blackColor];
        _backGround.layer.masksToBounds = YES;
        _backGround.layer.cornerRadius = 10;
        _backGround.alpha = 0.3;
    }
    return _backGround;
}

- (CGFloat)getCircleCenterY {
    return self.circle.gh_centery;
}

- (CGFloat)getSliderHeight {
    return self.bounds.size.height - 40;
}

@end

