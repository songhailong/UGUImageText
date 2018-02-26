//
//  FaceTextViewController.m
//  GPUImagetext
//
//  Created by 靓萌服饰靓萌服饰 on 2018/2/25.
//  Copyright © 2018年 靓萌服饰靓萌服饰. All rights reserved.
//

#import "FaceTextViewController.h"
#import "GPUImage.h"
#import "GPUImageBeautifyFilter.h"
#import "Masonry.h"
#import "GPUImageFilterViewController.h"
#import "BeautifyFilterViewController.h"
@interface FaceTextViewController ()
@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic, strong) GPUImageView *filterView;
@property (nonatomic, strong) UIButton *beautifyButton;
@end

@implementation FaceTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
//    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
//    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
//    self.videoCamera.horizontallyMirrorFrontFacingCamera = YES;
//    self.filterView = [[GPUImageView alloc] initWithFrame:self.view.frame];
//    self.filterView.center = self.view.center;
//
//    [self.view addSubview:self.filterView];
//    [self.videoCamera addTarget:self.filterView];
//    [self.videoCamera startCameraCapture];
//
//    self.beautifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.beautifyButton.backgroundColor = [UIColor whiteColor];
//    [self.beautifyButton setTitle:@"开启" forState:UIControlStateNormal];
//    [self.beautifyButton setTitle:@"关闭" forState:UIControlStateSelected];
//    [self.beautifyButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [self.beautifyButton addTarget:self action:@selector(beautify) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.beautifyButton];
//    [self.beautifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view).offset(-20);
//        make.width.equalTo(@100);
//        make.height.equalTo(@40);
//        make.centerX.equalTo(self.view);
//    }];
    
    
    
    
    UIButton *GPUImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    GPUImageButton.frame = CGRectMake(10, 100, 300, 30);
    GPUImageButton.backgroundColor = [UIColor blueColor];
    [GPUImageButton setTitle:@"GPUImage美颜" forState:UIControlStateNormal];
    [GPUImageButton addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:GPUImageButton];
    
    
    UIButton *BeautifyFilterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    BeautifyFilterButton.frame = CGRectMake(10, 150, 300, 30);
    BeautifyFilterButton.backgroundColor = [UIColor blueColor];
    [BeautifyFilterButton setTitle:@"BeautifyFilter美颜" forState:UIControlStateNormal];
    [BeautifyFilterButton addTarget:self action:@selector(broadCastAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:BeautifyFilterButton];

}
- (void)beautify {
    if (self.beautifyButton.selected) {
        self.beautifyButton.selected = NO;
        [self.videoCamera removeAllTargets];
        [self.videoCamera addTarget:self.filterView];
    }
    else {
        self.beautifyButton.selected = YES;
        [self.videoCamera removeAllTargets];
        GPUImageBeautifyFilter *beautifyFilter = [[GPUImageBeautifyFilter alloc] init];
        [self.videoCamera addTarget:beautifyFilter];
        [beautifyFilter addTarget:self.filterView];
    }
}
-(void)collectAction:(id)sender
{
    GPUImageFilterViewController *GPUImageVC = [[GPUImageFilterViewController alloc] init];
    [self presentViewController:GPUImageVC animated:YES completion:nil];
}

-(void)broadCastAction:(id)sender
{
   
    BeautifyFilterViewController *BeautifyFilterVC = [[BeautifyFilterViewController alloc] init];
    [self presentViewController:BeautifyFilterVC animated:YES completion:nil];
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
