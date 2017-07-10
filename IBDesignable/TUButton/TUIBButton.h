//
//  TUIBButton.h
//  TUSmartSpeaker
//
//  Created by chengxianghe on 16/5/17.
//  Copyright © 2016年 ITwU. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE//声明类是可设计的
@interface TUIBButton : UIButton

@property(nonatomic, assign) IBInspectable CGFloat cornerRadius; ///<圆角
@property(nonatomic, strong) IBInspectable UIColor *borderColor; ///<边框颜色
@property(nonatomic, assign) IBInspectable CGFloat borderWidth; ///<边框宽度
//@property(nonatomic) IBInspectable UIColor *highlightBackgroundColor;
@property(nonatomic, strong) IBInspectable UIImage *selectHighlightImage;
@property(nonatomic, strong) IBInspectable UIImage *selectHighlightBackgroundImage;

@property(nonatomic, strong) IBInspectable UIImage *disabledSelectImage;
@property(nonatomic, strong) IBInspectable UIImage *disabledSelectBackgroundImage;

@end
