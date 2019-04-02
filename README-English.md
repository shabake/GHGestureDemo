![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Objective--C-orange.svg )
![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg)
![](https://img.shields.io/appveyor/ci/gruntjs/grunt.svg)


## GHGestureDemo

Chinese | English

The pinch gesture and the drag gesture coexist to achieve the adjustment of the focal length<br/>


**git is large and unclear, please download demo to run to see **

**If you run crash, add key `Privacy - Camera Usage Description`** to iofo.plist

![Untitled.gif](https://upload-images.jianshu.io/upload_images/1419035-75858481f750f451.gif?imageMogr2/auto-orient/strip)

### Features
```diff
+ Package permission checker
+ Package camera module implements one line of code call
+ Camera permission judgment, app activation from background to foreground camera permission judgment
+ Drag and pinch gestures to dynamically adjust camera lens focal length

```
### Review drag gestures `UIPanGestureRecognizer `

First look at api to provide integration properties and methods

>`minimumNumberOfTouches` setting requires a minimum of a few finger drags
>`maximumNumberOfTouches` settings support up to a few finger drags
> `(CGPoint)translationInView:(nullable UIView *)view;` Get the current position
> `(void)setTranslation:(CGPoint)translation inView:(nullable UIView *)view;`Set current position
> `(void)setTranslation:(CGPoint)translation inView:(nullable UIView *)view;` Set the drag speed


### Review the pinch gesture `UIPinchGestureRecognizer `

>`scale` scaling

>`velocity` drag speed

Both gestures can add listener events when initializing

```
UIPinchGestureRecognizer *pinchGest = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchView:)];
UIPanGestureRecognizer *panGest = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panView:)];
```
Implementing the listening method separately

```
- (void)pinchView:(UIPinchGestureRecognizer *)pinchGest{
}
- (void)panView:(UIPanGestureRecognizer *)panGest{
}
```

If there are multiple gestures at the same time, you need to override the proxy method

```
- (BOOL)gestRecognizer:(UIGestureRecognizer *)gestRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    Return YES;
}
```

### Dependency
`GHPrivacyAuthTool` permission checker

`GHCameraModule.h` camera integration module

`UIView+GHAdd.h` Classification of UIView

### Custom view

Customize a `view` named `GHAdjustFocal`,
There are five parts inside which are
`backGround` background `circle` circle `slider `slider `add `plus ``sub` minus

The position of the circle can be set via the property `circleCenterY`
There are also two to get the current `centerY` of the circle and the total height of the slider

### Key Method

`videoScaleAndCropFactor ` Adjust the focus property, the minimum is 1, so add 1 for each value in order to be safe.

```
  AVCaptureConnection * videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];

    [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(1+value, 1+value)];
    videoConnection.videoScaleAndCropFactor = 1 + value;
    
```

I define a method to pass the `value` obtained after the gesture operation.

```
- (void)adjustFocalWtihValue: (CGFloat)value
```

### Called in the controller
#### Initialization
Declare a property `zoomScale`, because the default is the largest, so initialize to 1

```self.zoomScale = 1;```

The focal length of the camera is also the largest 10

```[self.cameraModule adjustFocalWtihValue:10];```

Add pinch gestures and drag gestures on the view

#### Calculation
Drag gesture
```
/// Sliding distance
CGPoint trans = [panGest translationInView:panGest.view];
/// Get the center y value of the circle
    CGFloat circleCenterY = [self.adjustFocal getCircleCenterY]; /// circleY
 /// y value increments
    circleCenterY += trans.y;
     /// Get the total distance to slide
    CGFloat totalHeight = [self.adjustFocal getSliderHeight]; /// total sliding length
  /// handle the top crossover
    If (circleCenterY <= 20) {
        circleCenterY = 20; /// handle the top
    }
     /// handle the bottom of the boundary

    If (circleCenterY >= self.adjustFocal.gh_height - 40 + 20) {
        circleCenterY = self.adjustFocal.gh_height - 40 + 20;
    }
    
    /// Refresh the y value of the circle
    self.adjustFocal.circleCenterY = circleCenterY;
    /// Calculate the scale
    CGFloat scale = (totalHeight - circleCenterY + 20)/totalHeight;
    self.zoomScale = scale;
    Self.test.transform = CGAffineTransformMakeScale(scale, scale);
    Self.value.text = [NSString stringWithFormat:@"proportion%.2f",scale];
    /// Reset
    [panGest setTranslation:CGPointZero inView:panGest.view];
    /// Dynamically change the camera focal length
    [self.cameraModule adjustFocalWtihValue:scale * 10];
```

#### Tip

Finally, don't forget to remove the monitor.

```
[[NSNotificationCenter defaultCenter] removeObserver:self];

```
---


## Other related knowledge points
### Gesture Recognizer Gesture Recognition
> Launched on iOS 3.2

#### Initialization method

```
/// Initialize
- (instancetype)initWithTarget:(nullable id)target action:(nullable SEL)action
```
```
/// Add a listener
- (void)addTarget:(id)target action:(SEL)action;
```
```
/// Remove the listener
- (void)removeTarget:(nullable id)target action:(nullable SEL)action;
```
#### state

```
Typedef NS_ENUM(NSInteger, UIGestureRecognizerState) {
    UIGestureRecognizerStatePossible, // The default state, the gesture at this time has no specific situation
    UIGestureRecognizerStateBegan, // the state at which the gesture begins to be recognized
    UIGestureRecognizerStateChanged, // Gesture recognition changed state
    UIGestureRecognizerStateEnded, // gesture recognition ends, the method that will trigger
    UIGestureRecognizerStateCancelled, // Gesture recognition canceled
    UIGestureRecognizerStateFailed, // recognition failed, method will not be called
    UIGestureRecognizerStateRecognized = UIGestureRecognizerStateEnded
};
```
#### Attributes
`delegate ` gesture agent

`enabled ` Set whether the gesture is valid
 
 `view ` Get the view where the gesture is located

`cancelsTouchesInView` defaults to YES. When touch is recognized, all touch events sent by touchesCancelled:withEvent: orPRESSesCancelled:withEvent: are terminated.

`delaysTouchesBegan` defaults to NO. When the touch starts, it will send a message to the event delivery chain. If set to YES, it will not send a message to the event delivery chain until the touch is not recognized.

`delaysTouchesEnded ` defaults to YES. After setting the gesture recognition, this property immediately sends a touchesEnded orPRESSesEnded message to the event delivery chain or waits for a short time. If no new gesture recognition task is received, send it again.

`allowedTouchTypes `
     
`allowedPressTypes `

####method

```
[A requireGestureRecognizerToFail:B] gesture mutual exclusion It can specify that when the A gesture occurs, even if A has met the condition, it will not be triggered immediately, and will wait until the specified gesture B determines that the failure has occurred.
- (void)requireGestureRecognizerToFail:(UIGestureRecognizer *)otherGestureRecognizer;
```
```
/ / Get the current touch point
- (CGPoint)locationInView:(nullable UIView*)view;
```

```
/ / Set the number of touch points
- (NSUInteger)numberOfTouches;
```
```
/ / Get the touch location of a touch point
- (CGPoint)locationOfTouch:(NSUInteger)touchIndex inView:(nullable UIView*)view;
```

### If you are helpful to you, please help me a star, thanks very much.

---