//
//  ZBSelectTimeView.m
//  LLCRM
//
//  Created by ZB on 2019/12/3.
//  Copyright © 2019 Wuhan lingli. All rights reserved.
//

#import "ZBSelectTimeView.h"

@interface ZBSelectTimeView ()<UIPickerViewDataSource, UIPickerViewDelegate>{
    NSInteger yearIndex;        //选择的年
    NSInteger monthIndex;       //选择的月
    NSInteger dayIndex;         //选择的日
    NSInteger currentYearIndex; //当前年
    NSInteger currentMonthIndex;//当前月
    NSInteger currentDayIndex;  //当前天
}

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *yearArray;
@property (nonatomic, strong) NSMutableArray *monthArray;
@property (nonatomic, strong) NSMutableArray *dayArray;

@end

@implementation ZBSelectTimeView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
        unsigned unitFlags = NSCalendarUnitYear |
        NSCalendarUnitMonth |  NSCalendarUnitDay |
        NSCalendarUnitHour |  NSCalendarUnitMinute |
        NSCalendarUnitSecond | NSCalendarUnitWeekday;
        // 获取不同时间字段的信息
        NSDateComponents *comp = [calendar components: unitFlags fromDate:[NSDate date]];
        
        yearIndex = [self.yearArray indexOfObject:[NSString stringWithFormat:@"%ld年", comp.year]];
        monthIndex = [self.monthArray indexOfObject:[NSString stringWithFormat:@"%02ld月", comp.month]];
        dayIndex = [self.dayArray indexOfObject:[NSString stringWithFormat:@"%02ld日", comp.day]];
        
        int y = [[Tools getCurrentFomatTime:@"yyyy"] intValue];
        currentYearIndex = y-2000;
        
        int m = [[Tools getCurrentFomatTime:@"MM"] intValue];
        currentMonthIndex = m-1;
        
        int d = [[Tools getCurrentFomatTime:@"dd"] intValue];
        currentDayIndex = d - 1;
        
        [self.pickerView selectRow:yearIndex inComponent:0 animated:YES];
        [self.pickerView selectRow:monthIndex inComponent:1 animated:YES];
        [self.pickerView selectRow:dayIndex inComponent:2 animated:YES];
        
        [self pickerView:_pickerView didSelectRow:yearIndex inComponent:0];
        [self pickerView:_pickerView didSelectRow:monthIndex inComponent:1];
        [self pickerView:_pickerView didSelectRow:dayIndex inComponent:2];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.pickerView.frame = self.bounds;
}

- (void)setDefultDate:(NSString *)timeSp{
    _defultDate = timeSp;
    NSString *yyyy = nil;
    NSString *MM = nil;
    NSString *dd = nil;
    
    yyyy = [Tools getFomatTime:timeSp format:@"yyyy年"];
    MM = [Tools getFomatTime:timeSp format:@"MM月"];
    dd = [Tools getFomatTime:timeSp format:@"dd日"];
    
    yearIndex = [self.yearArray indexOfObject:yyyy];
    monthIndex = [self.monthArray indexOfObject:MM];
    dayIndex = [self.dayArray indexOfObject:dd];
    
    [self.pickerView reloadAllComponents];
    
    [self.pickerView selectRow:yearIndex inComponent:0 animated:YES];
    [self.pickerView selectRow:monthIndex inComponent:1 animated:YES];
    [self.pickerView selectRow:dayIndex inComponent:2 animated:YES];
    
//    [self pickerView:_pickerView didSelectRow:yearIndex inComponent:0];
//    [self pickerView:_pickerView didSelectRow:monthIndex inComponent:1];
//    [self pickerView:_pickerView didSelectRow:dayIndex inComponent:2];
}

#pragma mark -  UIPickerView的数据源
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {//返回年份个数
        return self.yearArray.count;
    }else if(component == 1) {//返回月份个数
        //如果是今年，就返回今月
        if (currentYearIndex == yearIndex) {
            return currentMonthIndex + 1;
        }
        return self.monthArray.count;
    }else {//返回天个数
        //如果是今年、今月，就返回今天
        if (currentYearIndex == yearIndex && currentMonthIndex == monthIndex) {
            return currentDayIndex + 1;
        }
        NSInteger daysCount = [self daysCountOfMonth:monthIndex+1 andYear:yearIndex+2000];
        return daysCount;
    }
}

