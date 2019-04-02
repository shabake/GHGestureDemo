//
//  ViewController.m
//  GHGestureDemo
//
//  Created by zhaozhiwei on 2019/4/1.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import "ViewController.h"
#import "UIView+GHAdd.h"
#import "GHCameraModule.h"
#import "GHAdjustFocal.h"
#import "GHPrivacyAuthTool.h"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kAutoWithSize(r) r*kScreenWidth / 375.0
#define weakself(self)          __weak __typeof(self) weakSelf = self

@interface ViewController ()

@property (nonatomic , strong) UIView *backGround;
@property (nonatomic , strong) UIView *circle;
@property (nonatomic , strong) UIView *slider;
@property (nonatomic , strong) GHCameraModule *cameraModule;
@property (nonatomic , strong) UIImageView *test;
@property (nonatomic , assign) CGFloat zoomScale;
@property (nonatomic , strong) GHAdjustFocal *adjustFocal;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (TARGET_IPHONE_SIMULATOR) {
        UILabel *tip = [[UILabel alloc]initWithFrame:self.view.bounds];
        tip.text = @"请用真机运行此demo";
        tip.font = [UIFont systemFontOfSize:30];
        tip.textAlignment = NSTextAlignmentCenter;
        tip.textColor = [UIColor redColor];
        [self.view addSubview:tip];
        return;
    }
    
    self.zoomScale = 1;
    
    weakself(self);
    [[GHPrivacyAuthTool share] checkPrivacyAuthWithType:GHPrivacyCamera isPushSetting:YES title:@"提示" message:@"请在设置中开启相机权限" withHandle:^(BOOL granted, GHAuthStatus status) {
        if (granted) {
            [weakSelf.cameraModule adjustFocalWtihValue:10];
            [weakSelf.cameraModule start];
        }
    }];
 
    [self.view addSubview:self.adjustFocal];

    UIPanGestureRecognizer *panGest = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panView:)];
    panGest.minimumNumberOfTouches = 1;

    [self.view addGestureRecognizer:panGest];
    UIImageView *test = [[UIImageView alloc]initWithFrame:CGRectMake(300, 100, 100, 100)];
    test.image = [UIImage imageNamed:@"tian"];
    [self.view addSubview:test];
    self.test = test;
    self.test.transform = CGAffineTransformMakeScale(self.zoomScale, self.zoomScale);

    UIPinchGestureRecognizer *pinchGest = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchView:)];
    [self.view addGestureRecognizer:pinchGest];

    CGFloat totalHeight = [self.adjustFocal getSliderHeight]; /// 滑动总长度

    CGFloat scale = (totalHeight - [self.adjustFocal getCircleCenterY] + 20)/totalHeight;

    self.navigationItem.title = [NSString stringWithFormat:@"比例%.2f",scale];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterFore) name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];
}

- (void)enterFore{
    
    self.adjustFocal.circleCenterY = 20;

    CGFloat totalHeight = [self.adjustFocal getSliderHeight]; /// 滑动总长度
    
    CGFloat scale = (totalHeight - [self.adjustFocal getCircleCenterY] + 20)/totalHeight;
    
    self.navigationItem.title = [NSString stringWithFormat:@"比例%.2f",scale];
    self.test.transform = CGAffineTransformMakeScale(1, 1);
    
    weakself(self);
    [[GHPrivacyAuthTool share] checkPrivacyAuthWithType:GHPrivacyCamera isPushSetting:YES title:@"提示" message:@"请在设置中开启相机权限" withHandle:^(BOOL granted, GHAuthStatus status) {
        if (granted) {
            weakSelf.zoomScale = 1;
            [weakSelf.cameraModule adjustFocalWtihValue:10];
            [weakSelf.cameraModule start];
        }
    }];
}

#pragma mark - 捏合手势

- (void)pinchView:(UIPinchGestureRecognizer *)pinchGest{
    
    CGFloat currentScale = self.zoomScale + pinchGest.scale - 1.00f;
    
    if (currentScale > 1) {
        currentScale = 1;
    }
    
    if (currentScale < 0) {
        currentScale = 0;
    }
    
    CGFloat totalHeight = [self.adjustFocal getSliderHeight] + 20; /// 滑动总长度

    CGFloat height = (1 - currentScale) * totalHeight;

    if (height <= 20) {
        height = 20; /// 处理顶部
    }
    
    if (height >= self.adjustFocal.gh_height - 40 + 20) {
        height = self.adjustFocal.gh_height - 40 + 20;
    }
    
    self.adjustFocal.circleCenterY = height + 10;
    
    self.test.transform = CGAffineTransformMakeScale(currentScale, currentScale);
    
   self.navigationItem.title = [NSString stringWithFormat:@"比例%.2f",currentScale];

    [self.cameraModule adjustFocalWtihValue:currentScale * 10];
    
    if (pinchGest.state == UIGestureRecognizerStateEnded
        ||
        pinchGest.state == UIGestureRecognizerStateCancelled) {
        self.zoomScale = currentScale;
    }
}

#pragma mark - 拖拽手势
- (void)panView:(UIPanGestureRecognizer *)panGest{
    
    CGPoint trans = [panGest translationInView:panGest.view];

    CGFloat circleCenterY = [self.adjustFocal getCircleCenterY]; /// circleY
    
    circleCenterY += trans.y;
    
    CGFloat totalHeight = [self.adjustFocal getSliderHeight]; /// 滑动总长度
  
    if (circleCenterY <= 20) {
        circleCenterY = 20; /// 处理顶部
    }
    
    if (circleCenterY >= self.adjustFocal.gh_height - 40 + 20) {
        circleCenterY = self.adjustFocal.gh_height - 40 + 20;
    }
    
    self.adjustFocal.circleCenterY = circleCenterY;
    CGFloat scale = (totalHeight - circleCenterY + 20)/totalHeight;
    self.zoomScale = scale;
    self.test.transform = CGAffineTransformMakeScale(scale, scale);
    self.navigationItem.title = [NSString stringWithFormat:@"比例%.2f",scale];
    [panGest setTranslation:CGPointZero inView:panGest.view];
    [self.cameraModule adjustFocalWtihValue:scale * 10];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (GHAdjustFocal *)adjustFocal {
    if (_adjustFocal == nil) {
        _adjustFocal = [[GHAdjustFocal alloc]initWithFrame:CGRectMake(30, 88, 20,  200)];
    }
    return _adjustFocal;
}

@end
