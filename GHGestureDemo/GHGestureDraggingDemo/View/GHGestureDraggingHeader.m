//
//  GHGestureDraggingHeader.m
//  GHGestureDraggingDemo
//
//  Created by zhaozhiwei on 2019/4/4.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import "GHGestureDraggingHeader.h"
#import "UIView+Extension.h"

@interface GHGestureDraggingHeader()
@property (nonatomic , strong) UIView *backGround;
@property (nonatomic , strong) UILabel *title;
@property (nonatomic , strong) UIView *line;
@property (nonatomic , strong) UILabel *info;
@property (nonatomic , strong) UIButton *timeNavigation;

@end
@implementation GHGestureDraggingHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.backGround.frame = CGRectMake(10, 10, self.bounds.size.width - 20, self.bounds.size.height - 20);
    
    [self addSubview:self.backGround];
    
    self.title.frame = CGRectMake(10, 10, self.bounds.size.width - 20, 40);
    [self.backGround addSubview:self.title];
    
    self.line.frame = CGRectMake(10, self.title.height + self.title.y, self.bounds.size.width - 20, 0.5);
    [self.backGround addSubview:self.line];

    self.info.frame = CGRectMake(10, CGRectGetMaxY(self.line.frame) + 10, self.bounds.size.width - 20, 20);
    [self.backGround addSubview:self.info];

    self.timeNavigation.frame = CGRectMake(10, CGRectGetMaxY(self.info.frame) + 5, 100, 40);
    [self.backGround addSubview:self.timeNavigation];
}

- (UIButton *)timeNavigation {
    if (_timeNavigation == nil) {
        _timeNavigation = [[UIButton alloc]init];
        _timeNavigation.backgroundColor = [UIColor redColor];
        [_timeNavigation setTitle:@"实时导航" forState:UIControlStateNormal];
        [_timeNavigation setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _timeNavigation.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _timeNavigation;
}

- (UIView *)backGround {
    if (_backGround == nil) {
        _backGround = [[UIView alloc]init];
        _backGround.backgroundColor = [UIColor whiteColor];
    }
    return _backGround;
}

- (UIView *)line {
    if (_line == nil) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = [UIColor lightGrayColor];
    }
    return _line;
}

- (UILabel *)info {
    if (_info == nil) {
        _info = [[UILabel alloc]init];
        _info.font = [UIFont systemFontOfSize:10];
        _info.text = @"消耗5大卡  打车约14元";
    }
    return _info;
}

- (UILabel *)title {
    if (_title == nil) {
        _title = [[UILabel alloc]init];
        _title.font = [UIFont boldSystemFontOfSize:15];
        _title.text = @"1分钟 91米";
    }
    return _title;
}


@end
