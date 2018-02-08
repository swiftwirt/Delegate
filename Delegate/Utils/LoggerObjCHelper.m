//
//  LoggerObjCHelper.m
//  Delegate
//
//  Created by Dmitry Ivashin on 2/8/18.
//  Copyright © 2018 Dmitry Ivashin. All rights reserved.
//

#import "LoggerObjCHelper.h"
#import <sys/utsname.h>

@implementation LoggerObjCHelper

+ (NSString*) deviceCode
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString* code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];
    return code;
}

@end
