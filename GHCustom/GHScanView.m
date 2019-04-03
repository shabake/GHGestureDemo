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
@end
@implementation GHScanView

- (instancetype)creatScanViewWithFrame: (CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self configuration];
    }
    return self;
}

- (void)configuration {
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    [self addSubview:self.line];
    self.backgroundColor = [UIColor clearColor];
}

- (void)startAnimation {
    [self endAnimation];
    [UIView animateWithDuration:2 animations:^{
        self.line.y = self.height - self.line.height;
    } completion:^(BOOL finished) {
        if (finished) {
            self.line.y = 0;
            [self startAnimation];
        }
    }];
}

- (void)endAnimation{
    [self.line.layer removeAllAnimations];
}


- (UIImageView *)line {
    if (_line == nil) {
        _line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,200, 2)];
        _line.image = [UIImage imageNamed:@"scan_line"];
    }
    return _line;
}

- (void)dealloc {
    NSLog(@"已经销毁%s",__func__);
}

@end
