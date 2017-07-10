//
//  TUImageView.h
//  lefuSDKTest
//
//  Created by chengxianghe on 2017/6/28.
//  Copyright © 2017年 luo. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface TUImageView : UIImageView

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;               ///<圆角
@property (nonatomic, strong) IBInspectable UIColor *borderColor;               ///<边框颜色
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;                ///<边框宽度

@end