#pragma mark - UIPickerView的代理
// 滚动UIPickerView就会调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        yearIndex = row;
        //如果是今年，月份不能大于今月
        if (yearIndex == currentYearIndex && monthIndex > currentMonthIndex) {
            monthIndex = currentMonthIndex;
        }
        
        //如果是今年、今月，天不能大于今天
        if (yearIndex == currentYearIndex && monthIndex == currentMonthIndex && dayIndex > currentDayIndex) {
            dayIndex = currentDayIndex;
        }
        
        //天，不能大于当前日期天数。（润年2月29）
        NSInteger daysCount = [self daysCountOfMonth:monthIndex+1 andYear:yearIndex+2000];
        if (dayIndex >= daysCount) {
            dayIndex = daysCount - 1;
        }
        [pickerView reloadAllComponents];
    }else if (component == 1) {
        monthIndex = row;
        
        //如果是今年、今月，天不能大于今天
        if (yearIndex == currentYearIndex && monthIndex == currentMonthIndex && dayIndex > currentDayIndex) {
            dayIndex = currentDayIndex;
        }
        
        //天，不能大于当前日期天数。（润年2月29）
        NSInteger daysCount = [self daysCountOfMonth:monthIndex+1 andYear:yearIndex+2000];
        if (dayIndex >= daysCount) {
            dayIndex = daysCount - 1;
        }
        [pickerView reloadComponent:2];
        [pickerView selectRow:dayIndex inComponent:2 animated:YES];
    }else {
        dayIndex = row;
    }
    NSString *time = [NSString stringWithFormat:@"%@%@%@",self.yearArray[yearIndex],self.monthArray[monthIndex],self.dayArray[dayIndex]];
    NSString *timeSp = [Tools getTimestamp:time format:@"yyyy年MM月dd日"];
    if (self.selectTimeBlock) {
        self.selectTimeBlock(timeSp);
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    //设置文字的属性
    UILabel *genderLabel = [[UILabel alloc] init];
    genderLabel.textAlignment = NSTextAlignmentCenter;
    genderLabel.textColor = [UIColor blackColor];
    genderLabel.font = [UIFont systemFontOfSize:22];
    if (component == 0) {
        genderLabel.text = self.yearArray[row];
    }else if (component == 1) {
        genderLabel.text = self.monthArray[row];
    }else {
        genderLabel.text = self.dayArray[row];
    }
    return genderLabel;
}

#pragma mark - 根据当前年月，获取天数
- (NSInteger)daysCountOfMonth:(NSInteger)month andYear:(NSInteger)year{
    NSLog(@"yyyy:%ld, month:%ld",year, month);
    if((month == 1)||(month == 3)||(month == 5)||(month == 7)||(month == 8)||(month == 10)||(month == 12))
        return 31;
    if((month == 4)||(month == 6)||(month == 9)||(month == 11))
        return 30;
    if(year%4 == 0 && year%100 != 0)//普通年份，非100整数倍
        return 29;
    if(year%400 == 0)//世纪年份
        return 29;
    return 28;
}

#pragma mark - Lazy
- (NSMutableArray *)yearArray {
    if (!_yearArray) {
        int y = [[Tools getCurrentFomatTime:@"yyyy"] intValue];
        
        _yearArray = [NSMutableArray array];
        for (int year = 2000; year <= y; year++) {
            NSString *str = [NSString stringWithFormat:@"%d年", year];
            [_yearArray addObject:str];
        }
    }
    return _yearArray;
}

- (NSMutableArray *)monthArray {
    if (!_monthArray) {
        _monthArray = [NSMutableArray array];
        for (int month = 1; month <= 12; month++) {
            NSString *str = [NSString stringWithFormat:@"%02d月", month];
            [_monthArray addObject:str];
        }
    }
    return _monthArray;
}

- (NSMutableArray *)dayArray {
    if (!_dayArray) {
        _dayArray = [NSMutableArray array];
        for (int day = 1; day <= 31; day++) {
            NSString *str = [NSString stringWithFormat:@"%02d日", day];
            [_dayArray addObject:str];
        }
    }
    return _dayArray;
}

- (UIPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:self.bounds];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        [self addSubview:_pickerView];
    }
    return _pickerView;
}

@end
