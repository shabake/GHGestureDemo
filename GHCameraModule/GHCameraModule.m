//
//  GHCameraModule.m
//  GHCameraModuleDemo
//
//  Created by mac on 2018/11/23.
//  Copyright © 2018年 GHome. All rights reserved.
//

#import "GHCameraModule.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface GHCameraModuleModel:NSObject
@property (nonatomic , strong) UIImage *image;
@end
@implementation GHCameraModuleModel
@end

@interface GHCameraModule()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureMetadataOutputObjectsDelegate,AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
/** 硬件设备 */
@property (nonatomic , strong) AVCaptureDevice *device;
/** 输入流 */
@property (nonatomic , strong) AVCaptureDeviceInput *input;
/** 协调输入输出流的数据 */
@property (nonatomic , strong) AVCaptureSession *session;
/** 输出流 */
@property (nonatomic , strong) AVCaptureStillImageOutput *stillImageOutput;  //用于捕捉静态图片
@property (nonatomic , strong) AVCaptureVideoDataOutput *videoDataOutput;    //原始视频帧，用于获取实时图像以及视频录制
@property (nonatomic , strong) AVCaptureMetadataOutput *metadataOutput;      //用于二维码识别以及人脸识别
@property (nonatomic , strong) UIImagePickerController *imagePickerController;

@property (nonatomic , copy) CameraModuleBlock cameraModuleBlock;
@property (nonatomic , copy) CameraModuleCodeBlock cameraModuleCodeBlock;

#define weakself(self)  __weak __typeof(self) weakSelf = self

@end
@implementation GHCameraModule

- (void)setRectOfInterest:(CGRect)rectOfInterest {
    _rectOfInterest = rectOfInterest;
    self.metadataOutput.rectOfInterest = rectOfInterest;
}

- (instancetype)creatCameraModuleWithCameraModuleBlock: (CameraModuleBlock)cameraModuleBlock
                                 cameraModuleCodeBlock: (CameraModuleCodeBlock)cameraModuleCodeBlock {

    if (self == [super init]) {
        self.cameraModuleBlock = cameraModuleBlock;
        self.cameraModuleCodeBlock = cameraModuleCodeBlock;
    }
    return self;
}

- (void)chosePhoto {
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self.imagePickerController animated:YES completion:^{
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
        [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - 选取相册回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    weakself(self);
    [picker dismissViewControllerAnimated:YES completion:^{
        if (weakSelf.cameraModuleBlock) {
            weakSelf.cameraModuleBlock(info);
        }
        if (weakSelf.delegate && [weakSelf respondsToSelector:@selector(cameraModule:info:resultString:)]) {
            
            [weakSelf.delegate cameraModule:weakSelf info:info resultString:nil];
        }
    }];
}

- (void)start {
    [self stop];
    [self.session startRunning];
}

- (void)stop {
    [self.session stopRunning];
}

- (void)takePhoto {
    [self screenshot];
}

- (void)adjustFocalWtihValue: (CGFloat)value {
    
    AVCaptureConnection * videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(value, value)];
    videoConnection.videoScaleAndCropFactor = 1 + value;
}

- (void)turnTorchOn:(BOOL)on{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        if ([self.device hasTorch] && [self.device hasFlash]){
            [self.device lockForConfiguration:nil];
            if (on) {
                [self.device setTorchMode:AVCaptureTorchModeOn];
            } else {
                [self.device setTorchMode:AVCaptureTorchModeOff];
            }
            [self.device unlockForConfiguration];
        }
    }
}

#pragma mark - 二维码回调

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {

    if (metadataObjects.count > 0) {
   
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex :0];
    
        [self.session stopRunning];

        NSString *string = metadataObject.stringValue;
        if (string.length) {
            NSString *resultString = metadataObject.stringValue;
            
            if (self.cameraModuleCodeBlock) {
                self.cameraModuleCodeBlock(resultString);
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(cameraModule:info:resultString:)]) {
                [self.delegate cameraModule:self info:nil resultString:resultString];
            }
        }
    }
}

