//
//  ZBSelectTimeView.h
//  LLCRM
//
//  Created by ZB on 2019/12/3.
//  Copyright © 2019 Wuhan lingli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZBSelectTimeView : UIView

/// 默认显示时间（时间戳）
@property (copy, nonatomic) NSString *defultDate;
/// 选中回调
@property (copy, nonatomic) void (^selectTimeBlock)(NSString *timeSp);

@end

NS_ASSUME_NONNULL_END
