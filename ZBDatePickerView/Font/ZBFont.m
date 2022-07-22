//
//  ZBFont.m
//  ZBDatePickerView
//
//  Created by ZB on 2022/7/22.
//

#import "ZBFont.h"

@implementation ZBFont

/// 苹方-简 中黑体
UIFont *font_pingfang_sc_medium(CGFloat size){
    return [UIFont fontWithName:@"PingFang-SC-Medium" size:size];
}

/// 苹方-简 常规体
UIFont *font_pingfang_sc_regular(CGFloat size){
    return [UIFont fontWithName:@"PingFang-SC-Regular" size:size];
}

/// 苹方-简 细体
UIFont *font_pingfang_sc_light(CGFloat size){
    return [UIFont fontWithName:@"PingFang-SC-Light" size:size];
}

/// 苹方-简 中粗体
UIFont *font_pingfang_sc_semibold(CGFloat size){
    return [UIFont fontWithName:@"PingFang-SC-Semibold" size:size];
}

/// DIN Alternate
UIFont *font_DINAlternate_Bold(CGFloat size){
    return [UIFont fontWithName:@"DINAlternate-Bold" size:size];
}

@end
