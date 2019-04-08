//
//  ClipViewController.h
//  Camera
//
//  Created by wzh on 2017/6/6.
//  Copyright © 2017年 wzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClipPhotoDelegate <NSObject>

- (void)clipPhoto:(UIImage *)image;

@end

@interface ClipViewController : UIViewController
@property (strong, nonatomic) UIImage *image;

@property (nonatomic, strong) UIImagePickerController *picker;

@property (nonatomic, strong) UIViewController *controller;

@property (nonatomic, weak) id<ClipPhotoDelegate> delegate;

@property (nonatomic, assign) BOOL isTakePhoto;

@property (nonatomic, assign) BOOL isClip;

@end
