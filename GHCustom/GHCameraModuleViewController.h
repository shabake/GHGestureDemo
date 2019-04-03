//
//  GHCameraModuleViewController.h
//  GHCameraModuleDemo
//
//  Created by mac on 2018/11/27.
//  Copyright © 2018年 GHome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHCameraModuleHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface GHCameraModuleViewController : UIViewController

/**
 构造方法

 @param type 界面类型
 GHCameraModuleViewButtonTypeScan 扫一扫,
 GHCameraModuleViewButtonTypeTakephotos 拍照,
 传入不同的值显示不同UI
 @return 返回GHCameraModuleViewController
 */

+ (instancetype)creatCameraModuleVcWithType : (GHCameraModuleViewButtonType)type;
@property (nonatomic , assign) GHCameraModuleViewButtonType cameraModuleViewButtonType ;
@end

NS_ASSUME_NONNULL_END
