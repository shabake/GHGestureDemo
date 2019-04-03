//
//  GHAdjustFocal.h
//  GHGestureDemo
//
//  Created by zhaozhiwei on 2019/4/2.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 圆圈位置枚举
 */
typedef NS_ENUM (NSUInteger,GHAdjustFocalCircleLocation) {
    /// 默认最底部
    GHAdjustFocalCircleLocationBottom = 0,
    /// 顶部
    GHAdjustFocalCircleLocationTop,
};

typedef void(^GHAdjustFocalScaleBlock)(CGFloat scale);
/**
 * 调整焦距组件
 */
@interface GHAdjustFocal : UIView

/**
 * 圆圈的位置的枚举
 */
@property (nonatomic , assign) GHAdjustFocalCircleLocation circleLocation;

/**
 * 设置circleCenterY 范围 [0 - [self getSliderHeight]]
 */
@property (nonatomic , assign) CGFloat circleCenterY;

/**
 * 返回比例block
 */
@property (nonatomic , copy) GHAdjustFocalScaleBlock scaleBlock;

/**
 获取到circleCenterY

 @return circleCenterY
 */
- (CGFloat)getCircleCenterY;

/**
 获取滑杆的高度

 @return 返回滑杆的高度
 */
- (CGFloat)getSliderHeight;

/**
 * 顶部间距
 */
@property (nonatomic , assign) CGFloat marginY;

/**
 处理circleCenterY 两端越界

 @param circleCenterY circleCenterY
 @return circleCenterY
 */
- (CGFloat)actionCircleCenterY: (CGFloat)circleCenterY;

/**
 初始化方法

 @param frame frame
 @param circleLocation GHAdjustFocalCircleLocation
 @return GHAdjustFocal
 */
- (instancetype)initWithFrame:(CGRect)frame circleLocation: (GHAdjustFocalCircleLocation)circleLocation;

@end

NS_ASSUME_NONNULL_END
