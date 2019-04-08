//
//  GHGestureCropImagViewController.m
//  GHGestureCropImageDemo
//
//  Created by zhaozhiwei on 2019/4/8.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import "GHGestureCropImagViewController.h"
#import "UIView+Extension.h"
#import "ZZImageEditTool.h"
#import "ClipViewController.h"

@interface GHGestureCropImagViewController ()
@property (nonatomic , strong) UIView *test;

@end

@implementation GHGestureCropImagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.test];
    
    UIPanGestureRecognizer *panGest = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panView:)];
    panGest.minimumNumberOfTouches = 1;
    
    [self.test addGestureRecognizer:panGest];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    ClipViewController *vc = [[ClipViewController alloc]init];
    vc.image = [UIImage imageNamed:@"tian"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)panView:(UIPanGestureRecognizer *)panGest{
    
//    [self.cameraModuleView showAdjustFocal];
    CGPoint trans = [panGest translationInView:panGest.view];
//
//
    self.test.x += trans.x; /// circleCenterY 累加

    self.test.y += trans.y; /// circleCenterY 累加

    [panGest setTranslation:CGPointZero inView:panGest.view];
}

- (UIView *)test {
    if (_test == nil) {
        _test = [[UIView alloc]init];
        _test.frame = CGRectMake(100, 88, 100, 100);
        _test.backgroundColor = [UIColor redColor];
    }
    return _test;
}

@end
