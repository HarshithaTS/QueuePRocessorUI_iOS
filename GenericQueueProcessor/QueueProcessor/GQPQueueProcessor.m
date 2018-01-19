//
//  GQPQueueProcessor.m
//  GenericQueueProcessor
//
//  Created by Riyas Hassan on 30/10/14.
//  Copyright (c) 2014 GSS Software. All rights reserved.
//

#import "GQPQueueProcessor.h"
#import "Reachability.h"
#import "QueuedProcess.h"
#import "Constants.h"
#import "ErrorLog.h"
#import "GSPKeychainStoreManager.h"
#import "GQPViewController.h"

@implementation GQPQueueProcessor

@synthesize fourDaysTimer,fourHrsTimer,oneDayTimer,oneHrTimer,oneMintTimer,sevenDaysTimer,tenMintsTimer,timerTrial;

@synthesize backgroundTask;

@synthesize queuedItemArrayWithTimerFired;

+ (id)sharedInstance
{
        static GQPQueueProcessor *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    
    
    return sharedInstance;
}



- (id) init{
    
    self = [super init];
    
    if(self){
    
    
    objGCDThreads = [GCDThreads sharedInstance];
    }
    
    return  self;
}
- (void) getDataFormKeyChainAndProcess
{
    [self saveDataToQueueDBFromKeyChain];
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    
    if ([reachability isReachable])
    {
        NSLog(@"Reachable");
        
//        [self getDataFromDBAndSendToSAPServer];
        
//  Original code.....Commented by Harshitha
//        [self start7Timers];
        
//        [self start15minTimer];
//  *****  Added by Harshitha ends here   *****
    }
    else
    {
        NSLog(@"Unreachable");
        //Do Nothing
    }
 
}

// Original code.....Commented by Harshitha
/*
- (void) start7Timers
{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *request         = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"QueuedProcess" inManagedObjectContext:context]];
    
    NSError *error                  = nil;
    
   
    NSPredicate *predicate          = [NSPredicate predicateWithFormat:@"processCount = %d",1];
    [request setPredicate:predicate];
    
    NSMutableArray * processCountOneArray      = (NSMutableArray*)[context executeFetchRequest:request error:&error];
    
    if (processCountOneArray.count > 0)
    {
        oneMintTimer    = [NSTimer timerWithTimeInterval:60.0 target:self selector:@selector(processDataInQueueTableToSapWebServer:) userInfo:@"1 Mint" repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:oneMintTimer forMode:NSRunLoopCommonModes];
    }
    
    predicate          = [NSPredicate predicateWithFormat:@"processCount = %d",2];
    [request setPredicate:predicate];
    
    NSMutableArray * processCountTwoArray      = (NSMutableArray*)[context executeFetchRequest:request error:&error];
    
    if (processCountTwoArray.count > 0)
    {
        tenMintsTimer   = [NSTimer timerWithTimeInterval:600.0 target:self selector:@selector(processDataInQueueTableToSapWebServer:) userInfo:@"10 Mints" repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:tenMintsTimer forMode:NSRunLoopCommonModes];
    }
    
    predicate          = [NSPredicate predicateWithFormat:@"processCount = %d",3];
    [request setPredicate:predicate];
    
    NSMutableArray * processCountThreeArray      = (NSMutableArray*)[context executeFetchRequest:request error:&error];
    
    if (processCountThreeArray.count > 0)
    {
        oneHrTimer      = [NSTimer timerWithTimeInterval:3600.0 target:self selector:@selector(processDataInQueueTableToSapWebServer:) userInfo:@"1 Hour" repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:oneHrTimer forMode:NSRunLoopCommonModes];
    }
    
    predicate          = [NSPredicate predicateWithFormat:@"processCount = %d",4];
    [request setPredicate:predicate];
    
    NSMutableArray * processCountFourArray      = (NSMutableArray*)[context executeFetchRequest:request error:&error];
    
    if (processCountFourArray.count > 0)
    {
        fourHrsTimer    = [NSTimer timerWithTimeInterval:14400.0 target:self selector:@selector(processDataInQueueTableToSapWebServer:) userInfo:@"4 Hours" repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:fourHrsTimer forMode:NSRunLoopCommonModes];
    }
    
    predicate          = [NSPredicate predicateWithFormat:@"processCount = %d",5];
    [request setPredicate:predicate];
    
    NSMutableArray * processCountFiveArray      = (NSMutableArray*)[context executeFetchRequest:request error:&error];
    
    if (processCountFiveArray.count > 0)
    {
        oneDayTimer     = [NSTimer timerWithTimeInterval:86400.0 target:self selector:@selector(processDataInQueueTableToSapWebServer:) userInfo:@"1 Day" repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:oneDayTimer forMode:NSRunLoopCommonModes];
    }
    
    predicate          = [NSPredicate predicateWithFormat:@"processCount = %d",6];
    [request setPredicate:predicate];
    
    NSMutableArray * processCountSixArray      = (NSMutableArray*)[context executeFetchRequest:request error:&error];
    
    if (processCountSixArray.count > 0)
    {
        fourDaysTimer   = [NSTimer timerWithTimeInterval:345600.0 target:self selector:@selector(processDataInQueueTableToSapWebServer:) userInfo:@"4 Days" repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:fourDaysTimer forMode:NSRunLoopCommonModes];
    }
    
    predicate          = [NSPredicate predicateWithFormat:@"processCount = %d",7];
    [request setPredicate:predicate];
    
    NSMutableArray * processCountSevenArray      = (NSMutableArray*)[context executeFetchRequest:request error:&error];
    
    if (processCountSevenArray.count > 0)
    {
        sevenDaysTimer  = [NSTimer timerWithTimeInterval:604800.0 target:self selector:@selector(processDataInQueueTableToSapWebServer:) userInfo:@"7 Days" repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:sevenDaysTimer forMode:NSRunLoopCommonModes];
    }
    
}


- (void)processDataInQueueTableToSapWebServer:(NSTimer*)timer
{
    NSString * timerInfo = timer.userInfo;
    
    NSLog(@"Timer info is : %@", timerInfo);
    
    
    NSMutableArray *tempArray = [NSMutableArray new];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *request         = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"QueuedProcess" inManagedObjectContext:context]];
    
     NSError *error                  = nil;
    
    
    if ([timerInfo isEqualToString:@"1 Mint"])
    {
        NSPredicate *predicate          = [NSPredicate predicateWithFormat:@"processCount = %d",1];
        [request setPredicate:predicate];
    }
    else if ([timerInfo isEqualToString:@"10 Mints"])
    {
        NSPredicate *predicate          = [NSPredicate predicateWithFormat:@"processCount = %d",2];
        [request setPredicate:predicate];
    }
    
    else if ([timerInfo isEqualToString:@"1 Hour"])
    {
        NSPredicate *predicate          = [NSPredicate predicateWithFormat:@"processCount = %d",3];
        [request setPredicate:predicate];
    }
    else if ([timerInfo isEqualToString:@"4 Hours"])
    {
        NSPredicate *predicate          = [NSPredicate predicateWithFormat:@"processCount = %d",4];
        [request setPredicate:predicate];
    }
    else if ([timerInfo isEqualToString:@"1 Day"])
    {
        NSPredicate *predicate          = [NSPredicate predicateWithFormat:@"processCount = %d",5];
        [request setPredicate:predicate];
    }
    else if ([timerInfo isEqualToString:@"4 Days"])
    {
        NSPredicate *predicate          = [NSPredicate predicateWithFormat:@"processCount = %d",6];
        [request setPredicate:predicate];
    }
    else if ([timerInfo isEqualToString:@"7 Days"])
    {
        NSPredicate *predicate          = [NSPredicate predicateWithFormat:@"processCount = %d",7];
        [request setPredicate:predicate];
    }
 
    
   
    tempArray              = (NSMutableArray*)[context executeFetchRequest:request error:&error];

    for (int i = 0; i < tempArray.count ; i++)
    {
        [self updateProcessStartedDetailsInDBForObject:[tempArray objectAtIndex:i]];
        [self initializeWebServiceCallForObject:[tempArray objectAtIndex:i]];
    }

}
*/

// *****  Added by Harshitha starts here *****
- (void) setNextTimerForRefID : (NSString *)refId andAppName : (NSString *)appName andObjectType :(NSString*)objectType andFirstServiceItem :(NSString*)firstServiceItem
{
    int processCount;
    QueuedProcess *coredataObject;
    NSString *next_Process_Time;
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *request         = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"QueuedProcess" inManagedObjectContext:context]];
    
    NSError *error                  = nil;
    NSPredicate *predicate          = [NSPredicate predicateWithFormat:@"referenceID = %@ AND appName = %@ AND objectType =%@ AND firstServiceItem =%@", refId,appName,objectType,firstServiceItem];
    [request setPredicate:predicate];
    NSArray *results                = [context executeFetchRequest:request error:&error];
    
    if (results.count > 0)
    {
        coredataObject   = (QueuedProcess*)[results objectAtIndex:0];
        
        processCount         = [[coredataObject valueForKey:@"processCount"] intValue];
    }
    
    if (processCount > 0) {
        
      NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
      [DateFormatter setDateFormat:@"MMM dd,yyyy HH:mm:ss"];
        
      switch (processCount) {
            
        case 1:
//              next_Process_Time = [DateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:60.0]];
              next_Process_Time = [DateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:60.0]];

            break;

        case 2:
//              next_Process_Time = [DateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:600.0]];
              next_Process_Time = [DateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:120.0]];
            break;
            
        case 3:
