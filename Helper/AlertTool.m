//
//  AlertTool.m
//  SmartDevice
//
//  Created by chengxianghe on 2017/5/8.
//  Copyright © 2017年 lianluo. All rights reserved.
//

#import "AlertTool.h"

@implementation AlertTool

+ (UIAlertController *)alertWithTitle:(NSString *)title message:(NSString *)message doneTitle:(NSString *)doneTitle done:(void(^)())doneBlock cancelTitle:(NSString *)cancelTitle cancel:(void(^)())cancelBlock {
    
    UIViewController *vc = [[UIApplication sharedApplication].keyWindow rootViewController];

    return [self alertInVC:vc withTitle:title message:message doneTitle:doneTitle done:doneBlock cancelTitle:cancelTitle cancel:cancelBlock];
}

+ (UIAlertController *)alertInVC:(UIViewController *)vc withTitle:(NSString *)title message:(NSString *)message doneTitle:(NSString *)doneTitle done:(void (^)())doneBlock cancelTitle:(NSString *)cancelTitle cancel:(void (^)())cancelBlock {
    BOOL hasCancel = (cancelTitle == nil) ? NO : YES;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sure = [UIAlertAction actionWithTitle:doneTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (doneBlock != nil) {
            doneBlock();
        }
    }];
    [alert addAction:sure];
    
    if (hasCancel) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelBlock != nil) {
                cancelBlock();
            }
        }];
        [alert addAction:cancel];
    }
    
    [vc presentViewController:alert animated:YES completion:nil];
    
    return alert;
}

+ (UIAlertController *)alertDisableCancelWithTitle:(NSString *)title message:(NSString *)message doneTitle:(NSString *)doneTitle done:(void(^)())doneBlock cancelTitle:(NSString *)cancelTitle cancel:(void (^)())cancelBlock {
    BOOL hasCancel = (cancelTitle == nil) ? NO : YES;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sure = [UIAlertAction actionWithTitle:doneTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (doneBlock != nil) {
            doneBlock();
        }
    }];
    [alert addAction:sure];
    
    if (hasCancel) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelBlock != nil) {
                cancelBlock();
            }
        }];
        
        //修改按钮字体颜色
        [cancel setValue:[UIColor grayColor] forKey:@"titleTextColor"];
        [cancel setValue:@NO forKey:@"enabled"];

        [alert addAction:cancel];
    }
    
    UIViewController *vc = [[UIApplication sharedApplication].keyWindow rootViewController];
    [vc presentViewController:alert animated:YES completion:nil];
    
    return alert;
}

@end
