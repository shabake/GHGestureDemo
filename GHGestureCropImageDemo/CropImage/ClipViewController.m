//
//  ClipViewController.m
//  Camera
//
//  Created by wzh on 2017/6/6.
//  Copyright © 2017年 wzh. All rights reserved.
//

#import "ClipViewController.h"
#import "TKImageView.h"
#define SelfWidth [UIScreen mainScreen].bounds.size.width
#define SelfHeight  [UIScreen mainScreen].bounds.size.height
@interface ClipViewController ()



@property (nonatomic, strong) TKImageView *tkImageView;

@end

@implementation ClipViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    [self createdTkImageView];
    [self createdTool];
    
}

#define ColorRGBA(r, g, b, a) ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)])

- (void)createdTkImageView
{
    _tkImageView = [[TKImageView alloc] initWithFrame:CGRectMake(20, 0, SelfWidth - 40, SelfHeight - 120)];
    [self.view addSubview:_tkImageView];
    //需要进行裁剪的图片对象
    _tkImageView.toCropImage = _image;
    //是否显示中间线
    _tkImageView.showMidLines = NO;
    //是否需要支持缩放裁剪
    _tkImageView.needScaleCrop = NO;
    //是否显示九宫格交叉线
    _tkImageView.showCrossLines = YES;
    _tkImageView.cornerBorderInImage = NO;
    _tkImageView.cropAreaCornerWidth = 44;
    _tkImageView.cropAreaCornerHeight = 44;
    _tkImageView.minSpace = 30;
    _tkImageView.cropAreaCornerLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaBorderLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaCornerLineWidth = 6;
    _tkImageView.cropAreaBorderLineWidth = 1;
    _tkImageView.cropAreaMidLineWidth = 20;
    _tkImageView.cropAreaMidLineHeight = 6;
    _tkImageView.cropAreaMidLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaCrossLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaCrossLineWidth = 0.5;
    _tkImageView.initialScaleFactor = .8f;
    _tkImageView.cropAspectRatio = 0;
    
    self.isClip = YES;
}

- (void)createdTool
{
    UIView  *editorView = [[UIView alloc] initWithFrame:CGRectMake(0, SelfHeight - 120, SelfWidth, 120)];
    editorView.backgroundColor = [UIColor blackColor];
    editorView.alpha = 0.8;
    [self.view addSubview:editorView];
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(((SelfWidth / 3.0) - 50)/2.0, (120 - 50)/2.0, 50, 50);
//    [cancleBtn setImage:[UIImage imageNamed:@"canclePhoto"] forState:UIControlStateNormal];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    [cancleBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [editorView addSubview:cancleBtn];
    
//    UIButton *clipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    clipBtn.frame = CGRectMake(((SelfWidth) - 50)/2.0, (120 - 50)/2.0, 50, 50);
//    [clipBtn setImage:[UIImage imageNamed:@"clipPhoto"] forState:UIControlStateNormal];
//    [clipBtn setImage:[UIImage imageNamed:@"backPhoto"] forState:UIControlStateSelected];
//    [clipBtn addTarget:self action:@selector(clip:) forControlEvents:UIControlEventTouchUpInside];
//    [editorView addSubview:clipBtn];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(((SelfWidth/3.0) - 50)/2.0 + (SelfWidth * 2.0/3.0), (120 - 50)/2.0, 50, 50);
//    [sureBtn setImage:[UIImage imageNamed:@"surePhoto"] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(clip:) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    
    [editorView addSubview:sureBtn];
}

- (void)back{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)clip:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    
    self.isClip = btn.selected;
    
    if (btn.selected == YES) {
        _tkImageView.toCropImage = [_tkImageView currentCroppedImage];
        
    }else{
        _tkImageView.toCropImage = _image;
    
    }
 

}

- (void)sure{
    
    //裁剪
    if (self.isClip == YES) {
        
        UIImage *image = [_tkImageView currentCroppedImage];
        
        if (self.isTakePhoto) {
            //将图片存储到相册
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(clipPhoto:)]) {
            
            [self.delegate clipPhoto:image];
        }
    }else{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(clipPhoto:)]) {
            
            [self.delegate clipPhoto:self.image];
        }
        
        if (self.isTakePhoto) {
            
            //将图片存储到相册
            UIImageWriteToSavedPhotosAlbum(self.image, self, nil, nil);
        }
    
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.picker dismissViewControllerAnimated:YES completion:nil];
    [self.controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
