//
//  ZBSelectTimeVC.h
//  ZBDatePickerView
//
//  Created by ZB on 2022/7/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZBSelectTimeVC : UIViewController

/// 注意：进出参都是以时间戳形式传递
/// 开始时间（时间戳） 不传默认为当前日期
@property (copy, nonatomic) NSString *startTime;
/// 结束时间（时间戳） 不传默认为当前日期
@property (copy, nonatomic) NSString *endTime;
/// 0:按月选择  1:按日选择  不传默认为0
@property (assign, nonatomic) NSInteger timeType;
/// 选择回调
@property (copy, nonatomic) void(^timeBlock)(NSString *startTime, NSString *endTime, NSInteger timeType);

@end

NS_ASSUME_NONNULL_END
