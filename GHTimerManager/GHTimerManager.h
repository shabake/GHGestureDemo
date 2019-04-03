//
//  GHTimerManager.h
//  GHProtect
//
//  Created by mac on 2018/4/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GHTimerManager;
typedef void (^TimerActionBlock)(GHTimerManager *timerManager, NSInteger count);

/**
 * NSTimer时间管理工具
 */
@interface GHTimerManager : NSObject

@property (nonatomic , copy) TimerActionBlock timerActionBlock;

+ (instancetype)sharedManager;

/**
 定时器开始

 @param timerActionBlock 回调block
 */
- (void)timerStartWithTimerActionBlock: (TimerActionBlock)timerActionBlock;

/**
 * 定时器停止
 */
- (void)timerStop;

/**
 * 定时器重新开始
 */
- (void)timerReStart;

/**
 * 移除定时器
 */
- (void)timerRemove;

@end
