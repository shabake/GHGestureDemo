//
//  GHPrivacyAuthTool.m
//  GHPrivacyAuthToolDemo
//
//  Created by zhaozhiwei on 2019/3/28.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import "GHPrivacyAuthTool.h"
#import <AVFoundation/AVFoundation.h>  //相机/麦克风
#import <Photos/Photos.h> //相册
#import <CoreLocation/CoreLocation.h>            //定位
#import <CoreLocation/CLLocationManager.h>
#import <CoreBluetooth/CoreBluetooth.h>          //蓝牙
#import <Contacts/Contacts.h>                    //通讯录iOS9以后  之前用//#import <AddressBook/AddressBook.h>
#import <EventKit/EventKit.h>
#import <HealthKit/HealthKit.h>
#import <MediaPlayer/MediaPlayer.h>
//这里需要注意，我们最好写成这种形式（防止低版本找不到头文件出现问题）
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h> //通知
#endif
#define IOS10_OR_LATER  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
#define IOS9_OR_LATER   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define IOS8_OR_LATER   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IOS7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

@interface GHPrivacyAuthTool ()<UNUserNotificationCenterDelegate,CLLocationManagerDelegate>

@property (nonatomic , copy) NSString *title;
@property (nonatomic , copy) NSString *message;

@property (nonatomic , copy) GHPrivacyAuthToolStatusBlock statusBlock;

@property (nonatomic , strong) CBCentralManager *centralManager;   //蓝牙

@property (nonatomic , strong) CLLocationManager *locationManager; //定位

@property (nonatomic , copy) GHPrivacyAuthToolLocationAuthStatusBlock locationAuthStatusBlock;

@property (nonatomic , copy) void (^kCLCallBackBlock)(CLAuthorizationStatus state);

@end

@implementation GHPrivacyAuthTool

+ (instancetype)share {
    static GHPrivacyAuthTool *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (share ==nil) {
            share = [[GHPrivacyAuthTool alloc]init];
        }
    });
    return share;
}

