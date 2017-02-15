//
//  GMBUploadImagesHelper.m
//  GMBuy
//
//  Created by chengxianghe on 15/11/12.
//  Copyright © 2015年 cn. All rights reserved.
//

#import "GMBUploadImagesHelper.h"
#import "TUUploadRequest.h"
#import "TUNetworking.h"
#import "CBUserManager.h"

// 默认同时开启最多3个上传请求
#define kDefaultUploadMaxNum (3)

#pragma mark - Class: GMBUploadImageModel
@implementation GMBResultImageModel

@end

@implementation GMBUploadImageModel



@end

#pragma mark - Class: GMBUploadImageRequest
@interface GMBUploadImageRequest : TUUploadRequest

@property (nonatomic,   copy) NSString  *fileName;


// 尝试次数
@property (nonatomic, assign) NSInteger tryIndex;

@property (nonatomic, assign) NSInteger imageIndex;
@property (nonatomic,   copy) NSString  *imagePath;
@property (nonatomic,   copy) NSString  *resultImageUrl; // 接口返回的 图片地址

@end

@implementation GMBUploadImageRequest

- (id<TUNetworkConfigProtocol>)requestConfig {
    return nil;
}

- (NSString *)requestUrl {
    
    NSString *str = [NSString stringWithFormat:@"http://123.57.3.197/cmf/index.php?g=User&m=profile&a=avatar_upload&sign=%@",[[CBUserManager defaultManager] currentUser].sign];
    return str;
}

// 自行拼接公参
- (TURequestPublicParametersType)requestPublicParametersType {
    return TURequestPublicParametersTypeNone;
}

- (NSDictionary *)requestParameters {
   // NSString *sign = [[CBUserManager defaultManager] currentUser].sign;
    //if (sign.length) {
    //    return @{@"sign":@"728d54c4254a9883f88ab91ebc5f2a44"};
    //} else {
        return nil;
    //}
}

// 请求成功后返回的参数
- (void)requestHandleResult {
    [super requestHandleResult];
    
    if(self.responseObject == nil) {
        return ;
    }
    
    NSLog(@"上传图片接口返回:%@",self.responseObject);
    NSLog(@"上传图片接口返回:%@",self.responseObject[@"info"]);

    id temp = [self.responseObject objectForKey:@"data"];
    
    if ([temp isKindOfClass:[NSDictionary class]] && temp[@"file"] != nil) {
        self.resultImageUrl = temp[@"file"];
        NSLog(@"*********上传图index:%ld 成功!:%@", (long)self.imageIndex, self.resultImageUrl);
    } else {
        NSLog(@"*********上传图index:%ld 失败!:%@\nresponseObject:%@", (long)self.imageIndex, self.imagePath, self.responseObject);
    }
}

- (BOOL)requestVerifyResult {
    // 这里做接口返回的逻辑校验
    NSString *state = self.responseObject[@"state"];
    return ([state isKindOfClass:[NSString class]] && [state isEqualToString:@"success"]);
}

@end



#pragma mark - Class: GMBUploadImagesHelper
@interface GMBUploadImagesHelper()

//外部参数
@property (nonatomic, strong) NSArray                   *imageArray; // 需要上传的图片数组 里面存本地文件的地址
@property (nonatomic, assign) GMBUploadMode             mode;
@property (nonatomic,   copy) GMBUploadBlock            completion;
@property (nonatomic,   copy) GMBUploadProgressBlock    progress;
@property (nonatomic,   copy) GMBUploadOneProgressBlock oneProgress;
@property (nonatomic, assign) NSTimeInterval            maxTime;// 最长时间限制 默认单张60s

// 内部参数
@property (nonatomic, strong) NSMutableArray            *requestArray; // 已经发起的请求
@property (nonatomic, strong) NSMutableArray            *requestReadyArray; // 准备发起的请求
@property (nonatomic, strong) NSMutableArray            *resultModelArray; // 请求回来的保存的数据
@property (nonatomic, assign) NSInteger                 maxNum; // 同时最大并发数 默认 kDefaultUploadMaxNum
@property (nonatomic, assign) BOOL                      isEnd; // 是否已经结束请求

@end

@implementation GMBUploadImagesHelper

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestArray = [NSMutableArray array];
        self.resultModelArray = [NSMutableArray array];
        self.requestReadyArray = [NSMutableArray array];
        self.maxNum = kDefaultUploadMaxNum;
        self.maxTime = kDefauletMaxTime;
        self.isEnd = NO;
    }
    return self;
}

//MARK: - Public

- (void)cancelUploadRequest {
    // 先取消 结束回调
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endUpload) object:nil];
    self.isEnd = YES;
    
    for (GMBUploadImageRequest *request in self.requestArray) {
        [self cancelOneRequest:request];
    }
    self.completion = nil;
    self.progress = nil;
    self.oneProgress = nil;
}

- (void)uploadImages:(NSArray<__kindof id<GMBUploadImageRequestProtocol>> *)images uploadMode:(GMBUploadMode)mode progress:(GMBUploadProgressBlock)progress completion:(GMBUploadBlock)completion {
    [self uploadImages:images uploadMode:mode maxTime:(images.count * kDefauletMaxTime) progress:progress completion:completion];
}

- (void)uploadImages:(NSArray<__kindof id<GMBUploadImageRequestProtocol>> *)images uploadMode:(GMBUploadMode)mode maxTime:(NSTimeInterval)maxTime progress:(GMBUploadProgressBlock)progress completion:(GMBUploadBlock)completion {
    [self uploadImages:images uploadMode:mode maxTime:maxTime oneProgress:nil progress:progress completion:completion];
}

