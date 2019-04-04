//
//  GHCameraModuleHeader.h
//  GHCameraModuleDemo
//
//  Created by mac on 2018/11/27.
//  Copyright © 2018年 GHome. All rights reserved.
//

#ifndef GHCameraModuleHeader_h
#define GHCameraModuleHeader_h

typedef NS_ENUM (NSUInteger,GHCameraModuleViewButtonType) {
    /** 相机 */
    GHCameraModuleViewButtonTypeCamera = 1,
    /** 相册 */
    GHCameraModuleViewButtonTypePhoto ,
    /** 手电 */
    GHCameraModuleViewButtonTypeFlashlight ,
    /** 扫一扫 */
    GHCameraModuleViewButtonTypeScan ,
    /** 拍照 */
    GHCameraModuleViewButtonTypeTakephotos,
    
};

#define KAlert(title,msg) [[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show]

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kAutoWithSize(r) r*kScreenWidth / 375.0

#endif /* GHCameraModuleHeader_h */
