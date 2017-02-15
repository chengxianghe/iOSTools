//
//  UIViewController+Extention.m
//  BambooShoots
//
//  Created by LXJ on 2016/11/1.
//  Copyright © 2016年 cn. All rights reserved.
//

#import "UIViewController+Extention.h"

@implementation UIViewController (Extention)

- (UIViewController *)loadVC:(NSString *)vcStr fromSB:(NSString *)storyBoard {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:storyBoard bundle:[NSBundle mainBundle]];
    UIViewController *vc  = [sb instantiateViewControllerWithIdentifier:vcStr];
    return vc;
}

+ (UIViewController *)loadVC:(NSString *)vcStr fromSB:(NSString *)storyBoard {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:storyBoard bundle:[NSBundle mainBundle]];
    UIViewController *vc  = [sb instantiateViewControllerWithIdentifier:vcStr];
    return vc;
}

@end
