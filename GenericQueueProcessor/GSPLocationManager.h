//
//  GSPLocationManager.h
//  GenericQueueProcessor
//
//  Created by Sahana on 28/11/16.
//  Copyright (c) 2016 GSS Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GSPLocationManager : NSObject <CLLocationManagerDelegate>
{
    
    CLLocationManager *_locationManager;
    
}

@property (nonatomic,strong)  CLLocation *currentLocation;
@property(nonatomic,strong)CLLocationManager    *locationManager;

+ (id)sharedInstance;

- (void) initLocationMnager;

@end
