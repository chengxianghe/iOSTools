//
//  AlertTool.h
//  SmartDevice
//
//  Created by chengxianghe on 2017/5/8.
//  Copyright © 2017年 lianluo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlertTool : NSObject

+ (UIAlertController *)alertWithTitle:(NSString *)title message:(NSString *)message doneTitle:(NSString *)doneTitle done:(void(^)())doneBlock cancelTitle:(NSString *)cancelTitle cancel:(void(^)())cancelBlock;

+ (UIAlertController *)alertInVC:(UIViewController *)vc withTitle:(NSString *)title message:(NSString *)message doneTitle:(NSString *)doneTitle done:(void(^)())doneBlock cancelTitle:(NSString *)cancelTitle cancel:(void(^)())cancelBlock;


+ (UIAlertController *)alertDisableCancelWithTitle:(NSString *)title message:(NSString *)message doneTitle:(NSString *)doneTitle done:(void(^)())doneBlock cancelTitle:(NSString *)cancelTitle cancel:(void(^)())cancelBlock;

@end
