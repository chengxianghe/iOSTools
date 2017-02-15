//
//  TUIBView.m
//  CaiBao
//
//  Created by CXH on 2016/12/8.
//  Copyright © 2016年 CCaV. All rights reserved.
//

#import "TUIBView.h"

@implementation TUIBView

/**
 *  设置边框宽度
 *
 *  @param shadowOffsetHeight 可视化视图传入的值
 */
- (void)setShadowOffsetHeight:(CGFloat)shadowOffsetHeight {
    
    self.layer.shadowOffset = CGSizeMake(self.layer.shadowOffset.width, shadowOffsetHeight);
}

- (void)setShadowOffsetWidth:(CGFloat)shadowOffsetWidth {
    
    self.layer.shadowOffset = CGSizeMake(shadowOffsetWidth, self.layer.shadowOffset.height);
    
}

/**
*  设置边框颜色
*
*  @param shadowColor 可视化视图传入的值
*/
- (void)setShadowColor:(UIColor *)shadowColor {
    
    self.layer.shadowColor = shadowColor.CGColor;
}

/**
 *  设置圆角
 *
 *  @param shadowRadius 可视化视图传入的值
 */
- (void)setShadowRadius:(CGFloat)shadowRadius {
    
    self.layer.shadowRadius = shadowRadius;
    
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity {
    
    self.layer.shadowOpacity = shadowOpacity;
    
}
@end
