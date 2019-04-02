//
//  GHPrivacyAuthTool.h
//  GHPrivacyAuthToolDemo
//
//  Created by zhaozhiwei on 2019/3/28.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSUInteger,GHPrivacyType) {
    /// 定位服务
    GHPrivacyLocationServices =0,
    /// 通讯录
    GHPrivacyContacts,
    /// 日历
    GHPrivacyCalendars,
    /// 提醒事项
    GHPrivacyReminders,
    /// 照片
    GHPrivacyPhotos,
    /// 蓝牙共享
    GHPrivacyBluetoothSharing,
    /// 麦克风
    GHPrivacyMicrophone,
    /// 语音识别 >= iOS10
    GHPrivacySpeechRecognition,
    /// 相机
    GHPrivacyCamera,
    /// 健康 >= iOS8.0
    GHPrivacyHealth,
    /// 家庭 >= iOS8.0
    GHPrivacyHomeKit,
    /// 媒体与Apple Music >= iOS9.3
    GHPrivacyMediaAndAppleMusic,
    /// 运动与健身
    GHPrivacyMotionAndFitness,
    /// 网络连接
    GHPrivacyNetWork,
};

typedef NS_ENUM(NSInteger, GHAuthStatus) {
    /** 用户从未进行过授权等处理，首次访问相应内容会提示用户进行授权 */
    GHAuthStatusNotDetermined  = 0,
    /** 已授权 */
    GHAuthStatusAuthorized     = 1,
    /** 拒绝 */
    GHAuthStatusDenied         = 2,
    /** 应用没有相关权限，且当前用户无法改变这个权限，比如:家长控制 */
    GHAuthStatusRestricted     = 3,
    /** 硬件等不支持 */
    GHAutStatusNotSupport     = 4,
};

/// 定位权限状态，参考CLAuthorizationStatus
typedef NS_ENUM(NSUInteger, GHLocationAuthStatus){
    GHLocationAuthStatusNotDetermined         = 0, // 用户从未进行过授权等处理，首次访问相应内容会提示用户进行授权
    GHLocationAuthStatusAuthorized            = 1, // 一直允许获取定位 ps：< iOS8用
    GHLocationAuthStatusDenied                = 2, // 拒绝
    GHLocationAuthStatusRestricted            = 3, // 应用没有相关权限，且当前用户无法改变这个权限，比如:家长控制
    GHLocationAuthStatusNotSupport            = 4, // 硬件等不支持
    GHLocationAuthStatusAuthorizedAlways      = 5, // 一直允许获取定位
    GHLocationAuthStatusAuthorizedWhenInUse   = 6, // 在使用时允许获取定位
};

/**
 对应类型隐私权限状态回调block
 
 @param granted 是否授权
 @param status 授权的具体状态
 */
typedef void (^GHPrivacyAuthToolStatusBlock) (BOOL granted,GHAuthStatus status);

/**
 定位权限状态回调block
 @param status 授权的具体状态
 */
typedef void(^GHPrivacyAuthToolLocationAuthStatusBlock)(GHLocationAuthStatus status);

@interface GHPrivacyAuthTool : NSObject

+ (instancetype)share;

@property (nonatomic, assign) GHPrivacyType privacyType;
@property (nonatomic, assign) GHAuthStatus authStatus;


/**
 检查和请求对应类型的隐私权限
 
 @param type 类型
 @param isPushSetting 当拒绝时是否跳转设置界面开启权限 (为NO时 只提示信息)
 @param title 标题
 @param message 提示信息
 
 @param statusBlock 对应类型状态回调
 
 */
- (void)checkPrivacyAuthWithType:(GHPrivacyType)type
                   isPushSetting:(BOOL)isPushSetting
                           title:(NSString *)title
                         message:(NSString *)message
                      withHandle:(GHPrivacyAuthToolStatusBlock)statusBlock;

/**
 检查和请求 定位权限
 
 @param isPushSetting 当拒绝时是否跳转设置界面开启权限 (为NO时 只提示信息)
 @param locationAuthStatusBlock 定位状态回调
 */
- (void)checkLocationAuthWithisPushSetting:(BOOL)isPushSetting
                                withHandle:(GHPrivacyAuthToolLocationAuthStatusBlock)locationAuthStatusBlock;

@end

NS_ASSUME_NONNULL_END