- (void)checkPrivacyAuthWithType:(GHPrivacyType)type
                   isPushSetting:(BOOL)isPushSetting
                           title:(NSString *)title
                         message:(NSString *)message
                      withHandle:(GHPrivacyAuthToolStatusBlock)statusBlock {
    
    self.title = title;
    self.message = message;
    self.statusBlock = statusBlock;
    switch (type) {
#pragma mark - 相册权限
        case GHPrivacyPhotos: {   // 相册
            [self checkAuthPhotos:isPushSetting];
        }
            break;
#pragma mark - 相机权限
        case GHPrivacyCamera:
        {   // 相机
            [self checkAuthCamera:isPushSetting];
        }
            break;
#pragma mark - 麦克风权限
        case GHPrivacyMicrophone:
        {   // 麦克风
            [self checkAuthMicrophone:isPushSetting];
        }
            break;
        case GHPrivacyContacts:
        {   // 通讯录
            [self checkAuthContacts:isPushSetting];
        }
            break;
        case GHPrivacyCalendars:
        {   // 日历
            [self checkAuthCalendars:isPushSetting];
        }
            break;
        case GHPrivacyReminders:
        {    // 提醒事项
            [self checkAuthReminders:isPushSetting];
        }
            break;
        case GHPrivacySpeechRecognition:
        {   //语音识别
            
        }
            break;
        case GHPrivacyBluetoothSharing:
        {
            
        }
            break;
        case GHPrivacyLocationServices:
        {
            
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - 检查相册权限
- (void)checkAuthPhotos:(BOOL)isPushSetting {
    
    __weak typeof(self) weakSelf = self;
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    switch (authStatus) {
        case PHAuthorizationStatusNotDetermined:
        {   //第一次进来
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    weakSelf.statusBlock(YES, GHAuthStatusAuthorized);
                } else {
                    weakSelf.statusBlock(NO, GHAuthStatusDenied);
                    [self pushSetting:isPushSetting];
                }
            }];
        }
            break;
        case PHAuthorizationStatusRestricted:
        {    //未授权，家长限制
            weakSelf.statusBlock(NO, GHAuthStatusRestricted);
            [self pushSetting:isPushSetting];
        }
            break;
        case PHAuthorizationStatusDenied:
        {   //拒绝
            weakSelf.statusBlock(NO, GHAuthStatusDenied);
            [self pushSetting:isPushSetting]; //拒绝时跳转或提示
        }
            break;
        case PHAuthorizationStatusAuthorized:
        {   //已授权
            NSLog(@"PHAuthorizationStatusAuthorized%ld",(long)PHAuthorizationStatusAuthorized);
            NSLog(@"GHAuthStatusAuthorized%ld",(long)GHAuthStatusAuthorized);
            
            weakSelf.statusBlock(YES, GHAuthStatusAuthorized);
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - 检查相机权限
- (void)checkAuthCamera:(BOOL)isPushSetting{
    
    __weak typeof(self) weakSelf = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (authStatus) {
            case AVAuthorizationStatusNotDetermined:
            {   //第一次进来
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    
                    if (granted == YES) {
                        weakSelf.statusBlock(YES, GHAuthStatusAuthorized);
                    }else{
                        weakSelf.statusBlock(NO, GHAuthStatusDenied);
                        [self pushSetting:isPushSetting]; //拒绝时跳转或提示
                    }
                }];
            }
                break;
            case AVAuthorizationStatusRestricted:
            {   //未授权，家长限制
                weakSelf.statusBlock(NO, GHAuthStatusRestricted);
                [self pushSetting:isPushSetting]; //拒绝时跳转或提示
            }
                break;
            case AVAuthorizationStatusDenied:
            {   //拒绝
                weakSelf.statusBlock(NO, GHAuthStatusDenied);
                [self pushSetting:isPushSetting]; //拒绝时跳转或提示
            }
                break;
            case AVAuthorizationStatusAuthorized:
            {   //已授权
                weakSelf.statusBlock(YES, GHAuthStatusAuthorized);
            }
                break;
            default:
                break;
        }
    } else {
        weakSelf.statusBlock(NO, GHAutStatusNotSupport);
    }
    
}
#pragma mark - 检查麦克风权限
- (void)checkAuthMicrophone:(BOOL)isPushSetting{
    
    __weak typeof(self) weakSelf = self;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
        {   //第一次进来
            
            [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                
                if (granted == YES) {
                    weakSelf.statusBlock(YES, GHAuthStatusAuthorized);
                }else{
                    weakSelf.statusBlock(NO, GHAuthStatusDenied);
                    [self pushSetting:isPushSetting]; //拒绝时跳转或提示
                }
            }];
            
        }
            break;
        case AVAuthorizationStatusRestricted:
        {   //未授权，家长限制
            weakSelf.statusBlock(NO, GHAuthStatusRestricted);
            [self pushSetting:isPushSetting]; //拒绝时跳转或提示
        }
            break;
        case AVAuthorizationStatusDenied:
        {   //拒绝
            weakSelf.statusBlock(NO, GHAuthStatusDenied);
            [self pushSetting:isPushSetting]; //拒绝时跳转或提示
        }
            break;
        case AVAuthorizationStatusAuthorized:
        {   //已授权
            weakSelf.statusBlock(YES, GHAuthStatusAuthorized);
        }
            break;
        default:
            break;
    }
    
}
#pragma mark - 检查通讯录权限
- (void)checkAuthContacts:(BOOL)isPushSetting{
    
    //    __weak typeof(self) weakSelf = self;
    //    CNAuthorizationStatus authStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    //    switch (authStatus) {
    //        case CNAuthorizationStatusNotDetermined:
    //        {   //第一次进来
    //            CNContactStore *store = [[CNContactStore alloc] init];
    //            [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
    //                if (granted == YES) {
    //                    weakSelf.statusBlock(YES, GHAuthStatusAuthorized);
    //                }else{
    //                    weakSelf.statusBlock(NO, GHAuthStatusDenied);
    //                    [self pushSetting:isPushSetting]; //拒绝时跳转或提示
    //                }
    //            }];
    //        }
    //            break;
    //        case CNAuthorizationStatusRestricted:
    //        {   //未授权，家长限制
    //            weakSelf.statusBlock(NO, GHAuthStatusRestricted);
    //            [self pushSetting:isPushSetting]; //拒绝时跳转或提示
    //        }
    //            break;
    //        case CNAuthorizationStatusDenied:
    //        {   //拒绝
    //            weakSelf.statusBlock(NO, GHAuthStatusDenied);
    //            [self pushSetting:isPushSetting]; //拒绝时跳转或提示
    //        }
    //            break;
    //        case CNAuthorizationStatusAuthorized:
    //        {   //已授权
    //            weakSelf.statusBlock(YES, GHAuthStatusAuthorized);
    //        }
    //            break;
    //        default:
    //            break;
    //    }
}
#pragma mark - 检查日历权限
- (void)checkAuthCalendars:(BOOL)isPushSetting{
    
    __weak typeof(self) weakSelf = self;
    EKEntityType type  = EKEntityTypeEvent;
    EKAuthorizationStatus authStatus = [EKEventStore authorizationStatusForEntityType:type];
    switch (authStatus) {
        case EKAuthorizationStatusNotDetermined:
        {   //第一次进来
            EKEventStore *eventStore = [[EKEventStore alloc] init];
            [eventStore requestAccessToEntityType:type completion:^(BOOL granted, NSError * _Nullable error) {
                if (granted == YES) {
                    weakSelf.statusBlock(YES, GHAuthStatusAuthorized);
                }else{
                    weakSelf.statusBlock(NO, GHAuthStatusDenied);
                    [self pushSetting:isPushSetting]; //拒绝时跳转或提示
                }
            }];
            
        }
            break;
        case EKAuthorizationStatusRestricted:
        {   //未授权，家长限制
            weakSelf.statusBlock(NO, GHAuthStatusRestricted);
            [self pushSetting:isPushSetting]; //拒绝时跳转或提示
        }
            break;
        case EKAuthorizationStatusDenied:
        {   //拒绝
            weakSelf.statusBlock(NO, GHAuthStatusDenied);
            [self pushSetting:isPushSetting]; //拒绝时跳转或提示
        }
            break;
        case EKAuthorizationStatusAuthorized:
        {   //已授权
            weakSelf.statusBlock(YES, GHAuthStatusAuthorized);
        }
            break;
        default:
            break;
    }
}
#pragma mark - 提醒事项权限
- (void)checkAuthReminders:(BOOL)isPushSetting{
    
    __weak typeof(self) weakSelf = self;
    EKEntityType type  = EKEntityTypeReminder;
    EKAuthorizationStatus authStatus = [EKEventStore authorizationStatusForEntityType:type];
    switch (authStatus) {
        case EKAuthorizationStatusNotDetermined:
        {   //第一次进来
            EKEventStore *eventStore = [[EKEventStore alloc] init];
            [eventStore requestAccessToEntityType:type completion:^(BOOL granted, NSError * _Nullable error) {
                if (granted == YES) {
                    weakSelf.statusBlock(YES, GHAuthStatusAuthorized);
                }else{
                    weakSelf.statusBlock(NO, GHAuthStatusDenied);
                    [self pushSetting:isPushSetting]; //拒绝时跳转或提示
                }
            }];
            
        }
            break;
        case EKAuthorizationStatusRestricted:
        {   //未授权，家长限制
            weakSelf.statusBlock(NO, GHAuthStatusRestricted);
            [self pushSetting:isPushSetting]; //拒绝时跳转或提示
        }
            break;
        case EKAuthorizationStatusDenied:
        {   //拒绝
            weakSelf.statusBlock(NO, GHAuthStatusDenied);
            [self pushSetting:isPushSetting]; //拒绝时跳转或提示
        }
            break;
        case EKAuthorizationStatusAuthorized:
        {   //已授权
            weakSelf.statusBlock(YES, GHAuthStatusAuthorized);
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - 检查蓝牙权限
#pragma mark - 检查和请求定位权限
- (void)checkLocationAuthWithisPushSetting:(BOOL)isPushSetting
                                withHandle:(GHPrivacyAuthToolLocationAuthStatusBlock)locationAuthStatusBlock{
    
    self.locationAuthStatusBlock = locationAuthStatusBlock;
    __weak typeof(self) weakSelf = self;
    
    BOOL isLocationServicesEnabled = [CLLocationManager locationServicesEnabled];
    if (!isLocationServicesEnabled) {
        NSLog(@"定位服务不可用，例如定位没有打开...");
        weakSelf.locationAuthStatusBlock(GHLocationAuthStatusNotSupport);
    }else{
        CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
        switch (authStatus) {
            case kCLAuthorizationStatusNotDetermined:
            {   //第一次进来
                
                self.locationManager = [[CLLocationManager alloc] init];
                self.locationManager.delegate = self;
                
                // 两种定位模式：
                [self.locationManager requestAlwaysAuthorization];
                [self.locationManager requestWhenInUseAuthorization];
                
                [self setKCLCallBackBlock:^(CLAuthorizationStatus state){
                    if (authStatus == kCLAuthorizationStatusNotDetermined) {
                        weakSelf.locationAuthStatusBlock(GHLocationAuthStatusNotDetermined);
                    }else if (authStatus == kCLAuthorizationStatusRestricted) {
                        //未授权，家长限制
                        weakSelf.locationAuthStatusBlock(GHLocationAuthStatusRestricted);
                        [weakSelf pushSetting:isPushSetting]; //拒绝时跳转或提示
                        
                    }else if (authStatus == kCLAuthorizationStatusDenied) {
                        //拒绝
                        weakSelf.locationAuthStatusBlock(GHLocationAuthStatusDenied);
                        [weakSelf pushSetting:isPushSetting]; //拒绝时跳转或提示
                    }else if (authStatus == kCLAuthorizationStatusAuthorizedAlways) {
                        //总是
                        weakSelf.locationAuthStatusBlock(GHLocationAuthStatusAuthorizedAlways);
                    }else if (authStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
                        //使用期间
                        weakSelf.locationAuthStatusBlock(GHLocationAuthStatusAuthorizedWhenInUse);
                    }
                }];
                
            }
                break;
            case kCLAuthorizationStatusRestricted:
            {   //未授权，家长限制
                weakSelf.locationAuthStatusBlock(GHLocationAuthStatusRestricted);
                [self pushSetting:isPushSetting]; //拒绝时跳转或提示
                
            }
                break;
            case kCLAuthorizationStatusDenied:
            {   //拒绝
                [self pushSetting:isPushSetting]; //拒绝时跳转或提示
                weakSelf.locationAuthStatusBlock(GHLocationAuthStatusDenied);
            }
                break;
            case kCLAuthorizationStatusAuthorizedAlways:
            {   //总是
                weakSelf.locationAuthStatusBlock(GHLocationAuthStatusAuthorizedAlways);
            }
                break;
            case kCLAuthorizationStatusAuthorizedWhenInUse:
            {   //使用期间
                weakSelf.locationAuthStatusBlock(GHLocationAuthStatusAuthorizedWhenInUse);
            }
                break;
            default:
                break;
        }
        
    }
    
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (self.kCLCallBackBlock) {
        self.kCLCallBackBlock(status);
    }
}

#pragma mark - 跳转设置
- (void)pushSetting:(BOOL)isPushSetting{
    
    if(isPushSetting ==YES){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.title.length ?self.title:@""  message:[NSString stringWithFormat:@"%@",self.message.length?self.message:@""] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url= [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if (IOS10_OR_LATER) {
                if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                    [[UIApplication sharedApplication]openURL:url options:@{}completionHandler:^(BOOL        success) {
                    }];
                }
            }else{
                if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                    [[UIApplication sharedApplication]openURL:url];
                }
            }
        }];
        [alert addAction:okAction];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[GHPrivacyAuthTool getCurrentVc] presentViewController:alert animated:YES completion:nil];
            
        });
    }else{
        
        NSLog(@" 可以添加弹框,弹框的提示信息:%@ ",@"");
    }
    
}

#pragma mark - 获取当前Vc
+ (UIViewController *)getCurrentVc {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC {
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
}

@end



