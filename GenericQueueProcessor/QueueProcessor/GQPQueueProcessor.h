//
//  GQPQueueProcessor.h
//  GenericQueueProcessor
//
//  Created by Riyas Hassan on 30/10/14.
//  Copyright (c) 2014 GSS Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GssMobileConsoleiOS.h"

#import "GCDThreads.h"

@interface GQPQueueProcessor : NSObject<GssMobileConsoleiOSDelegate>
{
    int processItemNumber;
    NSMutableArray *fetchedResultArray;
    
    GCDThreads *objGCDThreads;
}

@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;

+ (id)sharedInstance;

- (void) getDataFormKeyChainAndProcess;

- (void) saveDataToQueueDBFromKeyChain;

- (void)saveInDB:(NSMutableArray*)objectArray;

- (void)saveAllItemsInKeyChainFromDb;

- (void) deleteItemsWithStatusDeleted;

//- (void)checkAndDeleteRecordsAlreadyExistsDB:(NSString*)entityName forRefID:(NSString*)objectID andApplicationName:(NSString*)appName;

- (void)checkAndDeleteRecordsAlreadyExistsDB:(NSString*)entityName forRefID:(NSString*)objectID andApplicationName:(NSString*)appName andObjType:(NSString*)objType andFirstServiceItem :(NSString*)serviceItem;


@property (nonatomic, strong) NSTimer *oneMintTimer, *tenMintsTimer, *oneHrTimer, *fourHrsTimer, *oneDayTimer, *fourDaysTimer, *sevenDaysTimer, *timerTrial;

// Added by Harshitha
@property (nonatomic, strong) NSMutableArray *queuedItemArrayWithTimerFired;

@property(nonatomic,assign)BOOL itemToProcess;
//- (void) setNextTimerForRefID : (NSString *)refId andAppName : (NSString *)appName;
- (void) setNextTimerForRefID : (NSString *)refId andAppName : (NSString *)appName andObjectType :(NSString*)objectType andFirstServiceItem :(NSString*)firstServiceItem;

-(void)stratTimertoCheckPriority;

-(void)checkPriorityinKeyChain;


- (void) processQitemsWithHighPriority;

-(void)startTimerToCheckApplicationState;

-(void)changePrioritytToLow;

- (void)saveAllInDB:(NSMutableArray*)objectArray;

- (void) deleteAllObjects: (NSString *) entityDescription ;

@end
