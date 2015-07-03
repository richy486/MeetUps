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
    }
    return self;
}
@end
