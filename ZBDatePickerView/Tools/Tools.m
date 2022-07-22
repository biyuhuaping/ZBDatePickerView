//
//  Tools.m
//  LLCRM
//
//  Created by ZB on 2019/11/5.
//  Copyright © 2019 Wuhan lingli. All rights reserved.
//

#import "Tools.h"

@implementation Tools

#pragma mark - 设置Label
///设置Label中指定文字的字体
+ (void)setLabel:(UILabel *)label font:(UIFont *)font string:(NSString *)string {
    [self setLabel:label font:font color:label.textColor string:string];
}

///设置Label中指定文字的颜色
+ (void)setLabel:(UILabel *)label color:(UIColor *)color string:(NSString *)string {
    [self setLabel:label font:label.font color:color string:string];
}

///设置Label中指定文字的字体、颜色
+ (void)setLabel:(UILabel *)label font:(UIFont *)font color:(UIColor *)color string:(NSString *)string {
    if (label.text.length == 0) return;
    NSRange range = [label.text rangeOfString:string];
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithAttributedString:label.attributedText];
    [attributed addAttribute:NSFontAttributeName value:font range:range];
    [attributed addAttribute:NSForegroundColorAttributeName value:color range:range];
    label.attributedText = attributed;
}

///设置Label行间距
+ (void)setLabel:(UILabel *)label lineSpacing:(CGFloat)space {
    NSString *labelText = label.text;
    if (labelText.length == 0) return;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:label.attributedText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
}

///设置TextView行间距
+ (void)setTextView:(UITextView *)textView lineSpacing:(CGFloat)space {
    NSString *labelText = textView.text;
    if (labelText.length == 0) return;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    textView.attributedText = attributedString;
    [textView sizeToFit];
}


+ (CGFloat)getLabelTextHeightWithText:(NSString *)text size:(CGSize)size attributes:(NSDictionary *)dic
{
    if (text.length == 0 || size.width<= 0) {
        return 0;
    }
     CGFloat h = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height;
    return h;
}

#pragma mark - 时间相关
/// 获得时间戳 from某个时间
+ (NSString *)getTimestamp:(NSString *)formatTime format:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format]; //(@"YYYY-MM-dd hh:mm:ss") 设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *date = [formatter dateFromString:formatTime]; // 将字符串按Formatter转成NSDate
    NSTimeInterval time = [date timeIntervalSince1970] * 1000;// *1000 是精确到毫秒(13位),不乘就是精确到秒(10位)

    //时间转时间戳的方法:
    NSString *timeSp = [[NSNumber numberWithDouble:time] stringValue];
    NSLog(@"获得时间戳：%ld",(long)timeSp); //时间戳的值
    return timeSp;
}

/// 获取指定格式的时间，form时间戳，没有值时返回@"--"
/// @param timeInterval 时间戳
/// @param format 例如@"yyyy-MM-dd hh:mm:ss"
+ (NSString *)getFomatTimeStr:(NSString *)timeInterval format:(NSString *)format{
    if (!timeInterval || timeInterval.length == 0) {
        return @"";
    }
    return [self getFomatTime:timeInterval format:format];
}

/// 获取指定格式的时间，form时间戳
+ (NSString *)getFomatTime:(NSString *)timeInterval format:(NSString*)format{
    if (!timeInterval || timeInterval.length == 0) {
        return @"--";
    }
    NSTimeInterval time = [timeInterval longLongValue] / 1000; // 传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];//先转成时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *stringTime = [formatter stringFromDate:date];
    return stringTime;
}

/// 获取当前日期，并指定格式，没指定格式将得到时间戳
+ (NSString *)getCurrentFomatTime:(NSString *)formator{
    if (!formator || formator.length == 0) {
        NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)([datenow timeIntervalSince1970] * 1000)];
        return timeSp;
    }
    NSDate *date = [NSDate date];//先转成时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formator];
    NSString *stringTime = [formatter stringFromDate:date];
    return stringTime;
}

/// 获取当前月第一天和最后一天的时间戳
+ (NSArray *)getCurrentMonthFirstAndLastDay{
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)([datenow timeIntervalSince1970] * 1000)];
    NSArray *array = [self getMonthBeginAndEndWith:timeSp];
    return array;
}

