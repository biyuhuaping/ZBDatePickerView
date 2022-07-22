//
//  ZBSelectMonthTimeView.m
//  LLCRM
//
//  Created by ZB on 2020/1/9.
//  Copyright © 2020 Wuhan lingli. All rights reserved.
//

#import "ZBSelectMonthTimeView.h"

@interface ZBSelectMonthTimeView ()<UIPickerViewDelegate,UIPickerViewDataSource>{
    NSInteger yearIndex;        //选择的年
    NSInteger monthIndex;       //选择的月
    
    NSInteger currentYearIndex; //当前年
    NSInteger currentMonthIndex;//当前月
}

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *yearArray;
@property (nonatomic, strong) NSMutableArray *monthArray;

@end

@implementation ZBSelectMonthTimeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _startYear = 2000;
        [self configUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _startYear = 2000;
        [self configUI];
    }
    return self;
}

- (void)configUI{
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
    
    int y = [[Tools getCurrentFomatTime:@"yyyy"] intValue];
    currentYearIndex = y-self.startYear;
    
    int m = [[Tools getCurrentFomatTime:@"MM"] intValue];
    currentMonthIndex = m-1;
    
    [self.pickerView selectRow:yearIndex inComponent:0 animated:YES];
    [self.pickerView selectRow:monthIndex inComponent:1 animated:YES];
    
    [self pickerView:_pickerView didSelectRow:yearIndex inComponent:0];
    [self pickerView:_pickerView didSelectRow:monthIndex inComponent:1];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.pickerView.frame = self.bounds;
}

//- (void)setStartYear:(int)startYear{
//    _startYear = startYear;
//    [self.yearArray removeAllObjects];
//    self.yearArray = nil;
//    [self configUI];
//}

- (void)setDefultDate:(NSString *)timeSp{
    _defultDate = timeSp;
    NSString *yyyy = nil;
    NSString *MM = nil;
    
    yyyy = [Tools getFomatTime:timeSp format:@"yyyy年"];
    MM = [Tools getFomatTime:timeSp format:@"MM月"];
    
    yearIndex = [self.yearArray indexOfObject:yyyy];
    monthIndex = [self.monthArray indexOfObject:MM];
    
    [self.pickerView reloadAllComponents];
    
    [self.pickerView selectRow:yearIndex inComponent:0 animated:YES];
    [self.pickerView selectRow:monthIndex inComponent:1 animated:YES];
}

#pragma mark - UIPickerView
#pragma mark UIPickerView的数据源
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.yearArray.count;
    }else if(component == 1) {
        if (currentYearIndex == yearIndex) {
            return currentMonthIndex + 1;
        }
        return self.monthArray.count;
    }
    return 0;
}

#pragma mark UIPickerView的代理
// 滚动UIPickerView就会调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        yearIndex = row;
        if (currentYearIndex == yearIndex) {
            monthIndex = currentMonthIndex;
        }
        [pickerView reloadAllComponents];
    }else if (component == 1) {
        monthIndex = row;
    }
    NSString *time = [NSString stringWithFormat:@"%@%@",self.yearArray[yearIndex],self.monthArray[monthIndex]];
    NSString *timeSp = [Tools getTimestamp:time format:@"yyyy年MM月"];
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
    }
    return genderLabel;
}

#pragma mark - Lazy
- (NSMutableArray *)yearArray {
    if (!_yearArray) {
        int y = [[Tools getCurrentFomatTime:@"yyyy"] intValue];
        
        _yearArray = [NSMutableArray array];
        for (int year = self.startYear; year <= y; year++) {
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
