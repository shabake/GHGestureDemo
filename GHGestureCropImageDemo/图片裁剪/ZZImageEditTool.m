//
//  ZZImageEditTool.m
//  YouAiXue
//
//  Created by root on 2018/11/9.
//  Copyright © 2018年 凉凉. All rights reserved.
//

#import "ZZImageEditTool.h"
#import "ZZCutGridLayer.h"
#import "ZZCutCircle.h"
#import "UIView+Extension.h"

static const NSUInteger kLeftTopCircleView = 0;
static const NSUInteger kLeftBottomCircleView = 1;
static const NSUInteger kRightTopCircleView = 2;
static const NSUInteger kRightBottomCircleView = 3;

@interface ZZImageEditTool ()

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, assign) CGRect clippingRect;

/**
 * 比例
 */
@property (nonatomic, assign) CGFloat selectClipRatio;
@end

@implementation ZZImageEditTool {
    ZZCutGridLayer *_gridLayer;
    //4个角
    ZZCutCircle *_ltView;
    ZZCutCircle *_lbView;
    ZZCutCircle *_rtView;
    ZZCutCircle *_rbView;
}

-(instancetype)initWithFrame:(CGRect)frame withImg:(UIImage *)image andSelectClipRatio:(CGFloat)selectClipRatio
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = image;
        [self initUI];
        self.selectClipRatio = selectClipRatio;
    }
    return self;
}

-(void)initUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.image = self.image;
    [self addSubview:self.imageView];
    [self setImageViewFrame];
    /// 拖动裁剪区域
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGridView:)];
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:panGesture];
    /// 保存
    UIView *bottomView = [[UIView alloc] init];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@87);
    }];
    
 
    
    /// 图片裁剪
    _gridLayer = [[ZZCutGridLayer alloc] init];
    _gridLayer.frame = self.imageView.bounds;
    _gridLayer.bgColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
    _gridLayer.gridColor = [UIColor whiteColor];
    [self.imageView.layer addSublayer:_gridLayer];
//
    _ltView = [self clippingCircleWithTag:kLeftTopCircleView];
    _lbView = [self clippingCircleWithTag:kLeftBottomCircleView];
    _rtView = [self clippingCircleWithTag:kRightTopCircleView];
    _rbView = [self clippingCircleWithTag:kRightBottomCircleView];
}

/// 设置 ImageViewFrame
- (void)setImageViewFrame
{
    CGFloat maxH = kScreenHeight - 87 - 20;
    CGFloat imgW = self.image.size.width;
    CGFloat imgH = self.image.size.height;
    CGFloat w = kScreenWidth - 20;
    CGFloat h = w * imgH / imgW;
    if (h > maxH) {
        h = maxH;
        w = h * imgW / imgH;
    }
    
    CGRect frame = CGRectMake((kScreenWidth - w) * 0.5, (maxH - h) * 0.5 + 10, w, h);
    self.imageView.frame = frame;
}

-(void)setSelectClipRatio:(CGFloat)selectClipRatio
{
    _selectClipRatio = selectClipRatio;
    CGRect rect = _imageView.bounds;
    if (self.selectClipRatio != 0) {
        CGFloat H = rect.size.width * self.selectClipRatio;
        if (H <= rect.size.height) {
            rect.size.height = H;
        } else {
            rect.size.width *= rect.size.height / H;
        }
        
        rect.origin.x = (_imageView.bounds.size.width - rect.size.width) / 2;
        rect.origin.y = (_imageView.bounds.size.height - rect.size.height) / 2;
    }
    self.clippingRect = rect;
}

// 4个角的拖动圆球
- (ZZCutCircle *)clippingCircleWithTag:(NSInteger)tag
{
    ZZCutCircle *view = [[ZZCutCircle alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
   
    view.tag = tag;
    view.test.tag = tag;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panCircleView:)];
    [view.test addGestureRecognizer:panGesture];
    
    [self addSubview:view];
    
    return view;
}

/// 设置裁剪区域
- (void)setClippingRect:(CGRect)clippingRect
{
    _clippingRect = clippingRect;
    _ltView.center = [self convertPoint:CGPointMake(clippingRect.origin.x, clippingRect.origin.y) fromView:_imageView];
    _lbView.center = [self convertPoint:CGPointMake(clippingRect.origin.x, clippingRect.origin.y+clippingRect.size.height) fromView:_imageView];
    _rtView.center = [self convertPoint:CGPointMake(clippingRect.origin.x+clippingRect.size.width, clippingRect.origin.y) fromView:_imageView];
    _rbView.center = [self convertPoint:CGPointMake(clippingRect.origin.x+clippingRect.size.width, clippingRect.origin.y+clippingRect.size.height) fromView:_imageView];
    
    _gridLayer.clippingRect = clippingRect;
    [self setNeedsDisplay];
}

- (void)setNeedsDisplay
{
    [super setNeedsDisplay];
    [_gridLayer setNeedsDisplay];
}


