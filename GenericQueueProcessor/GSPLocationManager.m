//
//  GSPLocationManager.m
//  GenericQueueProcessor
//
//  Created by Sahana on 28/11/16.
//  Copyright (c) 2016 GSS Software. All rights reserved.
//

#import "GSPLocationManager.h"

@implementation GSPLocationManager
+ (id)sharedInstance
{
    static GSPLocationManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        
    });
    
    return sharedInstance;
}

- (void) initLocationMnager
{
    _locationManager                 = [[CLLocationManager alloc] init];
    _locationManager.delegate        = self;
    _locationManager.distanceFilter  = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            [_locationManager requestWhenInUseAuthorization];
    
//    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startMonitoringSignificantLocationChanges];
    

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)    {
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    [_locationManager startUpdatingLocation];
}
#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [locations lastObject];
    NSLog(@"lat%f - lon%f", self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude);
    [_locationManager stopUpdatingLocation];
    
}

@end
