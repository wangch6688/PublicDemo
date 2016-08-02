//
//  ViewController.m
//  Two-dimension Code Demo
//
//  Created by wxhl on 16/8/2.
//  Copyright © 2016年 KingChuang. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (weak, nonatomic) IBOutlet UIView *PicView;

//扑捉会话
@property (nonatomic ,strong)AVCaptureSession * captureSession;

//展示 layer
@property (nonatomic ,strong)AVCaptureVideoPreviewLayer * captireVideoPreViewLayer;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _captureSession = nil;
    
    [self startReading];
    
}


-(BOOL)startReading{
    
    NSError * error = nil;

    //1.扑捉设备
    //1.初始化捕捉设备（AVCaptureDevice），类型为AVMediaTypeVideo
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //2.用captureDevice创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    //3.创建媒体数据输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    //4.实例化捕捉会话
    _captureSession = [[AVCaptureSession alloc] init];
    
    //4.1.将输入流添加到会话
    [_captureSession addInput:input];
    
    //4.2.将媒体输出流添加到会话中
    [_captureSession addOutput:captureMetadataOutput];
    
    //5.创建串行队列，并加媒体输出流添加到队列当中
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    //5.1.设置代理
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    
    //5.2.设置输出媒体数据类型为QRCode
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    //6.实例化预览图层
    _captireVideoPreViewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    
    //7.设置预览图层填充方式
    [_captireVideoPreViewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //8.设置图层的frame
    [_captireVideoPreViewLayer setFrame:_PicView.layer.bounds];
    
    //9.将图层添加到预览view的图层上
    [_PicView.layer addSublayer:_captireVideoPreViewLayer];
    
    //10.设置扫描范围
    captureMetadataOutput.rectOfInterest = CGRectMake(0.2f, 0.2f, 0.8f, 0.8f);
    
    
    //11.开始扫描
    [_captureSession startRunning];
    
    
    return YES;
    
    
}


- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    NSString * stringValue;
    //判断是否有数据
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        stringValue = metadataObj.stringValue;
    }
    NSLog(@"%@",stringValue);
    [_captureSession stopRunning];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
