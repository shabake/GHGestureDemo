//
//  GHCameraModuleViewController.m
//  GHCameraModuleDemo
//
//  Created by mac on 2018/11/27.
//  Copyright © 2018年 GHome. All rights reserved.
//

#import "GHCameraModuleViewController.h"
#import "GHCameraModule.h"
#import "GHScanView.h"
#import "GHCameraModuleView.h"
#import "GHPrivacyAuthTool.h"

@interface GHCameraModuleViewController ()<GHCameraModuleViewDelegate,GHCameraModuleDelegate>
/** 摄像头模块 */
@property (nonatomic , strong) GHCameraModule *cameraModule;
/** 扫描ui */
@property (nonatomic , strong) GHScanView *scanView;

@property (nonatomic , strong) GHCameraModuleView *cameraModuleView;

@property (nonatomic , assign) CGFloat scale;

@end

@implementation GHCameraModuleViewController

#define weakself(self)  __weak __typeof(self) weakSelf = self
+ (instancetype)creatCameraModuleVcWithType : (GHCameraModuleViewButtonType)type;{
    GHCameraModuleViewController *vc = [[GHCameraModuleViewController alloc]init];
    vc.cameraModuleViewButtonType = type;
    return vc;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];

    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    if (self.cameraModuleViewButtonType == GHCameraModuleViewButtonTypeScan) {
        self.scanView.hidden = NO;
        self.navigationItem.title = @"扫一扫";
        [self.scanView startAnimation];
    } else if (self.cameraModuleViewButtonType == GHCameraModuleViewButtonTypeTakephotos) {
         self.navigationItem.title = @"拍照";
        self.scanView.hidden = YES;
        [self.scanView endAnimation];
    }
    [self.cameraModuleView moveWithType:self.cameraModuleViewButtonType];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
  
    weakself(self);    
    self.scale = 0;
    [[GHPrivacyAuthTool share] checkPrivacyAuthWithType:GHPrivacyCamera isPushSetting:YES title:@"提示" message:@"请在设置中开启相机权限" withHandle:^(BOOL granted, GHAuthStatus status) {
        if (granted) {
            [weakSelf.cameraModule adjustFocalWtihValue:1];
            [weakSelf.cameraModule start];
        }
    }];
    [self.view addSubview:self.cameraModuleView];


    UIPanGestureRecognizer *panGest = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panView:)];
    panGest.minimumNumberOfTouches = 1;

    [self.view addGestureRecognizer:panGest];

    UIPinchGestureRecognizer *pinchGest = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchView:)];
    [self.view addGestureRecognizer:pinchGest];

    CGFloat totalHeight = [self.cameraModuleView getSliderHeight]; /// 滑动总长度

    CGFloat scale = (totalHeight - [self.cameraModuleView getCircleCenterY])/totalHeight;

    self.navigationItem.title = [NSString stringWithFormat:@"比例%.2f",scale];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterFore) name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];
    
}

- (void)enterFore{

    self.cameraModuleView.circleCenterY = [self.cameraModuleView getSliderHeight];

    CGFloat totalHeight = [self.cameraModuleView getSliderHeight]; /// 滑动总长度

    CGFloat scale = (totalHeight - [self.cameraModuleView getCircleCenterY])/totalHeight;

    self.navigationItem.title = [NSString stringWithFormat:@"比例%.2f",scale];

    weakself(self);
    [[GHPrivacyAuthTool share] checkPrivacyAuthWithType:GHPrivacyCamera isPushSetting:YES title:@"提示" message:@"请在设置中开启相机权限" withHandle:^(BOOL granted, GHAuthStatus status) {
        if (granted) {
            weakSelf.scale = 0;
            [weakSelf.cameraModule adjustFocalWtihValue:1];
            [weakSelf.cameraModule start];
        }
    }];
}

