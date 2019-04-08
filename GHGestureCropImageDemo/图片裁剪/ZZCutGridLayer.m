//
//  ZZCutGridLayer.m
//  test
//
//  Created by root on 2018/11/8.
//  Copyright © 2018年 凉凉. All rights reserved.
//

#import "ZZCutGridLayer.h"

@implementation ZZCutGridLayer

- (void)drawInContext:(CGContextRef)context
{
    CGRect rct = self.bounds;
    CGContextSetFillColorWithColor(context, self.bgColor.CGColor);
    CGContextFillRect(context, rct);
    
    //清除范围（截图范围）
    CGContextClearRect(context, _clippingRect);
    
    CGContextSetStrokeColorWithColor(context, self.gridColor.CGColor);
    CGContextSetLineWidth(context, 0.8);
    
    rct = self.clippingRect;
    
    CGContextBeginPath(context);
    CGFloat dW = 0;
    //画竖线
    for(int i = 0;i < 4; ++i){
        CGContextMoveToPoint(context, rct.origin.x + dW, rct.origin.y);
        CGContextAddLineToPoint(context, rct.origin.x + dW, rct.origin.y + rct.size.height);
        dW += _clippingRect.size.width / 3;
    }
    dW = 0;
    //画横线
    for(int i = 0;i < 4; ++i){
        CGContextMoveToPoint(context, rct.origin.x, rct.origin.y + dW);
        CGContextAddLineToPoint(context, rct.origin.x + rct.size.width, rct.origin.y + dW);
        dW += rct.size.height/3;
    }
    CGContextStrokePath(context);
}

@end
