//
//  ZBSelectMonthTimeView.h
//  LLCRM
//
//  Created by ZB on 2020/1/9.
//  Copyright © 2020 Wuhan lingli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZBSelectMonthTimeView : UIView

/// 起始年， 默认2020
@property (assign, nonatomic) int startYear;
/// 默认显示时间（时间戳）
@property (copy, nonatomic) NSString *defultDate;
/// 选中回调
@property (copy, nonatomic) void (^selectTimeBlock)(NSString *timeSp);

@end

NS_ASSUME_NONNULL_END
