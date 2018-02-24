#import <UIKit/UIKit.h>
#import "GPUImageContext.h"

typedef NS_ENUM(NSUInteger, GPUImageFillModeType) {
    kGPUImageFillModeStretch,                       // Stretch to fill the full view, which may distort the image outside of its normal aspect ratio  完整的视图，可能会扭曲图像的正常宽高比。
    kGPUImageFillModePreserveAspectRatio,           // Maintains the aspect ratio of the source image, adding bars of the specified background color  维护源图像的纵横比，添加指定背景颜色的条。
    kGPUImageFillModePreserveAspectRatioAndFill     // Maintains the aspect ratio of the source image, zooming in on its center to fill the view  保持源图像的纵横比，放大其中心以填充视图。
};



/**
 UIView subclass to use as an endpoint for displaying GPUImage outputs
 */
@interface GPUImageView : UIView <GPUImageInput>
{
    GPUImageRotationMode inputRotation;
}

/** The fill mode dictates how images are fit in the view, with the default being kGPUImageFillModePreserveAspectRatio
 
 填充模式决定图像是如何在视图中,使用默认kGPUImageFillModePreserveAspectRatio
 */
@property(readwrite, nonatomic) GPUImageFillModeType fillMode;

/** This calculates the current display size, in pixels, taking into account Retina scaling factors
 
 这将计算当前的显示大小，以像素为单位，考虑到视网膜的比例因子
 */
@property(readonly, nonatomic) CGSize sizeInPixels;

@property(nonatomic) BOOL enabled;

/** Handling fill mode
 
 @param redComponent Red component for background color
 @param greenComponent Green component for background color
 @param blueComponent Blue component for background color
 @param alphaComponent Alpha component for background color
 */
- (void)setBackgroundColorRed:(GLfloat)redComponent green:(GLfloat)greenComponent blue:(GLfloat)blueComponent alpha:(GLfloat)alphaComponent;

- (void)setCurrentlyReceivingMonochromeInput:(BOOL)newValue;

@end