- (void)screenshot {
    AVCaptureConnection * videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        return;
    }
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];

        dict[@"image"] = imageData;
        if (self.cameraModuleBlock) {
            self.cameraModuleBlock(dict);
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(cameraModule:info:resultString:)]) {
            [self.delegate cameraModule:self info:dict resultString:nil];
        }
    }];
}
- (void)clickButton: (UIButton *)button {
    [self takePhoto];
}

#pragma mark - 摄像头和相册相关的公共类

// 判断设备是否有摄像头
- (BOOL)isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

// 前面的摄像头是否可用
- (BOOL) isFrontCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

// 后面的摄像头是否可用
- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}


// 判断是否支持某种多媒体类型：拍照，视频
- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0){
        NSLog(@"Media type is empty.");
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL*stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

// 检查摄像头是否支持录像
- (BOOL) doesCameraSupportShootingVideos{
    return [self cameraSupportsMedia:( NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypeCamera];
}

// 检查摄像头是否支持拍照
- (BOOL) doesCameraSupportTakingPhotos{
    return [self cameraSupportsMedia:( NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

#pragma mark - 相册文件选取相关
// 相册是否可用
- (BOOL)isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary];
}

// 是否可以在相册中选择视频
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self cameraSupportsMedia:( NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

// 是否可以在相册中选择视频
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self cameraSupportsMedia:( NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (AVCaptureDevice *)device{
    if (_device == nil) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([_device lockForConfiguration:nil]) {
            //自动闪光灯
            if ([_device isFlashModeSupported:AVCaptureFlashModeAuto]) {
                [_device setFlashMode:AVCaptureFlashModeAuto];
            }
            //自动白平衡
            if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
                [_device setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
            }
            //自动对焦
            if ([_device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
                [_device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            }
            //自动曝光
            if ([_device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
                [_device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
            }
            [_device unlockForConfiguration];
        }
    }
    return _device;
}

- (AVCaptureDeviceInput *)input{
    if (_input == nil) {
        _input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
    }
    return _input;
}

- (AVCaptureStillImageOutput *)stillImageOutput{
    if (_stillImageOutput == nil) {
        _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    }
    return _stillImageOutput;
}

- (AVCaptureVideoDataOutput *)videoDataOutput{
    if (_videoDataOutput == nil) {
        _videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
        [_videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
        [_videoDataOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    }
    return _videoDataOutput;
}

-( AVCaptureMetadataOutput *)metadataOutput{
    if (_metadataOutput == nil) {
        _metadataOutput = [[AVCaptureMetadataOutput alloc]init];
        [_metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        _metadataOutput.rectOfInterest = CGRectMake(0.25,0.25, 0.5, 0.5);
    }
    return _metadataOutput;
}

-(AVCaptureSession *)session{
    if (_session == nil) {
        _session = [[AVCaptureSession alloc] init];
        if ([_session canAddInput:self.input]) {
            [_session addInput:self.input];
        }
        if ([_session canAddOutput:self.stillImageOutput]) {
            [_session addOutput:self.stillImageOutput];
        }
        if ([_session canAddOutput:self.videoDataOutput]) {
            [_session addOutput:self.videoDataOutput];
        }
        if ([_session canAddOutput:self.metadataOutput]) {
            [_session addOutput:self.metadataOutput];

            self.metadataOutput.metadataObjectTypes = @[
                                                        AVMetadataObjectTypeQRCode,
                                                        AVMetadataObjectTypeEAN13Code,
                                                        AVMetadataObjectTypeEAN8Code,
                                                        AVMetadataObjectTypeCode128Code
                                                        ];
        }
    }
    return _session;
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (_previewLayer == nil) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    }
    return _previewLayer;
}

- (UIImagePickerController *)imagePickerController {
    if (_imagePickerController == nil) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = NO;
        _imagePickerController.mediaTypes = @[( NSString *)kUTTypeImage,(NSString *)kUTTypeMovie];
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePickerController.navigationBar.translucent = NO;
    }
    return _imagePickerController;
}

@end
