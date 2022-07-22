//
//  ZBFont.h
//  ZBDatePickerView
//
//  Created by ZB on 2022/7/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZBFont : UIFont

/// 苹方-简 中黑体
extern UIFont *font_pingfang_sc_medium(CGFloat size);

/// 苹方-简 常规体
extern UIFont *font_pingfang_sc_regular(CGFloat size);

/// 苹方-简 细体
extern UIFont *font_pingfang_sc_light(CGFloat size);

/// 苹方-简 中粗体
extern UIFont *font_pingfang_sc_semibold(CGFloat size);

/// DIN Alternate
extern UIFont *font_DINAlternate_Bold(CGFloat size);

@end

NS_ASSUME_NONNULL_END
