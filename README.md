![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Objective--C-orange.svg) 
![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg) 
![](https://img.shields.io/appveyor/ci/gruntjs/grunt.svg)


## GHGestureDemo

[中文](https://github.com/shabake/GHGestureDemo) | [English](https://github.com/shabake/GHGestureDemo/blob/master/README-English.md)

`捏合手势和拖拽手势并存,实现调整焦距`

## 运行

**请选择**`GHGestureDemo` **运行**

![image.png](https://upload-images.jianshu.io/upload_images/1419035-ed2e6d34c6e37a47.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


**git较大且不清晰请下载demo运行到真机查看**

**如果运行崩溃请在iofo.plist中添加key `Privacy - Camera Usage Description`**

![1.gif](https://upload-images.jianshu.io/upload_images/1419035-e87501ab35e9b0d1.gif?imageMogr2/auto-orient/strip)

### 功能
```diff
+ 封装权限检查工具
+ 封装相机模块实现一行代码调用
+ 相机权限判断,app从后台激活到前台相机权限判断
+ 拖拽和捏合手势动态调整相机镜头焦距

```
### 复习拖拽手势 `UIPanGestureRecognizer `

先看api提供集成属性和方法

>`minimumNumberOfTouches` 设置最少需要几个手指拖动 
>`maximumNumberOfTouches`  设置最多支持几个手指拖动 
> `(CGPoint)translationInView:(nullable UIView *)view;` 获取当前位置  
> `(void)setTranslation:(CGPoint)translation inView:(nullable UIView *)view;`设置当前位置 
> `(void)setTranslation:(CGPoint)translation inView:(nullable UIView *)view;` 设置拖拽速度


### 复习捏合手势 `UIPinchGestureRecognizer `

>`scale` 缩放比例

>`velocity` 拖拽速度 

两种手势都可以在初始化的时候添加监听事件

```
UIPinchGestureRecognizer *pinchGest = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchView:)];
UIPanGestureRecognizer *panGest = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panView:)];
```
分别实现监听方法

```
- (void)pinchView:(UIPinchGestureRecognizer *)pinchGest{
}
- (void)panView:(UIPanGestureRecognizer *)panGest{
}
```

如果存在同时多种手势需要重写代理方法

```
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
}
```

### 依赖
`GHPrivacyAuthTool` 权限检查工具

`GHCameraModule.h` 相机整合模块

`UIView+GHAdd.h` UIView的分类

### 自定义view

自定义一个`view`命名为`GHAdjustFocal`,
里面包含五个部分分别是
`backGround`背景 `circle`圆圈 `slider `滑杆 `add `加号 `sub`减号

里面可以通过属性`circleCenterY`设置圆圈的位置
还有两个分别是获取圆圈的当前的`centerY`和滑杆的总高度

### 关键方法

`videoScaleAndCropFactor ` 调整焦距的属性,最小值是1,所以为了安全每个value再加上1

```
  AVCaptureConnection * videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];

    [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(1+value, 1+value)];
    videoConnection.videoScaleAndCropFactor = 1 + value;
    
```

我定义个一个方法讲手势操作之后获取的`value`传进来

```
- (void)adjustFocalWtihValue: (CGFloat)value 
```

### 在控制器中调用
#### 初始化
声明一个属性`zoomScale`,因为默认是最大的,所以初始化为1

```self.zoomScale = 1;```

相机的焦距也是最大的为10

```[self.cameraModule adjustFocalWtihValue:10];```

在view上添加捏合手势和拖拽手势

#### 计算
拖拽手势中
```
/// 滑动的距离
CGPoint trans = [panGest translationInView:panGest.view];
/// 获取到圆圈的中心y值
    CGFloat circleCenterY = [self.adjustFocal getCircleCenterY]; /// circleY
 /// y值自增
    circleCenterY += trans.y;
     /// 获取到滑动总距离
    CGFloat totalHeight = [self.adjustFocal getSliderHeight]; /// 滑动总长度
  	  /// 处理顶部越界
    if (circleCenterY <= 20) {
        circleCenterY = 20; /// 处理顶部
    }
     /// 处理底部越界

    if (circleCenterY >= self.adjustFocal.gh_height - 40 + 20) {
        circleCenterY = self.adjustFocal.gh_height - 40 + 20;
    }
    
    /// 刷新圆圈的y值
    self.adjustFocal.circleCenterY = circleCenterY;
    /// 计算比例
    CGFloat scale = (totalHeight - circleCenterY + 20)/totalHeight;
    self.zoomScale = scale;
    self.test.transform = CGAffineTransformMakeScale(scale, scale);
    self.value.text = [NSString stringWithFormat:@"比例%.2f",scale];
    /// 重置
    [panGest setTranslation:CGPointZero inView:panGest.view];
    /// 动态改变相机焦距
    [self.cameraModule adjustFocalWtihValue:scale * 10];
```

#### Tip

最后别忘了移除监听

```
[[NSNotificationCenter defaultCenter] removeObserver:self];

```
---


## 其他相关知识点
###  Gesture Recognizer 手势识别功能
> 推出于iOS 3.2

#### 初始化方法

```
/// 初始化
- (instancetype)initWithTarget:(nullable id)target action:(nullable SEL)action
```
```
/// 添加监听
- (void)addTarget:(id)target action:(SEL)action;
```
```
/// 移除监听
- (void)removeTarget:(nullable id)target action:(nullable SEL)action;
```
#### state

```
typedef NS_ENUM(NSInteger, UIGestureRecognizerState) {
    UIGestureRecognizerStatePossible,   // 默认的状态，这个时候的手势并没有具体的情形状态
    UIGestureRecognizerStateBegan,      // 手势开始被识别的状态
    UIGestureRecognizerStateChanged,    // 手势识别发生改变的状态
    UIGestureRecognizerStateEnded,      // 手势识别结束，将会执行触发的方法
    UIGestureRecognizerStateCancelled,  // 手势识别取消
    UIGestureRecognizerStateFailed,     // 识别失败，方法将不会被调用
    UIGestureRecognizerStateRecognized = UIGestureRecognizerStateEnded 
};
```
#### 属性
`delegate ` 手势代理

`enabled ` 设置手势是否有效
 
 `view ` 获取手势所在的View

`cancelsTouchesInView` 默认是YES。当识别到手势的时候，终止touchesCancelled:withEvent:或pressesCancelled:withEvent:发送的所有触摸事件。

`delaysTouchesBegan` 默认为NO ,在触摸开始的时候，就会发消息给事件传递链，如果设置为YES，在触摸没有被识别失败前，都不会给事件传递链发送消息

`delaysTouchesEnded ` 默认为YES 。这个属性设置手势识别结束后，是立刻发送touchesEnded或pressesEnded消息到事件传递链或者等待一个很短的时间后，如果没有接收到新的手势识别任务，再发送

`allowedTouchTypes `
     
`allowedPressTypes `

#### 方法

```
[A requireGestureRecognizerToFail：B]手势互斥 它可以指定当A手势发生时，即便A已经滿足条件了，也不会立刻触发，会等到指定的手势B确定失败之后才触发。
- (void)requireGestureRecognizerToFail:(UIGestureRecognizer *)otherGestureRecognizer;
```
```
//获取当前触摸的点
- (CGPoint)locationInView:(nullable UIView*)view;
```

```
//设置触摸点数
- (NSUInteger)numberOfTouches;
```
```
//获取某一个触摸点的触摸位置
- (CGPoint)locationOfTouch:(NSUInteger)touchIndex inView:(nullable UIView*)view; 
```


### 如果对你有帮助请点帮我一个✨,小弟感激不尽

---