#pragma mark - 拖动
// 拖动4个角
- (void)panCircleView:(UIPanGestureRecognizer*)sender
{
    CGPoint point = [sender locationInView:_imageView];
    
    CGRect rct = self.clippingRect;
    
    const CGFloat W = _imageView.frame.size.width;
    const CGFloat H = _imageView.frame.size.height;
    CGFloat minX = 0;
    CGFloat minY = 0;
    CGFloat maxX = W;
    CGFloat maxY = H;
    
    CGFloat ratio = (sender.view.tag == 1 || sender.view.tag == 2) ? -self.selectClipRatio : self.selectClipRatio;
    
    switch (sender.view.tag) {
        case 0: // upper left
        {
            maxX = MAX((rct.origin.x + rct.size.width)  - 0.1 * W, 0.1 * W);
            maxY = MAX((rct.origin.y + rct.size.height) - 0.1 * H, 0.1 * H);
            
 
            point.x = MAX(minX, MIN(point.x, maxX));
            point.y = MAX(minY, MIN(point.y, maxY));
        
            
            rct.size.width  = rct.size.width  - (point.x - rct.origin.x);
            rct.size.height = rct.size.height - (point.y - rct.origin.y);
            rct.origin.x = point.x;
            rct.origin.y = point.y;
            break;
        }
        case 1: // lower left
        {
            maxX = MAX((rct.origin.x + rct.size.width)  - 0.1 * W, 0.1 * W);
            minY = MAX(rct.origin.y + 0.1 * H, 0.1 * H);
            
      
            point.x = MAX(minX, MIN(point.x, maxX));
            point.y = MAX(minY, MIN(point.y, maxY));
            
            rct.size.width  = rct.size.width  - (point.x - rct.origin.x);
            rct.size.height = point.y - rct.origin.y;
            rct.origin.x = point.x;
            break;
        }
        case 2: // upper right
        {
            minX = MAX(rct.origin.x + 0.1 * W, 0.1 * W);
            maxY = MAX((rct.origin.y + rct.size.height) - 0.1 * H, 0.1 * H);
            
     
            point.x = MAX(minX, MIN(point.x, maxX));
            point.y = MAX(minY, MIN(point.y, maxY));
            
            
            rct.size.width  = point.x - rct.origin.x;
            rct.size.height = rct.size.height - (point.y - rct.origin.y);
            rct.origin.y = point.y;
            break;
        }
        case 3: // lower right
        {
            minX = MAX(rct.origin.x + 0.1 * W, 0.1 * W);
            minY = MAX(rct.origin.y + 0.1 * H, 0.1 * H);
            

            point.x = MAX(minX, MIN(point.x, maxX));
            point.y = MAX(minY, MIN(point.y, maxY));
        
            
            rct.size.width  = point.x - rct.origin.x;
            rct.size.height = point.y - rct.origin.y;
            break;
        }
        default:
            break;
    }
    self.clippingRect = rct;
}

//移动裁剪view
- (void)panGridView:(UIPanGestureRecognizer*)sender
{
    static BOOL dragging = NO;
    static CGRect initialRect;
    
    if (sender.state==UIGestureRecognizerStateBegan) {
        CGPoint point = [sender locationInView:_imageView];
        dragging = CGRectContainsPoint(_clippingRect, point);
        initialRect = self.clippingRect;
    } else if(dragging) {
        CGPoint point = [sender translationInView:_imageView];
        CGFloat left  = MIN(MAX(initialRect.origin.x + point.x, 0), _imageView.frame.size.width-initialRect.size.width);
        CGFloat top   = MIN(MAX(initialRect.origin.y + point.y, 0), _imageView.frame.size.height-initialRect.size.height);
        
        CGRect rct = self.clippingRect;
        rct.origin.x = left;
        rct.origin.y = top;
        self.clippingRect = rct;
    }
}


/// 裁剪
-(void)executeCutCompletion
{
    CGFloat zoomScale = self.imageView.width / self.imageView.image.size.width;
    CGRect rct = _gridLayer.clippingRect;
    rct.size.width  /= zoomScale;
    rct.size.height /= zoomScale;
    rct.origin.x    /= zoomScale;
    rct.origin.y    /= zoomScale;
    CGPoint origin = CGPointMake(-rct.origin.x, -rct.origin.y);
    UIGraphicsBeginImageContextWithOptions(rct.size, NO, self.imageView.image.scale);
    [self.imageView.image drawAtPoint:origin];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    !self.finishBlock ? : self.finishBlock(img);
}

/// 保存
-(void)save
{
    [self executeCutCompletion];
    [self removeFromSuperview];
}

/// 关闭
-(void)close
{
    !self.cancelBlock ? : self.cancelBlock();
    [self removeFromSuperview];
}

+(instancetype)showViewWithImg:(UIImage *)image andSelectClipRatio:(CGFloat)selectClipRatio 
{
    UIView *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    ZZImageEditTool *view = [[ZZImageEditTool alloc] initWithFrame:keyWindow.bounds withImg:image andSelectClipRatio:selectClipRatio];
    [keyWindow addSubview:view];

    return view;
}

@end