//              next_Process_Time = [DateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:3600.0]];
              next_Process_Time = [DateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:180.0]];
            break;
            
        case 4:
//              next_Process_Time = [DateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:14400.0]];
              next_Process_Time = [DateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:240.0]];
            break;
            
        case 5:
//              next_Process_Time = [DateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:86400.0]];
              next_Process_Time = [DateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:300.0]];
            break;
            
        case 6:
//              next_Process_Time = [DateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:345600.0]];
              next_Process_Time = [DateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:360.0]];
            break;
            
        case 7:
//              next_Process_Time = [DateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:604800.0]];
              next_Process_Time = [DateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:420.0]];
            break;
            
        default:
//              next_Process_Time = [DateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:604800.0]];
              next_Process_Time = [DateFormatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:420.0]];
            break;
    }
  }
    [coredataObject setValue:next_Process_Time forKey:@"nextProcessTime"];
    
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    else
    {
        NSLog(@"Saved successfully");
    }
}

- (void) start15minTimer
{
//    [NSTimer scheduledTimerWithTimeInterval:900 target:self selector:@selector(processQueueDataWhenTimerFired) userInfo:nil repeats:YES];
    
     dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
    [NSTimer scheduledTimerWithTimeInterval:900  target:self selector:@selector(processQueueDataWhenTimerFired) userInfo:nil repeats:YES];
          });
}

- (void) processQueueDataWhenTimerFired
{
    
   
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm"];
    [[QPLogs sharedInstance]writeLogsToFile:[NSString stringWithFormat:@"\n %@ : 15 minutes timer fired\n",[dateFormatter stringFromDate:[NSDate date] ]]];
    NSLog(@"15 mins timer fired %@",[NSDate date]);
    
    [self deleteErrorItemsinDBNotinKeychain];
    
    [self saveErrorItemsInKeyChain];
    
    
    [self saveDataToQueueDBFromKeyChain];

    [self deleteItemsWithCompletedStatus];
    
//    [self deleteItemsWithStatusDeleted];
    
     [GSPKeychainStoreManager deleteAllItemsFromGSMKeyChain];
    
    [self saveAllItemsInKeyChainFromDb];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshQueueTableView" object:nil];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *request         = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"QueuedProcess" inManagedObjectContext:context]];
    
    NSError *error                  = nil;
    NSPredicate *predicate          = [NSPredicate predicateWithFormat:@"status != NULL AND nextProcessTime != NULL"];

    [request setPredicate:predicate];
    NSArray *results                = [context executeFetchRequest:request error:&error];
    if (results.count > 0)
    {
        for (int i = 0 ; i < results.count ; i++)
        {
            NSDateFormatter *DateFormatter  =[[NSDateFormatter alloc] init];
            [DateFormatter setDateFormat:@"MMM dd,yyyy HH:mm:ss"];

            NSDate *curentdate              = [DateFormatter dateFromString:[DateFormatter stringFromDate:[NSDate date]]];
            NSString *nextProcesstime       = [[results objectAtIndex:i]valueForKey:@"nextProcessTime"];

            NSDate *next_process_time       = [DateFormatter dateFromString:nextProcesstime];
            
            if ([next_process_time compare:curentdate] == NSOrderedAscending)
            {
                [self updateProcessStartedDetailsInDBForObject:[results objectAtIndex:i]];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"HH:mm"];
                [[QPLogs sharedInstance]writeLogsToFile:[NSString stringWithFormat:@"\n %@ : For Reference ID : %@\t Object Type : %@\t Process Count : %@\n",[dateFormatter stringFromDate:[NSDate date]],[[results objectAtIndex:i] valueForKey:@"referenceID"],[[results objectAtIndex:i]valueForKey:@"objectType"],[[results objectAtIndex:i] valueForKey:@"processCount"]]];
                
                [self initializeWebServiceCallForObject:[results objectAtIndex:i]];
            }
            else{
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"HH:mm"];
                [[QPLogs sharedInstance]writeLogsToFile:[NSString stringWithFormat:@"\n %@ : As the 'next_process_time' of the items is not reached,no items to process ",[dateFormatter stringFromDate:[NSDate date]]]];
            }
        }
    }
    
    else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"HH:mm"];
        [[QPLogs sharedInstance]writeLogsToFile:[NSString stringWithFormat:@"\n %@ : No items to process\n",[dateFormatter stringFromDate:[NSDate date]]]];
    }
/*    predicate          = [NSPredicate predicateWithFormat:@"processCount>8"];
    [request setPredicate:predicate];
    results                = [context executeFetchRequest:request error:&error];
    if (results.count > 0)
    {
        for (int i = 0 ; i < results.count ; i++)
        {
            [self sendNotificationForRefID:[(QueuedProcess*)[results objectAtIndex:0] valueForKey:@"referenceID"] andAppName:[(QueuedProcess*)[results objectAtIndex:0] valueForKey:@"appName"]];
        }
    }
*/
    
//    [self stratTimertoCheckPriority];
        
   
}
// *****  Added by Harshitha ends here *****

- (void) saveDataToQueueDBFromKeyChain
{
    
    [self deleteAllObjects:@"QueuedProcess"];
    
    NSMutableArray * arrayOfTasksFromKeyChain = [GSPKeychainStoreManager allItemsArrayFromKeychain];
    
    
    [self saveAllInDB:arrayOfTasksFromKeyChain];
    
    
    NSMutableArray * arrayOfTasksFromQueueKeyChain = [GSPKeychainStoreManager arrayFromKeychain];
    
    
    [self saveInDB :arrayOfTasksFromQueueKeyChain];
    
    [self deleteItemsWithStatusDeleted];
    
}

- (void)getDataFromDBAndSendToSAPServer
{
    
    
    [self processQitemsWithHighPriority];
    
    [self processQueueDataWhenTimerFired];
    
    
   
    [self deleteErrorItemsinDBNotinKeychain];
    
    [self saveErrorItemsInKeyChain];
    
    
    [self saveDataToQueueDBFromKeyChain];
    
    [self deleteItemsWithCompletedStatus];
    
    //    [self deleteItemsWithStatusDeleted];
    
    [GSPKeychainStoreManager deleteAllItemsFromGSMKeyChain];
    
    [self saveAllItemsInKeyChainFromDb];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshQueueTableView" object:nil];

    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *request         = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"QueuedProcess" inManagedObjectContext:context]];
    
//  Original code
//    NSPredicate *predicate          = [NSPredicate predicateWithFormat:@"status != %@ OR status = NULL",@"Completed" ];// OR status != %@,@"Processing"];
    
//    Modified by Harshitha.....As completed items are already processed and need to be deleted from the queue,it doesn't require another web-service call
//    NSPredicate *predicate          = [NSPredicate predicateWithFormat:@"status = NULL"];
    
//    As items with process count>7 which havn't been notified by user to delete/retain have status NULL shudn't be processed when this function is called due to reachability change
    /*
    NSPredicate *predicate1          = [NSPredicate predicateWithFormat:@"status = NULL AND processCount = 0 AND nextProcessTime = NULL"];
    [request setPredicate:predicate1];
    
    NSError *error1                 = nil;
    resultArray1             = (NSMutableArray*)[context executeFetchRequest:request error:&error1];
    
    NSLog(@"The recently added item %@",resultArray1);
    [fetchedResultArray addObjectsFromArray:resultArray1];
    
    NSPredicate *predicate2  = [NSPredicate predicateWithFormat:@"status!=NULL AND nextProcessTime!= NULL"];
    
    [request setPredicate:predicate2];

    NSError *error2 = nil;
    resultArray2    =(NSMutableArray*)[context executeFetchRequest:request error:&error2];
    
    [fetchedResultArray addObjectsFromArray:resultArray1];
    
    NSPredicate *predicate3 =[NSPredicate predicateWithFormat:@"status!=NULL AND nextProcessTime!=NULL AND periority == 2"];
    
    [request setPredicate:predicate3];
    
    NSError *error3 = nil;
    resultArray3 = (NSMutableArray*)[context executeFetchRequest:request error:&error3];
    
    [fetchedResultArray addObjectsFromArray:resultArray1];
     
     */
    
    NSPredicate *predicate          = [NSPredicate predicateWithFormat:@"status = NULL AND nextProcessTime = NULL"];
    [request setPredicate:predicate];
    
    NSError *error                  = nil;
    fetchedResultArray              = (NSMutableArray*)[context executeFetchRequest:request error:&error];
    


