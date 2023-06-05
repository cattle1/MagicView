//
//  MAGPhotoManager.m
//  MagicView
//
//  Created by LL on 2021/10/30.
//

#import "MAGPhotoManager.h"

#import <PhotosUI/PhotosUI.h>

#import "MAGImport.h"

@interface MAGPhotoManager ()<PHPickerViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, copy) void(^selectedPhotoBlock)(UIImage *image);

@end

@implementation MAGPhotoManager

static MAGPhotoManager *_photoManager;
+ (void)usePhotoLibrary:(void (^) (UIImage *image))block {
    [self mp_requestPhotoLibraryAuthorization:^(BOOL isGranted) {
        if (!isGranted) return;
        
        _photoManager = [[MAGPhotoManager alloc] init];
        _photoManager.selectedPhotoBlock = block;
        if (@available(iOS 14.0, *)) {
            PHPickerConfiguration *configuration = [[PHPickerConfiguration alloc] init];
            configuration.filter = [PHPickerFilter anyFilterMatchingSubfilters:@[PHPickerFilter.imagesFilter, PHPickerFilter.livePhotosFilter]];
            configuration.selectionLimit = 1;
            
            PHPickerViewController *pickerViewController = [[PHPickerViewController alloc] initWithConfiguration:configuration];
            pickerViewController.delegate = _photoManager;
            [mCurrentViewController presentViewController:pickerViewController animated:YES completion:nil];
        } else {
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            pickerController.delegate = _photoManager;
            pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerController.allowsEditing = YES;
            pickerController.mediaTypes = @[@"public.image"];
            [mCurrentViewController presentViewController:pickerController animated:YES completion:nil];
        }
    }];
    
    [MAGClickAgent event:@"用户开始访问相册"];
}

+ (void)saveMediasToPhotoLibrary:(NSArray *)medias {
    if (mObjectIsEmpty(medias)) {
        [mMainWindow m_showErrorHUDFromText:@"保存失败"];
        return;
    }
    
    [self mp_requestPhotoLibraryAuthorization:^(BOOL isGranted) {
        if (!isGranted) return;
        [self mp_saveImagesToPhotoLibrary:medias];
    }];
    
    [MAGClickAgent event:@"用户准备将图片保存到相册"];
}


#pragma mark - PHPickerViewControllerDelegate
- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results API_AVAILABLE(ios(14.0)) {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (results.count > 0) {
        NSItemProvider *itemProvider = results.firstObject.itemProvider;
        if ([itemProvider canLoadObjectOfClass:UIImage.class]) {
            void (^t_block)(UIImage *) = _photoManager.selectedPhotoBlock;
            [itemProvider loadObjectOfClass:UIImage.class completionHandler:^(__kindof id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error) {
                if ([object isKindOfClass:UIImage.class]) {
                    NSData *data = UIImageJPEGRepresentation(object, 0.9);
                    mDispatchAsyncOnMainQueue(!t_block ?: t_block([UIImage imageWithData:data]));
                }
            }];
        }
        [MAGClickAgent event:@"用户在相册点击了照片"];
    } else {
        [MAGClickAgent event:@"用户在相册点击了取消"];
    }
    
    _photoManager = nil;
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (image == nil) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    
    NSData *data = UIImageJPEGRepresentation(image, 0.9);
    !_photoManager.selectedPhotoBlock ?: _photoManager.selectedPhotoBlock([UIImage imageWithData:data]);
    _photoManager = nil;
    
    [MAGClickAgent event:@"用户在相册点击了照片"];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    _photoManager = nil;
    
    [MAGClickAgent event:@"用户在相册点击了取消"];
}


