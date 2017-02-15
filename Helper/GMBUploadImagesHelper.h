//
//  GMBUploadImagesHelper.h
//  GMBuy
//
//  Created by chengxianghe on 15/11/12.
//  Copyright © 2015年 cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 单张默认时间
#define kDefauletMaxTime (60)

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GMBUploadMode) {
    /** 失败自动重传 */
    GMBUploadMode_Retry    = 0,
    /** 失败直接忽略 */
    GMBUploadMode_Ignore   = 1
};


@class GMBResultImageModel;

typedef void(^GMBUploadBlock)(__kindof NSArray<__kindof GMBResultImageModel *> * _Nullable successImageModels, __kindof NSArray<__kindof GMBResultImageModel *> * _Nullable failedImageModels);
typedef void(^GMBUploadProgressBlock)(NSInteger totals, NSInteger completions);
typedef void(^GMBUploadOneProgressBlock)(NSInteger index, NSProgress * _Nonnull progress);


@protocol GMBUploadImageRequestProtocol <NSObject>

- (NSString * _Nonnull)imagePath;

@optional
/// 当前主题Id，头像或背景图会忽略此项.
- (NSString * _Nonnull)themeId;

///type上传文件类型：1、照片 2、头像 3、背景图.
- (NSString * _Nonnull)imageType;

- (BOOL)isGIF;
- (NSData * _Nonnull)GIFData;
- (CGFloat)imageWidth;
- (CGFloat)imageHeight;
- (NSString * _Nonnull)imageName;

@end

/**
 *  上传准备的Model
 */
@interface GMBUploadImageModel : NSObject <GMBUploadImageRequestProtocol>

@property (nonatomic, copy) NSString *imagePath;
@property (nonatomic, copy) NSString *imageType;
@property (nonatomic, copy) NSString *imageName;

@end

/**
 *  上传结果的Model
 */
@interface GMBResultImageModel : NSObject

@property (nonatomic, assign) NSInteger imageIndex;
@property (nonatomic,   copy) NSString *imagePath;
@property (nonatomic,   copy) NSString *resultImageUrl;

@end

@interface GMBUploadImagesHelper : NSObject

/**
 *  需登录 上传多张图片
 *
 *  @param images     图片路径数组
 *  @param mode       模式
 *  @param maxTime    总共最大时间限制
 *  @param progress   进度
 *  @param completion 完成
 */
- (void)uploadImages:(NSArray<__kindof id<GMBUploadImageRequestProtocol>> * _Nonnull)images
          uploadMode:(GMBUploadMode)mode
             maxTime:(NSTimeInterval)maxTime
            progress:(GMBUploadProgressBlock _Nullable)progress
          completion:(GMBUploadBlock _Nullable)completion;

/**
 *  需登录 上传多张图片 采用默认时间(每张60s)
 *
 *  @param images     图片路径数组
 *  @param mode       模式
 *  @param progress   进度
 *  @param completion 完成
 */
- (void)uploadImages:(NSArray<__kindof id<GMBUploadImageRequestProtocol>> * _Nonnull)images
          uploadMode:(GMBUploadMode)mode
            progress:(GMBUploadProgressBlock _Nullable)progress
          completion:(GMBUploadBlock _Nullable)completion;

/**
 *  需登录 上传多张图片 每张图都有自己的进度回调
 *
 *  @param images       图片路径数组
 *  @param mode         模式
 *  @param maxTime      总共最大时间限制
 *  @param oneProgress  每张图的上传进度
 *  @param progress     图片上传完成进度(张数)
 *  @param completion   完成
 */
- (void)uploadImages:(NSArray<__kindof id<GMBUploadImageRequestProtocol>> * _Nonnull)images
          uploadMode:(GMBUploadMode)mode
             maxTime:(NSTimeInterval)maxTime
         oneProgress:(GMBUploadOneProgressBlock _Nullable)oneProgress
            progress:(GMBUploadProgressBlock _Nullable)progress
          completion:(GMBUploadBlock _Nullable)completion;

/**
 *  取消请求
 */
- (void)cancelUploadRequest;

@end

NS_ASSUME_NONNULL_END
