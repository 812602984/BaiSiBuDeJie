//
//  BSTopicShowPictureController.m
//  百思不得姐
//
//  Created by mac on 2017/4/15.
//  Copyright © 2017年 shaowu. All rights reserved.
//

#import "BSTopicShowPictureController.h"
#import "BSTopic.h"
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>
#import "BSProgressView.h"
#import "UINavigationBar+Awesome.h"
#import <Photos/Photos.h>

#define NAVBAR_CHANGE_POINT 50


@interface BSTopicShowPictureController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) UIImageView *imageView;

@property (weak, nonatomic) IBOutlet BSProgressView *progressView;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

- (PHAssetCollection *)createdCollection;

- (PHFetchResult<PHAsset *> *)createdAssets;

@end

@implementation BSTopicShowPictureController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearanceWhenContainedIn:[self class], nil] setBarTintColor:[UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearanceWhenContainedIn:[self class], nil] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //添加imageView
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)]];
    [self.scrollView addSubview:imageView];
    self.imageView = imageView;

    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];

    
//    imageView.clipsToBounds = YES;
    

    CGFloat imageW = BSScreenW;
    CGFloat imageH = BSScreenW/self.topic.width*self.topic.height;
    
    if (imageH > BSScreenH) {
        imageView.frame = CGRectMake(0, 0, imageW, imageH);
        self.scrollView.contentSize = CGSizeMake(0, imageH);
    }else {
        imageView.size = CGSizeMake(imageW, imageH);
        imageView.centerY = BSScreenH * 0.5;
    }
    
    [self.progressView setProgress:self.topic.pictureProgress animated:NO];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        CGFloat progress = 1.0 * receivedSize / expectedSize;
        [self.progressView setProgress:progress animated:NO];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
    }];
}

#pragma mark - 获取app对应的相册
- (PHAssetCollection *)createdCollection
{
    //2.创建相册,先判断是否存在.取出所有自定义相册名称
    PHFetchResult<PHAssetCollection *> *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    //取出app名字
    NSString *title = [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleNameKey];
    for (PHAssetCollection *collection in result) {  //PHFetchResult遵循快速遍历协议
        if ([collection.localizedTitle isEqualToString:title]) {//相册存在
            return collection;
            break;
        }
    }
    
    //相册不存在，那么就创建
    __block NSString *albumId = nil;
    
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        albumId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    
    if (error)  return nil;

    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[albumId] options:nil].firstObject;
}

- (PHFetchResult<PHAsset *> *)createdAssets
{
    NSError *error = nil;
    //1.保存图片到相机胶卷，同步操作
    __block NSString *assetId = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        assetId = [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image].placeholderForCreatedAsset.localIdentifier;
    } error:&error];
    if (error)  return nil;
    
    return [PHAsset fetchAssetsWithLocalIdentifiers:@[assetId] options:nil];
}

- (IBAction)close {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)save {
    //请求或检查访问权限：如果用户没有作出选择，会自动弹框，用户对弹框作出选择后，调用block；如果之前做过选择，会直接执行block
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        BSLog(@"%@",[NSThread currentThread]);
        PHAuthorizationStatus oldStatus = [PHPhotoLibrary authorizationStatus];  //之前的授权状态
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (status == PHAuthorizationStatusAuthorized) {
                [self saveImageToAlbum];
            }else if (status == PHAuthorizationStatusDenied) {
                if (oldStatus != PHAuthorizationStatusNotDetermined) {
                    [SVProgressHUD showErrorWithStatus:@"请先打开相册授权"];
                }

            }else if (status == PHAuthorizationStatusRestricted) {
                [SVProgressHUD showErrorWithStatus:@"因系统原因，无法访问相册"];
            }

        });
        
    }];
}

#pragma mark - save image to album
- (void)saveImageToAlbum {
    /*C语言函数，仅仅用来将照片存进相机胶卷*/
//    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    // 使用Photos框架（iOS 8）可以保存图片，创建和修改相册
    NSError *error = nil;
    
    //1.保存图片到相机胶卷，同步操作
    PHFetchResult<PHAsset *> *assets = self.createdAssets;
    if (assets == nil) {
        [SVProgressHUD showErrorWithStatus:@"保存图片失败"];
        return;
    }
    
    //2.创建自定义相册
    PHAssetCollection *createdCollection = self.createdCollection;
    if (createdCollection == nil) {
        [SVProgressHUD showErrorWithStatus:@"创建相册失败"];
        return;
    }
    
    //3.将照片从相机胶卷移到自定义相册,performChangesAndWait内部不能在调用自己，否则死锁
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdCollection];
        //把照片插入0的位置，作为相册的封面图片
        [request insertAssets:assets atIndexes:[NSIndexSet indexSetWithIndex:0]];

    } error:&error];
    
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存图片失败"];
    }else {
        [SVProgressHUD showSuccessWithStatus:@"保存图片成功"];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!self.imageView.image) {
        [SVProgressHUD showErrorWithStatus:@"图片未下载完毕"];
        return;
    }
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    }else {
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.backButton.hidden = YES;
    [super viewWillAppear:YES];
//    self.scrollView.delegate = self;
//    [self scrollViewDidScroll:self.scrollView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.scrollView.delegate = nil;
    [self.navigationController.navigationBar lt_reset];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)dealloc
{
    if (SVProgressHUD.isVisible) {
        [SVProgressHUD dismiss];
    }
}

@end
