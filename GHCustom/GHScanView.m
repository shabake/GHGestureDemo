//
//  GHScanView.m
//  GHCameraModuleDemo
//
//  Created by mac on 2018/11/26.
//  Copyright © 2018年 GHome. All rights reserved.
//

#import "GHScanView.h"
#import "UIView+Extension.h"

@interface GHScanView()

@property (nonatomic , strong) UIImageView *line;

/**
 * 正方形
 */
@property (nonatomic , strong) UIView *square;

@end

@implementation GHScanView

- (instancetype)creatScanViewWithFrame: (CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.square];
    [self addSubview:self.line];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.square.frame = CGRectMake(0, 0, self.bounds.size.width , self.bounds.size.height);
    self.line.width = self.bounds.size.width;
}

- (void)startAnimation {
    
    [UIView animateWithDuration:1 animations:^{
        self.line.y = 2;
        self.line.height = self.bounds.size.height - 2;

    } completion:^(BOOL finished) {
        
        if (finished) {
            self.line.y = 0;
            self.line.height = 2;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self startAnimation];
            });
        }
    }];
}

- (void)endAnimation{
    
}

- (void)drawRect:(CGRect)rect {
    [self createLine];
}

- (void)addLayerWithPath: (UIBezierPath *)path {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.lineWidth = 4;
    [self.layer addSublayer:layer];
}

- (void)createLine{
    
    UIBezierPath *leftTopPath = [UIBezierPath bezierPath];
    [leftTopPath moveToPoint:CGPointMake(0, 20)];
    [leftTopPath addLineToPoint:CGPointMake(0, 0)];
    [leftTopPath addLineToPoint:CGPointMake(20, 0)];
    [self addLayerWithPath:leftTopPath];
    
    UIBezierPath *leftBottomPath = [UIBezierPath bezierPath];
    [leftBottomPath moveToPoint:CGPointMake(0, self.bounds.size.height - 20)];
    [leftBottomPath addLineToPoint:CGPointMake(0, self.bounds.size.height)];
    [leftBottomPath addLineToPoint:CGPointMake(20, self.bounds.size.height)];
    [self addLayerWithPath:leftBottomPath];
    
    UIBezierPath *rightTopPath = [UIBezierPath bezierPath];
    [rightTopPath moveToPoint:CGPointMake(self.bounds.size.width - 20, 0)];
    [rightTopPath addLineToPoint:CGPointMake(self.bounds.size.width, 0)];
    [rightTopPath addLineToPoint:CGPointMake(self.bounds.size.width, 20)];
    [self addLayerWithPath:rightTopPath];
    
    UIBezierPath *rightBottomPath = [UIBezierPath bezierPath];
    [rightBottomPath moveToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height - 20)];
    [rightBottomPath addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
    [rightBottomPath addLineToPoint:CGPointMake(self.bounds.size.width -20, self.bounds.size.height)];
    [self addLayerWithPath:rightBottomPath];
}

- (UIView *)square {
    if (_square == nil) {
        _square = [[UIView alloc]init];
        _square.layer.borderWidth = 0.5;
        _square.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _square;
}

- (UIImageView *)line {
    if (_line == nil) {
        _line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,200, 2)];
        _line.image = [UIImage imageNamed:@"grid"];
    }
    return _line;
}

- (void)dealloc {
    NSLog(@"已经销毁%s",__func__);
}

@end
