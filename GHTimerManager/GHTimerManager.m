//
//  GHTimerManager.m
//  GHProtect
//
//  Created by mac on 2018/4/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "GHTimerManager.h"
@interface GHTimerManager()
@property (nonatomic , strong) NSTimer *timer;
@property (nonatomic , assign) NSInteger count;

@end
@implementation GHTimerManager

+ (instancetype)sharedManager {
    static GHTimerManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)creat {
    [self timerRemove];
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
    self.count = 0;
}

- (void)timerStartWithTimerActionBlock: (TimerActionBlock)timerActionBlock {
    self.timerActionBlock = timerActionBlock;
    [self creat];
    [self.timer fire];
}

- (void)timerStop {
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)timerReStart {
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)timerRemove {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)timerAction {
    self.count++;
    NSLog(@"%ld",(long)self.count);
    if (self.timerActionBlock) {
        self.timerActionBlock(self, self.count);
    }
}

@end
