//
//  NSString+Verify.h
//  GMBuy
//
//  Created by chengxianghe on 15/3/26.
//  Copyright (c) 2015年 cn. All rights reserved.
//

/**
 *  Verify : 验证
 *
 *  Email : 邮箱
 *  Mobile : 手机号
 *  CarNo : 车牌号
 *
 *  返回 : 是否有效
 *
 */

#import <Foundation/Foundation.h>

@interface NSString (Verify)

/*邮箱验证 MODIFIED BY HELENSONG*/
+ (BOOL)isValidateEmail:(NSString *)email;

/*手机号码验证 MODIFIED BY HELENSONG*/
+ (BOOL)isValidateMobile:(NSString *)mobile;

/*车牌号验证 MODIFIED BY HELENSONG*/
+ (BOOL)isValidateCarNo:(NSString *)carNo;

@end
