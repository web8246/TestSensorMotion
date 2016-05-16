//
//  ViewController.m
//  TestCoreMotion
//
//  Created by dean on 2016/5/15.
//  Copyright © 2016年 dean. All rights reserved.
//

/*
 增加CoreMotioin.FrameWork
 
 
 
 */

#import <CoreLocation/CoreLocation.h>
#import "ViewController.h"

@interface ViewController ()<CLLocationManagerDelegate>
{
    CLLocationManager *manager;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self coreLoaction];
//    [self locationHeading];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 全球定位
-(void)coreLoaction
{
    manager = [CLLocationManager new];
    //2選1
    
    [manager requestWhenInUseAuthorization];
    //    [manager requestAlwaysAuthorization];
    
    //讓manager可以背景執行：
//    manager.allowsBackgroundLocationUpdates = YES;
    manager.delegate = self;
    
    [manager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations firstObject];
    float latitude = location.coordinate.latitude;
    float longitude = location.coordinate.longitude;
    float altitude = location.altitude;
    NSLog(@"緯度%f,,經度%f,,高度%f",latitude,longitude,altitude);
}

#pragma mark - 電子羅盤
/*
 範圍：0~359
 北方：0
 東方：90
 南方：180
 西方：270
 
 */

-(void)locationHeading
{
    manager = [CLLocationManager new];
    manager.delegate = self;
    [manager startUpdatingHeading];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    if (newHeading.headingAccuracy < 0) {
        NSLog(@"請校準，遠離磁性干擾源");
    }
    
    NSLog(@"目前面向： %f",newHeading.magneticHeading);
}



@end
