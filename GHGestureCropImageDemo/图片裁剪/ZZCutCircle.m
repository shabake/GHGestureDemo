//
//  ZZCutCircle.m
//  test
//
//  Created by root on 2018/11/8.
//  Copyright © 2018年 凉凉. All rights reserved.
//

#import "ZZCutCircle.h"

@implementation ZZCutCircle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rct = self.bounds;
    rct.origin.x = rct.size.width / 2 - rct.size.width / 6;
    rct.origin.y = rct.size.height / 2 - rct.size.height / 6;
    rct.size.width /= 3;
    rct.size.height /= 3;
    
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextFillEllipseInRect(context, rct);
}

@end
