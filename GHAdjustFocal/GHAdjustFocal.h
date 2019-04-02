//
//  GHAdjustFocal.h
//  GHGestureDemo
//
//  Created by zhaozhiwei on 2019/4/2.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GHAdjustFocal;

typedef void(^GHAdjustFocalValueBlock)(GHAdjustFocal *sdjustFocal, CGFloat value);

/**
 * 调整焦距组件
 */
@interface GHAdjustFocal : UIView

@property (nonatomic , copy) GHAdjustFocalValueBlock focalValueBlock;

@property (nonatomic , assign) CGFloat circleCenterY;

- (CGFloat)getCircleCenterY;

/**
 获取滑杆的高度

 @return 返回滑杆的高度
 */
- (CGFloat)getSliderHeight;

@end

NS_ASSUME_NONNULL_END
