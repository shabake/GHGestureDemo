//
//  GHGestureDraggingViewController.m
//  GHGestureDemo
//
//  Created by zhaozhiwei on 2019/4/4.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import "GHGestureDraggingViewController.h"
#import "UIView+Extension.h"
#import "GHGestureDraggingView.h"

@interface GHGestureDraggingViewController ()

@property (nonatomic , strong) GHGestureDraggingView *testView;
@end

@implementation GHGestureDraggingViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.view.backgroundColor = [UIColor orangeColor];
    
    [self.view addSubview:self.testView];
    
    UIPanGestureRecognizer *panGest = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panView:)];
    panGest.minimumNumberOfTouches = 1;
    
    [self.testView addGestureRecognizer:panGest];
}

- (void)panView:(UIPanGestureRecognizer *)panGest {
    
    CGPoint trans = [panGest translationInView:panGest.view];
    
    self.testView.y += trans.y;
    self.testView.height -= trans.y;
  
    [panGest setTranslation:CGPointZero inView:panGest.view];
    
    CGPoint velocity = [panGest velocityInView:panGest.view];

    if (panGest.state == UIGestureRecognizerStateEnded ||
        panGest.state == UIGestureRecognizerStateCancelled) {
        
        if (velocity.y < 0) {
            [UIView animateWithDuration:0.25 animations:^{
                self.testView.y = kSafeAreaTopHeight;
                self.testView.height = kScreenHeight - kSafeAreaTopHeight;
            } completion:^(BOOL finished) {

            }];
        }else {
            [UIView animateWithDuration:0.25 animations:^{
                self.testView.y = kScreenHeight - 155;
            } completion:^(BOOL finished) {
            }];
        }
    }
}

- (GHGestureDraggingView *)testView {
    if (_testView == nil) {
        _testView = [[GHGestureDraggingView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 155, kScreenWidth, kScreenHeight - 155)];
    }
    return _testView;
}


@end
