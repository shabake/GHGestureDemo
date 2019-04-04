//
//  GHGestureDraggingTable.m
//  GHGestureDraggingDemo
//
//  Created by zhaozhiwei on 2019/4/4.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import "GHGestureDraggingView.h"
#import "GHGestureDraggingHeader.h"
#import "GHGestureDraggingCell.h"

@interface GHGestureDraggingView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic , strong) GHGestureDraggingHeader *header;

@property (nonatomic , strong) UITableView *tableView;

@end

@implementation GHGestureDraggingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.tableView];
    self.tableView.tableHeaderView = self.header;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GHGestureDraggingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GHGestureDraggingCellID"];
    cell.indexPath = indexPath;
    return cell;
}

- (GHGestureDraggingHeader *)header {
    if (_header == nil) {
        _header = [[GHGestureDraggingHeader alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 155)];
    }
    return _header;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[GHGestureDraggingCell class] forCellReuseIdentifier:@"GHGestureDraggingCellID"];
    }
    return _tableView;
}
@end
