//
//  TUUIMacro.h
//
//
//  Created by cn on 16/3/26.
//  Copyright © 2016年 cn. All rights reserved.
//

#ifndef TUUIMacro_h
#define TUUIMacro_h

// 屏幕大小
#ifndef kScreenSize
#define kScreenSize     [[UIScreen mainScreen] bounds].size
#endif

#ifndef kScreenWidth
#define kScreenWidth    [[UIScreen mainScreen] bounds].size.width
#endif

#ifndef kScreenHeight
#define kScreenHeight   [[UIScreen mainScreen] bounds].size.height
#endif

#ifndef kScreenOneScale
#define kScreenOneScale (1.0 / [UIScreen mainScreen].scale)
#endif

#ifndef kRGBA
#define kRGBA(r,g,b,a)           \
[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#endif

#ifndef kLoad_Nib
#define kLoad_Nib(name)  [[[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil] lastObject]
#endif

/** 判断是否为3.5inch 320*480 640*960 */
#ifndef kIs_Inch3_5
#define kIs_Inch3_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#endif

/** 判断是否为4.0inch 320*568 640*1136 */
#ifndef kIs_Inch4_0
#define kIs_Inch4_0 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#endif
/** 判断是否为4.7inch 375*667 750*1334 */
#ifndef kIs_Inch4_7
#define kIs_Inch4_7 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#endif

/** 判断是否为5.5inch 414*1104 1242*2208 */
#ifndef kIs_Inch5_5
#define kIs_Inch5_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#endif

///主题色
#ifndef kAppRedColor
#define kAppRedColor kRGBA(250,80,60,1.0)
#endif

#endif /* TUUIMacro_h */
