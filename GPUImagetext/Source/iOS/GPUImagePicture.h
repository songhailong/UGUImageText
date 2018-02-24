#import <UIKit/UIKit.h>
#import "GPUImageOutput.h"


@interface GPUImagePicture : GPUImageOutput
{
    CGSize pixelSizeOfImage;
    BOOL hasProcessedImage;
    
    dispatch_semaphore_t imageUpdateSemaphore;
}

// Initialization and teardown
- (id)initWithURL:(NSURL *)url;
- (id)initWithImage:(UIImage *)newImageSource;
- (id)initWithCGImage:(CGImageRef)newImageSource;
- (id)initWithImage:(UIImage *)newImageSource smoothlyScaleOutput:(BOOL)smoothlyScaleOutput;
- (id)initWithCGImage:(CGImageRef)newImageSource smoothlyScaleOutput:(BOOL)smoothlyScaleOutput;
- (id)initWithImage:(UIImage *)newImageSource removePremultiplication:(BOOL)removePremultiplication;
- (id)initWithCGImage:(CGImageRef)newImageSource removePremultiplication:(BOOL)removePremultiplication;
- (id)initWithImage:(UIImage *)newImageSource smoothlyScaleOutput:(BOOL)smoothlyScaleOutput removePremultiplication:(BOOL)removePremultiplication;
- (id)initWithCGImage:(CGImageRef)newImageSource smoothlyScaleOutput:(BOOL)smoothlyScaleOutput removePremultiplication:(BOOL)removePremultiplication;

// Image rendering
- (void)processImage;
- (CGSize)outputImageSize;

/**
 * Process image with all targets and filters asynchronously
 * The completion handler is called after processing finished in the
 * GPU's dispatch queue - and only if this method did not return NO.
 *
 * @returns NO if resource is blocked and processing is discarded, YES otherwise
 
 处理图像与所有目标和过滤器异步。
 完成处理后调用完成处理程序。
 * GPU的调度队列——只有当这个方法没有返回NO时。
 *
 如果资源被阻塞并且处理被丢弃，则返回NO，否则。
 
 */
- (BOOL)processImageWithCompletionHandler:(void (^)(void))completion;
- (void)processImageUpToFilter:(GPUImageOutput<GPUImageInput> *)finalFilterInChain withCompletionHandler:(void (^)(UIImage *processedImage))block;

@end
