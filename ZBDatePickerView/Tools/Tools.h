//
//  Tools.h
//  LLCRM
//
//  Created by ZB on 2019/11/5.
//  Copyright © 2019 Wuhan lingli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Tools : NSObject

#pragma mark - 设置Label

///设置Label中指定文字的字体
+ (void)setLabel:(UILabel *)label font:(UIFont *)font string:(NSString *)string;

///设置Label中指定文字的颜色
+ (void)setLabel:(UILabel *)label color:(UIColor *)color string:(NSString *)string;

///设置Label中指定文字的字体、颜色
+ (void)setLabel:(UILabel *)label font:(UIFont *)font color:(UIColor *)color string:(NSString *)string;

///设置Label行间距
+ (void)setLabel:(UILabel *)label lineSpacing:(CGFloat)space;

///设置TextView行间距
+ (void)setTextView:(UITextView *)textView lineSpacing:(CGFloat)space;


/// 获取文本高度
/// @param text <#text description#>
/// @param size <#size description#>
/// @param dic <#dic description#>
+ (CGFloat)getLabelTextHeightWithText:(NSString *)text size:(CGSize)size attributes:(NSDictionary *)dic;

#pragma mark - 时间相关
/// 获得时间戳 from某个时间
/// @param formatTime 时间
/// @param format 例如@"yyyy-MM-dd hh:mm:ss"
+ (NSString *)getTimestamp:(NSString *)formatTime format:(NSString *)format;

/// 获取指定格式的时间，form时间戳，没有值时返回@"--"
/// @param timeInterval 时间戳
/// @param format 例如@"yyyy-MM-dd hh:mm:ss"
//+ (NSString *)getFomatTimeStr:(NSString *)timeInterval format:(NSString *)format;

/// 获取指定格式的时间，form时间戳
/// @param timeInterval 时间戳
/// @param format 例如@"yyyy-MM-dd hh:mm:ss"
+ (NSString *)getFomatTime:(NSString *)timeInterval format:(NSString *)format;

/// 获取当前日期，并指定格式，没指定格式将得到时间戳
/// @param formator 例如@"yyyy-MM-dd hh:mm:ss"
+ (NSString *)getCurrentFomatTime:(NSString *)formator;

/// 获取当前月第一天和最后一天的时间戳
+ (NSArray *)getCurrentMonthFirstAndLastDay;

///获取当月第一天和最后一天，从时间戳(毫秒)
+ (NSArray *)getMonthBeginAndEndWith:(NSString *)timeInterval;

///从时间戳(毫秒)获取当天的时间段 00:00:00 - 23:59:59
+ (NSArray *)getDayBeginAndEndWith:(NSString *)timeInterval;

#pragma mark - 文件存取
/// 本地存储文件
+ (BOOL)saveFileToLoc:(NSString *)fileName theFile:(id)file;

/// 读取本地文件
+ (BOOL)getFileFromLoc:(NSString*)filePath into:(id)dic;

#pragma mark -
///获取当前最上层的控制器
+ (UIViewController *)getTopMostController;


#pragma mark - 高精度运算

/// 加法
/// @param num1 num1
/// @param num2 num2
+ (NSDecimalNumber *)addFun:(NSString *)num1 num2:(NSString *)num2;


/// 减法
/// @param num1 num1
/// @param num2 num1
+ (NSDecimalNumber *)subFun:(NSString *)num1 num2:(NSString *)num2;


/// 乘法
/// @param num1 num1
/// @param num2 num1
+ (NSDecimalNumber *)multiplying:(NSString *)num1 num2:(NSString *)num2;


/// 除法
/// @param num1 num1
/// @param num2 num2
+ (NSDecimalNumber *)dividing:(NSString *)num1 num2:(NSString *)num2;

#pragma mark - 验证
/// 是否为空
/// @param string string
+ (NSString *)isAllBlank:(NSString *)string;

/// 是否是纯数字
/// @param string string
+ (BOOL)isOnlyNumber:(NSString *)string;

/// 验证手机号
/// @param phone 手机号
+ (BOOL)isPhoneNum:(NSString *)phone;

@end

NS_ASSUME_NONNULL_END
