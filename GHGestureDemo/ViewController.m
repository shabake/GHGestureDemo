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

@property (nonatomic , strong) GHCameraModule *cameraModule;
@property (nonatomic , strong) UIImageView *test;
@property (nonatomic , assign) CGFloat scale;
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
    
    self.scale = 0;
    
    weakself(self);
    [[GHPrivacyAuthTool share] checkPrivacyAuthWithType:GHPrivacyCamera isPushSetting:YES title:@"提示" message:@"请在设置中开启相机权限" withHandle:^(BOOL granted, GHAuthStatus status) {
        if (granted) {
            [weakSelf.cameraModule adjustFocalWtihValue:1];
            [weakSelf.cameraModule start];
        }
    }];
    
    [self.view addSubview:self.adjustFocal];
    
    UIPanGestureRecognizer *panGest = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panView:)];
    panGest.minimumNumberOfTouches = 1;
    
    [self.view addGestureRecognizer:panGest];
    UIImageView *test = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.gh_centerx, 88, 200, 200)];
    test.image = [UIImage imageNamed:@"tian"];
    test.layer.masksToBounds = YES;
    test.layer.cornerRadius = 10;
    [self.view addSubview:test];
    
    self.test = test;
    self.test.transform = CGAffineTransformMakeScale(self.scale, self.scale);
    
    UIPinchGestureRecognizer *pinchGest = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchView:)];
    [self.view addGestureRecognizer:pinchGest];
    
    CGFloat totalHeight = [self.adjustFocal getSliderHeight]; /// 滑动总长度
    
    CGFloat scale = (totalHeight - [self.adjustFocal getCircleCenterY])/totalHeight;
    
    self.navigationItem.title = [NSString stringWithFormat:@"比例%.2f",scale];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterFore) name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];
}

- (void)enterFore{
    
    self.adjustFocal.circleCenterY = [self.adjustFocal getSliderHeight];
    
    CGFloat totalHeight = [self.adjustFocal getSliderHeight]; /// 滑动总长度
    
    CGFloat scale = (totalHeight - [self.adjustFocal getCircleCenterY])/totalHeight;
    
    self.navigationItem.title = [NSString stringWithFormat:@"比例%.2f",scale];
    self.test.transform = CGAffineTransformMakeScale(scale, scale);
    
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
    
    CGFloat totalHeight = [self.adjustFocal getSliderHeight]; /// 滑动总长度
    
    CGFloat circleCenterY = (1 - currentScale) * totalHeight;
    
    if (circleCenterY <= 0) {
        circleCenterY = 0; /// 处理顶部
    }
    
    if (circleCenterY >= self.adjustFocal.gh_height - 40) {
        circleCenterY = self.adjustFocal.gh_height - 40;
    }
    
    self.adjustFocal.circleCenterY = circleCenterY;
    
    self.test.transform = CGAffineTransformMakeScale(currentScale, currentScale);
    
    self.navigationItem.title = [NSString stringWithFormat:@"比例%.2f yyyy%2.f",currentScale,[self.adjustFocal getCircleCenterY]];
    
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
    
    CGFloat circleCenterY = [self.adjustFocal getCircleCenterY]; /// 获取到circleY
    
    circleCenterY += trans.y; /// circleCenterY 累加
    
    CGFloat totalHeight = [self.adjustFocal getSliderHeight]; /// 获取滑动总长度
    
    if (circleCenterY <= 0) {
        circleCenterY = 0; /// 处理顶部越界
    }
    
    if (circleCenterY >= self.adjustFocal.gh_height - 40) {
        circleCenterY = self.adjustFocal.gh_height - 40; /// 处理底部越界
    }
    
    self.adjustFocal.circleCenterY = circleCenterY; /// 设置circleCenterY
    CGFloat scale = (totalHeight - circleCenterY)/totalHeight;/// 计算比例
    self.scale = scale;
    self.test.transform = CGAffineTransformMakeScale(scale, scale);
    self.navigationItem.title = [NSString stringWithFormat:@"比例%.2f yyyy%2.f",scale,[self.adjustFocal getCircleCenterY]];
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
