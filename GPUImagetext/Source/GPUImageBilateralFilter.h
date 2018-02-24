#import "GPUImageGaussianBlurFilter.h"

@interface GPUImageBilateralFilter : GPUImageGaussianBlurFilter
{
    CGFloat firstDistanceNormalizationFactorUniform;
    CGFloat secondDistanceNormalizationFactorUniform;
}
// A normalization factor for the distance between central color and sample color.
//中心颜色与样本颜色之间距离的标准化因子
@property(nonatomic, readwrite) CGFloat distanceNormalizationFactor;
@end