// Added by Harshitha to process queued items acc. to priority
//    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"periority" ascending:YES];
//    NSArray *results = [fetchedResultArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
//    [fetchedResultArray arrayByAddingObjectsFromArray:results];
    
    processItemNumber = 0;
    [self processWebServiceRequestToSap];
    
    
//    dispatch_sync(objGCDThreads.Concurrent_Queue_High_SAPCRM, ^{
//        
//        [self changePrioritytToLow];
//        
//    });
    
    dispatch_group_notify(objGCDThreads.Task_Group_SAPCRM, dispatch_get_main_queue(), ^{
////        dispatch_release(objGCDThreads.Task_Group_SAPCRM);
//        
        [self changePrioritytToLow];
           });
    
//    [self changePrioritytToLow];
    
    
//    
//    dispatch_group_notify(objGCDThreads.Task_Group_SAPCRM,objGCDThreads.Concurrent_Queue_High_SAPCRM, ^ {
//        
//        [self changePrioritytToLow];
//    });
    
    
    
    

}




-(void)priorityHandler:(NSNotification*)notification{
    
    if([notification.name isEqualToString:@"changingPriority"]){
        [self changePrioritytToLow];
    }
    
}

-(void)changePrioritytToLow{
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm"];
    
   [[QPLogs sharedInstance]writeLogsToFile:[NSString stringWithFormat:@"\n %@ : Changing priority \n",[dateFormatter stringFromDate:[NSDate date]]]];
    
    
    
    
    NSMutableArray *errorKeyChainArray = [[NSMutableArray alloc]init];
    errorKeyChainArray = [GSPKeychainStoreManager getErrorItemsFromKeyChain];
    [GSPKeychainStoreManager deleteErrorItemsFromKeyChain];
    
    NSMutableDictionary *dic =[[NSMutableDictionary alloc]init];
            if(errorKeyChainArray.count>0){
    
    
    for(id item in errorKeyChainArray){
        
        for( id key in item){
            
            [dic setObject:[item objectForKey:key] forKey:key];
        }
    }
    
    NSLog(@"mutable dic %@",dic);
    //
    //                    for(id key in dic){
    //                        id value =[dic objectForKey:@"appName"];
    //                if([value isEqualToString:@"SERVICEPRO"]){
    //
    //
    //                [dic setObject:@"2" forKey:@"periority"];
    //            }
    //                    }
    NSMutableDictionary *mutableDic = [dic mutableCopy];
    
    [mutableDic setObject:@"3" forKey:@"periority"];
    
    
    NSLog(@"The mutated dictionary %@",mutableDic);
    //                    for(NSString *key in mutableDic){
    //                        id value = [dic objectForKey:key];
    //                        NSLog(@"the value of a key %@",value);
    //                        [value setObject:@"1" forKey:@"periority"]  ;
    //                    }
    //        }
    //         [GSPKeychainStoreManager saveErrorItemsInKeychain:errorKeychainArray];
    
    NSMutableArray  *mutatedArray =[[NSMutableArray alloc]init];
    [mutatedArray addObject:mutableDic];
    NSLog(@"Mutated Array %@",mutatedArray);
    [GSPKeychainStoreManager saveErrorItemsInKeychain:mutatedArray];
    errorKeyChainArray = [GSPKeychainStoreManager getErrorItemsFromKeyChain];
    NSLog(@"THe error items in error keychain %@",errorKeyChainArray);
            }
    [self saveinErrorDB :errorKeyChainArray];

}



- (void)processWebServiceRequestToSap
{
    if (processItemNumber < fetchedResultArray.count  )
    {
//  Addded by Harshitha to add logs
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"HH:mm"];
        [[QPLogs sharedInstance]writeLogsToFile:[NSString stringWithFormat:@"\n %@ : Calling webservice for Reference ID : %@ of Application : %@ and Object Type : %@\t with Process Count : %@\n",[dateFormatter stringFromDate:[NSDate date]],[[fetchedResultArray objectAtIndex:processItemNumber]valueForKey:@"referenceID"],[[fetchedResultArray objectAtIndex:processItemNumber]valueForKey:@"appName"],[[fetchedResultArray objectAtIndex:processItemNumber ]valueForKey:@"objectType"],[[fetchedResultArray objectAtIndex:processItemNumber]valueForKey:@"processCount"]]];
        
        [self updateProcessStartedDetailsInDBForObject:[fetchedResultArray objectAtIndex:processItemNumber]];
        [self initializeWebServiceCallForObject:[fetchedResultArray objectAtIndex:processItemNumber]];
        processItemNumber++;
    }
    else if (fetchedResultArray.count <= 0 || fetchedResultArray == nil)
    {
        //Do Nothing. Stop Processing
        
//        [self changePrioritytToLow];
    }
    else
    {
        processItemNumber   = 0;
        fetchedResultArray  = nil;
        //[self getDataFromDBAndSendToSAPServer];
        
       
    }
  
}


- (void)initializeWebServiceCallForObject:(QueuedProcess*)object
{
    GssMobileConsoleiOS *objServiceMngtCls      = [[GssMobileConsoleiOS alloc] init];
    
    objServiceMngtCls.ApplicationName           = [object valueForKey:@"appName"];
    objServiceMngtCls.ApplicationVersion        = [object valueForKey:@"subApplicationVersion"];
    objServiceMngtCls.ApplicationEventAPI       = [object valueForKey:@"apiName"];
    
    NSString *tempStr                           = [object valueForKey:@"inputDataArrayString"];
    objServiceMngtCls.InputDataArray            = [self createMutableArray:[tempStr componentsSeparatedByString:@","]];
    objServiceMngtCls.Options                   = @"UPDATEDATA";
    objServiceMngtCls.RefernceID                = [object valueForKey:@"referenceID"];
    
    objServiceMngtCls.subApp                    = [object valueForKey:@"subApplication"];
    objServiceMngtCls.objectType                = [object valueForKey:@"objectType"];
    
    objServiceMngtCls.firstItemService = [object valueForKey:@"firstServiceItem"];
    //objServiceMngtCls.CRMdelegate              = self;
    
//  Added by Harshitha.....To add SOAP request to logs
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm"];

    NSString *soapRequest = [objServiceMngtCls.InputDataArray componentsJoinedByString:@"\n"];
    [[QPLogs sharedInstance]writeLogsToFile:[NSString stringWithFormat:@"\n %@ : SOAP Request : %@\n",[dateFormatter stringFromDate:[NSDate date]],soapRequest]];
    
    NSLog(@"the output body of request %@",objServiceMngtCls.InputDataArray);
    [objServiceMngtCls callSOAPWebMethodWithBlock:^(GQPWebServiceResponse * response)
     {

         
        if (response.responseArray) {
            
//  Added by Harshitha.....To add SOAP response to logs
//            [[QPLogs sharedInstance]writeLogsToFile:[NSString stringWithFormat:@"SOAP Response : %@\n",[[objServiceMngtCls valueForKey:@"objInputProperties"] valueForKey:@"responseArrayStr"]]];
            
             if (response.responseArray.count > 3)
             {
                 NSString * message = [[response.responseArray objectAtIndex:0] objectAtIndex:0];
                 
                 if ([message isEqualToString:@"E"])
                 {
                     //Update Error table
                     NSLog(@"Error for reference id : %@",response.referenceID );
                     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                     [dateFormatter setDateFormat:@"HH:mm"];
                      [[QPLogs sharedInstance]writeLogsToFile:[NSString stringWithFormat:@"\n %@ : SOAP Response :\n\tType :%@\n\tID :%@\n\tMessage : %@\n",[dateFormatter stringFromDate:[NSDate date]],message,[[response.responseArray objectAtIndex:1]objectAtIndex:0],[[response.responseArray objectAtIndex:3]objectAtIndex:0]]];
                     
                     [self updateProcessStatusInDBForObjectWithReferenceID:response.referenceID withObjectType:objServiceMngtCls.objectType withFirstServiceItem:objServiceMngtCls.firstItemService withStatus:@"Error"];
                     [self updateErrorTableForReferenceId:response.referenceID  withObjectType:objServiceMngtCls.objectType withFirstServiceItem:objServiceMngtCls.firstItemService andErrorObject:response.responseArray andErrorMessage:@"Error"];
                     
                 }
                 else  if ([message isEqualToString:@"S"])
                 {
                     // Update success status in Db
                     NSLog(@"Success for reference id : %@",response.referenceID );
                     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                     [dateFormatter setDateFormat:@"HH:mm"];
                     [[QPLogs sharedInstance]writeLogsToFile:[NSString stringWithFormat:@"\n %@ :SOAP Response : %@\n",[dateFormatter stringFromDate:[NSDate date]],[[objServiceMngtCls valueForKey:@"objInputProperties"] valueForKey:@"responseArrayStr"]]];
                     [self updateProcessStatusInDBForObjectWithReferenceID:response.referenceID withObjectType:objServiceMngtCls.objectType withFirstServiceItem:objServiceMngtCls.firstItemService withStatus:@"Completed"];
                 }
             }
         }
         
         else if (response.errorResponseMessage)
         {
             
//  Added by Harshitha.....To add SOAP response to logs
             NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
             [dateFormatter setDateFormat:@"HH:mm"];
             [[QPLogs sharedInstance]writeLogsToFile:[NSString stringWithFormat:@"\n %@ : SOAP Response : %@\n",[dateFormatter stringFromDate:[NSDate date]],[[objServiceMngtCls valueForKey:@"objInputProperties"] valueForKey:@"responseArrayStr"]]];
             NSLog(@"REsponse %@\n",[[objServiceMngtCls valueForKey:@"objInputProperties"]valueForKey:@"responseArrayStr"]);
             
             [self updateProcessStatusInDBForObjectWithReferenceID:response.referenceID withObjectType:objServiceMngtCls.objectType withFirstServiceItem:objServiceMngtCls.firstItemService withStatus:@"Error"];
             
             [self updateErrorTableForReferenceId:response.referenceID  withObjectType:objServiceMngtCls.objectType withFirstServiceItem:objServiceMngtCls.firstItemService andErrorObject:response.responseArray andErrorMessage:response.errorResponseMessage];
         }
//         [[GQPQueueProcessor sharedInstance] saveDataToQueueDBFromKeyChain];
         [[GQPQueueProcessor sharedInstance]saveAllItemsInKeyChainFromDb];
         
         NSMutableArray *errorItemsFromKeychain = [GSPKeychainStoreManager getErrorItemsFromKeyChain];
         NSLog(@"array from keychain in viewdidload %@",errorItemsFromKeychain);


         NSMutableArray *allItemsFromKeychain = [GSPKeychainStoreManager allItemsArrayFromKeychain];
         NSLog(@"array from keychain %@",allItemsFromKeychain);
         NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
         [dateFormatter setDateFormat:@"HH:mm"];
         [[QPLogs sharedInstance]writeLogsToFile:[NSString stringWithFormat:@"\n %@ : Number of items in keychain: %lu\n",[dateFormatter stringFromDate:[NSDate date ] ],(unsigned long)[errorItemsFromKeychain count]]];
         for(int j=0;j<[allItemsFromKeychain count];j++){
           [[QPLogs sharedInstance]writeLogsToFile:[NSString stringWithFormat:@"\n\tItem :%d\n\tAppName : %@\n\tReference ID : %@\n\tObject Type :%@\n\tStatus : %@\n\tNext Process Time :%@\n",j+1,[[allItemsFromKeychain objectAtIndex:j] valueForKey:@"appName"],[[allItemsFromKeychain objectAtIndex:j] valueForKey:@"referenceID"],[[allItemsFromKeychain objectAtIndex:j ] valueForKey:@"objectType"],[[allItemsFromKeychain objectAtIndex:j] valueForKey:@"status"],[[allItemsFromKeychain objectAtIndex:j ] valueForKey:@"nextProcessTime"]]];
         }
         [self processWebServiceRequestToSap];
         
        
     }];
}


