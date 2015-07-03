//
//  MeetUp.m
//  MeetUps
//
//  Created by Richard Adem on 2/07/2015.
//  Copyright (c) 2015 Richard Adem. All rights reserved.
//

#import "Event.h"
#import "Group.h"

@implementation Event

- (id) initWithDictionary:(NSDictionary*) dict {
    self = [super init];
    if (self) {
        self.name = dict[@"name"];
        if (dict[@"group"]) {
            self.group = [[Group alloc] initWithDictionary:dict[@"group"]];
        }
        self.descriptionHtml = dict[@"description"];
        self.distance = dict[@"distance"];
        
        NSDictionary *venue = dict[@"venue"];
        if (venue) {
            self.latitude = venue[@"lat"];
            self.longitude = venue[@"lon"];
            self.venueName = venue[@"name"];
        }
        
        // Event duration in milliseconds
        NSNumber *duration = dict[@"duration"];
        if (duration) {
            self.duration = ((float)[duration integerValue]) / 1000;
        }
        
        // UTC start time of the event, in milliseconds since the epoch
        NSNumber *time = dict[@"time"];
        if (time) {
            NSTimeInterval timeInterval = ((float)[time integerValue]) / 1000;
            self.time = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        }
    }
    return self;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@, name: %@, distance: %.02f", [super description], self.name, [self.distance floatValue]];
}

@end
