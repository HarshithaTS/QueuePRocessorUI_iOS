//
//  GSPKeychainStoreManager.h
//  GssServicePro
//
//  Created by Riyas Hassan on 08/01/15.
//  Copyright (c) 2015 Riyas Hassan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSPKeychainStoreManager : NSObject

+ (void)saveDataInKeyChain:(NSMutableArray*)array;

+ (NSMutableArray*) arrayFromKeychain;

+ (void) deleteItemsFromKeyChain;

+ (void) saveErrorItemsInKeychain:(NSMutableArray*)array;

+ (NSMutableArray*)getErrorItemsFromKeyChain;

+(void)setLocalNotifVariable: (NSString *)ident andServiceItem: (NSString*)ident2;

+(void) saveAllItemsInKeychain:(NSMutableArray*)array;
// Added by Harshitha
+ (void) deleteErrorItemsFromKeyChain;

+ (void) deleteAllItemsFromGSMKeyChain;

+ (NSMutableArray*) allItemsArrayFromKeychain;

+(void)setApplicationStateVAriable;
+(NSMutableArray*)fetchApplicationState;


+(void)setApplicationStateVAriableWhenAppExits ;

+(void)saveLogFilepathinKeychain:(NSString*)filePath;

+ (NSString*) getLogFilepathfromKeychain;

@end