- (NSMutableArray *)createMutableArray:(NSArray *)array
{
    return [array mutableCopy];
}


#pragma mark coredata methods

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)saveInDB:(NSMutableArray*)objectArray
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Create a new managed object
    
    
    for (NSDictionary * taskDic in objectArray)
    {
        NSLog(@"item is %@", [taskDic objectForKey:@"referenceid"] );
    
        [self checkAndDeleteRecordsAlreadyExistsDB:@"QueuedProcess" forRefID:[taskDic objectForKey:@"referenceid"] andApplicationName:[taskDic objectForKey:@"applicationname"]andObjType :[taskDic objectForKey:@"objecttype"]andFirstServiceItem :[taskDic objectForKey:@"FirstServiceItem"]];
        
        NSManagedObject *process = [NSEntityDescription insertNewObjectForEntityForName:@"QueuedProcess" inManagedObjectContext:context];
        
        
        [process setValue:[taskDic objectForKey:@"applicationname"] forKey:@"appName"];
        [process setValue:[taskDic objectForKey:@"referenceid"] forKey:@"referenceID"];
        [process setValue:[taskDic objectForKey:@"packageName"] forKey:@"packageName"];
        [process setValue:[taskDic objectForKey:@"AddedTime"] forKey:@"queueDate"];
        
        [process setValue:[NSNumber numberWithInt:[[taskDic objectForKey:@"attempt"]integerValue]] forKey:@"processCount"];
        [process setValue:[taskDic objectForKey:@"inputdataarraystring"] forKey:@"inputDataArrayString"];
        [process setValue:[taskDic objectForKey:@"objecttype"] forKey:@"objectType"];
        [process setValue:[taskDic objectForKey:@"periority"] forKey:@"periority"];
        [process setValue:[taskDic objectForKey:@"subapplication"] forKey:@"subApplication"];
        [process setValue:[taskDic objectForKey:@"subapplicationversion"] forKey:@"subApplicationVersion"];
        
        [process setValue:[taskDic objectForKey:@"applicationeventapi"] forKey:@"apiName"];
        [process setValue:[taskDic objectForKey:@"ID"] forKey:@"altID"];
        [process setValue:[taskDic objectForKey:@"created"] forKey:@"processStartTime"];
        [process setValue:[taskDic objectForKey:@"deviceid"] forKey:@"deviceID"];
        [process setValue:[taskDic objectForKey:@"endtime"] forKey:@"endTime"];
        
        [process setValue:[taskDic objectForKey:@"FirstServiceItem"] forKey:@"firstServiceItem"];
        if([[taskDic objectForKey:@"status" ]isEqualToString:@"Delete"]){
            
            [process setValue:[taskDic objectForKey:@"status"] forKey:@"status"];

        }
        
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        else
        {
            NSLog(@"Saved successfully");
        }
        if([[taskDic objectForKey:@"status" ]isEqualToString:@"Delete"]){
        
        [self checkAndDeleteOnlineDatainDB:@"ErrorLog" forRefID:[taskDic objectForKey:@"referenceid"] andApplicationName:[taskDic objectForKey:@"applicationname"]andObjType :[taskDic objectForKey:@"objecttype"]andFirstServiceItem :[taskDic objectForKey:@"FirstServiceItem"]];
            
            [self saveErrorItemsInKeyChain];
        }
    }
//Commented by Sahana on MAy 29th 2017
//    [GSPKeychainStoreManager deleteItemsFromKeyChain];
}

// Function added by sahana on MAy 29th 2017

- (void)saveAllInDB:(NSMutableArray*)objectArray
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Create a new managed object
    
    
    for (NSDictionary * taskDic in objectArray)
    {
        NSLog(@"item is %@", [taskDic objectForKey:@"referenceID"] );
        
        [self checkAndDeleteRecordsAlreadyExistsDB:@"QueuedProcess" forRefID:[taskDic objectForKey:@"referenceID"] andApplicationName:[taskDic objectForKey:@"appName"]andObjType :[taskDic objectForKey:@"objectType"]andFirstServiceItem :[taskDic objectForKey:@"firstServiceItem"]];
        
        NSManagedObject *process = [NSEntityDescription insertNewObjectForEntityForName:@"QueuedProcess" inManagedObjectContext:context];
        
        
        [process setValue:[taskDic objectForKey:@"appName"] forKey:@"appName"];
        [process setValue:[taskDic objectForKey:@"referenceID"] forKey:@"referenceID"];
        [process setValue:[taskDic objectForKey:@"packageName"] forKey:@"packageName"];
        [process setValue:[taskDic objectForKey:@"queueDate"] forKey:@"queueDate"];
        
        [process setValue:[NSNumber numberWithInt:[[taskDic objectForKey:@"processCount"]integerValue]] forKey:@"processCount"];
        [process setValue:[taskDic objectForKey:@"inputDataArrayString"] forKey:@"inputDataArrayString"];
        [process setValue:[taskDic objectForKey:@"objectType"] forKey:@"objectType"];
        [process setValue:[taskDic objectForKey:@"periority"] forKey:@"periority"];
        [process setValue:[taskDic objectForKey:@"subApplication"] forKey:@"subApplication"];
        [process setValue:[taskDic objectForKey:@"subApplicationVersion"] forKey:@"subApplicationVersion"];
        
        [process setValue:[taskDic objectForKey:@"apiName"] forKey:@"apiName"];
        [process setValue:[taskDic objectForKey:@"altID"] forKey:@"altID"];
        [process setValue:[taskDic objectForKey:@"processStartTime"] forKey:@"processStartTime"];
        [process setValue:[taskDic objectForKey:@"deviceID"] forKey:@"deviceID"];
        [process setValue:[taskDic objectForKey:@"endTime"] forKey:@"endTime"];
        
        [process setValue:[taskDic objectForKey:@"firstServiceItem"] forKey:@"firstServiceItem"];
        
        [process setValue:[taskDic objectForKey:@"status"] forKey:@"status"];

        
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        else
        {
            NSLog(@"Saved successfully");
        }
        if([[taskDic objectForKey:@"status" ]isEqualToString:@"Delete"]){
            
            [self checkAndDeleteOnlineDatainDB:@"ErrorLog" forRefID:[taskDic objectForKey:@"referenceID"] andApplicationName:[taskDic objectForKey:@"appName"]andObjType :[taskDic objectForKey:@"objectType"]andFirstServiceItem :[taskDic objectForKey:@"firstServiceItem"]];
            
            [self saveErrorItemsInKeyChain];
        }
    }
    //Commented by Sahana on MAy 29th 2017
    //    [GSPKeychainStoreManager deleteItemsFromKeyChain];
}

