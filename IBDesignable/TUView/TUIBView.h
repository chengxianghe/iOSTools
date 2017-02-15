//
//  TUIBView.h
//  CaiBao
//
//  Created by CXH on 2016/12/8.
//  Copyright © 2016年 CCaV. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE  // 动态刷新

@interface TUIBView : UIView

/** 可视化设置边框阴影高度度 */
@property (nonatomic, assign)IBInspectable CGFloat shadowOffsetHeight;

/** 可视化设置边框阴影宽度 */
@property (nonatomic, assign)IBInspectable CGFloat shadowOffsetWidth;

/** 可视化设置边框阴影颜色 */
@property (nonatomic, strong)IBInspectable UIColor *shadowColor;

/** 可视化设置阴影圆角 */
@property (nonatomic, assign)IBInspectable CGFloat shadowRadius;

/** 可视化设置边框阴影透明度 */
@property (nonatomic, assign)IBInspectable CGFloat shadowOpacity;

@end