#pragma mark - 捏合手势
- (void)pinchView:(UIPinchGestureRecognizer *)pinchGest{

    CGFloat currentScale = self.scale + pinchGest.scale - 1.00f;

    if (currentScale > 1) {
        currentScale = 1;
    }

    if (currentScale < 0) {
        currentScale = 0;
    }

    CGFloat totalHeight = [self.cameraModuleView getSliderHeight]; /// 滑动总长度

    CGFloat circleCenterY = (1 - currentScale) * totalHeight;

    circleCenterY = [self.cameraModuleView actionCircleCenterY:circleCenterY];

    self.cameraModuleView.circleCenterY = circleCenterY;

    self.navigationItem.title = [NSString stringWithFormat:@"比例%.2f yyyy%2.f",currentScale,[self.cameraModuleView getCircleCenterY]];

    [self.cameraModule adjustFocalWtihValue:currentScale * 10];

    if (pinchGest.state == UIGestureRecognizerStateEnded
        ||
        pinchGest.state == UIGestureRecognizerStateCancelled) {
        self.scale = currentScale;
    }
}

#pragma mark - 拖拽手势
- (void)panView:(UIPanGestureRecognizer *)panGest{

    CGPoint trans = [panGest translationInView:panGest.view];

    CGFloat circleCenterY = [self.cameraModuleView getCircleCenterY]; /// 获取到circleY

    circleCenterY += trans.y; /// circleCenterY 累加

    CGFloat totalHeight = [self.cameraModuleView getSliderHeight]; /// 获取滑动总长度

    circleCenterY = [self.cameraModuleView actionCircleCenterY:circleCenterY];

    self.cameraModuleView.circleCenterY = circleCenterY; /// 设置circleCenterY
    CGFloat scale = (totalHeight - circleCenterY)/totalHeight;/// 计算比例
    self.scale = scale;
    self.navigationItem.title = [NSString stringWithFormat:@"比例%.2f yyyy%2.f",scale,[self.cameraModuleView getCircleCenterY]];
    [panGest setTranslation:CGPointZero inView:panGest.view];
    [self.cameraModule adjustFocalWtihValue:scale * 10];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{

    return YES;
}

#pragma mark - 懒加载

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)clickButton: (UIButton *)button {
    [self.cameraModule stop];
    [self.cameraModuleView removeFromSuperview];
    for (CALayer *layer in self.view.layer.sublayers) {
        if ([layer isKindOfClass:[AVCaptureVideoPreviewLayer class]]) {
            [layer removeFromSuperlayer];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cameraModuleView:(GHCameraModuleView *)cameraModuleView button:(UIButton *)button {
    if (button.tag == GHCameraModuleViewButtonTypePhoto) {
        [self.cameraModule chosePhoto];
    } else if (button.tag == GHCameraModuleViewButtonTypeCamera) {
        [self.cameraModule screenshot];
    } else if (button.tag == GHCameraModuleViewButtonTypeFlashlight) {
        [self.cameraModule turnTorchOn:button.selected];
    } else if (button.tag == GHCameraModuleViewButtonTypeScan) {
        self.scanView.hidden = NO;
        self.navigationItem.title = @"扫一扫";
        [self.scanView startAnimation];
    } else if (button.tag == GHCameraModuleViewButtonTypeTakephotos) {
        self.scanView.hidden = YES;
        self.navigationItem.title= @"拍照";
        [self.scanView endAnimation];
    }
    [self.cameraModuleView moveWithType:button.tag];
}

- (void)cameraModule:(GHCameraModule *)cameraModule info:(NSDictionary *)info resultString:(NSString *)resultString {
 
}

#pragma mark - 懒加载
- (GHCameraModule *)cameraModule {
    if (_cameraModule == nil) {
        _cameraModule = [[GHCameraModule alloc]creatCameraModuleWithCameraModuleBlock:^(NSDictionary * _Nonnull info) {
            /** your word */
        } cameraModuleCodeBlock:^(NSString * _Nonnull resultString) {
            /** your word */
        }];
        _cameraModule.previewLayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [self.view.layer addSublayer:_cameraModule.previewLayer];
        _cameraModule.delegate = self;
    }
    return _cameraModule;
}


- (GHCameraModuleView *)cameraModuleView {
    if (_cameraModuleView == nil) {
        _cameraModuleView = [[GHCameraModuleView alloc]initWithFrame:CGRectMake(0, 64 , kScreenWidth, kScreenHeight - 64)];
        _cameraModuleView.delegate = self;
    }
    return _cameraModuleView;
}


@end
