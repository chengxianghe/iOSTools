//
//  UITextView+Extention.h
//  LXJTextView
//
//  Created by LXJ on 2016/12/9.
//  Copyright © 2016年 LianLuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Extention)

@property (nonatomic,strong) NSString *placeholder;//占位符
@property (nonatomic, strong) UIColor *placeholderColor;//占位符颜色
@property (copy, nonatomic) NSNumber *limitLength;//限制字数

@end
