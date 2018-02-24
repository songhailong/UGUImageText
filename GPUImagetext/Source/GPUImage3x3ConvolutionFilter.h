#import "GPUImage3x3TextureSamplingFilter.h"

/** Runs a 3x3 convolution kernel against the image
 */
@interface GPUImage3x3ConvolutionFilter : GPUImage3x3TextureSamplingFilter
{
    GLint convolutionMatrixUniform;
}

/** Convolution kernel to run against the image
 
 The convolution kernel is a 3x3 matrix of values to apply to the pixel and its 8 surrounding pixels.
 The matrix is specified in row-major order, with the top left pixel being one.one and the bottom right three.three
 If the values in the matrix don't add up to 1.0, the image could be brightened or darkened.
 
 卷积核与图像相匹配。
 卷积核是一个3x3矩阵的值，适用于像素和它的8个周围像素。
 矩阵在行-主顺序中指定，左上角的像素为1。三、一、三。
 如果矩阵中的值不加到1.0，图像就会变得明亮或变暗。
 */
@property(readwrite, nonatomic) GPUMatrix3x3 convolutionKernel;

@end
