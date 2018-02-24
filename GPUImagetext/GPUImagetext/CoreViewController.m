//
//  CoreViewController.m
//  GPUImagetext
//
//  Created by 靓萌服饰靓萌服饰 on 2018/2/7.
//  Copyright © 2018年 靓萌服饰靓萌服饰. All rights reserved.
//

#import "CoreViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "GPUImage.h"
#import "PngUtil.h"
#import "QMImageHelper.h"
#import "QM3DLightFilter.h"
#import "QMFishEyeFilter.h"

@interface CoreViewController ()
@property(nonatomic,strong)GPUImageView *imageView;
@property (nonatomic, strong) GPUImageFilterPipeline *pipleLine;
@end

@implementation CoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self filetext];
   
}
-(void)filetext{
  self.imageView  =[[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, 400, 600)];
    [self.view addSubview:self.imageView];
    UIButton *btt=[[UIButton alloc] initWithFrame:CGRectMake(100, 500, 200, 30)];
    [btt setTitle:@"滤镜1" forState:UIControlStateNormal];
    btt.backgroundColor=[UIColor greenColor];
    btt.titleLabel.textColor=[UIColor blueColor];
    UIButton *btt1=[[UIButton alloc] initWithFrame:CGRectMake(100, 600, 200, 30)];
    btt1.backgroundColor=[UIColor greenColor];
    [btt1 setTitle:@"滤镜2" forState:UIControlStateNormal];
    btt1.titleLabel.textColor=[UIColor blueColor];
    [btt addTarget:self action:@selector(startFilerfirst) forControlEvents:UIControlEventTouchUpInside];
    [btt1 addTarget:self action:@selector(startFilertwo) forControlEvents:UIControlEventTouchUpInside];
    [self.imageView addSubview:btt];
    [self.imageView addSubview:btt1];
    
    
}
-(void)startFilerfirst{
    GPUImagePicture *picture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"1.jpg"]];
    
    QMFishEyeFilter *filter = [[QMFishEyeFilter alloc] init];
    
    [picture addTarget:filter];
    [filter addTarget:_imageView];
    
    [picture processImage];
}
-(void)startFilertwo{
    // 加载图片
    GPUImagePicture *picture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"3.jpg"]];
    
    QM3DLightFilter *filter = [[QM3DLightFilter alloc] init];
    
    [picture addTarget:filter];
    [filter addTarget:_imageView];
    
    [picture processImage];
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
