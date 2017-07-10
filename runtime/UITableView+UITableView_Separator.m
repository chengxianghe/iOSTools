//
//  UITableView+UITableView_Separator.m
//  GMBuy
//
//  Created by chengxianghe on 2017/4/28.
//  Copyright © 2017年 cn. All rights reserved.
//

#import "UITableView+UITableView_Separator.h"
#import <objc/runtime.h>

@implementation UITableView (UITableView_Separator)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethod:self originSelector:@selector(setDelegate:) otherSelector:@selector(my_setDelegate:)];
    });
}

- (void)my_setDelegate:(id<UITableViewDelegate>)delegate {
    [self my_setDelegate:delegate];
    [self setSeparatorInset:UIEdgeInsetsMake(0, 40, 0, 0)];
}

#pragma mark - Swizzle

/**
 *  交换两个对象方法
 *
 *  @param class          类名称
 *  @param originSelector 原始方法名称
 *  @param otherSelector  交换的方法名称
 */
+ (void)swizzleInstanceMethod:(Class)class originSelector:(SEL)originSelector otherSelector:(SEL)otherSelector
{
    Method otherMehtod = class_getInstanceMethod(class, otherSelector);
    Method originMehtod = class_getInstanceMethod(class, originSelector);
    if (originMehtod == nil) {
        // 原有类没实现这个方法
        originMehtod = class_getInstanceMethod(class, NSSelectorFromString(@"methodNotFound"));
    }
    // 交换2个方法的实现
    if (class_addMethod(class, originSelector, method_getImplementation(otherMehtod), method_getTypeEncoding(originMehtod))) {
        class_replaceMethod(class, otherSelector, method_getImplementation(originMehtod), method_getTypeEncoding(originMehtod));
    } else {
        method_exchangeImplementations(otherMehtod, originMehtod);
    }
}


@end
