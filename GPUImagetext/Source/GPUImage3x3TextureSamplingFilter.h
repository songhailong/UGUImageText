#import "GPUImageFilter.h"

extern NSString *const kGPUImageNearbyTexelSamplingVertexShaderString;

@interface GPUImage3x3TextureSamplingFilter : GPUImageFilter
{
    GLint texelWidthUniform, texelHeightUniform;
    
    CGFloat texelWidth, texelHeight;
    BOOL hasOverriddenImageSizeFactor;
}

// The texel width and height determines how far out to sample from this texel. By default, this is the normalized width of a pixel, but this can be overridden for different effects.
//texel的宽度和高度决定了从这个texel取样的距离。默认情况下，这是一个像素的归一化宽度，但是对于不同的效果，这是可以重写的。
@property(readwrite, nonatomic) CGFloat texelWidth; 
@property(readwrite, nonatomic) CGFloat texelHeight; 


@end
