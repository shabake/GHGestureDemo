//
//  GHCameraModuleView.h
//  GHCameraModuleDemo
//
//  Created by mac on 2018/11/27.
//  Copyright © 2018年 GHome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHCameraModuleHeader.h"

NS_ASSUME_NONNULL_BEGIN

@class GHCameraModuleView;
@protocol GHCameraModuleViewDelegate <NSObject>
- (void)cameraModuleView: (GHCameraModuleView *)cameraModuleView button:(UIButton *)button;

@end
@interface GHCameraModuleView : UIView
@property (nonatomic , weak)id <GHCameraModuleViewDelegate>delegate;
- (void)moveWithType: (GHCameraModuleViewButtonType)type;

@property (nonatomic , assign) CGFloat circleCenterY;

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

- (CGFloat)actionCircleCenterY: (CGFloat)circleCenterY;
@end

NS_ASSUME_NONNULL_END