///从时间戳(毫秒)获得当月第一天和最后一天
+ (NSArray *)getMonthBeginAndEndWith:(NSString *)timeInterval{
    //    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    //    [format setDateFormat:@"yyyy-MM"];
    //    NSDate *newDate = [format dateFromString:dateStr];
    NSTimeInterval time = [timeInterval longLongValue] / 1000;
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:time];//把时间戳先转成时间
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//设定周一为周首日
    
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:newDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return @[@"",@""];
    }
    //    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    //    [myDateFormatter setDateFormat:@"YYYY.MM.dd"];
    //    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    //    NSString *endString = [myDateFormatter stringFromDate:endDate];
    
    NSString *beginString = [NSString stringWithFormat:@"%ld", (long)([beginDate timeIntervalSince1970] * 1000)];
    NSString *endString = [NSString stringWithFormat:@"%ld", (long)([endDate timeIntervalSince1970] * 1000)];
    
    return @[beginString, endString];
}

///从时间戳(毫秒)获取当天的时间段 00:00:00 - 23:59:59
+ (NSArray *)getDayBeginAndEndWith:(NSString *)timeInterval {
    NSTimeInterval time = [timeInterval longLongValue] / 1000;
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:time];//把时间戳先转成时间
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:newDate];
    [components setHour:0];//设置开始时间为0点
    
    NSDate *beginDate = [calendar dateFromComponents:components];
    NSDate *endDate = [beginDate dateByAddingTimeInterval:3600*24 - 1];
    
    //转成时间戳
    NSString *startTime = [NSString stringWithFormat:@"%ld", (long)([beginDate timeIntervalSince1970] * 1000)];
    NSString *endTime = [NSString stringWithFormat:@"%ld", (long)([endDate timeIntervalSince1970] * 1000)];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";

    NSString *s = [formatter stringFromDate:beginDate];
    NSString *e = [formatter stringFromDate:endDate];
    NSLog(@"当天的时间段:%@ ~ %@",s,e);
    
    return @[startTime, endTime];
}

#pragma mark - 文件存取
/// 存入本地文件
+ (BOOL)saveFileToLoc:(NSString *)fileName theFile:(id)file{
    NSString *Path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *CachePath = [fileName stringByReplacingOccurrencesOfString: @"/" withString: @"_"];
    NSString *filename = [Path stringByAppendingPathComponent:CachePath];
    //NSLog(@"%@",fileName);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filename]) {
        if (! [fileManager createFileAtPath:filename contents:nil attributes:nil]) {
            NSLog(@"创建文件失败！");
        }
    }
    return  [file writeToFile:filename atomically:YES];//这句是往文件里面写数据  这都是覆盖式写入的  atomically的YES 或 NO  ：YES 表示保证文件的写入原子性,就是说会先创建一个临时文件,直到文件内容写入成功再导入到目标文件里.NO  则直接写入目标文件里.
}

/// 读取本地文件
+ (BOOL)getFileFromLoc:(NSString*)filePath into:(id)file {
    NSString *Path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *CachePath = [filePath stringByReplacingOccurrencesOfString: @"/" withString: @"_"];
    NSString *filename = [Path stringByAppendingPathComponent:CachePath];
    if ([file isKindOfClass:[NSDictionary class]]) {
        [file setDictionary: [NSDictionary dictionaryWithContentsOfFile:filename]];
    }else if ([file isKindOfClass:[NSArray class]]) {
//        [file addObjectsFromArray: [NSArray arrayWithContentsOfFile:filename]];
        [file setArray:[NSArray arrayWithContentsOfFile:filename]];
    }
    return YES;
}

