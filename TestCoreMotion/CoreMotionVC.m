//
//  CoreMotionVC.m
//  TestCoreMotion
//
//  Created by dean on 2016/5/15.
//  Copyright © 2016年 dean. All rights reserved.
//

#import "CoreMotionVC.h"
#import <CoreMotion/CoreMotion.h>

@interface CoreMotionVC ()
{
    CMMotionManager *manager;
}

@end

@implementation CoreMotionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self getXYZ];
//    [self getGyroUpdate];
    [self getDeviceMotion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 加速器

-(void) getXYZ
{
    manager = [CMMotionManager new];
    NSOperationQueue *queue = [NSOperationQueue new];
    [manager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        if (!error) {
            double x = accelerometerData.acceleration.x;
            double y = accelerometerData.acceleration.y;
            double z = accelerometerData.acceleration.z;
            NSLog(@"acceleration: %f,,%f,,%f",x,y,z);
        }
    }];
    //關掉加速器：
//    [manager stopAccelerometerUpdates];
}

#pragma mark - 陀螺儀

-(void) getGyroUpdate
{
    manager = [CMMotionManager new];
    NSOperationQueue *queue = [NSOperationQueue new];
    [manager startGyroUpdatesToQueue:queue withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
        if (!error) {
            double x = gyroData.rotationRate.x;
            double y = gyroData.rotationRate.y;
            double z = gyroData.rotationRate.z;
            NSLog(@"gyroData: %f,,%f,,%f",x,y,z);
        }
    }];
    //關閉：
//    [manager stopGyroUpdates];
}

#pragma mark - 磁力計

-(void) getmagnetometer
{
    manager = [CMMotionManager new];
    NSOperationQueue *queue = [NSOperationQueue new];
    [manager startMagnetometerUpdatesToQueue:queue withHandler:^(CMMagnetometerData * _Nullable magnetometerData, NSError * _Nullable error) {
        if (!error) {
            double x = magnetometerData.magneticField.x;
            double y = magnetometerData.magneticField.y;
            double z = magnetometerData.magneticField.z;
            NSLog(@"magnetometerData: %f,,%f,,%f",x,y,z);
        }
    }];
    //stop
    [manager stopMagnetometerUpdates];
    
}

#pragma mark - 裝置動作

-(void)getDeviceMotion
{
    manager = [CMMotionManager new];
    NSOperationQueue *queue = [NSOperationQueue new];
    [manager startDeviceMotionUpdatesToQueue:queue withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
        //姿勢
        double pitch = motion.attitude.pitch;
        double roll = motion.attitude.roll;
        double yaw = motion.attitude.yaw;
        NSLog(@"姿勢: %f,,%f,,%f",pitch,roll,yaw);
        //三軸的轉動弧度
        double rx = motion.rotationRate.x;
        double ry = motion.rotationRate.y;
        double rz = motion.rotationRate.z;
        NSLog(@"三軸的轉動弧度: %f,,%f,,%f",rx,ry,rz);
        //三軸方向受到的重力加速度
        double gx = motion.gravity.x;
        double gy = motion.gravity.y;
        double gz = motion.gravity.z;
        NSLog(@"重力加速度: %f,,%f,,%f",gx,gy,gz);
        //三軸方向受到的外力產生的加速度，不包括重力
        double ax = motion.userAcceleration.x;
        double ay = motion.userAcceleration.y;
        double az = motion.userAcceleration.z;
        NSLog(@"外力產生的加速度，不包括重力: %f,,%f,,%f",ax,ay,az);
        //裝置周圍的磁場強度，不包括地球磁場和裝置本身的誤差
        double mx = motion.magneticField.field.x;
        double my = motion.magneticField.field.y;
        double mz = motion.magneticField.field.z;
        NSLog(@"磁場強度: %f,,%f,,%f",mx,my,mz);
        
    }];
    //stop
//    [manager stopDeviceMotionUpdates];
}

#pragma mark - 偵測搖晃

//not delegate Method:
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.subtype == UIEventSubtypeMotionShake) {
        NSLog(@"Shaking!!!!");
    }
}
-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
}

#pragma mark - 接近感應器

//Not Delegate Method:

-(void) getDevice
{
    UIDevice *device = [UIDevice currentDevice];
    
    //開啟感應器
    [device setProximityMonitoringEnabled:YES];
    if ([device isProximityMonitoringEnabled]) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(proximitySensorChange:) name:UIDeviceProximityStateDidChangeNotification object:nil];
    }
}
-(void)proximitySensorChange: (NSNotification *)sender
{
    if ([[UIDevice currentDevice] proximityState]) {
        NSLog(@"Closing");
    } else {
        NSLog(@"Leaving");
    }
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
