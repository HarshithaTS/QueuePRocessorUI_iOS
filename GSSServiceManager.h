//
//  GSSServiceManager.h
//  GenericQueueProcessor
//
//  Created by Sahana on 28/11/16.
//  Copyright (c) 2016 GSS Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GssMobileConsoleiOS.h"

@interface GSSServiceManager : NSObject{
    GCDThreads          * objGCDThreads;

}
+ (id)sharedInstance;

- (void) startQueueProcessorApp;

- (void) startPingerService;
- (void)startGSM;

@end
