//
//  GMBLifeUploadHelper.m
//  GMBuy
//
//  Created by chengxianghe on 15/9/14.
//  Copyright (c) 2015年 cn. All rights reserved.
//

#import "GMBLifeUploadHelper.h"
#include <CommonCrypto/CommonCrypto.h>
#include <zlib.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <MobileCoreServices/UTCoreTypes.h>
//#import "UIImage+FixOrientation.h"

#define MAX_IMAGEBYTES (1024.0*200)

@implementation GMBLifeUploadHelper

+ (BOOL)isGIFWithAsset:(id)asset {
    if ([asset isKindOfClass:[ALAsset class]]) {
        ALAssetRepresentation *re = [(ALAsset *)asset representationForUTI: (__bridge NSString *)kUTTypeGIF];
        return (BOOL)re;
    } else if ([asset isKindOfClass:[PHAsset class]]) {
        
        __block BOOL isGIFImage = NO;
        
        NSArray *resourceList = [PHAssetResource assetResourcesForAsset:asset];
        [resourceList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PHAssetResource *resource = obj;
            if ([resource.uniformTypeIdentifier isEqualToString:(__bridge NSString *)kUTTypeGIF]) {
                isGIFImage = YES;
                *stop = YES;
            }
        }];
        return isGIFImage;
    }
    
    return NO;
}

+ (void)getGIFDataWithAsset:(id)asset completion:(GMBGIFUploadBlock)completion {
    if ([asset isKindOfClass:[ALAsset class]]) {
        
        NSError *error = nil;
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        Byte *imageBuffer = (Byte*)malloc(rep.size);
        NSUInteger bufferSize = [rep getBytes:imageBuffer fromOffset:0.0 length:rep.size error:&error];
        NSData *imageData = [NSData dataWithBytesNoCopy:imageBuffer length:bufferSize freeWhenDone:YES];
        

        if (completion) {
            completion(imageData, error);
        }
        
    } else if ([asset isKindOfClass:[PHAsset class]]) {
        PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
        PHImageRequestOptions *options = [PHImageRequestOptions new];
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        options.synchronous = YES;
        
        [imageManager requestImageDataForAsset:asset
                                       options:options
                                 resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                                     NSLog(@"dataUTI:%@",dataUTI);
                                     
                                     //if ([dataUTI isEqualToString:(__bridge NSString *)kUTTypeGIF]) {
                                     if (completion) {
                                         completion(imageData, [info objectForKey:PHImageErrorKey]);
                                     }
                                }];
    }
}

+ (void)getImageDataWithAsset:(id)asset completion:(GMBImageDataUploadBlock)completion {
    BOOL isGIF = [self isGIFWithAsset:asset];
    if (isGIF) {
        [self getGIFDataWithAsset:asset completion:^(NSData * _Nullable imageData, NSError * _Nullable error) {
            if (completion) {
                completion(isGIF, imageData, error);
            }
        }];
    } else {
        if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            ALAssetRepresentation *assetRep = [alAsset defaultRepresentation];
            
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                CGImageRef originalImageRef = [assetRep fullResolutionImage];
                UIImage *originalImage = [UIImage imageWithCGImage:originalImageRef scale:1.0 orientation:UIImageOrientationUp];
                
                NSData *imageData = UIImageJPEGRepresentation(originalImage, 1.0);

                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(isGIF, imageData, nil);
                    }
                });
            });
        } else if ([asset isKindOfClass:[PHAsset class]]) {
            CGSize targetSize = CGSizeMake(1000, 1000);
            
            PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
            PHImageRequestOptions *options = [PHImageRequestOptions new];
            options.resizeMode = PHImageRequestOptionsResizeModeFast;

            [imageManager requestImageForAsset:asset
                                    targetSize:targetSize
                                   contentMode:PHImageContentModeAspectFill
                                       options:options
                                 resultHandler:^(UIImage *result, NSDictionary *info) {
                                     // 得到一张 UIImage，展示到界面上
                                     BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);

                                     if (downloadFinined && result) {
                                         //result = [result fixOrientation];
                                         if (completion) {
                                             NSData *imageData = UIImageJPEGRepresentation(result, 1.0);
                                             completion(isGIF, imageData, [info objectForKey:PHImageErrorKey]);
                                         }
                                     }
                                     
                                     // Download image from iCloud / 从iCloud下载图片
                                     if ([info objectForKey:PHImageResultIsInCloudKey] && !result) {
                                         PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
                                         option.networkAccessAllowed = YES;
                                         option.resizeMode = PHImageRequestOptionsResizeModeFast;
                                         [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                                             UIImage *resultImage = [UIImage imageWithData:imageData scale:0.1];
                                             if (resultImage) {
                                                 //resultImage = [resultImage fixOrientation];
                                                 NSData *imageData = UIImageJPEGRepresentation(result, 1.0);

                                                 if (completion) {
                                                     completion(isGIF, imageData, [info objectForKey:PHImageErrorKey]);
                                                 }

                                             }
                                         }];
                                     }

                                 }];

        }
    }
}

