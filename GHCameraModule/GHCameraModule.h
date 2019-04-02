//
//  GHCameraModule.h
//  GHCameraModuleDemo
//
//  Created by mac on 2018/11/23.
//  Copyright © 2018年 GHome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class GHCameraModuleModel;
NS_ASSUME_NONNULL_BEGIN

typedef void (^CameraModuleBlock)(NSDictionary *info);
typedef void (^CameraModuleCodeBlock)(NSString *resultString);

/** 摄像头类型 */
typedef NS_ENUM (NSUInteger,GHCameraModuleType) {
    /** 相机 */
    GHCameraModuleTypeCamera,
    /** 扫一扫 */
    GHCameraModuleTypeScan,
};

@class GHCameraModule;
@protocol GHCameraModuleDelegate <NSObject>
- (void)cameraModule: (GHCameraModule *)cameraModule info: (nullable NSDictionary  *) info resultString: (nullable NSString *) resultString;

@end

@interface GHCameraModule : NSObject
#pragma mark - ios9之后调用相机.需要在info中 添加 NSCameraUsageDescription
/**
 构造方法

 @param cameraModuleBlock 选择图片回调
 @param cameraModuleCodeBlock 二维码回调
 @return GHCameraModule
 */
- (instancetype)creatCameraModuleWithCameraModuleBlock: (CameraModuleBlock)cameraModuleBlock
                                      cameraModuleCodeBlock: (CameraModuleCodeBlock)cameraModuleCodeBlock;
/** 二维码扫描区域 */
@property (nonatomic , assign) CGRect rectOfInterest;
/** 打开摄像头 */
- (void)start;
/** 关闭摄像头 */
- (void)stop;
/** 屏幕截图 */
- (void)screenshot;
/** 打开关闭手电筒 */
- (void)turnTorchOn:(BOOL)on;
/** 选择相册 */
- (void)chosePhoto ;

/** 调整镜头焦距 */
- (void)adjustFocalWtihValue: (CGFloat)value;

@property (nonatomic , strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic , weak) id <GHCameraModuleDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
