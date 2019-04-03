//
//  GHAdjustFocal.h
//  GHGestureDemo
//
//  Created by zhaozhiwei on 2019/4/2.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^GHAdjustFocalScaleBlock)(CGFloat scale);
/**
 * 调整焦距组件
 */
@interface GHAdjustFocal : UIView

/**
 * 设置circleCenterY
 */
@property (nonatomic , assign) CGFloat circleCenterY;

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
 处理circleCenterY 两端越界

 @param circleCenterY circleCenterY
 @return circleCenterY
 */
- (CGFloat)actionCircleCenterY: (CGFloat)circleCenterY;

@end

NS_ASSUME_NONNULL_END
