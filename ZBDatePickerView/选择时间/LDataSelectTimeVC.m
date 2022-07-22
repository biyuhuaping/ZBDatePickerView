//
//  LDataSelectTimeVC.m
//  LLCRM
//
//  Created by ZB on 2020/1/9.
//  Copyright © 2020 Wuhan lingli. All rights reserved.
//

#import "LDataSelectTimeVC.h"
#import "ZBSelectMonthTimeView.h"

@interface LDataSelectTimeVC ()

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (copy, nonatomic) NSString *timeSpMonth;//按月-开始时间（时间戳）

@property (strong, nonatomic) IBOutlet ZBSelectMonthTimeView *pickView;

@end

@implementation LDataSelectTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择时间";
    
    //获取当前日期，并指定格式
    NSArray *timeAr = [Tools getCurrentMonthFirstAndLastDay];
    if (!self.timeSp.length) {
        self.timeSp = timeAr.firstObject;
    }
    
    self.timeSpMonth = self.timeSp;
    NSString *currentDay = [Tools getCurrentFomatTime:@""];
    NSArray *array = [Tools getDayBeginAndEndWith:currentDay];
    self.timeSp = array.firstObject;
    
    [self configNav];
    [self didSelectSegmentedControl];
    
    WEAKSELF
    self.pickView.selectTimeBlock = ^(NSString * _Nonnull timeSp) {
        weakSelf.timeSpMonth = timeSp;
        weakSelf.timeLabel.text = [Tools getFomatTime:timeSp format:@"yyyy-MM"];
    };
}

- (void)configNav{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 44);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -35, 0, 0);
    btn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:15];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:ColorFromHex(0x666666) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 0, 60, 44);
    btn1.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -35);
    btn1.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:15];
    [btn1 setTitle:@"完成" forState:UIControlStateNormal];
    [btn1 setTitleColor:ColorFromHex(0x23C2B7) forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn1];
}

- (void)didSelectSegmentedControl{
    [self updateLeftView];
}

- (void)updateLeftView{
    self.timeLabel.text = [Tools getFomatTime:self.timeSpMonth format:@"yyyy-MM"];
    //查询月份      1575129600000, 1577807999000
    self.pickView.defultDate = self.timeSpMonth;
}

#pragma mark -
- (void)dismissView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneAction{
    NSString *timeSp = [Tools getMonthBeginAndEndWith:self.timeSpMonth].firstObject;
    if (self.timeBlock) {
        self.timeBlock(timeSp);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
