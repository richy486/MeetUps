//
//  LocationManager.h
//  MeetUps
//
//  Created by Richard Adem on 2/07/2015.
//  Copyright (c) 2015 Richard Adem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationManager : NSObject

+ (LocationManager*)sharedInstance;
- (BOOL) isAuthorized;
- (void) requestAuthorization;

@end