#pragma mark - Private
+ (void)mp_requestPhotoLibraryAuthorization:(void (^) (BOOL granted))block {
    dispatch_async(dispatch_get_main_queue(), ^{
        PHAuthorizationStatus authorizationStatus;
        if (@available(iOS 14.0, *)) {
            if (mPhotoLibraryAddAuthorization && !mPhotoLibraryAuthorization) {
                authorizationStatus = [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelAddOnly];
            } else {
                authorizationStatus = [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelReadWrite];
            }
        } else {
            authorizationStatus = [PHPhotoLibrary authorizationStatus];
        }
        
        switch (authorizationStatus) {
            case PHAuthorizationStatusNotDetermined: {
                if (@available(iOS 14.0, *)) {
                    PHAccessLevel level = PHAccessLevelReadWrite;
                    if (mPhotoLibraryAddAuthorization && !mPhotoLibraryAuthorization) {
                        level = PHAccessLevelAddOnly;
                    }
                    [PHPhotoLibrary requestAuthorizationForAccessLevel:level handler:^(PHAuthorizationStatus status) {
                        BOOL granted = (status == PHAuthorizationStatusAuthorized) || (status == PHAuthorizationStatusLimited);
                        mDispatchAsyncOnMainQueue(!block ?: block(granted));
                    }];
                } else {
                    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                        BOOL granted = (status == PHAuthorizationStatusAuthorized);
                        mDispatchAsyncOnMainQueue(!block ?: block(granted));
                    }];
                }
            }
                break;
            case PHAuthorizationStatusRestricted: {
                [mMainWindow m_showErrorHUDFromText:@"您暂时没有权限使用相册"];
                !block ?: block(NO);
                [MAGClickAgent event:@"用户没有权限使用相册"];
            }
                break;
            case PHAuthorizationStatusDenied: {
                NSString *message = [NSString stringWithFormat:@"请在iPhone的->设置%@选项中，允许%@访问你的相册", mAppName, mAppName];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"相册权限未开启" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:UIApplicationOpenSettingsURLString.m_URL options:@{} completionHandler:nil];
                }];
                [alert addAction:cancelAction];
                [alert addAction:sureAction];
                [mCurrentViewController presentViewController:alert animated:YES completion:nil];
                !block ?: block(NO);
                [MAGClickAgent event:@"用户拒绝了相册使用权限"];
            }
                break;
            case PHAuthorizationStatusAuthorized: {
                !block ?: block(YES);
                [MAGClickAgent event:@"用户同意了相册全部使用权限"];
            }
                break;
            case PHAuthorizationStatusLimited: {
                !block ?: block(YES);
                [MAGClickAgent event:@"用户同意了相册有限使用权限"];
            }
                break;
        }
    });
}

+ (void)mp_saveImagesToPhotoLibrary:(NSArray *)images {
    // 这里需要一张张的存到相册，因为一起存的话只要有一张图片存的过程中发生了错误就会导致整个存储过程都失败
    NSMutableArray<NSNumber *> *indexsArray = [NSMutableArray array];
    NSMutableArray<NSNumber *> *failedIndexsArray = [NSMutableArray array];
    NSInteger totalImages = images.count;
    [images enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self mp_saveImageToPhotoLibrary:obj completion:^(BOOL isSuccess) {
            if (isSuccess) {
                [indexsArray addObject:@(idx)];
            } else {
                [failedIndexsArray addObject:@(idx)];
            }
            
            // 判断所有图片是否都保存完毕
            if (indexsArray.count + failedIndexsArray.count == totalImages) {
                if (indexsArray.count == 0) {
                    mDispatchAsyncOnMainQueue([mMainWindow m_showErrorHUDFromText:@"保存失败"]);
                    [MAGClickAgent event:@"图片保存到相册失败"];
                } else {
                    mDispatchAsyncOnMainQueue([mMainWindow m_showErrorHUDFromText:@"保存成功"]);
                    [MAGClickAgent event:@"图片保存到相册成功"];
                }
            }
            
        }];
    }];
}

+ (void)mp_saveImageToPhotoLibrary:(id)image completion:(void (^)(BOOL isSuccess))completion  {
    if ([image isKindOfClass:UIImage.class]) {
        [self mp_saveImageToPhotoLibraryWithImageObj:(UIImage *)image completion:completion];
        return;
    }
    
    if ([image isKindOfClass:NSString.class]) {
        [self mp_saveImageToPhotoLibraryFromImageURL:(NSString *)image completion:completion];
        return;
    }
    !completion ?: completion(NO);
}

+ (void)mp_saveImageToPhotoLibraryFromImageURL:(NSString *)imageURL completion:(void (^)(BOOL isSuccess))completion {
    // 获取本地图片
    YYImage *localImage = [YYImage imageWithContentsOfFile:imageURL];
    if (localImage) {
        [self mp_saveImageToPhotoLibraryWithImageObj:localImage completion:completion];
        return;
    }
    
    // 下载图片
    [[YYWebImageManager sharedManager] requestImageWithURL:imageURL.m_URL options:kNilOptions progress:nil transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (image) {
            [self mp_saveImageToPhotoLibraryWithImageObj:image completion:completion];
        } else {
            !completion ?: completion(NO);
        }
    }];
}

