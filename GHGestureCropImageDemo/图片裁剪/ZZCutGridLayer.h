//
//  ZZCutGridLayer.h
//  test
//
//  Created by root on 2018/11/8.
//  Copyright © 2018年 凉凉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZCutGridLayer : CALayer
@property (nonatomic, assign) CGRect clippingRect; //裁剪范围
@property (nonatomic, strong) UIColor *bgColor;    //背景颜色
@property (nonatomic, strong) UIColor *gridColor;  //线条颜色
@end
