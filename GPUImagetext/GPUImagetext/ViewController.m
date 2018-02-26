//
//  ViewController.m
//  GPUImagetext
//
//  Created by 靓萌服饰靓萌服饰 on 2018/2/7.
//  Copyright © 2018年 靓萌服饰靓萌服饰. All rights reserved.
//

#import "ViewController.h"
#import "GPUImage.h"
#import "SecondViewController.h"
#import "CoreViewController.h"
#import "FaceTextViewController.h"
NSString *const kTwoInputFragmentShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 void main()
 {
     highp vec4 oneInputColor = texture2D(inputImageTexture, textureCoordinate);
     highp vec4 twoInputColor = texture2D(inputImageTexture2, textureCoordinate2);
     
     highp float range = distance(textureCoordinate, vec2(0.5, 0.5));
     
     highp vec4 dstClor = oneInputColor;
     if (range < 0.25) {
         dstClor = twoInputColor;
     }else {
         //dstClor = vec4(vec3(1.0 - oneInputColor), 1.0);
         if (oneInputColor.r < 0.001 && oneInputColor.g < 0.001 && oneInputColor.b < 0.001) {
             dstClor = vec4(1.0);
         }else {
             dstClor = vec4(1.0, 0.0, 0.0, 1.0);
         }
     }
     
     gl_FragColor = dstClor;
 }
 );
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
    UIButton *bt=[[UIButton alloc] initWithFrame:CGRectMake(100, 200, 200, 30)];
    bt.titleLabel.text=@"跳转";
    bt.backgroundColor=[UIColor redColor];
    [bt addTarget:self action:@selector(startButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
    
    UIButton *bt5=[[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 30)];
    bt5.titleLabel.text=@"跳转";
    bt5.backgroundColor=[UIColor redColor];
    [bt5 addTarget:self action:@selector(startButton5) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt5];
    
    GPUImageView *imamgeview3=[[GPUImageView alloc] initWithFrame:CGRectMake(220, 400, 200, 300)];
    [self.view addSubview:imamgeview3];
    /*  GPUImageUIElement   GPUImageHueFilter  都继承 GPUImageOutput
     
     */
    [imamgeview3 setBackgroundColorRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    GPUImagePicture *picture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"2.jpg"]];
    
    // 滤镜
    GPUImageCannyEdgeDetectionFilter *cannyFilter = [[GPUImageCannyEdgeDetectionFilter alloc] init];
    GPUImageGammaFilter *gammaFilter = [[GPUImageGammaFilter alloc] init];
    
    [picture addTarget:cannyFilter];
    [picture addTarget:gammaFilter];
    
    // GPUImageTwoInputFilter
    GPUImageTwoInputFilter *twoFilter = [[GPUImageTwoInputFilter alloc] initWithFragmentShaderFromString:kTwoInputFragmentShaderString];
    
    [cannyFilter addTarget:twoFilter];
    [gammaFilter addTarget:twoFilter];
    [twoFilter addTarget:imamgeview3];
    
    [picture processImage];
    
   
    
    
}
-(void)Hue{
    // bgView第一张原始图片
    UIView *bgView=[[UIView alloc] initWithFrame:CGRectMake(0, 400, 200, 300)];
    UIImageView *imageview1=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 300)];
    [bgView addSubview:imageview1];
    UIImage *image1=[UIImage imageNamed: @"1.jpg"];
    imageview1.image=image1;
    UILabel *lable=[[UILabel alloc] initWithFrame:CGRectMake(77, 210, 130, 20)];
    lable.text=@"我是文字";
    lable.textColor=[UIColor blueColor];
    [bgView addSubview:lable];
    [self.view addSubview:bgView];
    GPUImageView *imamgeview3=[[GPUImageView alloc] initWithFrame:CGRectMake(220, 400, 200, 300)];
    [self.view addSubview:imamgeview3];
    /*  GPUImageUIElement   GPUImageHueFilter  都继承 GPUImageOutput
     
     */
    [imamgeview3 setBackgroundColorRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    //ui 对象
    GPUImageUIElement *element = [[GPUImageUIElement alloc] initWithView:bgView];
    //颜色过滤器
    GPUImageHueFilter *filter2 = [[GPUImageHueFilter alloc] init];
    //filter2.hue=0.001;
    
    //添加 谁来响
    [element addTarget:filter2];
    //添加谁来响应
    [filter2 addTarget:imamgeview3];
    //仍然图像处理
    [filter2 useNextFrameForImageCapture];
    //刷新
    [element update];
}

-(void)Grayscale{
    GPUImageView *imageview=[[GPUImageView alloc] initWithFrame:CGRectMake(138, 70, 200, 300)];
    [self.view addSubview:imageview];
    [imageview setBackgroundColorRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    
    GPUImagePicture *picture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"1.jpg"]];
    //将一个图像转换成灰度
    GPUImageGrayscaleFilter *filter = [[GPUImageGrayscaleFilter alloc] init];
    [picture addTarget:filter];
    [filter addTarget:imageview];
    [filter useNextFrameForImageCapture];
    //过滤图片
    [picture processImage];
}
-(void)startButton{
    SecondViewController *sc=[[SecondViewController alloc] init];
    [self presentViewController:sc animated:YES completion:nil];
}
-(void)startButton5{
//    CoreViewController *sc=[[CoreViewController alloc] init];
//    [self presentViewController:sc animated:YES completion:nil];
    FaceTextViewController *vc=[[FaceTextViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
