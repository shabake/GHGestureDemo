//
//  GHScanView.h
//  GHCameraModuleDemo
//
//  Created by mac on 2018/11/26.
//  Copyright © 2018年 GHome. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 自定义扫描视图ui
 */
@interface GHScanView : UIView

/**
 构造方法

 @param frame 传入frame
 @return 返回GHScanView
 */
- (instancetype)creatScanViewWithFrame: (CGRect)frame;

/**
 开始动画
 */
- (void)startAnimation;

/**
 停止动画
 */
- (void)endAnimation;

@end

NS_ASSUME_NONNULL_END