- (void)checkAndDeleteRecordsAlreadyExistsDB:(NSString*)entityName forRefID:(NSString*)objectID andApplicationName:(NSString*)appName andObjType:(NSString*)objType andFirstServiceItem :(NSString*)serviceItem
{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *request         = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:context]];//@"QueuedProcess"
    
    NSError *error                  = nil;
    NSPredicate *predicate          = [NSPredicate predicateWithFormat:@"referenceID = %@ AND appName = %@ AND firstServiceItem = %@ AND objectType=%@", objectID,appName,serviceItem,objType];
    [request setPredicate:predicate];
    NSArray *results                = [context executeFetchRequest:request error:&error];
    
    if (results.count > 0)
    {
        for (NSManagedObject* object in results)
        {
            [context deleteObject:object];
        }
        
        [context save:&error];
    }
    
}

- (void)updateProcessStartedDetailsInDBForObject:(QueuedProcess*)object
{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *request         = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"QueuedProcess" inManagedObjectContext:context]];
    
    NSError *error                  = nil;
    NSPredicate *predicate          = [NSPredicate predicateWithFormat:@"referenceID = %@ AND appName = %@ AND objectType=%@ AND firstServiceItem = %@", object.referenceID,object.appName,object.objectType,object.firstServiceItem];
    [request setPredicate:predicate];
    NSArray *results                = [context executeFetchRequest:request error:&error];
    if (results.count > 0)
    {
        NSManagedObject *coredataObject = [results objectAtIndex:0];
        
        NSNumber *processCount          = [coredataObject valueForKey:@"processCount"];
        
        processCount                    = [NSNumber numberWithInt:[processCount integerValue] + 1 ];
        
        [coredataObject setValue:processCount forKey:@"processCount"];
        [coredataObject setValue:@"Processing" forKey:@"status"];
        
        NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
//        [DateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
        [DateFormatter setDateFormat:@"MMM dd,yyyy HH:mm"];

        [coredataObject setValue:[NSString stringWithFormat:@"%@",[DateFormatter stringFromDate:[NSDate date]]] forKey:@"processStartTime"];
        
        
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        else
        {
            NSLog(@"Saved successfully");
        }
        [GSPKeychainStoreManager deleteAllItemsFromGSMKeyChain];
        
        [self saveAllItemsInKeyChainFromDb];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshQueueTableView" object:nil];
        });
    }
    
}


- (void)updateProcessStatusInDBForObjectWithReferenceID:(NSString*)refId withObjectType:(NSString *)objectType withFirstServiceItem :(NSString*)firstServiceItem withStatus:(NSString*)status
{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *request         = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"QueuedProcess" inManagedObjectContext:context]];
    
    NSError *error                  = nil;
    NSPredicate *predicate          = [NSPredicate predicateWithFormat:@"referenceID = %@ AND objectType = %@ AND firstServiceItem = %@",refId,objectType,firstServiceItem ];
    [request setPredicate:predicate];
    NSArray *results                = [context executeFetchRequest:request error:&error];
    
    if (results.count > 0)
    {
        NSManagedObject *coredataObject = [results objectAtIndex:0];
        
        [coredataObject setValue:status forKey:@"status"];
        [coredataObject setValue:[NSString stringWithFormat:@"%@",[NSDate date]] forKey:@"endTime"];
        
        
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        else
        {
            NSLog(@"Saved successfully");
        }
        [GSPKeychainStoreManager deleteAllItemsFromGSMKeyChain];
        
        [self saveAllItemsInKeyChainFromDb];
        dispatch_async(dispatch_get_main_queue(), ^{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshQueueTableView" object:nil];
        });
    }
}

- (void) updateErrorTableForReferenceId:(NSString*)refId withObjectType:(NSString *)objectType withFirstServiceItem :(NSString*)firstServiceItem andErrorObject:(NSMutableArray*)responseObject andErrorMessage:(NSString*)errorMessage
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *request         = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"QueuedProcess" inManagedObjectContext:context]];
    
    NSError *error                  = nil;
    NSPredicate *predicate          = [NSPredicate predicateWithFormat:@"referenceID = %@ AND objectType =%@ AND firstServiceItem =%@",refId,objectType,firstServiceItem] ;
    [request setPredicate:predicate];
    NSArray *results                = [context executeFetchRequest:request error:&error];
    
    if (results.count > 0)
    {
        QueuedProcess *coredataObject   = (QueuedProcess*)[results objectAtIndex:0];
    
        NSNumber *processCount         = [coredataObject valueForKey:@"processCount"];
    
// Original code...Commented by Harshitha
//    if ([processCount integerValue] >= 7){
    
//            [self checkAndDeleteRecordsAlreadyExistsDB:@"ErrorLog"  forRefID:refId andApplicationName:[coredataObject valueForKey:@"appName"]];
        [self checkAndDeleteRecordsAlreadyExistsDB:@"ErrorLog" forRefID:refId andApplicationName:[coredataObject valueForKey:@"appName"]andObjType :[coredataObject valueForKey:@"objectType"]andFirstServiceItem :[coredataObject valueForKey:@"firstServiceItem"]];
            if (responseObject.count > 0) {
            
                NSArray *errResponseArray   = [responseObject objectAtIndex:0];
            
                NSString *errorType         = [errResponseArray objectAtIndex:0];
                errResponseArray            = [responseObject objectAtIndex:3];
                NSString * errorDesc        = [errResponseArray objectAtIndex:0];
            
            [   self insertNewErrorRecordInDbWithRefID:refId andCoredatObj:coredataObject errorType:errorType andEroorDesc:errorDesc];
            }
            else
            {
                [self insertNewErrorRecordInDbWithRefID:refId andCoredatObj:coredataObject errorType:errorMessage andEroorDesc:errorMessage];
            }
        if ([processCount integerValue] <= 7)
            [self setNextTimerForRefID:refId andAppName:[(QueuedProcess*)[results objectAtIndex:0] valueForKey:@"appName"]andObjectType:[(QueuedProcess*)[results objectAtIndex:0] valueForKey:@"objectType"] andFirstServiceItem:[(QueuedProcess*)[results objectAtIndex:0] valueForKey:@"firstServiceItem"]];
        else
//            [self deleteItemsWithProcessCountGreaterThanSevenAndErrorStatus];
            [self sendNotificationForRefID:[(QueuedProcess*)[results objectAtIndex:0] valueForKey:@"referenceID"] andAppName:[(QueuedProcess*)[results objectAtIndex:0] valueForKey:@"appName"]andObjectType:[(QueuedProcess*)[results objectAtIndex:0] valueForKey:@"objectType"] andFirstServiceItem:[(QueuedProcess*)[results objectAtIndex:0] valueForKey:@"firstServiceItem"]];
        
    }
        
    [self saveErrorItemsInKeyChain];
}


- (void)insertNewErrorRecordInDbWithRefID:(NSString*)refID andCoredatObj:(QueuedProcess*)coreDataObj errorType:(NSString*)errorType andEroorDesc:(NSString*)errorDesc
{
    
//     [self checkAndDeleteRecordsAlreadyExistsDB:@"ErrorLog"  forRefID:refID andApplicationName:[coreDataObj valueForKey:@"appName"]];
     [self checkAndDeleteRecordsAlreadyExistsDB:@"ErrorLog" forRefID:refID andApplicationName:[coreDataObj valueForKey:@"appName"]andObjType :[coreDataObj valueForKey:@"objectType"]andFirstServiceItem :[coreDataObj valueForKey:@"firstServiceItem"]];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSManagedObject *errorLog = [NSEntityDescription insertNewObjectForEntityForName:@"ErrorLog" inManagedObjectContext:context];

    [errorLog setValue:refID forKey:@"referenceID"];
    [errorLog setValue:[coreDataObj valueForKey:@"appName"] forKey:@"appName"];
    [errorLog setValue:[coreDataObj valueForKey:@"apiName"] forKey:@"apiName"];
    [errorLog setValue:errorType forKey:@"errType"];
    [errorLog setValue:errorDesc forKey:@"errDescription"];
    [errorLog setValue:[NSString stringWithFormat:@"%@",[NSDate date]] forKey:@"errDate"];
    [errorLog setValue:@"ERROR" forKey:@"status"];
    
     [errorLog setValue:[coreDataObj valueForKey:@"objectType"] forKey:@"objectType"];
     [errorLog setValue:[coreDataObj valueForKey:@"firstServiceItem"] forKey:@"firstServiceItem"];
    
    [errorLog setValue:[coreDataObj valueForKey:@"periority"] forKey:@"periority"];

    
    NSError *error = nil;
    if (![context save:&error])
    {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    else
    {
        NSLog(@"Saved successfully");
    }

}

- (NSMutableArray*) getErrorOccuredItemsFromDB
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *request         = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"ErrorLog" inManagedObjectContext:context]];
    
    NSError *error                  = nil;
    NSArray *results                = [context executeFetchRequest:request error:&error];

    return (NSMutableArray*)results;
}


