//
//  SecondViewController.m
//  GPUImagetext
//
//  Created by 靓萌服饰靓萌服饰 on 2018/2/9.
//  Copyright © 2018年 靓萌服饰靓萌服饰. All rights reserved.
//

#import "SecondViewController.h"
#import "GPUImage.h"
#import "PngUtil.h"
#import "QMImageHelper.h"
#define DOCUMENT(path) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:path]


#define DOCUMENT(path) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:path]

NSString *const kVertexShaderString = SHADER_STRING
(
 attribute vec4 position;
 attribute vec4 inputTextureCoordinate;
 
 varying vec2 textureCoordinate;
 
 void main()
 {
     gl_Position = position;
     textureCoordinate = inputTextureCoordinate.xy;
 }
 );

NSString *const kFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 void main()
 {
     gl_FragColor = texture2D(inputImageTexture, textureCoordinate);
 }
 );
@interface SecondViewController ()
@property(nonatomic,strong)GPUImageView *imageView;
@property (nonatomic, strong) GPUImageRawDataInput *rawDataInput;
@property (nonatomic, assign) GLuint texture;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [_imageView setBackgroundColorRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    CGRect frame=self.view.frame;
    _imageView=[[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self.view addSubview:_imageView];
    
    UIButton *btt=[[UIButton alloc] initWithFrame:CGRectMake(100, 500, 200, 30)];
    [btt setTitle:@"读取RGBA数据" forState:UIControlStateNormal];
    btt.backgroundColor=[UIColor greenColor];
    btt.titleLabel.textColor=[UIColor blueColor];
    UIButton *btt1=[[UIButton alloc] initWithFrame:CGRectMake(100, 600, 200, 30)];
    btt1.backgroundColor=[UIColor greenColor];
    [btt1 setTitle:@"生成RGBA数据" forState:UIControlStateNormal];
    btt1.titleLabel.textColor=[UIColor blueColor];
    [btt addTarget:self action:@selector(startButtonTapped) forControlEvents:UIControlEventTouchUpInside];
     [btt1 addTarget:self action:@selector(finishButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.imageView addSubview:btt];
    [self.imageView addSubview:btt1];
    
    UIButton *btt2=[[UIButton alloc] initWithFrame:CGRectMake(100, 550, 200, 30)];
    [btt2 setTitle:@"纹理输入" forState:UIControlStateNormal];
    btt2.backgroundColor=[UIColor greenColor];
    btt2.titleLabel.textColor=[UIColor blueColor];
    UIButton *btt3=[[UIButton alloc] initWithFrame:CGRectMake(100, 650, 200, 30)];
    btt3.backgroundColor=[UIColor greenColor];
    [btt3 setTitle:@"纹理输出" forState:UIControlStateNormal];
    btt3.titleLabel.textColor=[UIColor blueColor];
    [btt3 addTarget:self action:@selector(textureOutputButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [btt2 addTarget:self action:@selector(textureInputButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.imageView addSubview:btt2];
    [self.imageView addSubview:btt3];
    [self.imageView addSubview:btt];
    [self.imageView addSubview:btt1];
    self.view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.imageView];
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGRect frame=self.view.frame;
    self.imageView.frame=CGRectMake(0, 0, frame.size.width, frame.size.height);
     NSLog(@"已经跳转了");
}
#pragma mark*******纹理输入

-(void)textureInputButtonTapped{
    // 加载纹理
    UIImage *image = [UIImage imageNamed:@"3.jpg"];
    size_t width = CGImageGetWidth(image.CGImage);
    size_t height = CGImageGetHeight(image.CGImage);
    unsigned char *imageData = [QMImageHelper convertUIImageToBitmapRGBA8:image];
    
    glGenTextures(1, &_texture);
    glBindTexture(GL_TEXTURE_2D, _texture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)width, (GLsizei)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
    glBindTexture(GL_TEXTURE_2D, 0);
    
    GPUImageTextureInput *textureInput = [[GPUImageTextureInput alloc] initWithTexture:_texture size:CGSizeMake(width, height)];
    [textureInput addTarget:_imageView];
    [textureInput processTextureWithFrameTime:kCMTimeIndefinite];
    
    // 清理
    if (imageData) {
        free(imageData);
        image = NULL;
    }
}
#pragma mark*******纹理输出
-(void)textureOutputButtonTapped{
    
    NSLog(@"-；-；-；-；-；-那就看你尽可能将");
    UIImage *image = [UIImage imageNamed:@"3.jpg"];
    size_t width = CGImageGetWidth(image.CGImage);
    size_t height = CGImageGetHeight(image.CGImage);
    
    // GPUImagePicture
    GPUImagePicture *picture = [[GPUImagePicture alloc] initWithImage:image];
    
    // GPUImageTextureOutput
    GPUImageTextureOutput *output = [[GPUImageTextureOutput alloc] init];
    
    [picture addTarget:output];
    [picture addTarget:_imageView];
    
    [picture processImage];
    
    // 生成图片
    runSynchronouslyOnContextQueue([GPUImageContext sharedImageProcessingContext], ^{
        // 设置程序
        GLProgram *progam = [[GPUImageContext sharedImageProcessingContext] programForVertexShaderString:kVertexShaderString fragmentShaderString:kFragmentShaderString];
        [progam addAttribute:@"position"];
        [progam addAttribute:@"inputTextureCoordinate"];
        
        // 激活程序
        [GPUImageContext setActiveShaderProgram:progam];
        [GPUImageContext useImageProcessingContext];
        
        // GPUImageFramebuffer
        GPUImageFramebuffer *frameBuffer = [[GPUImageContext sharedFramebufferCache] fetchFramebufferForSize:CGSizeMake(width, height) onlyTexture:NO];
        [frameBuffer lock];
        
        static const GLfloat imageVertices[] = {
            -1.0f, -1.0f,
            1.0f, -1.0f,
            -1.0f,  1.0f,
            1.0f,  1.0f,
        };
        
        static const GLfloat textureCoordinates[] = {
            0.0f, 0.0f,
            1.0f, 0.0f,
            0.0f, 1.0f,
            1.0f, 1.0f,
        };
        
        glClearColor(1.0, 1.0, 1.0, 1.0);
        glClear(GL_COLOR_BUFFER_BIT);
        glViewport(0, 0, (GLsizei)width, (GLsizei)height);
        
        glActiveTexture(GL_TEXTURE2);
        glBindTexture(GL_TEXTURE_2D, output.texture);
        
        glUniform1i([progam uniformIndex:@"inputImageTexture"], 2);
        
        glVertexAttribPointer([progam attributeIndex:@"position"], 2, GL_FLOAT, 0, 0, imageVertices);
        glVertexAttribPointer([progam attributeIndex:@"inputTextureCoordinate"], 2, GL_FLOAT, 0, 0, textureCoordinates);
        
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        
        CGImageRef outImage = [frameBuffer newCGImageFromFramebufferContents];
        NSData *pngData = UIImagePNGRepresentation([UIImage imageWithCGImage:outImage]);
        [pngData writeToFile:DOCUMENT(@"texture_output.png") atomically:YES];
        
        NSLog(@"-；-；-；-；-；-%@", DOCUMENT(@"texture_output.png"));
        
        // unlock
        [frameBuffer unlock];
        [output doneWithTexture];
    });
}
-(void)startButtonTapped{
    // 加载纹理
    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    size_t width = CGImageGetWidth(image.CGImage);
    size_t height = CGImageGetHeight(image.CGImage);
    unsigned char *imageData = [QMImageHelper convertUIImageToBitmapRGBA8:image];
    
    // 初始化GPUImageRawDataInput
    _rawDataInput = [[GPUImageRawDataInput alloc] initWithBytes:imageData size:CGSizeMake(width, height) pixelFormat:GPUPixelFormatRGBA];
    
    // 曝光滤镜
    GPUImageSolarizeFilter *filter = [[GPUImageSolarizeFilter alloc] init];
    [_rawDataInput addTarget:filter];
    [filter addTarget:_imageView];
    
    // 开始处理数据
    [_rawDataInput processData];
    
    // 清理
    if (imageData) {
        free(imageData);
        image = NULL;
    }
}

-(void)finishButtonTapped{
    // 加载纹理
    UIImage *image = [UIImage imageNamed:@"2.jpg"];
    size_t width = CGImageGetWidth(image.CGImage);
    size_t height = CGImageGetHeight(image.CGImage);
    unsigned char *imageData = [QMImageHelper convertUIImageToBitmapRGBA8:image];
    
    // 初始化GPUImageRawDataInput
    _rawDataInput = [[GPUImageRawDataInput alloc] initWithBytes:imageData size:CGSizeMake(width, height) pixelFormat:GPUPixelFormatRGBA];
    
    // 滤镜
    GPUImageSaturationFilter *filter = [[GPUImageSaturationFilter alloc] init];
    filter.saturation = 0.3;
    
    // GPUImageRawDataOutput
    GPUImageRawDataOutput *rawDataOutput = [[GPUImageRawDataOutput alloc] initWithImageSize:CGSizeMake(width, height) resultsInBGRAFormat:NO];
    [rawDataOutput lockFramebufferForReading];
    
    [_rawDataInput addTarget:filter];
    [filter addTarget:_imageView];
    [filter addTarget:rawDataOutput];
    
    // 开始处理数据
    [_rawDataInput processData];
    
    // 生成png图片
    unsigned char *rawBytes = [rawDataOutput rawBytesForImage];
    pic_data pngData = {(int)width, (int)height, 8, PNG_HAVE_ALPHA, rawBytes};
    //write_png_file([DOCUMENT(@"raw_data_output.png") UTF8String], &pngData);
    
    // 清理
    [rawDataOutput unlockFramebufferAfterReading];
    if (imageData) {
        free(imageData);
        image = NULL;
    }
    
    NSLog(@"%@", DOCUMENT(@"raw_data_output.png"));
}


-(GPUImageView *)imageView{
    if (_imageView==nil) {
        CGRect frame=self.view.frame;
        _imageView=[[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.view addSubview:_imageView];
    }
    return _imageView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
