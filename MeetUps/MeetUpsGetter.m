//
//  MeetUpsGetter.m
//  MeetUps
//
//  Created by Richard Adem on 2/07/2015.
//  Copyright (c) 2015 Richard Adem. All rights reserved.
//

#import "MeetUpsGetter.h"

@interface MeetUpsGetter() {
    NSMutableData *_container;
}
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) void (^completionBlock)(NSNumber *value, NSError *error) ;
@end

@implementation MeetUpsGetter



@end