- (void)saveErrorItemsInKeyChain
{
    
    NSMutableArray * errorItems = [self getErrorOccuredItemsFromDB];
    
//  Original code
//    [GSPKeychainStoreManager saveErrorItemsInKeychain:erorrItems];

// *****   Modified by Harshitha starts here   *****
    NSMutableArray *errorLogArray = [[NSMutableArray alloc]init];
    
    if (errorItems.count > 0)
    {
        for (NSString *errorField in errorItems)
        {
            NSMutableDictionary *errorLogDict = [NSMutableDictionary new];
            [errorLogArray addObject:errorLogDict];
            
            [errorLogDict setObject:[errorField valueForKey:@"referenceID"] forKey:@"referenceID"];
            [errorLogDict setObject:[errorField valueForKey:@"appName"] forKey:@"appName"];
            [errorLogDict setObject:[errorField valueForKey:@"apiName"] forKey:@"apiName"];
            [errorLogDict setObject:[errorField valueForKey:@"errType"] forKey:@"errType"];
            [errorLogDict setObject:[errorField valueForKey:@"errDescription"] forKey:@"errDescription"];
            [errorLogDict setObject:[errorField valueForKey:@"errDate"] forKey:@"errDate"];
            [errorLogDict setObject:[errorField valueForKey:@"status"] forKey:@"status"];
             [errorLogDict setObject:[errorField valueForKey:@"firstServiceItem"] forKey:@"firstServiceItem"];
            [errorLogDict setObject:[errorField valueForKey:@"objectType"] forKey:@"objectType"];
             [errorLogDict setObject:[errorField valueForKey:@"periority"] forKey:@"periority"];
        }
        [GSPKeychainStoreManager saveErrorItemsInKeychain:errorLogArray];
    }
    else
    {
        [GSPKeychainStoreManager deleteErrorItemsFromKeyChain];
    }
// *****   Modified by Harshitha ends here   *****
}

//  *****   Added by Harshitha starts here   *****
- (void) sendNotificationForRefID:(NSString*)refID andAppName:(NSString*)appName andObjectType :(NSString*)objectType andFirstServiceItem :(NSString *)firstServiceItem
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *request         = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"QueuedProcess" inManagedObjectContext:context]];
    
    NSError *error                  = nil;

    NSPredicate *predicate          = [NSPredicate predicateWithFormat:@"referenceID = %@ AND appName = %@ AND objectType = %@ And firstServiceItem = %@",refID,appName,objectType,firstServiceItem];

    [request setPredicate:predicate];
    NSArray *results                = [context executeFetchRequest:request error:&error];
    
    if (results.count > 0)
    {
        for (NSManagedObject* object in results)
        {
            [self updateProcessStatusInDBForObjectWithReferenceID:refID  withObjectType:objectType withFirstServiceItem:firstServiceItem withStatus:NULL];
          /*   commented on march 24th 2017
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            [localNotification setAlertAction:@"Launch"];
            [localNotification setAlertBody:[NSString stringWithFormat:@"Item : %@ of application : %@ is processed with error and deleted from queue\n",refID,appName]];
            [localNotification setHasAction: YES];
            [localNotification setApplicationIconBadgeNumber:[[UIApplication sharedApplication] applicationIconBadgeNumber]+1];
            
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:refID,@"referenceID",firstServiceItem,@"firstServiceItem", nil];
            
            localNotification.userInfo=dic;
          
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            NSLog(@"Launching notification ");

       */
               /*
           [self updateProcessStatusInDBForObjectWithReferenceID:refID withStatus:NULL];
            
         
            UIMutableUserNotificationAction* deleteAction = [[UIMutableUserNotificationAction alloc] init];
            [deleteAction setIdentifier:@"deleteQueueItem"];
            [deleteAction setTitle:@"Delete"];
            [deleteAction setActivationMode:UIUserNotificationActivationModeBackground];
            [deleteAction setDestructive:YES];
            
            UIMutableUserNotificationAction* retainAction = [[UIMutableUserNotificationAction alloc] init];
            [retainAction setIdentifier:@"retainQueueItem"];
            [retainAction setTitle:@"Retain"];
            [retainAction setActivationMode:UIUserNotificationActivationModeForeground];
            [retainAction setDestructive:NO];
            
            UIMutableUserNotificationCategory* deleteRetainCategory = [[UIMutableUserNotificationCategory alloc] init];
            [deleteRetainCategory setIdentifier:@"deleteRetainQueueItemCategory"];
            [deleteRetainCategory setActions:@[retainAction, deleteAction] forContext:UIUserNotificationActionContextDefault];
            
            NSSet* categories = [NSSet setWithArray:@[deleteRetainCategory]];
            UIUserNotificationSettings* settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:categories];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
            
            UILocalNotification* notification = [[UILocalNotification alloc] init];
            [notification setAlertBody:[NSString stringWithFormat:@"Item : %@ of application : %@ is processed with error. Do you want to delete the item or retain?\n",refID,appName]];
            [notification setCategory:@"deleteRetainQueueItemCategory"];
            
            NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:refID forKey:@"refID"];
            [userInfo setObject:appName forKey:@"appName"];
            [notification setUserInfo:userInfo];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
*/
        }
    }
}

- (void) deleteItemsWithCompletedStatus
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *request         = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"QueuedProcess" inManagedObjectContext:context]];
    
    NSError *error                  = nil;
    NSPredicate *predicate          = [NSPredicate predicateWithFormat:@"status = %@",@"Completed"];
    [request setPredicate:predicate];
    NSArray *results                = [context executeFetchRequest:request error:&error];
    
    if (results.count > 0)
    {
        for (NSManagedObject* object in results)
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"HH:mm"];
            [[QPLogs sharedInstance]writeLogsToFile:[NSString stringWithFormat:@"\n %@ : Item : %@ of application : %@ is completed and deleted from queue\n",[dateFormatter stringFromDate:[NSDate date]],[object valueForKey:@"referenceID"],[object valueForKey:@"appName"]]];
            
//            [self checkAndDeleteRecordsAlreadyExistsDB:@"QueuedProcess"  forRefID:[object valueForKey:@"referenceID"] andApplicationName:[object valueForKey:@"appName"]];
             [self checkAndDeleteRecordsAlreadyExistsDB:@"QueuedProcess" forRefID:[object valueForKey:@"referenceID"] andApplicationName:[object valueForKey:@"appName"]andObjType :[object valueForKey:@"objectType"]andFirstServiceItem :[object valueForKey:@"firstServiceItem"]];

//            [self checkAndDeleteRecordsAlreadyExistsDB:@"ErrorLog"  forRefID:[object valueForKey:@"referenceID"] andApplicationName:[object valueForKey:@"appName"]];
            [self checkAndDeleteRecordsAlreadyExistsDB:@"ErrorLog" forRefID:[object valueForKey:@"referenceID"] andApplicationName:[object valueForKey:@"appName"]andObjType :[object valueForKey:@"objectType"]andFirstServiceItem :[object valueForKey:@"firstServiceItem"]];
        }
    }
}



-(NSMutableArray*)fetchAllItemsFromDB{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *request         = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"QueuedProcess" inManagedObjectContext:context]];
    
    //          NSPredicate *predicate          = [NSPredicate predicateWithFormat:@"status != %@ OR status = NULL",@"Completed" ];// OR status != %@,@"Processing"];
    //    [request setPredicate:predicate];
    //
    
    NSError *error                  = nil;
    NSArray *dataSourceArray            = [context executeFetchRequest:request error:&error];
    
    //        [self.queueLogTable reloadData];
    
    NSLog(@"The data source aarray from coredata %@",dataSourceArray);
    
    return (NSMutableArray*)dataSourceArray;

}


