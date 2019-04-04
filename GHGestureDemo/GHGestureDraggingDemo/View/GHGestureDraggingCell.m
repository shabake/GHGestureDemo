//
//  GHGestureDraggingCell.m
//  GHGestureDraggingDemo
//
//  Created by zhaozhiwei on 2019/4/4.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import "GHGestureDraggingCell.h"

@interface GHGestureDraggingCell()
@property (nonatomic , strong) UIImageView *imgView;
@property (nonatomic , strong) UIView *line;
@property (nonatomic , strong) UILabel *title;
@property (nonatomic , strong) UIView *backGround;

@end
@implementation GHGestureDraggingCell

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    
    self.line.hidden = NO;
    if (indexPath.row == 0) {
        self.imgView.image = [UIImage imageNamed:@"origin"];
        self.title.text = @"起点(我的位置)";
    } else if (indexPath.row == 1) {
        self.imgView.image = [UIImage imageNamed:@"right"];
        self.title.text = @"向正东方向出发,走20米,右转";
    } else if (indexPath.row == 2) {
        self.imgView.image = [UIImage imageNamed:@"straight"];
        self.title.text = @"走70米,到达终点";
    } else if (indexPath.row == 3) {
        self.imgView.image = [UIImage imageNamed:@"end"];
        self.title.text = @"终点(万达广场)";
        self.line.hidden = YES;
    }
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupUI {
    
    self.backGround.frame = CGRectMake(10, 0, kScreenWidth - 20 , self.bounds.size.height);
    
    [self addSubview:self.backGround];
    
    self.imgView.frame = CGRectMake(10, 10, 30, 30);
    [self.backGround addSubview:self.imgView];
    
    self.title.frame = CGRectMake(CGRectGetMaxX(self.imgView.frame) + 10, 10, 200, 30);
    [self.backGround addSubview:self.title];
    
    self.line.frame = CGRectMake(CGRectGetMinX(self.title.frame) , self.bounds.size.height - 0.5 , kScreenWidth - 20 - CGRectGetMinX(self.title.frame) - 20, 0.5);
    [self.backGround addSubview:self.line];
}

- (UIView *)line {
    if (_line == nil) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = [UIColor lightGrayColor];
        _line.alpha = 0.3;
    }
    return _line;
}
- (UILabel *)title {
    if (_title == nil) {
        _title = [[UILabel alloc]init];
        _title.font = [UIFont systemFontOfSize:14];
    }
    return _title;
}

- (UIImageView *)imgView {
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc]init];
    }
    return _imgView;
}
- (UIView *)backGround {
    if (_backGround == nil) {
        _backGround = [[UIView alloc]init];
        _backGround.backgroundColor = [UIColor whiteColor];
    }
    return _backGround;
}


@end