#pragma mark -
///获取当前最上层的控制器
+ (UIViewController *)getTopMostController{
    UIWindow *topWindow = [UIApplication sharedApplication].keyWindow;
    if (topWindow.windowLevel != UIWindowLevelNormal) {
        topWindow = [self returnWindowWithWindowLevelNormal];
    }
    
    UIViewController *topController = topWindow.rootViewController;
    if(topController == nil) {
        topWindow = [UIApplication sharedApplication].delegate.window;
        if (topWindow.windowLevel != UIWindowLevelNormal) {
            topWindow = [self returnWindowWithWindowLevelNormal];
        }
        topController = topWindow.rootViewController;
    }
    
    while(topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    if([topController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController*)topController;
        topController = [nav.viewControllers lastObject];
        while(topController.presentedViewController) {
            topController = topController.presentedViewController;
        }
    }
    return topController;
}

+ (UIWindow *)returnWindowWithWindowLevelNormal{
    NSArray *windows = [UIApplication sharedApplication].windows;
    for(UIWindow *topWindow in windows) {
        if (topWindow.windowLevel == UIWindowLevelNormal)
            return topWindow;
    }
    return [UIApplication sharedApplication].keyWindow;
}

#pragma mark - 高精度运算
///加法
+ (NSDecimalNumber *)addFun:(NSString *)num1 num2:(NSString *)num2{
    return [self decimalNumberBy:@"+" num1:num1 num2:num2 afterPoint:2];
}

///减法
+ (NSDecimalNumber *)subFun:(NSString *)num1 num2:(NSString *)num2{
    return [self decimalNumberBy:@"-" num1:num1 num2:num2 afterPoint:2];
}

///乘法
+ (NSDecimalNumber *)multiplying:(NSString *)num1 num2:(NSString *)num2{
    return [self decimalNumberBy:@"*" num1:num1 num2:num2 afterPoint:2];
}

///除法
+ (NSDecimalNumber *)dividing:(NSString *)num1 num2:(NSString *)num2{
    return [self decimalNumberBy:@"/" num1:num1 num2:num2 afterPoint:2];
}

/// 四则混合运算
/// @param num1 num1
/// @param num2 num2
/// @param position 保留位数
+ (NSDecimalNumber *)decimalNumberBy:(NSString *)fun num1:(NSString *)num1 num2:(NSString *)num2 afterPoint:(int)position{
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    NSDecimalNumber *number1 = [NSDecimalNumber decimalNumberWithString:num1];
    NSDecimalNumber *number2 = [NSDecimalNumber decimalNumberWithString:num2];
    if (isnan(number1.doubleValue)) {
        number1 = [NSDecimalNumber decimalNumberWithString:@"0"];
    }
    if (isnan(number2.doubleValue)){
        number2 = [NSDecimalNumber decimalNumberWithString:@"0"];
    }
    
    NSDecimalNumber *result;
    if ([fun isEqualToString:@"+"]) {//加
        result = [number1 decimalNumberByAdding:number2 withBehavior:handler];
    }else if ([fun isEqualToString:@"-"]){//减
        result = [number1 decimalNumberBySubtracting:number2 withBehavior:handler];
    }else if ([fun isEqualToString:@"*"]){//乘
        result = [number1 decimalNumberByMultiplyingBy:number2 withBehavior:handler];
    }else if ([fun isEqualToString:@"/"]){//除
        if (isnan(number2.doubleValue) || number2.doubleValue == 0){
            //防止除法分母为0引起崩溃
            number2 = [NSDecimalNumber decimalNumberWithString:@"1"];
        }
        result = [number1 decimalNumberByDividingBy:number2 withBehavior:handler];
    }

    //平方
//    NSDecimalNumber *powerResult = [number1 decimalNumberByRaisingToPower:2 withBehavior:handler];
//    NSLog(@"\n%f\n%f\n%f\n%f\n%f",[addResult doubleValue],[subtractResult doubleValue],[multiplyResult doubleValue],[divideResult doubleValue],[powerResult doubleValue]);
    return result;
}

#pragma mark - 验证
// 是否为空
+ (NSString *)isAllBlank:(NSString *)string{
    NSString *str = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (str.length) {
        str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    return  str;
}

//是否是纯数字
+ (BOOL)isOnlyNumber:(NSString *)string{
    NSString *regex = @"^[0-9]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:string];
}

//验证手机号
+ (BOOL)isPhoneNum:(NSString *)phone{
    //过滤字符串前后的空格
    phone = [phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![self isOnlyNumber:phone] ) return NO;
    if (!(phone.length == 11)) return NO;
    
    NSString *str = [phone substringWithRange:NSMakeRange(0,1)];
    if (![str isEqualToString:@"1"]) return NO;
    else return YES;
}

@end
