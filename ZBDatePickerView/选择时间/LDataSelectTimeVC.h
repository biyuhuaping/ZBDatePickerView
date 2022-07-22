//
//  LDataSelectTimeVC.h
//  LLCRM
//
//  Created by ZB on 2020/1/9.
//  Copyright © 2020 Wuhan lingli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LDataSelectTimeVC : UIViewController

/// 注意：进出参都是以时间戳形式传递
/// 时间戳
@property (copy, nonatomic) NSString *timeSp;
/// 回调
@property (copy, nonatomic) void(^timeBlock)(NSString *timeSp);

@end

NS_ASSUME_NONNULL_END
