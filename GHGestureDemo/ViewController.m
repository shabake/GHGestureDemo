//
//  ViewController.m
//  GHGestureDemo
//
//  Created by zhaozhiwei on 2019/4/1.
//  Copyright © 2019年 GHome. All rights reserved.
//

#import "ViewController.h"
#import "GHCameraModule.h"
#import "GHAdjustFocal.h"
#import "GHPrivacyAuthTool.h"
#import "GHCameraModuleViewController.h"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kAutoWithSize(r) r*kScreenWidth / 375.0
#define weakself(self)          __weak __typeof(self) weakSelf = self

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *dataArray;

@property (nonatomic , strong) GHCameraModule *cameraModule;
@property (nonatomic , strong) UIImageView *test;
@property (nonatomic , assign) CGFloat scale;
@property (nonatomic , strong) GHAdjustFocal *adjustFocal;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    self.title = @"相机整合模块";
    [self.view addSubview:self.tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellID"];
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
#if TARGET_IPHONE_SIMULATOR
    KAlert(@"提示", @"请在真机运行此demo");
#else
    if (indexPath.row == 0) {
        GHCameraModuleViewController *cameraModuleVc = [GHCameraModuleViewController creatCameraModuleVcWithType:GHCameraModuleViewButtonTypeScan /** 扫一扫 */];
        [self.navigationController pushViewController:cameraModuleVc animated:YES];
    } else if (indexPath.row == 1) {
        GHCameraModuleViewController *cameraModuleVc = [GHCameraModuleViewController  creatCameraModuleVcWithType:GHCameraModuleViewButtonTypeTakephotos];
        [self.navigationController pushViewController:cameraModuleVc animated:YES];
    }
#endif
    
}
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithObjects:@"扫一扫",@"相机", nil];
    }
    return _dataArray;
}
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCellID"];
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}
@end