+ (NSData *)getUpLoadImageData:(UIImage *)originalImage {
    return [self getUpLoadImageData:originalImage withMaxDataSize:MAX_IMAGEBYTES];
}

+ (NSData *)getUpLoadImageData:(UIImage *)originalImage withMaxDataSize:(long long)maxSize {

    NSData *imageData = UIImageJPEGRepresentation(originalImage, 1);
    long long sizeB = imageData.length;

    // 对图片大小进行压缩--
    if(sizeB > maxSize) {
       float scale = ((float)maxSize) / sizeB;
//        // 对图片进行剪裁 这里可以设置统一规格
//        CGSize toSize = CGSizeMake(originalImage.size.width * 0.5, originalImage.size.height * 0.5);
//        UIImage *cutImage = [self scaleToSize:originalImage size:toSize];
//        imageData = UIImageJPEGRepresentation(cutImage, scale);
        
        //UIImageJPEGRepresentation方法比UIImagePNGRepresentation耗时短 而且文件更小
        imageData = UIImageJPEGRepresentation(originalImage, scale);
    }
    
    return imageData;
}

// 指定图片大小
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

// 临时保存图片
+ (NSString *)saveImage:(id)tempImage withName:(NSString *)imageName {
    
    NSData* imageData = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([tempImage isKindOfClass:[UIImage class]]) {
        //优先使用UIImageJPEGRepresentation
        imageData = UIImageJPEGRepresentation(tempImage, 1);
        if (imageData == nil) {
            imageData = UIImagePNGRepresentation(tempImage);
        }
    } else {
        imageData = tempImage;
    }
    if (imageData == nil) {
        return nil;
    }
    NSString* documentsDirectory = NSTemporaryDirectory();//[paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFileFirst = [documentsDirectory stringByAppendingPathComponent:@"commentSizeImages"];
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:fullPathToFileFirst isDirectory:&isDir];
    
    if ( !(isDir == YES && existed == YES) ) {
        [fileManager createDirectoryAtPath:fullPathToFileFirst
               withIntermediateDirectories:YES
                                attributes:nil error:nil];
    }
    
    if (imageName == nil || imageName.length == 0) {
        imageName = [self md5StringFromData:imageData];
    }
    
    NSString* fullPathToFile = [fullPathToFileFirst stringByAppendingPathComponent:imageName];
    
    if([imageData writeToFile:fullPathToFile atomically:NO]) {
        return fullPathToFile;
    } else {
        return nil;
    }
}

+ (NSString *)md5StringFromData:(NSData *)data {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

/**
 *  返回图片完整路径
 *  压缩图约为原图的 1/4
 */
+ (NSString *)setuoUploadImageWithImage:(UIImage *)image isOriginalPhoto:(BOOL)isOriginalPhoto {
    
    NSData *imageData = nil;
    
    if (isOriginalPhoto) {
        // 原图
        imageData = UIImageJPEGRepresentation(image, 1.0);
    } else {
        // 压缩的
        imageData = [self getUpLoadImageData:image];
    }
    
    return [self saveImage:imageData withName:nil];
}

+ (NSString *)getAssetName:(id)asset {
    NSString *fileName;
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = (PHAsset *)asset;
        fileName = [phAsset valueForKey:@"filename"];
    } else if ([asset isKindOfClass:[ALAsset class]]) {
        ALAsset *alAsset = (ALAsset *)asset;
        fileName = alAsset.defaultRepresentation.filename;;
    }
    return fileName;
}

+ (NSArray *)getAssetNameArray:(NSArray *)assetsArray {
    NSMutableArray *array = [NSMutableArray array];
    
    for (id asset in assetsArray) {
        NSString *fileName;
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            fileName = [phAsset valueForKey:@"filename"];
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            fileName = alAsset.defaultRepresentation.filename;;
        }
        [array addObject:fileName];
    }
    
    return array;
}


@end
