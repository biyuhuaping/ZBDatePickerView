//
//  ZBSelectTimeVC.m
//  ZBDatePickerView
//
//  Created by ZB on 2022/7/22.
//

#import "ZBSelectTimeVC.h"
#import "ZBSelectMonthTimeView.h"
#import "ZBSelectTimeView.h"

@interface ZBSelectTimeVC ()

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong, nonatomic) IBOutlet UITextField *textFieldMonth;
@property (strong, nonatomic) IBOutlet UITextField *textFieldStart;
@property (strong, nonatomic) IBOutlet UITextField *textFieldEnd;
@property (assign, nonatomic) NSInteger index;//选择的第几个textField
@property (copy, nonatomic) NSString *timeSpMonth;//按月-开始时间（时间戳）

@property (strong, nonatomic) IBOutlet UIView *line1;
@property (strong, nonatomic) IBOutlet UIView *line2;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftLLineToCenterX;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rightLineToCenterX;
@property (strong, nonatomic) IBOutlet ZBSelectMonthTimeView *pickView;
@property (strong, nonatomic) IBOutlet ZBSelectTimeView *selectTimeView;

@end

@implementation ZBSelectTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择时间";
    
    //获取当前日期，并指定格式
    NSArray *timeAr = [Tools getCurrentMonthFirstAndLastDay];
    if (!self.startTime.length) {
        self.startTime = timeAr.firstObject;
    }
    if (self.endTime.length) {
        self.endTime = timeAr.lastObject;
    }
    
    
    self.timeSpMonth = self.startTime;
    if (self.timeType == 0) {
        NSString *currentDay = [Tools getCurrentFomatTime:@""];
        NSArray *array = [Tools getDayBeginAndEndWith:currentDay];
        self.endTime = array.lastObject;
    }
    
    [self configNav];
    [self configSegmentControl];
    [self didSelectSegmentedControl];
    
    [self.textFieldStart addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.textFieldEnd addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    WEAKSELF
    self.pickView.startYear = 2000;
    self.pickView.selectTimeBlock = ^(NSString * _Nonnull timeSp) {
        weakSelf.timeSpMonth = timeSp;
        weakSelf.textFieldMonth.text = [Tools getFomatTime:timeSp format:@"yyyy-MM"];
    };
    
    self.selectTimeView.selectTimeBlock = ^(NSString * _Nonnull timeSp) {
        switch (weakSelf.index) {
            case 0:{
                weakSelf.timeSpMonth = timeSp;
                weakSelf.textFieldStart.text = [Tools getFomatTime:timeSp format:@"yyyy-MM-dd"];
            }
                break;
            case 1:{
                weakSelf.startTime = timeSp;
                weakSelf.textFieldStart.text = [Tools getFomatTime:timeSp format:@"yyyy-MM-dd"];
            }
                break;
            case 2:{
                weakSelf.endTime = timeSp;
                weakSelf.textFieldEnd.text = [Tools getFomatTime:timeSp format:@"yyyy-MM-dd"];
            }
                break;
            default:
                break;
        }
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

- (void)configSegmentControl{
    [self.segmentControl addTarget:self action:@selector(didSelectSegmentedControl) forControlEvents:UIControlEventValueChanged];
    
    _segmentControl.selectedSegmentIndex = self.timeType;
    //    设置默认时的背景色
    [_segmentControl setBackgroundImage:[UIImage imageNamed:@"segement"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    //    设置选中时的背景色
    [_segmentControl setBackgroundImage:[UIImage imageNamed:@"segement_selected"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    //    设置默认字体颜色
    NSDictionary *dics = @{NSForegroundColorAttributeName:ColorFromHex(0x666666), NSFontAttributeName:[UIFont systemFontOfSize:14]};
    [_segmentControl setTitleTextAttributes:dics forState:UIControlStateNormal];
    
    //    设置选中时字体颜色
    NSDictionary *dic = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:14]};
    [_segmentControl setTitleTextAttributes:dic forState:UIControlStateSelected];
    
    // 设置整体的色调
    self.segmentControl.tintColor = [UIColor whiteColor];
}

- (void)didSelectSegmentedControl{
    NSLog(@"%ld",(long)self.segmentControl.selectedSegmentIndex);
    self.textFieldMonth.hidden = self.segmentControl.selectedSegmentIndex;
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:{//按月选择
            self.index = 0;
            [UIView animateWithDuration:0.25 animations:^{
                self.leftLLineToCenterX.constant = -75;
                self.rightLineToCenterX.constant = -75;
                [self.view layoutIfNeeded];  //没有此句可能没有动画效果
            }];
            self.pickView.hidden = NO;
            self.selectTimeView.hidden = YES;
            [self updateLeftView];
        }
            break;
        case 1:{//按日选择
            self.index = 1;
            [UIView animateWithDuration:0.25 animations:^{
                self.leftLLineToCenterX.constant = 18;
                self.rightLineToCenterX.constant = 18;
                [self.view layoutIfNeeded];  //没有此句可能没有动画效果
            }];
            self.pickView.hidden = YES;
            self.selectTimeView.hidden = NO;
            [self updateRightView];
        }
            break;
    }
}

- (void)updateLeftView{
    self.textFieldMonth.text = [Tools getFomatTime:self.timeSpMonth format:@"yyyy-MM"];
    //查询月份      1575129600000, 1577807999000
    self.pickView.defultDate = self.timeSpMonth;
}

- (void)updateRightView{
    self.textFieldStart.text = [Tools getFomatTime:self.startTime format:@"yyyy-MM-dd"];
    self.textFieldEnd.text = [Tools getFomatTime:self.endTime format:@"yyyy-MM-dd"];
    
    NSTimeInterval interval = 0;
    if (self.index == 1) {//开始时间
        self.line1.backgroundColor = ColorFromHex(0x23C2B7);
        self.line2.backgroundColor = ColorFromHex(0xeeeeee);
        interval = self.startTime.doubleValue / 1000;
        self.selectTimeView.defultDate = self.startTime;
    }else{//结束时间
        self.line1.backgroundColor = ColorFromHex(0xeeeeee);
        self.line2.backgroundColor = ColorFromHex(0x23C2B7);
        interval = self.endTime.doubleValue / 1000;
        self.selectTimeView.defultDate = self.endTime;
    }
}

#pragma mark -
- (void)dismissView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneAction{
    if (self.segmentControl.selectedSegmentIndex == 0) {
        NSString *startTime = [Tools getMonthBeginAndEndWith:self.timeSpMonth].firstObject;
        NSString *endTime = [Tools getMonthBeginAndEndWith:self.timeSpMonth].lastObject;
        if (self.timeBlock) {
            self.timeBlock(startTime, endTime, self.segmentControl.selectedSegmentIndex);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        //当按日选择时，时间段开始时间不能大于结束时间
        if (self.startTime.integerValue > self.endTime.integerValue) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"开始时间不能大于结束时间" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }]];
            [self presentViewController:alert animated:YES completion:^{}];
        }else if (self.timeBlock) {
            NSLog(@"按日选择：%@ - %@",[Tools getFomatTime:self.startTime format:@"yyyy-MM-dd HH:mm:ss"],[Tools getFomatTime:self.endTime format:@"yyyy-MM-dd HH:mm:ss"]);
            NSArray *array = [Tools getDayBeginAndEndWith:self.endTime];
            self.endTime = array.lastObject;
            self.timeBlock(self.startTime, self.endTime, self.segmentControl.selectedSegmentIndex);
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma mark - textFieldDelegate
- (void)textFieldDidChange:(UITextField *)textField{
    if (textField.text.length == 0) {
        textField.font = [UIFont boldSystemFontOfSize:16];
    }else{
        textField.font = [UIFont boldSystemFontOfSize:22];
    }
}

//TextField是否可编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.index = textField.tag;
    if (self.segmentControl.selectedSegmentIndex == 0) {
        [self updateLeftView];
    }else{
        [self updateRightView];
    }
    return NO;
}


@end