+ (void)mp_saveImageToPhotoLibraryWithImageObj:(UIImage *)image completion:(void (^)(BOOL isSuccess))completion {
    __block NSString *localIdentifier = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        localIdentifier = [self createImageLocalIdentifierFromMedia:image];
    } completionHandler:^(BOOL isSuccess, NSError * _Nullable error) {
        if (!isSuccess || localIdentifier == nil) {
            !completion ?: completion(NO);
            return;
        }
        
        [self mp_saveToMyPhotoLibraryFromAssetIdentifier:localIdentifier completion:^(BOOL isSuccess) {
            !completion ?: completion(isSuccess);
        }];
    }];
}

/// 创建一个图片相册对象
+ (nullable NSString *)createImageLocalIdentifierFromMedia:(id)media {
    if ([media isKindOfClass:UIImage.class]) {
        UIImage *image = (UIImage *)media;
        // 判断是不是Gif图
        if ([image isKindOfClass:YYImage.class]) {
            NSData *gifData = [(YYImage *)image animatedImageData];
            if (gifData) {
                PHAssetCreationRequest *request = [PHAssetCreationRequest creationRequestForAsset];
                [request addResourceWithType:PHAssetResourceTypePhoto data:gifData options:[[PHAssetResourceCreationOptions alloc] init]];
                return request.placeholderForCreatedAsset.localIdentifier;
            }
        }
        
        return [PHAssetCreationRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
    }
    
    if ([media isKindOfClass:NSString.class]) {
        return [PHAssetCreationRequest creationRequestForAssetFromVideoAtFileURL:[(NSString *)media m_URL]].placeholderForCreatedAsset.localIdentifier;
    }
    return nil;
}

/// 根据标识符保存到我的相册
+ (void)mp_saveToMyPhotoLibraryFromAssetIdentifier:(NSString *)assetIdentifier completion:(void (^)(BOOL isSuccess))completion {
    [self mp_getMyPhotoAlbum:^(PHAssetCollection * _Nullable myAlbum) {
        if (myAlbum == nil) {
            !completion ?: completion(NO);
            return;
        }
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetIdentifier] options:nil].lastObject;
            PHAssetCollectionChangeRequest *requestCollection = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:myAlbum];
            [requestCollection insertAssets:@[asset] atIndexes:[NSIndexSet indexSetWithIndex:0]];
            !completion ?: completion(YES);
        } completionHandler:^(BOOL isSuccess, NSError * _Nullable error) {
            if (!isSuccess) {
                !completion ?: completion(NO);
            }
        }];
    }];
}

/// 获取自定义相册簿
+ (void)mp_getMyPhotoAlbum:(void (^) (PHAssetCollection * _Nullable myAlbum))completion {
    {// 获取本地相册
        PHAssetCollection *collection = [self mp_getMyLocalPhotoLibraryWithName:mAppName];
        if (collection) {
            !completion ?: completion(collection);
            return;
        }
    }
    
    static NSMutableArray *customPhotoAlbumQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        customPhotoAlbumQueue = [NSMutableArray array];
    });
    
    if (customPhotoAlbumQueue.count > 0) {// 正在创建相册
        [customPhotoAlbumQueue addObject:completion];
        return;
    }
    
    [customPhotoAlbumQueue addObject:completion];
    
    // 创建我的相册
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:mAppName];
    } completionHandler:^(BOOL isSuccess, NSError * _Nullable error) {
        [customPhotoAlbumQueue enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            void (^t_block)(PHAssetCollection *) = obj;
            if (isSuccess) {
                !t_block ?: t_block([self mp_getMyLocalPhotoLibraryWithName:mAppName]);
            } else {
                !t_block ?: t_block(nil);
            }
            [customPhotoAlbumQueue removeObject:obj];
        }];
    }];
}

/// 根据相册标识符获取本地自定义相册簿
+ (nullable PHAssetCollection *)mp_getMyLocalPhotoLibraryWithName:(NSString *)albumName {
    PHFetchResult<PHAssetCollection *> *results = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *obj in results) {
        if ([obj.localizedTitle isEqualToString:mAppName]) {
            return obj;
        }
    }
    return nil;
}

@end
