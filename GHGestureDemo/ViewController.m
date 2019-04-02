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
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kAutoWithSize(r) r*kScreenWidth / 375.0
#define ColorRGBA(r, g, b, a) ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)])

@interface ViewController ()

@property (nonatomic , strong) UIView *backGround;
@property (nonatomic , strong) UIView *circle;
@property (nonatomic , strong) UILabel *value;
@property (nonatomic , strong) UIView *slider;
@property (nonatomic , strong) GHCameraModule *cameraModule;
@property (nonatomic , strong) UIView *test;
@property (nonatomic, assign) CGFloat zoomScale;

#define kSliderHeight 460
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.zoomScale = 0.0;

    [self.cameraModule start];
    UIView *backGround = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 30, 500)];
    backGround.backgroundColor = ColorRGBA(0, 0, 0, 102.0/255);

    backGround.layer.masksToBounds = YES;
    backGround.layer.cornerRadius = 15;
    backGround.alpha = 0.3;
    [self.view addSubview:backGround];
    
    self.backGround = backGround;
    
    UIView *slider = [[UIView alloc]initWithFrame:CGRectMake(10, 20, 10, 460 -46)];
    slider.backgroundColor = [UIColor lightGrayColor];
    slider.layer.masksToBounds = YES;
    slider.layer.cornerRadius = 5;
    [backGround addSubview:slider];
    self.slider = slider;

    UIView *circle = [[UIView alloc]initWithFrame:CGRectMake(5,20, 20, 20)];
    circle.backgroundColor = [UIColor yellowColor];
    circle.layer.masksToBounds = YES;
    circle.layer.cornerRadius = 10;
    [backGround addSubview:circle];
    self.circle = circle;

    UIPanGestureRecognizer *panGest = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panView:)];
    panGest.minimumNumberOfTouches = 1;

    [self.view addGestureRecognizer:panGest];

    UIView *test = [[UIView alloc]initWithFrame:CGRectMake(300, 100, 100, 100)];
    test.backgroundColor = [UIColor redColor];
    [self.view addSubview:test];
    self.test = test;
    self.test.transform = CGAffineTransformMakeScale(self.zoomScale, self.zoomScale);

    UIPinchGestureRecognizer *pinchGest = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchView:)];
    [self.view addGestureRecognizer:pinchGest];

    UILabel *value = [[UILabel alloc]initWithFrame:CGRectMake(200, 100, 100, 30)];
    value.textColor = [UIColor whiteColor];
    value.text = @"0.00";
    [self.view addSubview:value];
    self.value = value;
    
}

#pragma mark - 捏合手势
- (void)pinchView:(UIPinchGestureRecognizer *)pinchGest{
    
    CGFloat currentZoomScale = self.zoomScale + (pinchGest.scale - 1);
    
    if (currentZoomScale > 1) {
        currentZoomScale = 1;
    }
    if (currentZoomScale < 0) {
        currentZoomScale = 0;
    }
    
    /// 范围是1 - 5
    CGFloat height = (1 -currentZoomScale)/1 * kSliderHeight;
    
    self.circle.gh_top = height + 20;
    
    self.test.transform = CGAffineTransformMakeScale(currentZoomScale, currentZoomScale);
    self.value.text = [NSString stringWithFormat:@"%.2f",currentZoomScale];
    if (pinchGest.state == UIGestureRecognizerStateEnded || pinchGest.state == UIGestureRecognizerStateCancelled) {
        self.zoomScale = currentZoomScale;
    }
    
    [self getValueWithCircle: self.circle];
}

#pragma mark - 拖拽手势
- (void)panView:(UIPanGestureRecognizer *)panGest{
    CGPoint trans = [panGest translationInView:panGest.view];

    CGPoint center = self.circle.center;
    center.y += trans.y;
    CGFloat value = (kSliderHeight - self.circle.gh_top +10)/(kSliderHeight);


    self.zoomScale = value;
    self.test.transform = CGAffineTransformMakeScale(self.zoomScale,    self.zoomScale);
    self.value.text = [NSString stringWithFormat:@"%.2f",value];
    self.circle.center = center;
    [panGest setTranslation:CGPointZero inView:panGest.view];
    [self.cameraModule adjustFocalWtihValue:value * 10];
}

- (void)getValueWithCircle: (UIView *)circle {
    CGFloat value = (kSliderHeight - circle.gh_top +10)/(kSliderHeight);
    NSInteger o = value * 10;
    if (o > 10) o = 10;
    if (o < 0 ) o = 0;
    [self.cameraModule adjustFocalWtihValue:o];
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


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
}

@end
