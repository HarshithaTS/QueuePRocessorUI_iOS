//
//  GSPLocationPingService.h
//  GenericQueueProcessor
//
//  Created by Sahana on 28/11/16.
//  Copyright (c) 2016 GSS Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GssMobileConsoleiOS.h"

@interface GSPLocationPingService : NSObject<GssMobileConsoleiOSDelegate>
{
GssMobileConsoleiOS * objServiceMngtCls;
GCDThreads          * objGCDThreads;
}

- (void) initializePingServiceCall;

@end