- (void)saveAllItemsInKeyChainFromDb
{
    
    NSMutableArray * allItems = [self fetchAllItemsFromDB];
    
    //  Original code
    //    [GSPKeychainStoreManager saveErrorItemsInKeychain:erorrItems];
    
    // *****   Modified by Harshitha starts here   *****
    NSMutableArray *allItemsArray = [[NSMutableArray alloc]init];
    
    if (allItems.count > 0)
    {
        for (NSString *Field in allItems)
        {
            NSMutableDictionary *allItemsLogDict = [NSMutableDictionary new];
            [allItemsArray addObject:allItemsLogDict];
            
            [allItemsLogDict setObject:[Field valueForKey:@"referenceID"] forKey:@"referenceID"];
            [allItemsLogDict setObject:[Field valueForKey:@"appName"] forKey:@"appName"];
            [allItemsLogDict setObject:[Field valueForKey:@"apiName"] forKey:@"apiName"];
            [allItemsLogDict setObject:[Field valueForKey:@"objectType"] forKey:@"objectType"];
//            [allItemsLogDict setObject:[Field valueForKey:@"errDescription"] forKey:@"errDescription"];
//            [allItemsLogDict setObject:[Field valueForKey:@"errDate"] forKey:@"errDate"];
            if([[Field valueForKey:@"status"]length]!=0)
            [allItemsLogDict setObject:[Field valueForKey:@"status"] forKey:@"status"];
            else
                [allItemsLogDict setObject:@"" forKey:@"status"];
            
           if ([[Field valueForKey:@"firstServiceItem"]length]!=0)
            [allItemsLogDict setObject:[Field valueForKey:@"firstServiceItem"] forKey:@"firstServiceItem"];
            else
                [allItemsLogDict setObject:@"" forKey:@"firstServiceItem"];
            
                        if([[Field valueForKey:@"nextProcessTime"]length]!=0)
  [allItemsLogDict setObject:[Field valueForKey:@"nextProcessTime"] forKey:@"nextProcessTime"];
            else
                [allItemsLogDict setObject:@""forKey:@"nextProcessTime"];
            
             [allItemsLogDict setObject:[Field valueForKey:@"processCount"] forKey:@"processCount"];

                   }
        [GSPKeychainStoreManager saveAllItemsInKeychain:allItemsArray];
    }
}
/*
- (void) addTimerToItemsWithoutRetryTimeAdded
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *request         = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"ErrorLog" inManagedObjectContext:context]];
    
    NSError *error                  = nil;

    NSArray *results                = [context executeFetchRequest:request error:&error];
    
    if (results.count > 0)
    {
        for (NSManagedObject* object in results)
        {
            BOOL timerAddedForItem = NO;
            for (int i = 0 ; i < queuedItemArrayWithTimerFired.count ; i++)
            {
//                if ([[object valueForKey:@"referenceID"] isEqualToString:[[queuedItemArrayWithTimerFired objectAtIndex:i]valueForKey:@"referenceID"]] && [[object valueForKey:@"appName"] isEqualToString:[[queuedItemArrayWithTimerFired objectAtIndex:i]valueForKey:@"appName"]])
                if ([[object valueForKey:@"referenceID"] isEqualToString:[[queuedItemArrayWithTimerFired objectAtIndex:i]valueForKey:@"referenceID"]] && [[object valueForKey:@"appName"] isEqualToString:[[queuedItemArrayWithTimerFired objectAtIndex:i]valueForKey:@"appName"]] && [object valueForKey:@"status"] != NULL)
                {
                    timerAddedForItem = YES;
                    break;
                }
            }
            if (timerAddedForItem == NO)
            {
                [self setNextTimerForRefID:[object valueForKey:@"referenceID"] andAppName:[object valueForKey:@"appName"]];
            }
        }
    }
}
*/
//  *****   Added by Harshitha ends here   *****



- (void) deleteItemsWithStatusDeleted
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *request         = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"QueuedProcess" inManagedObjectContext:context]];
    
    NSError *error                  = nil;
    NSPredicate *predicate          = [NSPredicate predicateWithFormat:@"status = %@",@"Delete"];
    [request setPredicate:predicate];
    NSArray *results                = [context executeFetchRequest:request error:&error];
    
    if (results.count > 0)
    {
        for (NSManagedObject* object in results)
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"HH:mm"];
            [[QPLogs sharedInstance]writeLogsToFile:[NSString stringWithFormat:@"\n %@ : Item : %@ of application : %@ is deleted from queue\n",[dateFormatter stringFromDate:[NSDate date]],[object valueForKey:@"referenceID"],[object valueForKey:@"appName"]]];
            
            //            [self checkAndDeleteRecordsAlreadyExistsDB:@"QueuedProcess"  forRefID:[object valueForKey:@"referenceID"] andApplicationName:[object valueForKey:@"appName"]];
            [self checkAndDeleteRecordsAlreadyExistsDB:@"QueuedProcess" forRefID:[object valueForKey:@"referenceID"] andApplicationName:[object valueForKey:@"appName"]andObjType :[object valueForKey:@"objectType"]andFirstServiceItem :[object valueForKey:@"firstServiceItem"]];
            
            //            [self checkAndDeleteRecordsAlreadyExistsDB:@"ErrorLog"  forRefID:[object valueForKey:@"referenceID"] andApplicationName:[object valueForKey:@"appName"]];
            [self checkAndDeleteRecordsAlreadyExistsDB:@"ErrorLog" forRefID:[object valueForKey:@"referenceID"] andApplicationName:[object valueForKey:@"appName"]andObjType :[object valueForKey:@"objectType"]andFirstServiceItem :[object valueForKey:@"firstServiceItem"]];
        }
    }
}


- (void)checkAndDeleteOnlineDatainDB:(NSString*)entityName forRefID:(NSString*)objectID andApplicationName:(NSString*)appName andObjType:(NSString*)objType andFirstServiceItem :(NSString*)serviceItem
{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *request         = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:context]];//@"QueuedProcess"
    
    NSError *error                  = nil;
    NSPredicate *predicate          = [NSPredicate predicateWithFormat:@"referenceID = %@ AND appName = %@ AND firstServiceItem = %@ AND objectType=%@", objectID,appName,serviceItem,objType];
    [request setPredicate:predicate];
    NSArray *results                = [context executeFetchRequest:request error:&error];
    
    if (results.count > 0)
    {
        for (NSManagedObject* object in results)
        {
            [context deleteObject:object];
        }
        
        [context save:&error];
    }
    
}


-(void)deleteErrorItemsinDBNotinKeychain{
    
    
    NSMutableArray *errorListArray = [GSPKeychainStoreManager getErrorItemsFromKeyChain];
    
    NSLog(@"The fetched error items in keychain %@",errorListArray);
    
     NSMutableArray *errorObjectID = [[NSMutableArray alloc]init];
    
    NSMutableArray *appName = [[NSMutableArray alloc]init];
    
    if(errorListArray.count>0){
        for(NSDictionary *dic in errorListArray){
           
            [errorObjectID addObject:[dic valueForKey:@"referenceID"]];
            
            [appName addObject:[dic valueForKey:@"appName"]];
    }
        NSLog(@"The error object id array %@",errorObjectID);
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *request         = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"ErrorLog" inManagedObjectContext:context]];
    
    NSError *error                  = nil;
        NSPredicate *predicate          = [NSPredicate predicateWithFormat:@"appName = %@",[appName objectAtIndex:0]];
        [request setPredicate:predicate];
    NSArray *results            = [context executeFetchRequest:request error:&error];
        
        NSLog(@"Array from Error DB %@",results);
    
    if(results.count > 0){
        for(NSManagedObject* object in results){
            if(![errorObjectID containsObject:[object valueForKey:@"referenceID"]]){
                
                [context deleteObject:object];
   
            }
        }
    }
    
    
    }
    else{
        NSManagedObjectContext *context = [self managedObjectContext];
        
        NSFetchRequest *request         = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"ErrorLog" inManagedObjectContext:context]];
        NSError *error                  = nil;
        NSPredicate *predicate          = [NSPredicate predicateWithFormat:@"appName =%@",@"SERVICEPRO"];
        [request setPredicate:predicate];
        NSArray *results            = [context executeFetchRequest:request error:&error];
        if(results.count>0){
            for(NSManagedObject *object in results){
                [context deleteObject:object];
            }
        }
    }
               }
 

-(void)stratTimertoCheckPriority{
    
      dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void) {
 timerTrial =  [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(checkPriorityinKeyChain) userInfo:nil repeats:YES];
          });
}

