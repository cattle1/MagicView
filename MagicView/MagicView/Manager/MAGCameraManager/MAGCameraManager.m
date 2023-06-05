//
//  MAGCameraManager.m
//  MagicView
//
//  Created by LL on 2021/10/29.
//

#import "MAGCameraManager.h"

#import <AVFoundation/AVCaptureDevice.h>

#import "MAGImport.h"

@interface MAGCameraManager ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, copy) void(^cameraPhotoBlock)(UIImage *image);

@end

@implementation MAGCameraManager

static MAGCameraManager *_cameraManager;
+ (void)useCamera:(void (^) (UIImage *image))block {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [mMainWindow m_showErrorHUDFromText:@"当前设备无法使用相机"];
        
        [MAGClickAgent event:@"设备无法使用相机"];
        return;
    }
    
    [self requestCameraAuthorization:^(BOOL granted) {
        if (granted) {
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerController.mediaTypes = @[@"public.image"];
            _cameraManager = [[MAGCameraManager alloc] init];
            _cameraManager.cameraPhotoBlock = block;
            pickerController.delegate = _cameraManager;
            pickerController.allowsEditing = YES;
            if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
                pickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            } else {
                pickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            pickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
            [mCurrentViewController presentViewController:pickerController animated:YES completion:nil];
        }
    }];
    
    [MAGClickAgent event:@"用户点击了相机"];
}

+ (void)requestCameraAuthorization:(void (^) (BOOL granted))block {
    dispatch_async(dispatch_get_main_queue(), ^{
        AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (authorizationStatus) {
            case AVAuthorizationStatusNotDetermined: {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    mDispatchAsyncOnMainQueue(!block ?: block(granted));
                }];
            }
                break;
            case AVAuthorizationStatusRestricted: {
                [mMainWindow m_showErrorHUDFromText:@"您暂时没有权限使用相机"];
                !block ?: block(NO);
                [MAGClickAgent event:@"用户没有权限使用相机"];
            }
                break;
            case AVAuthorizationStatusDenied: {
                NSString *message = [NSString stringWithFormat:@"请在iPhone的->设置%@选项中，允许%@访问你的摄像头", mAppName, mAppName];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"相机权限未开启" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:UIApplicationOpenSettingsURLString.m_URL options:@{} completionHandler:nil];
                }];
                [alert addAction:cancelAction];
                [alert addAction:sureAction];
                [mCurrentViewController presentViewController:alert animated:YES completion:nil];
                !block ?: block(NO);
                [MAGClickAgent event:@"用户拒绝了相机使用权限"];
            }
                break;
            case AVAuthorizationStatusAuthorized: {
                !block ?: block(YES);
                [MAGClickAgent event:@"用户同意了相机使用权限"];
            }
                break;
        }
    });
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (image == nil) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    
    NSData *data = UIImageJPEGRepresentation(image, 0.9);
    image = [UIImage imageWithData:data];
    !_cameraManager.cameraPhotoBlock ?: _cameraManager.cameraPhotoBlock(image);
    _cameraManager = nil;
    
    [MAGClickAgent event:@"用户用相机成功拍摄了照片"];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    _cameraManager = nil;
    
    [MAGClickAgent event:@"用户在相机点击了取消"];
}

@end
