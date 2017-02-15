//
//  UIViewController+Extention.h
//  BambooShoots
//
//  Created by LXJ on 2016/11/1.
//  Copyright © 2016年 cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Extention)

- (UIViewController *)loadVC:(NSString *)vcStr fromSB:(NSString *)storyBoard;
+ (UIViewController *)loadVC:(NSString *)vcStr fromSB:(NSString *)storyBoard;

@end
