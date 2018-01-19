//
//  GSSServiceManager.m
//  GenericQueueProcessor
//
//  Created by Sahana on 28/11/16.
//  Copyright (c) 2016 GSS Software. All rights reserved.
//

#import "GSSServiceManager.h"
#import "GSPLocationManager.h"
#import "GSPLocationPingService.h"
#import "GQPQueueProcessor.h"


@implementation GSSServiceManager
+ (id)sharedInstance
{
    static GSSServiceManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}



- (void)startGSM
{
//    [self startPingerService];
    
//     [[GQPQueueProcessor sharedInstance] getDataFormKeyChainAndProcess];
    
    
     [[GQPQueueProcessor sharedInstance] getDataFormKeyChainAndProcess];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0), ^{
//        
//        
//    [[GQPQueueProcessor sharedInstance] getDataFormKeyChainAndProcess];
//        
//    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0), ^{
        
        
         [self startPingerService];
    });
//  dispatch_async(dispatch_get_main_queue(),^{
//    
//     [self startPingerService];
//
//      
// });
    
//    [self startQueueProcessorApp];
}

- (void) startQueueProcessorApp
{
    UIApplication *ourApplication = [UIApplication sharedApplication];
    NSString *URLEncodedText = [@"Open Queue Processor" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *ourPath = [@"openQueueProcessor://" stringByAppendingString:URLEncodedText];//com.gss.genericIOsQueueProcessor/
    NSURL *ourURL = [NSURL URLWithString:ourPath];
    if ([ourApplication canOpenURL:ourURL]) {
        [ourApplication openURL:ourURL];
    }
    else {
        //Display error
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"QueueProcessor app Not found" message:@"Please install Queue Processor app ." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    
}

- (void) startPingerService
{
    GSPLocationPingService *locationPingService = [GSPLocationPingService new];
    [[GSPLocationManager sharedInstance] initLocationMnager];
    dispatch_async(dispatch_get_main_queue(),^{
    [locationPingService performSelector:@selector(initializePingServiceCall) withObject:nil afterDelay:8.0];
    });
//    [locationPingService performSelector:@selector(initializePingServiceCall) withObject:nil afterDelay:0.0];
}


@end