- (void)uploadImages:(NSArray<__kindof id<GMBUploadImageRequestProtocol>> *)images uploadMode:(GMBUploadMode)mode maxTime:(NSTimeInterval)maxTime oneProgress:(GMBUploadOneProgressBlock)oneProgress progress:(GMBUploadProgressBlock)progress completion:(GMBUploadBlock)completion {
    [self.requestArray removeAllObjects];
    [self.requestReadyArray removeAllObjects];
    [self.resultModelArray removeAllObjects];
    
    self.completion = completion;
    self.progress = progress;
    self.mode = mode;
    self.imageArray = images;
    self.maxTime = maxTime;
    self.isEnd = NO;
    
    // 根据网络环境 决定 同时上传数量
    if ([[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi]) {
        self.maxNum = kDefaultUploadMaxNum;
    } else {
        self.maxNum = 1;
    }
    
    // 定时回调endUpload
    [self performSelector:@selector(endUpload) withObject:nil afterDelay:maxTime];
    
    for (int i = 0; i < images.count; i ++) {
        GMBUploadImageRequest *request = [[GMBUploadImageRequest alloc] init];
        id<GMBUploadImageRequestProtocol> obj = images[i];
        if ([obj respondsToSelector:@selector(imageName)]) {
            request.fileName = [obj imageName];
        }
        
        request.imagePath = [obj imagePath];
        request.imageIndex = i;
        [self addRequest:request];
    }
    
    // 先回调一下progress
    if (self.progress) {
        self.progress(self.imageArray.count, self.resultModelArray.count);
    }
}

//MARK: - Private

- (void)cancelOneRequest:(GMBUploadImageRequest *)request {
    [request cancelRequest];
    request = nil;
}

- (void)removeRequest:(GMBUploadImageRequest *)request {
    [self.requestArray removeObject:request];
    [self cancelOneRequest:request];
    
    if (self.requestReadyArray.count > 0 && self.requestArray.count < self.maxNum) {
        GMBUploadImageRequest *req = [self.requestReadyArray firstObject];
        [self.requestArray addObject:req];
        [self startRequest:req];
        [self.requestReadyArray removeObject:req];
    }
}

- (void)addRequest:(GMBUploadImageRequest *)request {
    if (request != nil) {
        if (self.requestArray.count < self.maxNum) {
            [self.requestArray addObject:request];
            [self startRequest:request];
        } else {
            [self.requestReadyArray addObject:request];
        }
    }
}

- (void)startRequest:(GMBUploadImageRequest *)request {
    if (request != nil) {
        //        [request cancelRequest];
        __weak typeof(self) weakSelf = self;
        NSLog(@"*********正在上传图index:%ld ....", (long)request.imageIndex);

        request.tryIndex++;
        
        [request uploadWithConstructingBody:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:request.imagePath]
                                       name:@"file"
                                   fileName:request.fileName
                                   mimeType:@"image/jpeg"
                                      error:nil];
            
        } progress:^(NSProgress * _Nonnull progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf updateProgress:progress request:request];
            });
        } success:^(__kindof TUBaseRequest * _Nonnull baseRequest, id  _Nullable responseObject) {
            [weakSelf checkResult:(GMBUploadImageRequest *)request];
        } failur:^(__kindof TUBaseRequest * _Nonnull baseRequest, NSError * _Nonnull error) {
            [weakSelf checkResult:(GMBUploadImageRequest *)request];
        }];
    }
}

- (void)updateProgress:(NSProgress * _Nonnull)progress request:(GMBUploadImageRequest *)request {
//    NSLog(@"requestIndex:%d - progressView: %f", request.imageIndex, progress.fractionCompleted);
    if (self.oneProgress != nil) {
        self.oneProgress(request.imageIndex, progress);
    }
}

- (void)checkResult:(GMBUploadImageRequest *)request {
    
    if (self.isEnd) {
        return;
    }
    
    if (self.mode == GMBUploadMode_Retry && !request.resultImageUrl.length && request.tryIndex <= 3) {
        // 失败自动重传
        [self startRequest:request];
        return;
    } else {
        if (request.tryIndex > 3) {
            NSLog(@"上传图片失败次数超过3次:\nImagePath:%@\nImageIndex:%ld\nrequest:%@", request.imagePath, request.imageIndex, request);
        }
        GMBResultImageModel *model = [[GMBResultImageModel alloc] init];
        model.imageIndex = request.imageIndex;
        model.imagePath = request.imagePath;

        model.resultImageUrl = request.resultImageUrl;
        
        [self.resultModelArray addObject:model];
        
        [self removeRequest:request];
    }
    
    // 进度回调
    if (self.progress) {
        self.progress(self.imageArray.count, self.resultModelArray.count);
    }
    
    if (self.resultModelArray.count == self.imageArray.count) {
        [self endUpload];
    }
}

- (void)endUpload {
    // 全部完成
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endUpload) object:nil];
    
    // 排序
    [self.resultModelArray sortUsingComparator:^NSComparisonResult(GMBResultImageModel *obj1, GMBResultImageModel *obj2) {
        // 从小到大
        return obj1.imageIndex > obj2.imageIndex;
    }];
    
    NSMutableArray<__kindof GMBResultImageModel *> *successImages = [NSMutableArray array];
    NSMutableArray<__kindof GMBResultImageModel *> *failedImages = [NSMutableArray array];
    
    for (GMBResultImageModel *model in self.resultModelArray) {
        if (model.resultImageUrl.length > 0) {
            [successImages addObject:model];
        } else {
            [failedImages addObject:model];
        }
    }
    if (self.completion) {
        self.completion(successImages,failedImages);
    }
    
    [self cancelUploadRequest];
}

@end
