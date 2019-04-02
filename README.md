![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Objective--C-orange.svg) 
![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg) 
![](https://img.shields.io/appveyor/ci/gruntjs/grunt.svg)


## GHGestureDemo

捏合手势和拖拽手势并存,实现调整焦距

### 拖拽手势 `UIPanGestureRecognizer `

先看api提供集成属性和方法

>`minimumNumberOfTouches` 设置最少需要几个手指拖动 
>`maximumNumberOfTouches`  设置最多支持几个手指拖动 
> `(CGPoint)translationInView:(nullable UIView *)view;` 获取当前位置  
> `(void)setTranslation:(CGPoint)translation inView:(nullable UIView *)view;`设置当前位置 
> `(void)setTranslation:(CGPoint)translation inView:(nullable UIView *)view;` 设置拖拽速度


### 捏合手势 `UIPinchGestureRecognizer `

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


相关知识点

###  Gesture Recognizer 手势识别功能
> 推出于iOS 3.2

#### 初始化方法

```
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