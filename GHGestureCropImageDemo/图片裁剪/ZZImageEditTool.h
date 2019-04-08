//
//  ZZImageEditTool.h
//  YouAiXue
//
//  Created by root on 2018/11/9.
//  Copyright © 2018年 凉凉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZImageEditTool : UIView

@property (nonatomic, copy) void (^cancelBlock)(void);
@property (nonatomic, copy) void (^finishBlock)(UIImage *image);

/// selectClipRatio 0 = 全屏 1 = 1:1
+(instancetype)showViewWithImg:(UIImage *)image andSelectClipRatio:(CGFloat)selectClipRatio;

@end
