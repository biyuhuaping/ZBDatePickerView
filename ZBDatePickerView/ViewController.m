//
//  ViewController.m
//  ZBDatePickerView
//
//  Created by ZB on 2022/7/22.
//

#import "ViewController.h"
#import "ZBSelectTimeVC.h"
#import "LDataSelectTimeVC.h"

@interface ViewController ()

@property (copy, nonatomic) NSString *startTime;//开始时间（时间戳）
@property (copy, nonatomic) NSString *endTime;  //结束时间（时间戳）
@property (assign, nonatomic) NSInteger timeType;//0:按月选择  1:按日选择

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - action
//选择日期
- (IBAction)selectDate:(UIButton *)sender {
    ZBSelectTimeVC *vc = [[ZBSelectTimeVC alloc]initWithNibName:@"ZBSelectTimeVC" bundle:nil];
    vc.timeType = self.timeType;
    vc.startTime = self.startTime;
    vc.endTime = self.endTime;
    
    WEAKSELF
    vc.timeBlock = ^(NSString * _Nonnull startTime, NSString * _Nonnull endTime, NSInteger timeType) {
        weakSelf.startTime = startTime;
        weakSelf.endTime = endTime;
        weakSelf.timeType = timeType;
        
        if (timeType == 1) {
            startTime = [Tools getFomatTime:startTime format:@"yyyy/MM/dd"];
            endTime = [Tools getFomatTime:endTime format:@"yyyy/MM/dd"];
            NSString *text = [NSString stringWithFormat:@"%@-%@",startTime,endTime];
            [sender setTitle:text forState:UIControlStateNormal];
        }else{
            NSString *text = [Tools getFomatTime:startTime format:@"yyyy/MM"];
            [sender setTitle:text forState:UIControlStateNormal];
        }
        
        //时间变化，刷新数据
    };
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
//    nav.modalPresentationStyle = 0;
    [self presentViewController:nav animated:YES completion:nil];
}

//选择日期
- (IBAction)selectDate111:(UIButton *)sender{
    LDataSelectTimeVC *vc = [[LDataSelectTimeVC alloc]initWithNibName:@"LDataSelectTimeVC" bundle:nil];
    
    NSDate *date = [self stringToDate:sender.titleLabel.text];
    if (date) {
        NSTimeInterval time = [date timeIntervalSince1970] * 1000;
        //时间转时间戳
        NSString *timeSp = [[NSNumber numberWithDouble:time] stringValue];
        vc.timeSp = timeSp;
    }
    
    vc.timeBlock = ^(NSString * _Nonnull timeSp) {
        NSString *text = [Tools getFomatTime:timeSp format:@"yyyy年M月"];
        [sender setTitle:text forState:UIControlStateNormal];
    };
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}


//string -> date
- (NSDate *)stringToDate:(NSString *)timeStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年M月"];
    NSDate *date = [formatter dateFromString:timeStr];
    return date;
}

@end