-(void)checkPriorityinKeyChain{
    
    @synchronized(self){
       
            
        
    NSMutableArray *errorKeyChainArray = [[NSMutableArray alloc]init];
    errorKeyChainArray = [GSPKeychainStoreManager getErrorItemsFromKeyChain];
    if(errorKeyChainArray.count>0){
        
        
        [GSPKeychainStoreManager setApplicationStateVAriable ];
        
//       NSMutableArray *applicationStateArray = [GSPKeychainStoreManager fetchApplicationState];
        
      
        
    for(NSDictionary *dic in errorKeyChainArray){
        if([[dic valueForKey:@"periority"]isEqualToString:@"2"]){
            _itemToProcess= TRUE;
        }
    }
    
    if(_itemToProcess){
        _itemToProcess=FALSE;
        [[GQPQueueProcessor sharedInstance] processQitemsWithHighPriority];

//        [self processQueueDataAtLaunch];
        [GSPKeychainStoreManager deleteErrorItemsFromKeyChain];
        
        NSMutableDictionary *dic =[[NSMutableDictionary alloc]init];
        if(errorKeyChainArray.count>0){
        
            
            for(id item in errorKeyChainArray){
                
                for( id key in item){
                    
                    [dic setObject:[item objectForKey:key] forKey:key];
                }
            }
            
            NSLog(@"mutable dic %@",dic);
            //
            //                    for(id key in dic){
            //                        id value =[dic objectForKey:@"appName"];
            //                if([value isEqualToString:@"SERVICEPRO"]){
            //
            //
            //                [dic setObject:@"2" forKey:@"periority"];
            //            }
            //                    }
            NSMutableDictionary *mutableDic = [dic mutableCopy];
            
            [mutableDic setObject:@"3" forKey:@"periority"];
            
            
            NSLog(@"The mutated dictionary %@",mutableDic);
            //                    for(NSString *key in mutableDic){
            //                        id value = [dic objectForKey:key];
            //                        NSLog(@"the value of a key %@",value);
            //                        [value setObject:@"1" forKey:@"periority"]  ;
            //                    }
            //        }
            //         [GSPKeychainStoreManager saveErrorItemsInKeychain:errorKeychainArray];
            
            NSMutableArray  *mutatedArray =[[NSMutableArray alloc]init];
            [mutatedArray addObject:mutableDic];
            NSLog(@"Mutated Array %@",mutatedArray);
            [GSPKeychainStoreManager saveErrorItemsInKeychain:mutatedArray];
            errorKeyChainArray = [GSPKeychainStoreManager getErrorItemsFromKeyChain];
            NSLog(@"THe error items in error keychain %@",errorKeyChainArray);
           }
    }
        [self saveinErrorDB :errorKeyChainArray];

    }
       
    }
}

-(void)processQueueDataAtLaunch{
   
    NSLog(@"ServicePro App has started,Processing error items...");
   
    
    [self deleteItemsWithCompletedStatus];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshQueueTableView" object:nil];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *request         = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"QueuedProcess" inManagedObjectContext:context]];
    
    NSError *error                  = nil;
    NSPredicate *predicate          = [NSPredicate predicateWithFormat:@"status != NULL AND nextProcessTime != NULL"];
    
    [request setPredicate:predicate];
    NSArray *results                = [context executeFetchRequest:request error:&error];
    if (results.count > 0)
    {
        for (int i = 0 ; i < results.count ; i++)
        {
            
            
                        [self updateProcessStartedDetailsInDBForObject:[results objectAtIndex:i]];
                
                [[QPLogs sharedInstance]writeLogsToFile:[NSString stringWithFormat:@"For Reference ID : %@\tProcess Count : %@\n",[[results objectAtIndex:i] valueForKey:@"referenceID"],[[results objectAtIndex:i] valueForKey:@"processCount"]]];
                
                [self initializeWebServiceCallForObject:[results objectAtIndex:i]];
            
        }
    }

    
}

-(void)saveinErrorDB:(NSMutableArray*)erroKeychainArray{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Create a new managed object
    
    
    for (NSDictionary * task in erroKeychainArray)
    {
        NSLog(@"item is %@", [task objectForKey:@"referenceID"] );
        
      
        
        [self checkAndDeleteRecordsAlreadyExistsDB:@"ErrorLog" forRefID:[task objectForKey:@"referenceID"]  andApplicationName:[task valueForKey:@"appName"]andObjType :[task valueForKey:@"objectType"]andFirstServiceItem :[task valueForKey:@"firstServiceItem"]];

        
        NSManagedObject *process = [NSEntityDescription insertNewObjectForEntityForName:@"ErrorLog" inManagedObjectContext:context];
        
        
        [process setValue:[task objectForKey:@"appName"] forKey:@"appName"];
        [process setValue:[task objectForKey:@"referenceID"] forKey:@"referenceID"];
        [process setValue:[task objectForKey:@"objectType"] forKey:@"objectType"];
        [process setValue:[task objectForKey:@"periority"] forKey:@"periority"];
        [process setValue:[task objectForKey:@"apiName"] forKey:@"apiName"];
        [process setValue:[task objectForKey:@"errType"] forKey:@"errType"];
        [process setValue:[task objectForKey:@"errDescription"] forKey:@"errDescription"];
        [process setValue:[task objectForKey:@"errDate"] forKey:@"errDate"];
             [process setValue:[task objectForKey:@"status"] forKey:@"status"];
             [process setValue:[task objectForKey:@"firstServiceItem"] forKey:@"firstServiceItem"];
    
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        else
        {
            NSLog(@"Saved successfully");
        }
        
    }

}


- (void) processQitemsWithHighPriority
{
    
    @synchronized(self){
        
      
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm"];
    [[QPLogs sharedInstance]writeLogsToFile:[NSString stringWithFormat:@"\n %@ : Processing queued items before API call \n",[dateFormatter stringFromDate:[NSDate date] ]]];
    NSLog(@"15 mins timer fired %@",[NSDate date]);
    
    [self deleteErrorItemsinDBNotinKeychain];
    
    [self saveErrorItemsInKeyChain];
    
    
    [self saveDataToQueueDBFromKeyChain];
    
    [self deleteItemsWithCompletedStatus];
    
    //    [self deleteItemsWithStatusDeleted];
    
    [GSPKeychainStoreManager deleteAllItemsFromGSMKeyChain];
    
    [self saveAllItemsInKeyChainFromDb];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshQueueTableView" object:nil];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *request         = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"QueuedProcess" inManagedObjectContext:context]];
    
    NSError *error                  = nil;
    NSPredicate *predicate          = [NSPredicate predicateWithFormat:@"status != NULL AND nextProcessTime != NULL AND     periority == 2"];
    
    [request setPredicate:predicate];
    NSArray *results                = [context executeFetchRequest:request error:&error];
    if (results.count > 0)
    {
        for (int i = 0 ; i < results.count ; i++)
        {
            NSDateFormatter *DateFormatter  =[[NSDateFormatter alloc] init];
            [DateFormatter setDateFormat:@"MMM dd,yyyy HH:mm:ss"];
            
            NSDate *curentdate              = [DateFormatter dateFromString:[DateFormatter stringFromDate:[NSDate date]]];
            NSString *nextProcesstime       = [[results objectAtIndex:i]valueForKey:@"nextProcessTime"];
            
            NSDate *next_process_time       = [DateFormatter dateFromString:nextProcesstime];
            
            if ([next_process_time compare:curentdate] == NSOrderedAscending)
            {
                [self updateProcessStartedDetailsInDBForObject:[results objectAtIndex:i]];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"HH:mm"];
                [[QPLogs sharedInstance]writeLogsToFile:[NSString stringWithFormat:@"\n %@ : For Reference ID : %@\t Object Type : %@\t Process Count : %@\n",[dateFormatter stringFromDate:[NSDate date]],[[results objectAtIndex:i] valueForKey:@"referenceID"],[[results objectAtIndex:i]valueForKey:@"objectType"],[[results objectAtIndex:i] valueForKey:@"processCount"]]];
                
                [self initializeWebServiceCallForObject:[results objectAtIndex:i]];
            }
            else {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"HH:mm"];
                [[QPLogs sharedInstance]writeLogsToFile:[NSString stringWithFormat:@"\n %@ : As the 'next_process_time' of the items is not reached,no items to process ",[dateFormatter stringFromDate:[NSDate date]]]];
            }
        }
    }
    
    else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"HH:mm"];
        [[QPLogs sharedInstance]writeLogsToFile:[NSString stringWithFormat:@"\n %@ : No items to process\n",[dateFormatter stringFromDate:[NSDate date]]]];
    }
    /*    predicate          = [NSPredicate predicateWithFormat:@"processCount>8"];
     [request setPredicate:predicate];
     results                = [context executeFetchRequest:request error:&error];
     if (results.count > 0)
     {
     for (int i = 0 ; i < results.count ; i++)
     {
     [self sendNotificationForRefID:[(QueuedProcess*)[results objectAtIndex:0] valueForKey:@"referenceID"] andAppName:[(QueuedProcess*)[results objectAtIndex:0] valueForKey:@"appName"]];
     }
     }
     */
        
}
                      
}


- (void) deleteAllObjects: (NSString *) entityDescription  {
    
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
    
    
    for (NSManagedObject *managedObject in items) {
        [context deleteObject:managedObject];
        NSLog(@"%@ object deleted",entityDescription);
    }
    if (![context save:&error]) {
        NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
    
}

-(void)startTimerToCheckApplicationState{
    
    
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^void{
       
//       [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(setApplicationStateVAriable) userInfo:nil repeats:YES];
    });
    
}
@end
